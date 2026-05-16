# Non-Functional Requirements (NFR) — TDesk2

| ID | Category | Requirement | Metric | Target | Verification method |
|---|---|---|---|---|---|
| NFR-REL-01 | Reliability | Критичные API должны быть доступны в рабочее время | Uptime | >= 99.5%/month | Мониторинг availability + SLA report |
| NFR-REL-02 | Reliability | Неизменяемость audit-событий | Data integrity incidents | 0 инцидентов изменения audit log | Интеграционные тесты + аудит БД политик |
| NFR-PERF-01 | Performance | Время ответа read API для типовых экранов | p95 latency | <= 500 ms | Нагрузочные тесты + APM |
| NFR-PERF-02 | Performance | Время ответа write API для критичных операций | p95 latency | <= 800 ms | Нагрузочные тесты на create/update flows |
| NFR-SEC-01 | Security | Авторизация каждой операции через RBAC | Unauthorized access success rate | 0 успешных неавторизованных операций | Автотесты policy + penetration checks |
| NFR-SEC-02 | Security | Защита персональных и финансовых данных | Encryption coverage | 100% TLS in transit, encrypted storage where applicable | Security review + config audit |
| NFR-MNT-01 | Maintainability | Бизнес-логика отделена от UI и persistence | Layering violations | 0 нарушений архитектурных правил | Code review checklist + static architecture checks |
| NFR-MNT-02 | Maintainability | Изменения доменных правил должны быть локализованы | Change surface per rule | Изменение правила в <= 3 модулях | ADR review + change impact analysis |
| NFR-OBS-01 | Observability | Логи и метрики критичных флоу доступны для диагностики | Trace/log coverage | >= 95% критичных операций | Observability checklist + smoke incidents |
| NFR-OBS-02 | Observability | Алертинг по сбоям и деградации | MTTD | <= 10 минут | Тестовые инциденты и проверка оповещений |
| NFR-BR-01 | Backup/Restore | Резервное копирование критичных данных | Backup success rate | >= 99% ежедневных backup jobs | Проверка job reports |
| NFR-BR-02 | Backup/Restore | Восстановление после сбоя | RTO / RPO | RTO <= 4h, RPO <= 24h | Плановый restore drill ежеквартально |
| NFR-USB-01 | Usability | Типовой сценарий (client→order→invoice) понятен без обучения | Task completion rate | >= 90% в UAT | UAT протоколы и UX тесты |
| NFR-USB-02 | Usability | Ошибки валидации должны быть объяснимыми | Validation clarity score | >= 4/5 на UAT опросе | UX review + анкета UAT |
