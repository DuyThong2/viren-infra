#!/bin/bash
set -euxo pipefail

echo "=== USER_DATA_MARKER: 2026-03-04-TEST-123 ==="

APP_DIR="/opt/viren"
SCRIPTS_DIR="$APP_DIR/scripts"
TPL_DIR="$APP_DIR/templates"

mkdir -p "$APP_DIR" "$SCRIPTS_DIR" "$TPL_DIR"

cat > "$APP_DIR/.env" <<'__VIREN_ENV_EOF__'
${env_file}
__VIREN_ENV_EOF__
chmod 600 "$APP_DIR/.env"

cat > "$TPL_DIR/docker-compose.yml.tmpl" <<'__VIREN_COMPOSE_EOF__'
${DOCKER_COMPOSE_TMPL}
__VIREN_COMPOSE_EOF__

cat > "$SCRIPTS_DIR/01-install-docker.sh" <<'__VIREN_S01_EOF__'
${SCRIPT_01}
__VIREN_S01_EOF__

cat > "$SCRIPTS_DIR/03-write-compose.sh" <<'__VIREN_S03_EOF__'
${SCRIPT_03}
__VIREN_S03_EOF__

cat > "$SCRIPTS_DIR/05-run-compose.sh" <<'__VIREN_S05_EOF__'
${SCRIPT_05}
__VIREN_S05_EOF__

chmod +x "$SCRIPTS_DIR"/*.sh

bash "$SCRIPTS_DIR/01-install-docker.sh"
bash "$SCRIPTS_DIR/03-write-compose.sh"
bash "$SCRIPTS_DIR/05-run-compose.sh"

echo "DONE"