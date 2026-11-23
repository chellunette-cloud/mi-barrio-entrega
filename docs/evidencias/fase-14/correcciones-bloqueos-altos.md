# Fase 14.2 — Corrección de bloqueos altos de Fase 14.1

**Fecha:** 2026-11-19  
**Alcance:** tres repositorios independientes + workflow E2E existente + documentación local de `docs/`.

> No se encontraron documentos previos de Fase 14 en `docs/evidencias/`. La afirmación de que `q` ya declaraba `maxLength: 60` no aparece en los documentos disponibles: Fase 12-1 y Fase 13 registran correctamente `q` sin límite. Esta evidencia corrige y cierra esa limitación.

---

## 1. Bloqueos detectados y correcciones

| Bloqueo | Corrección implementada |
|---|---|
| `/internal/v1/health` no estaba protegido | La ruta se registró dentro de `createInternalRouter`, después de `requireServiceToken`. El contrato interno dejó de declarar `security: []` para health. |
| `q` sin `maxLength: 60` en OpenAPI | Se añadió el límite en los cuatro contratos y se sincronizaron hashes y tipos derivados. La validación Zod ya aplicaba `.max(60)` desde Fase 14. |
| Workflow E2E con secretos/admin mal mapeados, readiness falso y artefacto incorrecto | Se corrigió el mapeo de secretos, se añadió preflight, se fijaron refs por inputs, se protegió el readiness, se verificaron contratos y se configuró el reporte HTML sin trazas. |

---

## 2. Bloque A — Health protegido

### Cambios

- `backend/src/infrastructure/http/app.ts`: se eliminó el registro público de `/internal/v1/health`.
- `backend/src/infrastructure/http/routes/internal/barrioRoutes.ts`: health se registra tras `requireServiceToken`.
- `backend/contracts/internal.openapi.yaml`: se eliminó `security: []` del operation de health.
- `backend/README.md`: la tabla de endpoints indica `X-Service-Token`.
- `backend/tests/integration/health.test.ts`: nuevo archivo con tres pruebas.
- `backend/tests/integration/http.test.ts`: se retiró la comprobación antigua de health sin token.

### Respuesta

```json
{ "status": "ok", "service": "mi-barrio-backend" }
```

No incluye configuración, secretos, credenciales ni datos internos.

### Evidencia de pruebas negativas y positivas

| Caso | Resultado |
|---|---|
| Sin `X-Service-Token` | `401`, `error.code = NO_AUTORIZADO` |
| Token incorrecto | `401`, `error.code = NO_AUTORIZADO` |
| Token válido | `200`, cuerpo exacto `{ status: 'ok', service: 'mi-barrio-backend' }` |

Comando específico: `npx vitest run tests/integration/health.test.ts` → **3/3**, exit `0`.

El API no consume el health interno del backend; solo expone `GET /api/v1/health`, que sigue siendo público por contrato.

### Hallazgo adicional corregido durante la validación

La primera ejecución completa de Playwright dejó el árbol de React vacío por un error en el manejador `add` de `GeoJSON`:

```text
event.target.getElement is not a function
```

`event.target` es el grupo GeoJSON, que no expone `getElement()`. Se corrigió iterando sus capas con `eachLayer` y aplicando `getElement()` a cada capa individual. El manejador `keydown` también verifica que `openPopup` exista antes de invocarlo. Archivo: `frontend/src/features/mapa/components/MapaLeaflet.tsx`.

La validación completa posterior dejó 5 fallos, con estas causas y ajustes:

- `definition-list` de axe: `DatoFicha` renderizaba un `<p>` dentro del `<div>` del `<dl>`. El detalle se movió dentro del `<dd>` como `<span>`.
- Estado de carga: `getByRole('status')` resolvería 5 elementos; se acotó con `.first()`.
- Filtros de `places.spec.ts`: nombres accesibles ambiguos por las tarjetas; se usó `exact: true`.
- `hu13.categorias.spec.ts`: se consultaba la base antes de que terminara la reasignación; se espera a que desaparezca la fila de la categoría.
- `ficha-mapa.spec.ts`: el texto «Información no disponible» dejó ser coincidencia exacta al incluir el detalle; se usa `.first()`.
- Arrastre del mapa: las coordenadas del ratón caían fuera del viewport porque el mapa está debajo del pliegue; se añadió `scrollIntoViewIfNeeded()`.
- `hu03-hu06.spec.ts` HU-04: se consultaban los `li[data-tipo]` antes de que React aplicara el filtro `supermarket`; se espera a que aparezca el primer elemento.

---

## 3. Bloque B — Contrato de `q`

### Archivos sincronizados

- `backend/contracts/internal.openapi.yaml`
- `api/contracts/internal.openapi.yaml`
- `api/contracts/public.openapi.yaml`
- `frontend/contracts/public.openapi.yaml`

Los cuatro declaran ahora:

```yaml
- name: q
  in: query
  schema: { type: string, maxLength: 60 }
```

No se modificaron otros parámetros. `tipo` ya tenía `maxLength: 60`.

### Implementación

- `backend/src/infrastructure/http/controllers/placesController.ts`: `q: z.string().trim().max(60).optional()`.
- `api/src/http/controllers/placesController.ts`: misma validación.
- Frontend: `maxLength={60}` en el campo de búsqueda (Fase 14).

### Comportamiento verificado

| Caso | Backend | API |
|---|---|---|
| `q` ausente | 200 | 200 |
| `q=''` | 200; repositorio interpreta búsqueda vacía como `null` | 200 |
| 60 caracteres | 200; se propaga el valor exacto | 200; se propaga el valor exacto |
| 61 caracteres | 400 `FILTRO_INVALIDO` | 400 `FILTRO_INVALIDO` |

### Hashes

| Contrato | Antes | Después |
|---|---|---|
| Interno | `606a25436e23c4964f44153acc545b4dcb947801ffc726aa1aaf0f565c15a84c` | `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` |
| Público | `c1602756c9eb7edf98695da489856f76387f3d62874e13e5ce89a1ed461aed59` | `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` |

Mecanismos oficiales ejecutados:

- `npm run contracts:sync` en API y frontend.
- `npm run contracts:types` en API y frontend.
- `npm run contracts:verify` en API y frontend.

---

## 4. Bloque C — Workflow E2E corregido

Archivo: `mi-barrio-frontend/.github/workflows/e2e.yml`.

### Cambios relevantes

1. `workflow_dispatch` con inputs obligatorios `backend_ref` y `api_ref` (SHA de 40 hexadecimales). El frontend usa `github.sha`.
2. Preflight sin imprimir valores:
   - secretos no vacíos;
   - `SERVICE_TOKEN`, `JWT_SECRET`, `JWT_REFRESH_SECRET` ≥ 16;
   - `ADMIN_PASSWORD` ≥ 8;
   - credenciales E2E no vacías;
   - refs con formato SHA.
3. `E2E_ADMIN_USERNAME` / `E2E_ADMIN_PASSWORD` siguen disponibles para Playwright y además se inyectan en el backend como `ADMIN_USERNAME` / `ADMIN_PASSWORD`.
4. Backend con `HOST=127.0.0.1`.
5. `VITE_API_BASE_URL=''` explícito; se mantiene el proxy de Vite a `127.0.0.1:3000`.
6. Readiness:
   - 200 con token válido;
   - fallo sin token;
   - 200 en health público de la API.
7. `contracts:verify` con rutas ajustadas a los paths del job (`../backend/...`, `../api/...`).
8. PostGIS, migraciones y ETL siguen confinados a `postgresql://postgres@127.0.0.1:5432/mi_barrio`.
9. Playwright con `E2E_TRACE=off`; reporter HTML configurado; artefacto `frontend/playwright-report` con `if-no-files-found: error`.
10. Permisos `contents: read`, `timeout-minutes: 25` y concurrencia se mantienen.

### Estado

**Corregido, pero NO ejecutado en GitHub Actions.** Los SHAs de los HEAD actuales son anteriores a estos cambios locales; por eso el workflow exige los SHAs exactos que se publiquen tras la revisión humana. No se hicieron commits, push, tags ni despliegues.

---

## 5. Bloque D — Documentación

- Se actualizó `docs/README.md` con el índice de esta evidencia.
- Se actualizó `mi-barrio-backend/README.md` para reflejar health protegido.
- No se encontraron documentos de Fase 14 que afirmaran lo contrario sobre `q`; la limitación se registraba en Fase 12-1 y Fase 13 y ahora queda resuelta.

---

## 6. Bloque E — Validación local

Todas las salidas y códigos de salida están en `<TEMP>\opencode\fase14-2-verify\`.

| Repositorio | Comando | Exit | Resultado |
|---|---|---:|---|
| backend | `npm ci` | 0 | Reinstalación verificable |
| backend | `npm run ci` | 0 | 12 archivos, **30/30** pruebas |
| backend | `npm run build` | 0 | Compilación OK |
| backend | `npx vitest run tests/integration/health.test.ts` | 0 | **3/3** |
| backend | `npm run verify:data` | 0 | 10 snapshots OK |
| backend | `npm run check:lines` | 0 | OK |
| API | `npm ci` | 0 | Reinstalación verificable |
| API | `npm run ci` | 0 | 6 archivos, **19/19** pruebas |
| API | `npm run build` | 0 | Compilación OK |
| API | `npm run contracts:verify` | 0 | Hash interno OK |
| API | `npm run check:lines` | 0 | OK |
| frontend | `npm ci` | 0 | Reinstalación verificable |
| frontend | `npm run ci` | 0 | 6 archivos, **13/13** pruebas; build incluido |
| frontend | `npm run build` | 0 | Compilación OK |
| frontend | `npm run contracts:verify` | 0 | Hash público OK |
| frontend | `npm run check:lines` | 0 | OK |
| frontend | `npx playwright test tests/acceptance/ficha-mapa.spec.ts --reporter=line` | 0 | **2/2** tras corregir `MapaLeaflet` |
| frontend | `npm run ci` (re-ejecución final) | 0 | **13/13**, lint, tipos, contratos y build |
| frontend | `npm run build` (re-ejecución final) | 0 | OK |
| frontend | `npm run check:lines` (re-ejecución final) | 0 | OK |
| frontend | Playwright focal (arrastre de mapa) | 0 | **1/1** |
| frontend | `npm run test:acceptance` | 0 | **36/36** en 51,4 s |

Health local con servicios efímeros del proceso: `backend=200; backend_sin_token=401; api=200`.

---

## 7. Hallazgos pendientes y riesgos residuales

1. El workflow no se ha ejecutado en GitHub Actions; requiere revisión humana y secretos configurados.
2. Los SHAs de checkout son inputs obligatorios porque estos cambios aún no están commiteados; usar `main` reintroduciría el riesgo de deriva.
3. La documentación histórica de Fase 14 no existe en el workspace; no fue posible "corregirla" sino que se sustituye por esta evidencia.
4. No se verificó el artefacto HTML dentro de GitHub Actions; solo se configuró su generación local.
5. No se ejecutaron migraciones ni ETL en esta fase.

---

## 8. Confirmación

- No se ejecutó el workflow en GitHub Actions.
- No se hicieron commits, push, tags ni despliegues.
- No se modificó `mi-barrio-entrega`, `temp-reference/` ni secretos/configuración de GitHub.
- No se añadieron archivos `.env`, credenciales ni datos sensibles.
- No se usó `npm audit fix --force`.
