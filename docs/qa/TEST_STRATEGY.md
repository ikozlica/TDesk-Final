# TEST STRATEGY (Phase D)

## Goal
Enforce production-grade data/migration safety gates before merge.

## Phase D QA gates (local + CI)
Required commands:
- `ruff check src tests`
- `mypy src`
- `pytest -q`
- `alembic heads`
- `alembic history`
- `alembic upgrade head` (clean DB)
- `alembic current`
- `scripts/db_verify.sh`

## Migration verification assertions
- Single-head policy is enforced for `main` target branches.
- History chain is continuous and readable.
- Upgrade from clean DB to `head` succeeds.
- Current revision equals expected head revision.
- Verification scripts return non-zero exit code on policy violations.

## Rollback and rollout QA
For potentially unsafe migrations, tests must validate staged rollout:
- expand step is backward-compatible,
- backfill is idempotent,
- contract step is executed only after safety checks.

## CI posture
- Run migration checks as a dedicated blocking stage.
- Archive Alembic/script logs as CI artifacts.
- Any failure in Phase D gates blocks merge.
