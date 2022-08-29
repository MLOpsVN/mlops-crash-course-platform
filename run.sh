#!/bin/bash
declare -a services=("airflow" "elk" "feast" "jenkins" "mlflow" "prometheus-grafana")

# iterate over all services
for service in ${services[@]}; do
    if [ $service == "airflow" ]; then
        echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > $service/.env
    fi
    docker-compose -f $service/$service-docker-compose.yml down
done