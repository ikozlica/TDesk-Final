#!/usr/bin/env bash
set -euo pipefail

echo "[db_current] current database revision"
python -m alembic current
