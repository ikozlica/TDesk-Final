#!/usr/bin/env bash
set -euo pipefail

echo "[db_history] migration history"
python -m alembic history
