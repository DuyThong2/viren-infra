#!/bin/bash
set -euxo pipefail

APP_DIR="/opt/viren"
TPL_DIR="${APP_DIR}/templates"

cp "${TPL_DIR}/docker-compose.yml.tmpl" "${APP_DIR}/docker-compose.yml"
