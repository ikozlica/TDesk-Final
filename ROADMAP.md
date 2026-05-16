# TDesk2 Roadmap (Phase 1)

## Guiding principles
- Clean rewrite: legacy только источник требований.
- Никакого mailbox/email threads/встроенной переписки в MVP.
- UI не ходит напрямую в БД; бизнес-логика в domain/application.

## Week 1 — Docs + Architecture Lock
- Зафиксировать PRD/FRD/NFR/RBAC/DOMAIN_RULES.
- Утвердить единую терминологию сущностей и статусов.
- Подготовить архитектурные ADR по слоям и границам модулей.

## Week 2 — Foundation (auth/rbac/audit/references)
- Реализовать auth и модель users/roles.
- Внедрить server-side RBAC enforcement.
- Запустить базовый immutable audit trail.
- Поднять справочники (statuses, currencies, types).

## Week 3 — Clients
- Реализовать модуль Clients (CRUD + связи).
- Добавить валидации и аудит изменений карточки клиента.
- Интегрировать с Dashboard базовые client KPI.

## Week 4 — Orders Foundation
- Реализовать создание/обновление заказов.
- Внедрить жизненный цикл статусов Orders по DOMAIN_RULES.
- Добавить связи с Personnel и Calendar.

## Week 5 — Invoices/Payments Foundation
- Реализовать Invoices lifecycle.
- Реализовать Payments и базовые проверки консистентности.
- Добавить первичные финансовые сводки в Finance модуль.

## Week 6 — Stabilization Checkpoint
- E2E проверки сквозного потока Client→Order→Invoice→Payment/Payout.
- Hardening RBAC и Audit на критичных сценариях.
- Оптимизация производительности и устранение дефектов P1/P2.

## Phase 1 Exit Criteria
1. Все документы Phase 1 утверждены и не содержат шаблонных заглушек.
2. Реализован минимальный сквозной поток Client→Order→Invoice→Payment/Payout.
3. RBAC покрывает Admin/Manager/Finance/Readonly с server-side enforcement.
4. Все критичные операции имеют неизменяемые audit-события.
5. NFR-метрики по reliability/performance/security определены и проверяемы.
6. В функционале отсутствуют mailbox/email threads/встроенная переписка.
7. Проведён stabilization checkpoint с закрытием блокирующих дефектов.
