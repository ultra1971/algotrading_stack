echo "create folders needed"
mkdir ./airflow
mkdir ./airflow/dags
mkdir ./airflow/logs
mkdir ./airflow/plugins
mkdir ./mlflow-image
mkdir ./notebooks
mkdir ./pgadmin
mkdir ./postgress_db
mkdir ./superset

echo "build algotrading image"
docker-compose build

echo "run algotrading image"
docker-compose up -d

echo "scripts on superset"
docker exec -it superset superset fab create-admin \
               --username admin \
               --firstname Superset \
               --lastname Admin \
               --email admin@superset.com \
               --password admin
docker exec -it superset superset db upgrade
docker exec -it superset superset init

