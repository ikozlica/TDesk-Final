# TEST STRATEGY (Phase D update)

## Goal
Add migration safety checks as a required quality gate.

## Required checks
- Lint/type/test baseline:
  - `ruff check src tests`
  - `mypy src`
  - `pytest -q`
- Migration checks:
  - `alembic heads`
  - `alembic current`
  - `alembic history`
  - `alembic upgrade head` against clean test DB
  - `scripts/db_verify.sh`

## Migration-specific assertions
- Upgrade from clean DB to head succeeds.
- Branch has no unexpected multiple heads for main-targeted change.
- Key schema artifacts exist (tables/indexes/constraints for Client→Order→Invoice→Payment chain).
- Verify process is idempotent (rerun produces same successful outcome).

## CI posture
- Run migration verification as a separate job/stage.
- Block merges when migration job fails.
- Persist Alembic command output as build artifacts for investigation.
