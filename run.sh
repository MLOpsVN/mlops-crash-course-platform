#!/bin/bash

service=$1
cmd=$2

# define service name
AIRFLOW="airflow"
ELK="elk"
FEAST="feast"
JENKINS="jenkins"
MLFLOW="mlflow"
PROMETHEUS_GRAFANA="prometheus-grafana"

usage() {
    echo "run.sh <service> <command>"
    echo "Available services:"
    echo " all                  all services"
    echo " airflow              airflow service"
    echo " elk                  elk service"
    echo " feast                feast service"
    echo " jenkins              jenkins service"
    echo " mlflow               mlflow service"
    echo " prometheus-grafana   prometheus and grafana service"
    echo "Available commands:"
    echo " up                   deploy service"
    echo " down                 stop and remove containers, networks"
}

up() {
    service=$1
    docker-compose -f $service/$service-docker-compose.yml up -d
}

down() {
    service=$1
    #! Using --volumes will remove volumes
    docker-compose -f $service/$service-docker-compose.yml down
}

# AIRFLOW
up_airflow() {
    env_file="$AIRFLOW/.env"
    if [[ ! -f "$env_file" ]]; then
        echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > "$env_file"
    fi
    up "$AIRFLOW"
}

down_airflow() {
    down "$AIRFLOW"
}

# ELK
up_elk() {
    up "$ELK"
}

down_elk() {
    down "$ELK"
}

# FEAST
up_feast() {
    up "$FEAST"
}

down_feast() {
    down "$FEAST"
}

# JENKINS
up_jenkins() {
    up "$JENKINS"
}

down_jenkins() {
    down "$JENKINS"
}

# MLFLOW
up_mlflow() {
    up "$MLFLOW"
}

down_mlflow() {
    down "$MLFLOW"
}

# PROMETHEUS_GRAFANA
up_prometheus_grafana() {
    up "$PROMETHEUS_GRAFANA"
}

down_prometheus_grafana() {
    down "$PROMETHEUS_GRAFANA"
}

# ALL
up_all() {
    up_airflow
    up_elk
    up_feast
    up_jenkins
    up_mlflow
    up_prometheus_grafana
}

down_all() {
    down_airflow
    down_elk
    down_feast
    down_jenkins
    down_mlflow
    down_prometheus_grafana
}

if [[ -z "$cmd" ]]; then
    echo "Missing command"
    usage
    exit 1
fi

if [[ -z "$service" ]]; then
    echo "Missing service"
    usage
    exit 1
fi

shift 2

case $cmd in
up)
    case $service in
        all)
            up_all "$@"
            ;;
        "$AIRFLOW")
            up_airflow "$@"
            ;;
        "$ELK")
            up_elk "$@"
            ;;
        "$FEAST")
            up_feast "$@"
            ;;
        "$JENKINS")
            up_jenkins "$@"
            ;;
        "$MLFLOW")
            up_mlflow "$@"
            ;;
        "$PROMETHEUS_GRAFANA")
            up_prometheus_grafana "$@"
            ;;
        *)
            echo "Unknown service"
            usage
            exit 1
            ;;
    esac
    ;;

down)
    case $service in
        all)
            down_all "$@"
            ;;
        "$AIRFLOW")
            down_airflow "$@"
            ;;
        "$ELK")
            down_elk "$@"
            ;;
        "$FEAST")
            down_feast "$@"
            ;;
        "$JENKINS")
            down_jenkins "$@"
            ;;
        "$MLFLOW")
            down_mlflow "$@"
            ;;
        "$PROMETHEUS_GRAFANA")
            down_prometheus_grafana "$@"
            ;;
        *)
            echo "Unknown service"
            usage
            exit 1
            ;;
    esac
    ;;

*)
    echo "Unknown command"
    usage
    exit 1
    ;;
esac
