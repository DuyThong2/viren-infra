#!/bin/bash
set -euxo pipefail

cd /opt/viren

# náº¿u image private: báº¡n SSH vÃ o vÃ  docker login thá»§ cÃ´ng
docker compose --env-file .env pull || true
docker compose --env-file .env up -d
docker compose ps
