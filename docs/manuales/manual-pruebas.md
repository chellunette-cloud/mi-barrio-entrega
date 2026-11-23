# Guía de pruebas y verificación — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**

Esta guía unifica los comandos reales de prueba de los tres repositorios, distingue los resultados ejecutados de los pendientes y explica la diferencia entre la matriz canónica de 46 criterios y la regresión E2E remota.

---

## 1. Principios de verificación

- La **matriz canónica** registra **46/46 criterios aprobados** en [`docs/evidencias/fase-13/matriz-global-46-criterios.md`](../evidencias/fase-13/matriz-global-46-criterios.md), físicamente presente en este portal e incorporada a Git.
- El **E2E remoto** `44979541605` terminó en `success` con **36/36 pruebas en 15 archivos**; es una **regresión de los criterios cubiertos**, no una ejecución individual de los 46 criterios ni un despliegue.
- PT-01, PT-02 y la auditoría formal de accesibilidad **no** tienen evidencia de cierre.
- Las evidencias de Fase 12.1, Fase 13 y Fase 14.7 están físicamente presentes en `docs/evidencias/` de este portal, incorporadas a Git y enlazadas de forma versionada.

---

## 2. Catálogo de comandos por repositorio

### 2.1 Backend (`mi-barrio-backend`)

```bash
npm ci
npm run verify:data
npm run migrate
npm run etl
npm run test:unit
npm run test:integration
npm run test:contract
npm run test:geo
npm run test
npm run ci
npm run build
```

`npm run ci` ejecuta `lint && typecheck && check:lines && verify:data && test`. Las suites `integration` y `geographic` requieren PostgreSQL/PostGIS disponible.

Prueba puntual documentada en evidencia de Fase 14:

```bash
npx vitest run tests/integration/health.test.ts
```

### 2.2 API (`mi-barrio-api`)

```bash
npm ci
npm run contracts:verify
npm run test:unit
npm run test:integration
npm run test:contract
npm test
npm run ci
npm run build
```

`npm run contracts:verify` comprueba SHA-256 del contrato interno y, si existe, lo compara con el archivo de origen `../mi-barrio-backend/contracts/internal.openapi.yaml`.

### 2.3 Frontend (`mi-barrio-frontend`)

```bash
npm ci
npm run contracts:verify
npm run lint
npm run typecheck
npm run check:lines
npm test
npm run build
npm run ci
npm run test:acceptance
```

`npm test` incluye `tests/unit` y `tests/integration`. `npm run test:acceptance` ejecuta Playwright sobre `tests/acceptance` y requiere backend, API y frontend en ejecución, además de Chrome y las variables `E2E_ADMIN_USERNAME` / `E2E_ADMIN_PASSWORD`.

---

## 3. Orden recomendado de ejecución

1. Preparar PostgreSQL/PostGIS y configurar los tres `.env` según el [manual de instalación](manual-instalacion.md).
2. En el backend: `npm run verify:data`, `npm run migrate`, `npm run etl`.
3. Verificar contratos en API y frontend.
4. Iniciar backend, luego API y luego frontend.
5. Repetir los health checks.
6. Ejecutar pruebas unitarias, integración y contrato de backend y API.
7. Ejecutar `npm test` y `npm run ci` del frontend.
8. Ejecutar `npm run test:acceptance` si se dispone del entorno completo.
9. Registrar salida, fecha, HEAD y hashes verificados.

---

## 4. E2E remoto

El workflow `mi-barrio-frontend/.github/workflows/e2e.yml` se dispara con `workflow_dispatch` y exige dos entradas: `backend_ref` y `api_ref`, cada una un SHA de 40 caracteres hexadecimales.

El workflow prepara sucesivamente backend, API y frontend:

```bash
npm ci
npm run verify:data
npm run migrate
npm run etl
npm run build
npm run contracts:verify
npx playwright install --with-deps chrome
npm run test:acceptance
```

Variables inyectadas por el workflow: `DATABASE_URL`, `SERVICE_TOKEN`, `JWT_SECRET`, `JWT_REFRESH_SECRET`, `HOST`, `PORT`, `BACKEND_URL`, `FRONTEND_ORIGIN`, `RATE_LIMIT_MAX`, `ADMIN_USERNAME`, `ADMIN_PASSWORD`, `VITE_API_BASE_URL`, `E2E_ADMIN_USERNAME`, `E2E_ADMIN_PASSWORD`, `E2E_TRACE` y `NO_COLOR`. El workflow valida longitudes mínimas para tokens, secretos y contraseña administrativa.

Resultado vigente registrado:

| Campo | Valor |
|---|---|
| Run | `44979541605` |
| URL | `https://github.com/chellunette-cloud/mi-barrio-frontend/actions/runs/44979541605` |
| Estado | `success` |
| Pruebas | 36/36 en 15 archivos `*.spec.ts` |
| Job | `playwright` en `success` |
| Artefacto | `playwright-report`, ID `14737372046` |
| SHA-256 del artefacto | `c876b01c49a1f003aba73bce4c3facb3ce6cd1eb507b30db5ae29f6e6eedf0e0` |

Se registró una advertencia no bloqueante de Node.js 20 en acciones v4; el job terminó correctamente.

---

## 5. Evidencias disponibles

### 5.1 Workspace principal

| Evidencia | Contenido |
|---|---|
| `docs/evidencias/fase-11-2/resultados-regresion.md` | CI, builds, contratos, snapshots y Playwright de Fase 11.2 |
| `docs/evidencias/fase-11-1/trazabilidad-pruebas.md` | Trazabilidad criterio por criterio antes del cierre |
| `docs/evidencias/fase-12/resultados-regresion.md` | Regresión del lote Fase 12 |
| `docs/evidencias/fase-12-1/resultados-regresion.md` | Correcciones del lote Fase 12.1 |
| `docs/evidencias/fase-13/resultados-regresion.md` | Regresión de cierre de la matriz canónica |
| `docs/evidencias/fase-13/matriz-global-46-criterios.md` | Matriz canónica 46/46 |
| `docs/evidencias/fase-13/auditoria-accesibilidad.md` | Revisión de accesibilidad, no auditoría formal externa |
| `docs/evidencias/fase-13/pruebas-interaccion-mapa.md` | Interacción de mapa |
| `docs/evidencias/fase-14/correcciones-bloqueos-altos.md` | Correcciones y health checks |
| `docs/evidencias/fase-14-7/ejecucion-e2e-remota.md` | Ejecución remota vigente |

Los archivos de Fase 12.1, 13, 14 y 14.7 están presentes en `docs/evidencias/` de este portal y se enlazan desde [el índice de documentación](../README.md); su estado es `untracked` y su incorporación a Git y revisión siguen pendientes.

### 5.2 Repositorios

- `mi-barrio-frontend/test-results/.last-run.json` registra `status: passed`.
- `mi-barrio-frontend/test-results/ficha-mapa-desktop.png` y `ficha-mapa-mobile.png` son capturas generadas por `tests/acceptance/ficha-mapa.spec.ts`.
- `mi-barrio-frontend/playwright-report/index.html` contiene el informe local de 36/36 pruebas.
- `mi-barrio-backend` y `mi-barrio-api` no versionan logs ni reportes de cobertura; `.gitignore` excluye `*.log` y `coverage/`.

---

## 6. Resultados ejecutados y pendientes

| Ámbito | Estado | Observación |
|---|---|---|
| Matriz canónica | Ejecutada y aprobada | 46/46 criterios aprobados. |
| E2E remoto | Ejecutado | 36/36 en 15 archivos; regresión, no ejecución individual de 46 criterios. |
| Backend | Ejecutado | Fase 14 registró 30/30 pruebas, `verify:data` 10/10, `build` correcto y health 3/3. |
| API | Ejecutado | Suites unitarias, integración y contrato ejecutadas en CI local; no se conserva un conteo separado versionado en el repositorio. |
| Frontend local | Ejecutado | Informe local 36/36; capturas reales de ficha y mapa. |
| PT-01 | Pendiente | Sin evidencia formal de cierre. |
| PT-02 | Pendiente | Sin evidencia formal de cierre. |
| Auditoría formal de accesibilidad | Pendiente | Existe revisión interna, no auditoría formal. |
| Staging HTTPS y despliegue | Despliegue Free ejecutado; staging con dominio propio pendiente | Render sin dominio propio ni red privada; P0-01 NO APROBADO. Véase `docs/despliegue/evidencia-fase-15.2-despliegue-render.md`. |
| Respaldos/restauración | Pendiente | No hay scripts en los repositorios. |

---

## 7. Cómo registrar nueva evidencia

1. No modifique evidencias históricas de Fase 11.2, 12, 13 ni 14.7.
2. Cree un registro nuevo con fecha, repositorio, HEAD, comandos ejecutados y resultados literales.
3. Conserve hashes cuando verifique contratos o artefactos.
4. Distinga explícitamente entre ejecución local, CI y regresión remota.
5. No interprete un `success` de E2E como despliegue ni como cierre de PT-01, PT-02 o accesibilidad formal.
6. Enlace el registro nuevo desde el índice correspondiente, sin reemplazar el registro anterior.

---

## 8. Referencias

- [Manual de usuario](manual-usuario.md)
- [Manual técnico](manual-tecnico.md)
- [Manual de instalación](manual-instalacion.md)
- [Manual de operación](manual-operacion.md)
- [Guía de despliegue](manual-despliegue.md)
- [`requerimientos/criterios-aceptacion.md`](../requerimientos/criterios-aceptacion.md)
- [`planificacion/plan-desarrollo.md`](../planificacion/plan-desarrollo.md)
