#!/usr/bin/env bash
set -euo pipefail

EXPECTED_REVISION="${1:-}"

echo "[db_verify] preflight: checking alembic availability"
python -m alembic --help >/dev/null

echo "[db_verify] preflight: resolving heads"
HEADS_RAW="$(python -m alembic heads)"
echo "$HEADS_RAW"

HEAD_COUNT="$(printf '%s\n' "$HEADS_RAW" | sed '/^\s*$/d' | wc -l | tr -d ' ')"
if [ "$HEAD_COUNT" -ne 1 ]; then
  echo "[db_verify] ERROR: expected single head, got $HEAD_COUNT"
  exit 2
fi

HEAD_REVISION="$(printf '%s\n' "$HEADS_RAW" | awk '{print $1}' | head -n1)"
echo "[db_verify] detected head revision: $HEAD_REVISION"

echo "[db_verify] migration history"
python -m alembic history

echo "[db_verify] upgrade to head"
python -m alembic upgrade head

echo "[db_verify] current revision"
CURRENT_RAW="$(python -m alembic current)"
echo "$CURRENT_RAW"
CURRENT_REVISION="$(printf '%s\n' "$CURRENT_RAW" | awk '{print $1}' | head -n1)"

if [ -n "$EXPECTED_REVISION" ] && [ "$CURRENT_REVISION" != "$EXPECTED_REVISION" ]; then
  echo "[db_verify] ERROR: expected revision '$EXPECTED_REVISION', got '$CURRENT_REVISION'"
  exit 3
fi

if [ "$CURRENT_REVISION" != "$HEAD_REVISION" ]; then
  echo "[db_verify] ERROR: current revision '$CURRENT_REVISION' does not match head '$HEAD_REVISION'"
  exit 4
fi

echo "[db_verify] OK: database is at single head revision '$CURRENT_REVISION'"
