# MIGRATIONS_POLICY (Phase D)

## Branching & heads
- Target state for `main`: exactly one head.
- Feature branches may temporarily diverge; before merge they must:
  1. rebase/merge latest main,
  2. run `alembic heads`,
  3. add merge revision if multiple heads remain.

## Revision discipline
- One migration per cohesive schema change.
- Revisions must include both `upgrade()` and explicit `downgrade()` behavior.
- Revision message must describe intent, not ticket-only labels.

## Rollback-safe policy
Unsafe operations (require expand/contract pattern):
- dropping columns/tables,
- renaming columns used by running app versions,
- changing type/constraints that can truncate or reject existing data.

Safe pattern:
1. **Expand**: add new nullable structures.
2. **Backfill**: migrate data with idempotent scripts.
3. **Contract**: enforce new constraints/remove old structures in later release.

## Data safety
- Never embed secrets in migrations.
- Never depend on mutable external services during migration.
- Long locks should be minimized (batch operations/index concurrently where supported).

## Verification requirements
Each PR with migration changes must pass:
- `alembic heads` (single head in main-targeted branch),
- `alembic history` (continuous chain),
- `alembic upgrade head` on clean DB,
- project `db_verify` script.
