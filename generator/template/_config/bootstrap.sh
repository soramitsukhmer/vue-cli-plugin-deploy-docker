#!/bin/sh
set -e

apk update
apk add --no-cache git openssh jq
