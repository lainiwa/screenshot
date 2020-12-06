#!/bin/sh

set -o errexit  # exit on fail
set -o nounset  # exit on undeclared variable
# set -o xtrace   # trace execution

# docker build -t screenshot .

SCREENSHOT_DIR=${SCREENSHOT_DIR:-${PWD}/shared}

mkdir -p "${SCREENSHOT_DIR}"

docker run \
    --user "$(id -u):$(id -g)" \
    -e "DISPLAY=unix${DISPLAY}" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e SCREENSHOT_DIR=/opt/shared \
    -v "${SCREENSHOT_DIR}:/opt/shared" \
    --rm screenshot "$@"
