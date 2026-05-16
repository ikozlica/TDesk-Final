# Domain Rules — TDesk2

## Clients
- **CL-001**
  - Rule text: Клиент должен иметь уникальный business identifier.
  - Rationale: Исключить дубли и расхождения в отчётности.
  - Enforcement level: hard.
- **CL-002**
  - Rule text: Деактивация клиента возможна только при отсутствии активных заказов.
  - Rationale: Не нарушать операционные цепочки.
  - Enforcement level: hard.

## Orders
- **OR-001**
  - Rule text: Order не может быть создан без ссылки на Client.
  - Rationale: Обеспечить связность домена.
  - Enforcement level: hard.
- **OR-002 (status transitions)**
  - Rule text: Допустимые статусы: Draft -> Confirmed -> InProgress -> Completed; Cancelled допустим из Draft/Confirmed.
  - Rationale: Предсказуемый жизненный цикл заказа.
  - Enforcement level: hard.
- **OR-003**
  - Rule text: Переход в Completed запрещён при наличии незакрытых обязательств по Invoice/Payout.
  - Rationale: Финансовая консистентность.
  - Enforcement level: hard.

## Invoices
- **IN-001**
  - Rule text: Invoice должен ссылаться на существующий Order.
  - Rationale: Трассируемость финансового документа.
  - Enforcement level: hard.
- **IN-002 (status transitions)**
  - Rule text: Draft -> Issued -> Paid; Overdue допустим из Issued; Cancelled допустим из Draft/Issued (до Paid).
  - Rationale: Контроль корректного оборота счетов.
  - Enforcement level: hard.
- **IN-003**
  - Rule text: Paid Invoice нельзя редактировать, кроме технических полей с спец. разрешением.
  - Rationale: Защита финансовой целостности.
  - Enforcement level: hard.

## Payments
- **PM-001**
  - Rule text: Payment не может превышать остаток по Invoice.
  - Rationale: Предотвратить переплату в системе учёта.
  - Enforcement level: hard.
- **PM-002**
  - Rule text: Частичные оплаты агрегируются и обновляют остаток Invoice.
  - Rationale: Корректная поддержка частичных платежей.
  - Enforcement level: hard.

## Personnel
- **PE-001**
  - Rule text: Назначение на Order доступно только active personnel.
  - Rationale: Исключить фиктивные назначения.
  - Enforcement level: hard.
- **PE-002**
  - Rule text: Конфликт занятости в критичное время помечается предупреждением.
  - Rationale: Улучшить планирование без лишней блокировки операций.
  - Enforcement level: soft.

## Payouts
- **PO-001**
  - Rule text: Payout должен иметь основание (Order/period/approved work).
  - Rationale: Обоснованность финансового обязательства.
  - Enforcement level: hard.
- **PO-002 (status transitions)**
  - Rule text: Draft -> Approved -> Scheduled -> Paid; Cancelled допустим из Draft/Approved.
  - Rationale: Контролируемый процесс выплаты.
  - Enforcement level: hard.
- **PO-003**
  - Rule text: Повторная выплата по одному основанию запрещена без override-права и audit reason.
  - Rationale: Предотвратить дублирование выплат.
  - Enforcement level: hard.

## Finance
- **FI-001**
  - Rule text: Любая manual adjustment требует указания причины и автора.
  - Rationale: Прозрачность и аудитируемость.
  - Enforcement level: hard.
- **FI-002**
  - Rule text: Финансовая сводка строится только из подтверждённых доменных событий.
  - Rationale: Исключить расчёт по невалидным/черновым данным.
  - Enforcement level: hard.

## Calendar
- **CA-001**
  - Rule text: Событие должно иметь start <= end.
  - Rationale: Корректность планирования.
  - Enforcement level: hard.
- **CA-002**
  - Rule text: Критичные дедлайны должны иметь назначенного ответственного.
  - Rationale: Повышение исполнительской дисциплины.
  - Enforcement level: hard.

## Templates
- **TP-001**
  - Rule text: Публикация шаблона допустима только после валидации placeholders.
  - Rationale: Избежать генерации некорректных документов.
  - Enforcement level: hard.

## Users / RBAC
- **UR-001**
  - Rule text: У пользователя должна быть минимум одна активная роль.
  - Rationale: Исключить неоднозначный статус доступа.
  - Enforcement level: hard.
- **UR-002**
  - Rule text: Нельзя деактивировать последнего активного Admin.
  - Rationale: Гарантировать управляемость системы.
  - Enforcement level: hard.

## Audit
- **AU-001**
  - Rule text: Все критичные операции пишутся в неизменяемый audit log.
  - Rationale: Соответствие требованиям контроля.
  - Enforcement level: hard.
- **AU-002**
  - Rule text: Audit event должен содержать actor, timestamp, entity, action, before/after (если применимо).
  - Rationale: Диагностика и расследование инцидентов.
  - Enforcement level: hard.

## Cross-cutting architecture rules
- **AR-001**
  - Rule text: UI не обращается напрямую к БД.
  - Rationale: Сохранить чистую архитектуру и тестируемость.
  - Enforcement level: hard.
- **AR-002**
  - Rule text: UI не содержит бизнес-логики.
  - Rationale: Централизация правил в domain/application.
  - Enforcement level: hard.
- **AR-003**
  - Rule text: Бизнес-правила исполняются в domain/application слоях.
  - Rationale: Единое поведение для UI/API/интеграций.
  - Enforcement level: hard.
