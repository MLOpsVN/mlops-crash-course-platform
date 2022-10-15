#!/bin/bash

service=$1
cmd=$2

# define service name
AIRFLOW="airflow"
ELK="elk"
FEAST="feast"
JENKINS="jenkins"
MLFLOW="mlflow"
PROM_GRAF="prom-graf"
RESTART_SLEEP_SEC=2

usage() {
    echo "run.sh <service> <command> [options]"
    echo "Available services:"
    echo " all                  all services"
    echo " $AIRFLOW             airflow service"
    echo " $ELK                 elk service"
    echo " $FEAST               feast service"
    echo " $JENKINS             jenkins service"
    echo " $MLFLOW              mlflow service"
    echo " $PROM_GRAF           prometheus and grafana service"
    echo "Available commands:"
    echo " up                   deploy service"
    echo " down                 stop and remove containers, networks"
    echo " restart              down then up"
    echo "Available options:"
    echo " --build              rebuild when up"
    echo " --volumes            remove volumes when down"
}

get_docker_compose_file() {
    service=$1
    docker_compose_file="$service/$service-docker-compose.yml"
    echo "$docker_compose_file"
}

init_docker_swarm()
{
    if [ "$(docker info | grep Swarm | sed 's/ Swarm: //g')" == "inactive" ]; then
        echo "init_docker_swarm"
        docker swarm init --advertise-addr 127.0.0.1 --listen-addr 127.0.0.1
    fi
}

up() {
    service=$1
    shift
    docker_compose_file=$(get_docker_compose_file $service)

    # Use docker-compose
    docker-compose -f "$docker_compose_file" up -d "$@"

    # Use docker swarm
    # init_docker_swarm
    # docker stack deploy --resolve-image always --prune --with-registry-auth --compose-file "$docker_compose_file" "$service"
}

down() {
    service=$1
    shift
    docker_compose_file=$(get_docker_compose_file $service)

    # Use docker-compose
    docker-compose -f "$docker_compose_file" down "$@"

    # Use docker swarm
    # docker stack rm "$service"
}

# AIRFLOW
up_airflow() {
    env_file="$AIRFLOW/.env"
    if [[ ! -f "$env_file" ]]; then
        echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > "$env_file"
    fi
    up "$AIRFLOW" "$@"
}

down_airflow() {
    down "$AIRFLOW" "$@"
}

# ELK
up_elk() {
    docker-compose -f "$ELK/$ELK-docker-compose.yml" -f "$ELK/extensions/filebeat/filebeat-compose.yml" up -d "$@"
}

down_elk() {
    docker-compose -f "$ELK/$ELK-docker-compose.yml" -f "$ELK/extensions/filebeat/filebeat-compose.yml" down "$@"
}

# FEAST
up_feast() {
    up "$FEAST" "$@"
}

down_feast() {
    down "$FEAST" "$@"
}

# JENKINS
up_jenkins() {
    up "$JENKINS" "$@"
}

down_jenkins() {
    down "$JENKINS" "$@"
}

# MLFLOW
up_mlflow() {
    up "$MLFLOW" "$@"
}

down_mlflow() {
    down "$MLFLOW" "$@"
}

# PROM_GRAF
up_prom_graf() {
    up "$PROM_GRAF" "$@"
}

down_prom_graf() {
    down "$PROM_GRAF" "$@"
}

# ALL
up_all() {
    up_airflow "$@"
    up_elk "$@"
    up_feast "$@"
    up_jenkins "$@"
    up_mlflow "$@"
    up_prom_graf "$@"
}

down_all() {
    down_airflow "$@"
    down_elk "$@"
    down_feast "$@"
    down_jenkins "$@"
    down_mlflow "$@"
    down_prom_graf "$@"
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
        "$PROM_GRAF")
            up_prom_graf "$@"
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
        "$PROM_GRAF")
            down_prom_graf "$@"
            ;;
        *)
            echo "Unknown service"
            usage
            exit 1
            ;;
    esac
    ;;

restart)
    case $service in
        all)
            down_all "$@"
            sleep $RESTART_SLEEP_SEC
            up_all "$@"
            ;;
        "$AIRFLOW")
            down_airflow "$@"
            sleep $RESTART_SLEEP_SEC
            up_airflow "$@"
            ;;
        "$ELK")
            down_elk "$@"
            sleep $RESTART_SLEEP_SEC
            up_elk "$@"
            ;;
        "$FEAST")
            down_feast "$@"
            sleep $RESTART_SLEEP_SEC
            up_feast "$@"
            ;;
        "$JENKINS")
            down_jenkins "$@"
            sleep $RESTART_SLEEP_SEC
            up_jenkins "$@"
            ;;
        "$MLFLOW")
            down_mlflow "$@"
            sleep $RESTART_SLEEP_SEC
            up_mlflow "$@"
            ;;
        "$PROM_GRAF")
            down_prom_graf "$@"
            sleep $RESTART_SLEEP_SEC
            up_prom_graf "$@"
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
