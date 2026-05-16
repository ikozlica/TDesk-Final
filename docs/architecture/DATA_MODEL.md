# DATA_MODEL v1 (Phase D)

## Scope
This document defines Data Model v1 discipline for TDesk2 MVP.
It is limited to foundational entities and migration hygiene. No mailbox/email/chat scope is introduced.

## Naming conventions
- **Tables**: `snake_case`, plural nouns (example: `clients`, `orders`).
- **Columns**: `snake_case`; primary key is `id` (UUID preferred), FK columns end with `_id`.
- **Indexes**: `ix_<table>__<col1>[_<colN>]`.
- **Unique constraints**: `uq_<table>__<col1>[_<colN>]`.
- **Foreign keys**: `fk_<from_table>__<from_col>__<to_table>`.
- **Check constraints**: `ck_<table>__<rule_name>`.

## Nullability policy
- Default posture: business-critical fields are `NOT NULL`.
- Nullable allowed only when absence is a valid domain state:
  - optional references (`approved_by_user_id`),
  - optional timestamps (`paid_at`, `deleted_at`),
  - optional metadata (`external_reference`).
- New columns should be introduced with:
  1. nullable + backfill,
  2. then `NOT NULL` migration when safe.

## Soft-delete policy
- Soft-delete applies to mutable business records (`clients`, `orders`, `invoices`, `payments`) using `deleted_at TIMESTAMPTZ NULL`.
- Soft-deleted rows remain queryable for audit and financial consistency.
- Hard-delete is restricted to:
  - lookup/reference seed data replacement under maintenance windows,
  - pre-production cleanup.
- Financial records are append-first; state transitions are preferred over delete.

## FK strategy
- Default `ON UPDATE RESTRICT`.
- Default `ON DELETE RESTRICT` for accounting chain (`clients -> orders -> invoices -> payments`) to preserve history.
- `ON DELETE SET NULL` permitted only for optional references where domain rules allow orphaning.
- `ON DELETE CASCADE` only for purely technical child rows with no business identity.

## Index strategy
Required baseline indexes for first vertical slice:
- `clients`: unique business key (`tenant_id`, `client_code`).
- `orders`: unique (`tenant_id`, `order_number`), plus index on (`tenant_id`, `client_id`, `created_at`).
- `invoices`: unique (`tenant_id`, `invoice_number`), index on (`tenant_id`, `order_id`).
- `payments`: unique external id per tenant when present (`tenant_id`, `provider_payment_id`) with partial-unique semantics if nullable.
- Soft-delete aware access paths should include `deleted_at` when query plans require it.

## Baseline entity contract (Phase D prep only)
- **Client**: identity + lifecycle status.
- **Order**: belongs to client.
- **Invoice**: belongs to order.
- **Payment**: belongs to invoice.
- Cross-entity invariants are enforced in domain/application layers; schema enforces identity/referential integrity only.

## Secrets policy
- Never commit secrets/passwords/connection URLs with credentials in migrations, fixtures, or scripts.
- Migration scripts must read connection info from environment variables.
