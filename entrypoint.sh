#!/bin/bash -l
set -xeEuo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 REMOTE_URL" >&2
  exit 1
fi

REMOTE_URL=$1
REMOTE=upstream-$(date +%s)

trap "git remote rm $REMOTE" ERR SIGHUP SIGINT SIGTERM

declare EXTRA_ARGS

if [[ ${SKIP_HOOKS:-} == "true" ]]; then
  EXTRA_ARGS+="--no-verify "
fi

if [[ ${FORCE_PUSH:-} == "true" ]]; then
  EXTRA_ARGS+="-f "
fi

git remote add $REMOTE $REMOTE_URL
git push $EXTRA_ARGS $REMOTE HEAD:master
