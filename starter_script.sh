#!/bin/bash
set -e

echo "Creating required directories..."
mkdir -p ./airflow/dags
mkdir -p ./airflow/logs
mkdir -p ./airflow/plugins
mkdir -p ./notebooks
mkdir -p ./pgadmin
mkdir -p ./postgress_db
mkdir -p ./metabase

echo "Building algotrading images..."
docker-compose build

echo "Starting algotrading stack..."
docker-compose up -d

echo "Stack is up. Check service status with: docker-compose ps"
