# Matriz de pendientes — Fase 9

| Pendiente | HU / requisito | Repositorio afectado | Actividad necesaria | Criterio de aceptación | Evidencia que debe producirse | Prioridad | Dependencias | Estado |
|---|---|---|---|---|---|---|---|---|
| Auditoría formal de accesibilidad | HU-01, CA-HU01-04 | `mi-barrio-frontend` | Revisar contraste, foco, teclado, formularios, mapa y responsive | WCAG 2.2 AA aplicable | Informe de accesibilidad y correcciones | Alta | Ninguna | Pendiente |
| PT-01 rendimiento formal | HU-01, HU-02 | `mi-barrio-api`, `mi-barrio-frontend` | Ejecutar Lighthouse en producción y una prueba controlada de concurrencia | Tiempos documentados y sin errores | `lighthouse-prod.json`, `concurrency.json`, informe | Media | Backend y API operativos | Parcialmente cumplido |
| Prueba de interacción del mapa | HU-02, CA-HU02-03 | `mi-barrio-frontend` | Verificar arrastre, zoom y apertura/cierre del popup | Mapa georreferenciado y funcional | Prueba Playwright o guion manual registrado | Media | HU-02 | Pendiente |
| Pruebas de aceptación HU-03 | HU-03, CA-HU03-01..04 | `mi-barrio-frontend` | Verificar categorías, búsqueda, listado, detalle y marcadores | Criterios CA-HU03 | Log Playwright y capturas | Alta | HU-03 implementada | Pendiente |
| Pruebas de aceptación HU-04 | HU-04, CA-HU04-01..04 | `mi-barrio-frontend` | Verificar búsqueda, filtros, detalle y aviso de cobertura parcial | Criterios CA-HU04 | Log Playwright y capturas | Alta | HU-04 implementada | Pendiente |
| Pruebas de aceptación HU-05 | HU-05, CA-HU05-01..03 | `mi-barrio-frontend` | Verificar parques, etiqueta cercanas y marcadores | Criterios CA-HU05 | Log Playwright y capturas | Alta | HU-05 implementada | Pendiente |
| Pruebas de aceptación HU-06 | HU-06, CA-HU06-01..03 | `mi-barrio-frontend` | Verificar instituciones, filtro ≤800 m y sedes dentro | Criterios CA-HU06 | Log Playwright y capturas | Alta | HU-06 implementada | Pendiente |
| Pruebas de aceptación HU-07 | HU-07, CA-HU07-01..03 | `mi-barrio-frontend` | Verificar IPS, consultorios, farmacias y etiqueta cercanos | Criterios CA-HU07 | Log Playwright y capturas | Media | HU-07 implementada | Pendiente |
| Pruebas de aceptación HU-08 | HU-08, CA-HU08-01..03 | `mi-barrio-frontend` | Verificar capa vial, jerarquía y ausencia de rutas | Criterios CA-HU08 | Log Playwright y capturas | Media | HU-08 implementada | Pendiente |
| Pruebas de aceptación HU-09 | HU-09, CA-HU09-01..03 | `mi-barrio-frontend` | Verificar paraderos, estaciones, portales y ausencia de horarios | Criterios CA-HU09 | Log Playwright y capturas | Media | HU-09 implementada | Pendiente |
| Pruebas de aceptación HU-10 | HU-10, CA-HU10-01..03 | `mi-barrio-frontend` | Verificar paneles separados barrio y UPZ | Criterios CA-HU10 | Log Playwright y capturas | Media | HU-10 implementada | Pendiente |
| Pruebas de aceptación HU-11 | HU-11, CA-HU11-01..03 | `mi-barrio-frontend` | Verificar cuadrante, etiqueta Kennedy y capas ambientales | Criterios CA-HU11 | Log Playwright y capturas | Media | HU-11 implementada | Pendiente |
| Pruebas de aceptación HU-12 | HU-12, CA-HU12-01..04 | `mi-barrio-frontend` | Verificar filtros simples, múltiples, consistencia y restablecimiento | Criterios CA-HU12 | Log Playwright y capturas | Media | HU-12 implementada | Pendiente |
| Pruebas de HU-13 | HU-13, CA-HU13-01..05 | `mi-barrio-backend`, `mi-barrio-api`, `mi-barrio-frontend` | Login válido/inválido, CRUD, auditoría, protección | Criterios CA-HU13 | Pruebas unitarias, integración y E2E | Alta | HU-13 implementada | Pendiente |
| Vulnerabilidades de desarrollo | RNF-18, seguridad | 3 repositorios | Evaluar actualizaciones major de `typescript-eslint` y `vitest` | `npm audit` sin vulnerabilidades críticas o justificación documentada | Informe de vulnerabilidades | Media | Ninguna | Pendiente |
| Manual técnico | Documentación | `docs/` | Documentar arquitectura, instalación, configuración, ejecución y operación | Manual completo y verificable | `docs/manuales/manual-tecnico.md` | Media | Funcionalidades estables | Pendiente |
| Manual de usuario | Documentación | `docs/` | Documentar uso de la aplicación, mapa, filtros y limitaciones | Manual completo y verificable | `docs/manuales/manual-usuario.md` | Media | Funcionalidades estables | Pendiente |
| Staging HTTPS | Despliegue | 3 repositorios | Preparar proveedor, dominio, TLS, variables y base de datos | Entorno HTTPS funcional | Evidencias de despliegue | Alta | Intervención humana | Pendiente |
| GitHub Actions remoto | CI/CD | 3 repositorios | Configurar remotos y ejecutar workflows | Workflows en verde | Evidencias remotas | Media | Intervención humana | Pendiente |
| Validación de historias | HU-01 a HU-13 | `docs/` | Actualizar estados según evidencias reales | Matriz consistente con implementación | Matriz de trazabilidad | Baja | Pruebas completadas | Pendiente |

## Notas

- HU-01 y HU-02 permanecen en `En pruebas`.
- HU-03 a HU-13 permanecen en `En desarrollo`.
- Ninguna historia está marcada como `Validada`.
- Las vulnerabilidades actuales son de desarrollo y no afectan la ejecución de producción.
- El despliegue HTTPS y la publicación remota requieren autorización e infraestructura externa.