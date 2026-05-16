# RBAC Specification — TDesk2

## Roles
- **Admin**: полный доступ к настройкам, пользователям, справочникам, критичным операциям.
- **Manager**: операционное управление клиентами, заказами, календарём, файлами.
- **Finance**: управление счетами, платежами, выплатами, финансовыми сводками.
- **Readonly**: только чтение разрешённых модулей.
- **Contractor (optional, Phase 2)**: ограниченный доступ к назначенным задачам/выплатам.

## Permission matrix (Role × Module × Action)
Legend: C=create, R=read, U=update, D=delete, A=approve/critical action

| Module | Action | Admin | Manager | Finance | Readonly | Contractor (P2) |
|---|---|---|---|---|---|---|
| Dashboard | R | ✅ | ✅ | ✅ | ✅ | ✅ (ограниченно) |
| Clients | C/R/U/D | ✅ | ✅ (без D критичных) | R | R | R (только свои) |
| Orders | C/R/U | ✅ | ✅ | R | R | R (назначенные) |
| Orders | A (status override) | ✅ | ⚠️ (ограниченно) | ❌ | ❌ | ❌ |
| Invoices | C/R/U | ✅ | R | ✅ | R | ❌ |
| Invoices | A (issue/cancel paid lock) | ✅ | ❌ | ✅ | ❌ | ❌ |
| Payments | C/R/U | ✅ | R | ✅ | R | ❌ |
| Payouts | C/R/U | ✅ | R | ✅ | R | R (свои) |
| Finance | R/U | ✅ | R | ✅ | R | ❌ |
| Calendar | C/R/U/D | ✅ | ✅ | R | R | R |
| Files | C/R/U/D | ✅ | ✅ | ✅ | R | R/C (свои) |
| Templates | C/R/U/D | ✅ | ✅ | R | R | ❌ |
| References | C/R/U/D | ✅ | R | R | R | ❌ |
| Settings | C/R/U/D | ✅ | ❌ | ❌ | ❌ | ❌ |
| Users/RBAC | C/R/U/D | ✅ | ❌ | ❌ | ❌ | ❌ |
| Audit | R | ✅ | R (ограниченно) | R (фин. события) | R (ограниченно) | ❌ |

## Critical operations
Только указанные роли могут выполнять:
1. Изменение ролей пользователя — **Admin**.
2. Деактивация последнего активного Admin — **запрещено системой**.
3. Перевод Invoice в Paid/Cancelled после Issued — **Finance или Admin**.
4. Payout approve/release — **Finance или Admin**.
5. Изменение системных настроек и справочников высокого риска — **Admin**.
6. Корректировка финансовых записей (manual adjustment) — **Finance, Admin** с обязательным audit reason.

## Audit rules by role
- **Admin**: аудит всех write/critical действий, включая старое и новое состояние.
- **Manager**: аудит изменений Clients/Orders/Calendar/Files.
- **Finance**: аудит изменений Invoices/Payments/Payouts/Finance.
- **Readonly**: аудит входа и просмотра критичных сущностей (по policy), без write-событий.
- **Contractor (P2)**: аудит доступа к назначенным сущностям и загрузок файлов.

## Enforcement notes
- Все проверки прав выполняются в application/domain уровне, не в UI.
- UI показывает только разрешённые действия, но окончательное решение — server-side authorization.
