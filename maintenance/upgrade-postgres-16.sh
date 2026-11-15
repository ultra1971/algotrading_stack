#!/usr/bin/env bash
# Upgrade pg-airflow and pg-master from PostgreSQL 13 to 16 (dump + restore into NEW volumes).
#
#   sudo ./maintenance/upgrade-postgres-16.sh
#
# * The Postgres 13 volumes are never modified or deleted: to go back, run
#   `docker compose up -d` with the normal docker-compose.yaml.
# * Everything that writes to the databases (Airflow, Metabase, pgAdmin) is stopped first, so
#   the dump is consistent. Run it when no DAG is running (the weekend is fine).
# * pg_hba is switched to md5 before restoring: the dump carries md5 password hashes, which
#   the image's default scram-sha-256 rule rejects (tested, it breaks the restore).
set -euo pipefail

cd "$(dirname "$0")/.."
OVERRIDE=maintenance/postgres16/docker-compose.pg16.yaml
DC_OLD=(docker compose)
DC_NEW=(docker compose -f docker-compose.yaml -f "$OVERRIDE")
BACKUP_DIR="${BACKUP_DIR:-$HOME/pg-upgrade-$(date +%Y%m%d-%H%M%S)}"
WRITERS=(airflow-apiserver airflow-scheduler airflow-dag-processor airflow-triggerer
         airflow-worker airflow-flower metabase pgadmin)

# POSTGRES_USER / POSTGRES_DB of pg-airflow come from .env (pg-master's superuser is postgres)
envval() { grep -E "^$1=" .env 2>/dev/null | cut -d= -f2- | head -1 || true; }
AIRFLOW_DB_USER="$(envval PG_AIRFLOW_USER)"; AIRFLOW_DB_USER="${AIRFLOW_DB_USER:-airflow}"
AIRFLOW_DB_NAME="$(envval PG_AIRFLOW_DB)"; AIRFLOW_DB_NAME="${AIRFLOW_DB_NAME:-airflow}"
declare -A SUPERUSER=([pg-airflow]="$AIRFLOW_DB_USER" [pg-master]=postgres)

say() { printf '\n\033[1m== %s\033[0m\n' "$*"; }
die() {
    printf '\033[1;31mERROR: %s\033[0m\n' "$*" >&2
    echo "Postgres 13 data was not modified. To go back to the old setup: docker compose up -d" \
         "(normal docker-compose.yaml, no override)." >&2
    exit 1
}
psql_in() { # service, extra psql args...
    local svc=$1; shift
    "${DC_CURRENT[@]}" exec -T "$svc" psql -v ON_ERROR_STOP=1 -U "${SUPERUSER[$svc]}" "$@"
}
counts() { # service, outfile: exact row counts of every table in every database
    local svc=$1 out=$2 db
    : > "$out"
    for db in $("${DC_CURRENT[@]}" exec -T "$svc" psql -U "${SUPERUSER[$svc]}" -d postgres -Atc \
                "select datname from pg_database where not datistemplate order by 1"); do
        "${DC_CURRENT[@]}" exec -T "$svc" psql -U "${SUPERUSER[$svc]}" -d "$db" -At \
            < maintenance/postgres16/row-counts.sql | sed "s#^#$db: #" >> "$out"
    done
}

say "0. Checks"
[[ $EUID -eq 0 ]] || die "run it with sudo"
"${DC_NEW[@]}" config -q || die "the compose override is not valid"
DC_CURRENT=("${DC_OLD[@]}")
for svc in pg-airflow pg-master; do
    ver=$(psql_in "$svc" -d postgres -Atc "show server_version_num" | head -1)
    [[ $ver -ge 130000 && $ver -lt 140000 ]] || die "$svc is not running PostgreSQL 13 (server_version_num=$ver)"
done
running=$(psql_in pg-airflow -d "$AIRFLOW_DB_NAME" -Atc "select count(*) from task_instance where state in ('running','queued')" || echo "?")
if [[ "$running" != "0" && "${FORCE:-0}" != "1" ]]; then
    die "$running task(s) running/queued in Airflow. Wait for them, or pass FORCE=1 to stop them anyway"
fi
mkdir -p "$BACKUP_DIR"
avail_gb=$(df --output=avail -BG /var/lib/docker | tail -1 | tr -dc 0-9)
echo "backups in: $BACKUP_DIR | free disk for Docker: ${avail_gb}G"
[[ $avail_gb -ge 20 ]] || die "less than 20 GB free for Docker"

echo
echo "This will STOP Airflow, Metabase and pgAdmin, dump both databases, and bring everything back"
echo "up on PostgreSQL 16 with new volumes. Postgres 13 volumes are kept for rollback."
read -r -p "Type 'upgrade' to continue: " answer
[[ $answer == upgrade ]] || die "cancelled"

say "1. Stopping everything that writes to the databases"
"${DC_OLD[@]}" stop "${WRITERS[@]}"

say "2. Row counts and dumps from PostgreSQL 13"
for svc in pg-airflow pg-master; do
    counts "$svc" "$BACKUP_DIR/$svc.counts.before"
    "${DC_OLD[@]}" exec -T "$svc" pg_dumpall -U "${SUPERUSER[$svc]}" > "$BACKUP_DIR/$svc.sql"
    tail -n 3 "$BACKUP_DIR/$svc.sql" | grep -q "PostgreSQL database cluster dump complete" \
        || die "$svc dump looks truncated: $BACKUP_DIR/$svc.sql"
    echo "$svc: $(wc -l < "$BACKUP_DIR/$svc.counts.before") tables, dump $(du -h "$BACKUP_DIR/$svc.sql" | cut -f1)"
done

say "3. Starting PostgreSQL 16 on new volumes"
"${DC_OLD[@]}" stop pg-airflow pg-master
"${DC_NEW[@]}" up -d pg-airflow pg-master
DC_CURRENT=("${DC_NEW[@]}")
for svc in pg-airflow pg-master; do
    for _ in $(seq 1 60); do
        "${DC_CURRENT[@]}" exec -T "$svc" pg_isready -U "${SUPERUSER[$svc]}" -q && break
        sleep 2
    done
    ver=$(psql_in "$svc" -d postgres -Atc "show server_version_num" | head -1)
    [[ $ver -ge 160000 ]] || die "$svc is not running PostgreSQL 16 (server_version_num=$ver)"
    # keep md5 hashes from the dump valid (also accepts scram secrets)
    "${DC_CURRENT[@]}" exec -T "$svc" sh -c "sed -i 's/scram-sha-256/md5/g' \"\$PGDATA/pg_hba.conf\""
    psql_in "$svc" -d postgres -Atc "select pg_reload_conf()" >/dev/null
done

say "4. Restoring"
for svc in pg-airflow pg-master; do
    # "already exists" is expected: the new cluster already has its bootstrap role/database
    "${DC_CURRENT[@]}" exec -T "$svc" psql -U "${SUPERUSER[$svc]}" -d postgres -q \
        < "$BACKUP_DIR/$svc.sql" > "$BACKUP_DIR/$svc.restore.log" 2> "$BACKUP_DIR/$svc.restore.err" || true
    unexpected=$(grep -v "already exists" "$BACKUP_DIR/$svc.restore.err" | grep -ciE "error|fatal" || true)
    echo "$svc: $unexpected unexpected error(s) (see $BACKUP_DIR/$svc.restore.err)"
    [[ $unexpected -eq 0 ]] || die "restore of $svc reported errors. Postgres 13 data is intact; see the log"
done

say "5. Comparing row counts"
for svc in pg-airflow pg-master; do
    counts "$svc" "$BACKUP_DIR/$svc.counts.after"
    diff "$BACKUP_DIR/$svc.counts.before" "$BACKUP_DIR/$svc.counts.after" \
        || die "row counts differ for $svc (above). Postgres 13 data is intact"
    echo "$svc: identical row counts"
done

say "6. Analyzing (new cluster has no statistics)"
for svc in pg-airflow pg-master; do
    "${DC_CURRENT[@]}" exec -T "$svc" vacuumdb -U "${SUPERUSER[$svc]}" --all --analyze-only -q
done

say "7. Bringing the whole stack up"
"${DC_NEW[@]}" up -d

cat <<EOF

Done. Check Airflow (http://localhost:8080), Metabase and pgAdmin, and trigger a harmless DAG.

Make it permanent once you are happy: merge $OVERRIDE into docker-compose.yaml
(image: postgres:16 and the pg16-* volumes) and keep using plain \`docker compose\`.
Until then, always pass:  -f docker-compose.yaml -f $OVERRIDE

Rollback: \`docker compose up -d\` with the normal compose file (back on the Postgres 13
volumes; anything written since this upgrade is not there).
Dumps and counts: $BACKUP_DIR
EOF
