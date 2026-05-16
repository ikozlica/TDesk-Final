#!/usr/bin/env bash
set -euo pipefail

echo "[db_upgrade] upgrading database to head"
python -m alembic upgrade head
