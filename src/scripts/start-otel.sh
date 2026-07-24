#!/bin/bash

# Start the OTel Collector + Jaeger stack and print the env vars needed for Goose.
set -euo pipefail

# Pass in the name of the .env file
ENVFILE=$1

echo $ENVFILE

# Load environment variables from .env file
if [[ -n "${ENVFILE}" && -f ${ENVFILE} ]]; then
  echo "*** Loading environment variables from .env..."
  export $(grep -v '^#' ${ENVFILE} | xargs)
  echo "Environment variables loaded."
else
  echo "*** No ENV ${ENVFILE} file found in the current directory. Exiting."
  exit 1
fi

docker compose up -d
# docker compose up otel-collector # for debug


echo ""
echo "OTel stack is running."
echo "Jaeger UI: http://localhost:16686"
