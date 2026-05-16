#!/usr/bin/env bash
set -euo pipefail

python -m alembic heads
python -m alembic history
python -m alembic current || true
python -m alembic upgrade head
python -m alembic current
