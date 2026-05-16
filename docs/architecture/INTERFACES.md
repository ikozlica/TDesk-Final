# INTERFACES (Data/DB implications)

## Layer boundary rules
- UI layer must not access DB directly.
- Application layer depends on repository interfaces.
- Infrastructure layer implements persistence adapters and Alembic migrations.

## Repository contracts (Phase D baseline)
- `ClientRepository`: create/get/list soft-active clients.
- `OrderRepository`: create/get orders by client.
- `InvoiceRepository`: create/get invoices by order.
- `PaymentRepository`: record/get payments by invoice.

All contracts must be tenant-aware and return domain-safe models, not raw SQL rows.

## DB transaction boundary
- Application services own transaction scope via unit-of-work abstraction.
- Repositories should avoid implicit auto-commit behavior.

## Migration contract
- Main branch policy: single Alembic head.
- If multiple heads appear, merge migration is required before release.
- Downgrades are smoke-tested for latest step where feasible; destructive downgrades must be documented.
