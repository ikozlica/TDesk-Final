# DATA_MODEL v1 (Phase D)

## Scope
Phase D defines schema and migration contracts for MVP data foundations only.
Out of scope: mailbox/email/chat.

## DB naming conventions
- Tables: `snake_case`, plural (`clients`, `orders`).
- Columns: `snake_case`.
- Primary keys: `pk_<table>`.
- Foreign keys: `fk_<from_table>__<from_col>__<to_table>`.
- Unique constraints: `uq_<table>__<col1>[_<colN>]`.
- Indexes: `ix_<table>__<col1>[_<colN>]`.
- Check constraints: `ck_<table>__<rule_name>`.

## Nullability policy
- Default: columns are `NOT NULL`.
- Nullable only when absence is a valid domain state (`deleted_at`, optional external IDs, optional actor refs).
- New required columns use phased rollout: nullable -> backfill -> enforce `NOT NULL`.

## FK policy
- Default: `ON UPDATE RESTRICT`.
- Financial chain `Client -> Order -> Invoice -> Payment`: `ON DELETE RESTRICT`.
- `ON DELETE SET NULL` only for truly optional references.
- `ON DELETE CASCADE` only for technical dependent rows without business identity.

## Soft-delete and immutability policy
- `deleted_at` allowed for mutable aggregates that may be hidden operationally (clients/orders).
- Invoices/payments are financially sensitive: append-only lifecycle preferred; no destructive deletes.
- Immutable/audit records must remain history-preserving.

## Index policy for critical workflows
Minimum guarantees for Client -> Order -> Invoice -> Payment:
- `clients`: `uq_clients__tenant_id_client_code`.
- `orders`: `uq_orders__tenant_id_order_number`; supporting read index on `(tenant_id, client_id, created_at)`.
- `invoices`: `uq_invoices__tenant_id_invoice_number`; supporting index on `(tenant_id, order_id)`.
- `payments`: uniqueness for provider reference per tenant when present (partial unique semantics if nullable).

## Vertical slice contract readiness
Phase D guarantees referential chain feasibility:
- `orders.client_id -> clients.id`
- `invoices.order_id -> orders.id`
- `payments.invoice_id -> invoices.id`

Business invariants remain in domain/application layers.

## Secrets policy
- Secrets are forbidden in repository files, migrations, and script output.
- Connection details are environment-driven only.
