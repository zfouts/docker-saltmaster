#!/bin/bash
set -o pipefail
set -e

if [[ -z "${NODE_LABELS}" ]]; then
  echo "Please set NODE_LABELS"
  exit 1
fi

cmd=$1

docker_build_init() {
  if [ "$(echo ${NODE_LABELS}|awk '{print $1}')" == "armhf" ];
  then
    BUILD_ARCH=$(uname -m)
    IMAGE=debian:8
    DOCKERFILE=Dockerfile.${BUILD_ARCH}
  else
    BUILD_ARCH=$(uname -m)
    IMAGE=debian:9
    DOCKERFILE=Dockerfile
  fi
  docker_build
}

docker_build() {
  local build_sha=$(git rev-parse HEAD)
  docker build --label built_on=${IMAGE} --label maintainer=${EMAIL} --label build.sha=${build_sha} -t ${REPO_NAME}:master -f ./${DOCKERFILE} . \
  && docker_push
}

docker_push() {
  docker login -u="${docker_username}" -p="${docker_password}"
  local version_iteration="${REPO_NAME}:${VERSION_IMAGE_TAG}_${BUILD_ARCH}"

  # Push Tags
  docker tag ${REPO_NAME}:master ${version_iteration}
  docker push ${version_iteration}
}

build_commands () {
    if [ "$cmd" == "build" ]; then
        docker_build_init
    elif [ "$cmd" == "push" ]; then
        docker_push
    elif [ "$cmd" == "deploy" ]; then
        docker_build_init
        docker_push
    fi
}

prompt_confirm() {
    read -r -n 1 -p "${1} [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

check_deploy() {
    echo "Checking..."
    if [[ -z "${JENKINS}" || "${JENKINS}" != true ]]; then
        prompt_confirm "You are trying to deploy outside of Jenkins. Are you sure?" || exit 0
    fi
}

case "$cmd" in
    "build")
        build_commands
        ;;
    "deploy")
        check_deploy
        build_commands
        ;;
    *)
        echo "usage: $0 [build|deploy]"
        ;;
esac

