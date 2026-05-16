# MIGRATIONS_POLICY (Phase D)

## Mainline head policy
- `main` must always converge to a **single Alembic head**.
- Multiple heads are allowed only temporarily on feature branches.
- Before merge to `main`, branch owner must either:
  1. rebase on latest `main` so only one head remains, or
  2. create an explicit merge migration and verify the merged head.

## Branching and merge migration rules
- Every migration PR must run `alembic heads` and publish output in CI logs.
- If `alembic heads` returns more than one head, PR is blocked.
- Merge revisions must:
  - reference all divergent parent revisions,
  - contain no hidden schema changes,
  - be named clearly (`merge_<date>_<topic>`).

## Revision discipline
- One migration per cohesive schema change.
- `upgrade()` and `downgrade()` must both be explicit.
- Revision message must describe schema intent.

## Rollback-safe policy (expand/contract)
Unsafe operations (must be staged):
- dropping columns/tables,
- destructive type changes,
- renames consumed by mixed-version deployments,
- adding `NOT NULL`/`UNIQUE` without data prep.

Safe staged rollout:
1. **Expand**: additive nullable columns/tables/indexes.
2. **Backfill**: idempotent data migration and validation.
3. **Contract**: enforce constraints, remove obsolete structures.

## Data & secrets safety
- No secrets/credentials in repo, migration code, or script logs.
- Database URL must come from environment (`DATABASE_URL`).
- Migrations must not depend on external mutable services.

## Mandatory Phase D verification gates
Required before merge and in CI:
- `ruff check src tests`
- `mypy src`
- `pytest -q`
- `alembic heads`
- `alembic history`
- `alembic upgrade head` (on clean DB)
- `alembic current`
- `scripts/db_verify.sh`
