#!/bin/bash
set -o pipefail
set -e
set -x

# You need VERSON_IMAGE_TAG, IMAGE, REPO_NAME, EMAIL defined.
VERSION_IMAGE_TAG=2018.3.3
EMAIL=zach@linux.com
REPO_NAME=fouts/salt-master
IMAGE=ubuntu:16.04

cmd=$1
docker_build() {
    local build_sha=$(git rev-parse HEAD)
    docker build --build-arg IMAGE=${IMAGE} --build-arg EMAIL=${EMAIL} --label build.sha=${build_sha} -t ${REPO_NAME}:master .
}

docker_push() {
    local version="${REPO_NAME}:${VERSION_IMAGE_TAG}"
    local version_iteration="${REPO_NAME}:${VERSION_IMAGE_TAG}_$(uname -m)"

#    docker login -u="${docker_username}" -p="${docker_password}"

    # Push Tags
    docker tag ${REPO_NAME}:master ${version_iteration}
    docker push ${version_iteration}
    docker images
}

build_commands () {
    if [ "$cmd" == "build" ]; then
        docker_build
    elif [ "$cmd" == "push" ]; then
        docker_push
    elif [ "$cmd" == "deploy" ]; then
        docker_build
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
        echo NO SIR
        ;;
esac
