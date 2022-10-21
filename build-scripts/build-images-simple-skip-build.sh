#!/bin/bash

function build_basic_images() {
  JAR_FILE=$1
  APP_NAME=$2

  docker build -f ./build-scripts/docker/basic/Dockerfile \
    --build-arg JAR_FILE=${JAR_FILE} \
    -t ${APP_NAME}:latest \
    -t ${APP_NAME}:simple .
}

function build_jar() {
  # Get count of args
for var in $@
  do
    DIR=$var
    echo "Building JAR files for ${DIR}"
    CD_PATH="./${DIR}"
    cd ${CD_PATH}
    mvn clean package -T 3 -DskipTests
    cd ..
  done
}

function build_lib() {
  # Get count of args
for var in $@
  do
    DIR=$var
    echo "Building JAR files for ${DIR}"
    CD_PATH="./${DIR}"
    cd ${CD_PATH}
    mvn clean install -T 3 -DskipTests
    cd ..
  done
}

function pull_or_clone_proj() {
  SERVICE_NAME=$1
  echo $SERVICE_NAME
  SERVICE_URL=$2
 if cd ${SERVICE_NAME}
  then
 #  git branch -f master origin/master
   git checkout hometask-4
   git pull
   cd ..
  else
    git clone --branch hometask-4 ${SERVICE_URL} ${SERVICE_NAME}
 fi
}
function pull_rabbit() {
    docker pull rabbitmq:3-management
}
function start_rabbit() {
    docker run --rm -it --hostname my-rabbit -p 15672:15672 -p 5672:5672 rabbitmq:3-management
}
function start_postgres() {
    docker run --name liga-pg -e POSTGRES_PASSWORD=root -d postgres
}

# Building the app
cd ..

echo "CLONING"
# Clone or update projects
#pull_or_clone_proj common-module https://github.com/bolshakovk/common-module.git
#pull_or_clone_proj medical-monitoring https://github.com/bolshakovk/medical-monitoring.git
pull_or_clone_proj message-analyzer https://github.com/bolshakovk/liga-medical-clinic.git
#pull_or_clone_proj person-service https://github.com/bolshakovk/person-service.git
#build_lib common-module

build_jar  message-analyzer  #medical-monitoring person-service

pull_rabbit
start_rabbit
start_postgres

APP_VERSION=0.0.1-SNAPSHOT


echo "Building Docker images"
#build_basic_images ./medical-monitoring/core/target/medical-monitoring-${APP_VERSION}.jar application/medical-monitoring
#build_basic_images ./message-analyzer/core/target/message-analyzer-${APP_VERSION}.jar application/message-analyzer
#build_basic_images ./person-service/core/target/person-service-${APP_VERSION}.jar application/person-service