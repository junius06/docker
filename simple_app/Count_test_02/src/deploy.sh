#!/bin/bash

# 1. 도커 레지스트리에 대해 변수 설정, 변수 파일 추가 필요
# 2. 도커 이미지에 대한 태그 설정 필요

DOCKER_APP=count-app
DOCKER_REPO=junius06
IMAGE_TAG=latest

docker pull $DOCKER_REGISTRY/$DOCKER_APP:latest

# blue를 기준으로 현재 떠있는 컨테이너를 체크한다.
EXIST_BLUE=$(docker-compose -p ${DOCKER_APP}-blue -f docker-compose.blue.yml ps | grep ${DOCKER_APP}-blue)

# 컨테이너 스위칭
if [ -z "$EXIST_BLUE" ]; then
    # blue 컨테이너가 없으면 Up
    echo "blue up"
    docker-compose -p ${DOCKER_APP}-blue -f docker-compose.blue.yml up -d
    BEFORE_COMPOSE_COLOR="green"
    AFTER_COMPOSE_COLOR="blue"
else
    # blue 컨테이너가 있으면 green Up
    echo "green up"
    docker-compose -p ${DOCKER_APP}-green -f docker-compose.green.yml up -d
    BEFORE_COMPOSE_COLOR="blue"
    AFTER_COMPOSE_COLOR="green"
fi

sleep 10

# 새로운 컨테이너(green) Up 상태 확인
EXIST_AFTER=$(docker-compose -p ${DOCKER_APP}-${AFTER_COMPOSE_COLOR} -f docker-compose.${AFTER_COMPOSE_COLOR}.yml ps | grep ${DOCKER_APP}-${AFTER_COMPOSE_COLOR})
if [ -n "$EXIST_AFTER" ]; then
  # green 컨테이너 up 되었을 경우
  # nginx가 설치되어있고 test conf 파일을 nginx conf 파일이라고 가정했을 때, 아래와 같이 수정한 파일을 서비스 파일로 복사하여 서비스를 reload 한다.
  # cp ~/app/conf/${AFTER_COMPOSE_COLOR}-test.conf ~/app/conf/test.conf
  # nginx -s reload
  # 이전 컨테이너 종료
  docker-compose -p ${DOCKER_APP}-${BEFORE_COMPOSE_COLOR} -f docker-compose.${BEFORE_COMPOSE_COLOR}.yml down # up 상태의 green 컨테이너를 down 한다.
  docker rmi $(docker images --filter=reference="${DOCKER_REPO}/${DOCKER_APP}:${IMAGE_TAG}") # green 컨테이너의 이미지를 삭제한다.
  docker rmi $(docker images -q --filter "dangling=true") # none 값을 가지고 있는 이미지들 없애버리자!
  echo "$BEFORE_COMPOSE_COLOR down"
fi