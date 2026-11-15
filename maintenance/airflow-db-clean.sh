#!/usr/bin/env bash
# Purge Airflow metadata (dag runs, task instances, XCom, logs...) older than RETENTION_DAYS.
#
# Airflow 3 blocks metadata DB access from tasks, so this cannot run as a DAG: run it from
# the host instead, e.g. weekly from root's crontab:
#   0 3 * * 0  /home/algotrading/docker/algotrading_stack/maintenance/airflow-db-clean.sh >> /var/log/airflow-db-clean.log 2>&1
# The first run can take a long time (it deletes the whole backlog); --verbose prints each table.
set -euo pipefail

RETENTION_DAYS="${RETENTION_DAYS:-30}"
cd "$(dirname "$0")/.."

before="$(date -u -d "-${RETENTION_DAYS} days" +%Y-%m-%dT%H:%M:%S+00:00)"
echo "$(date -Is) Cleaning Airflow metadata older than ${before}"
# dag / dag_version are left out: old versions are still referenced by serialized_dag and
# dag_code, so deleting them fails and aborts the transaction for every table after it.
TABLES="log,job,dag_run,task_instance,task_instance_history,task_reschedule,xcom,_xcom_archive,trigger,asset_event,import_error,sla_miss,callback_request,celery_taskmeta,celery_tasksetmeta,deadline,session"

docker compose exec -T airflow-scheduler \
    airflow db clean --yes --skip-archive --verbose --tables "${TABLES}" --clean-before-timestamp "${before}"

# Drop any _airflow_deleted__* table left behind by an interrupted or failed clean.
docker compose exec -T airflow-scheduler airflow db drop-archived --yes
echo "$(date -Is) Done"
