# Evidencia de Fase 1 — HU-01 y HU-02

**Fecha:** 2026-11-15 · **Alcance:** únicamente HU-01 (ficha general) y HU-02 (mapa y polígono).
**Estado:** `En pruebas`. No se declara ninguna historia `Validada` y no se inició la Fase 2.

> **Nota de estado (2026-11-22):** este documento es el registro histórico de la Fase 1. Las referencias a repositorios sin remoto y a la ejecución remota pendiente corresponden a esa fecha. El estado vigente es el de la [opción C](../../README.md): tres repositorios independientes publicados, sin submódulos, con versiones registradas en el [manifiesto de versiones](../../../entrega/manifiesto-versiones.md). La presencia o ausencia de archivos en este portal se rige por el índice de evidencias, no por la configuración de submódulos.

Esta evidencia se generó contra el stack local real: frontend Vite, API pública, backend privado,
PostgreSQL 16.13 + PostGIS 3.7.0. Los archivos de esta carpeta son la salida directa de las
ejecuciones; no son capturas reconstruidas ni datos inventados.

## 1. Repositorios y commits

Los tres repositorios son independientes, cada uno con su propio `.git`; no hay monorepo ni
importaciones de código entre ellos. La única comunicación es HTTP.

| Repositorio | Commit | Contenido de Fase 1 |
|---|---|---|
| `mi-barrio-backend` | `2cfbbd4df3b29b8d1b41c42bae27be7146f12141` | Dominio, ETL, PostGIS, HTTP interno y pruebas |
| `mi-barrio-api` | `dcf7cf4482aeae7eb8dfc10c463fba4cc1a9f141` | API pública, contrato público y cliente interno |
| `mi-barrio-frontend` | `ac2ad4cfb224002960160c9af7dd1b4d21dac769` | Ficha HU-01, mapa Leaflet HU-02 y pruebas |

Los repositorios no tienen remoto configurado. Los workflows de GitHub Actions están en
`.github/workflows/ci.yml`, pero **no se ejecutaron en GitHub**; la validación de CI que sí se ejecutó
es la local equivalente, registrada en §5.

## 2. Contratos y snapshots

| Artefacto | SHA-256 |
|---|---|
| Contrato interno canónico `mi-barrio-backend/contracts/internal.openapi.yaml` | `03873c01e4ef1ed65b0fd7ef629c1a1bbd3b85e53c0f81ade791c7219e231684` |
| Contrato público canónico `mi-barrio-api/contracts/public.openapi.yaml` | `fbf6f56cf80eb1cde086ddc0588491e9e1fba3ffc4e20142c3b024983fd405e9` |
| Copia pública en frontend `mi-barrio-frontend/contracts/public.openapi.yaml` | `fbf6f56cf80eb1cde086ddc0588491e9e1fba3ffc4e20142c3b024983fd405e9` |
| Polígono oficial `barrio-ciudad-granada.geojson` | `1CDD6D0A63E3AD38393EB8FB37CBF7E2CAD1AD507D97CC2EDCBE2E8CCD5B0F6E` |
| Estrato `estrato-ciudad-granada.geojson` | `175E3BA4BAD361863B1731669AD7A9E1EFD7F2B531FA950EE170D5D8619591E9` |
| Atributos oficiales `barrio-atributos-oficial.json` | `58EC23169DBA0C43EEEA8D0339C04DD07DE1B29C61D8AA9631087C31BF8FF229` |

Los tres snapshots se verifican antes de la carga y el ETL falla si un hash no coincide. Ver
[`verify-data.log`](verify-data.log). El manifiesto `data/source/manifest.json` pertenece al repositorio independiente `mi-barrio-backend` y no está incluido en este portal: con la opción C los repositorios se referencian por URL HTTPS y manifiesto de versiones, sin submódulos. Su ruta canónica es `mi-barrio-backend/data/source/manifest.json`.

## 3. Migraciones y ETL

- Migración explícita de `barrio_fuente`: `004_create_barrio_fuente.sql`.
- Clave única `(barrio_id, fuente_id, campo)`, PK y FKs con `ON DELETE CASCADE` / `RESTRICT`.
- Las cinco migraciones están aplicadas y registradas en `schema_migrations`.

Ver [`migrations.txt`](migrations.txt) y [`migrate.log`](migrate.log). La reejecución de `migrate`
fue idempotente y no dejó migraciones pendientes.

Salida real del ETL en [`etl.log`](etl.log):

```text
barrio OK: URBANIZACION CIUDAD GRANADA · 58 vértices · centroide 4.641833130667935, -74.17175846032757
estrato OK: 34 manzanas, todas estrato 2, todas dentro del polígono
ETL Fase 1 completado en una transacción.
```

La verificación de integridad geográfica quedó así:

| Comprobación | Resultado |
|---|---|
| Geometría | `Polygon`, válida, `SRID=4326` |
| Vértices | `58` |
| Centroide | `4.641833130667935, -74.17175846032757` |
| Distancia al centroide de referencia | ≤ 5 m (prueba GT-01) |
| Área calculada | `94.551,13 m²` (`9,1 ha` oficiales) |
| Manzanas | `34`; `34` con estrato `2`; `0` inválidas |
| Contención | `34/34` dentro del polígono |

Ver [`db-validation.txt`](db-validation.txt). La prueba `tests/geographic/geometry.test.ts` pertenece al repositorio independiente `mi-barrio-backend` y no está incluida en este portal: con la opción C los repositorios se referencian por URL HTTPS y manifiesto de versiones, sin submódulos. Su ruta canónica es `mi-barrio-backend/tests/geographic/geometry.test.ts`.

## 4. Respuestas reales de la API

| Solicitud | Resultado | Evidencia |
|---|---|---|
| `GET /api/v1/barrio` | `200`, ficha oficial y fuentes F-01/F-02 | [`api-barrio.json`](api-barrio.json), [`api-barrio.headers.txt`](api-barrio.headers.txt) |
| `GET /api/v1/barrio/geometria` | `200`, `Polygon` de 58 coordenadas, `srid=4326` | [`api-geometria.json`](api-geometria.json), [`api-geometria.headers.txt`](api-geometria.headers.txt) |
| `GET http://127.0.0.1:3001/internal/v1/barrio` sin token | `401 NO_AUTORIZADO` | [`api-interno-sin-token.json`](api-interno-sin-token.json) |

La ficha devuelve `3.807` habitantes como **estimación del registro del barrio**, `9,1 ha`, `705`
lotes, `34` manzanas de estrato `2`, localidad Kennedy (`08`), UPZ Patio Bonito (`82`) y UPL14.
No se usó la población de la UPZ como si fuera la del barrio.

Cabeceras verificadas en las respuestas públicas: `Cache-Control: public, max-age=300,
stale-while-revalidate=60`, `Access-Control-Allow-Origin: http://127.0.0.1:5173`,
`X-Request-Id` y cabeceras de seguridad de Helmet. El backend interno no tiene CORS público.

## 5. Pruebas ejecutadas

| Comando | Resultado | Log |
|---|---|---|
| `mi-barrio-backend`: `npm run ci` | lint, typecheck, límite de 100 líneas, 3 hashes y **11/11 pruebas** en 6 archivos | [`ci-backend.log`](ci-backend.log) |
| `mi-barrio-api`: `npm run ci` | lint, typecheck, límite de 100 líneas, contrato interno y **8/8 pruebas** en 4 archivos | [`ci-api.log`](ci-api.log) |
| `mi-barrio-frontend`: `npm run ci` | lint, typecheck, límite de 100 líneas, contrato público, **3/3 pruebas** y build de producción | [`ci-frontend.log`](ci-frontend.log) |
| `mi-barrio-frontend`: `npx playwright test --reporter=line` | **2/2 pruebas** de aceptación | [`aceptacion-playwright.log`](aceptacion-playwright.log) |

Las pruebas de aceptación comprueban, en navegador real con Chrome:

- ficha, `3.807`, `9,1 ha`, UPL14 y “Información no disponible”;
- atribución SDP/UAECD – IDECA y licencia CC BY 4.0;
- un único polígono Leaflet, encuadrado dentro del mapa, zoom y popup;
- escritorio y móvil `390 × 844`, sin depender de datos simulados en la UI;
- enlace “Saltar al contenido principal”, recorrido con teclado y foco visible.

No se ejecutó una auditoría formal de accesibilidad (WCAG/lector de pantalla) ni la prueba de
rendimiento PT-01. Por eso las historias no pasan de `En pruebas`.

## 6. Capturas

- [`ficha-desktop.png`](ficha-desktop.png): vista de escritorio generada por Playwright, con popup del polígono.
- [`ficha-mobile.png`](ficha-mobile.png): vista móvil `390 × 844`.

Son capturas del stack local, no de un despliegue staging.

## 7. Red privada y seguridad

- El backend escucha en `HOST=0.0.0.0:3001` para la red de servicios, pero no se publica en Internet.
- La API usa `X-Service-Token`; el backend rechaza solicitudes sin token con `401`.
- En contenedores, la API debe usar `BACKEND_URL=http://mi-barrio-backend:3001`, no `localhost`.
- Los `.env` locales no están versionados; solo se versiona `.env.example`.
- No se implementaron endpoints administrativos ni autenticación administrativa (D-7 sigue pendiente).

## 8. Reproducción

```bash
# Backend
cd mi-barrio-backend
npm ci
cp .env.example .env
npm run verify:data
npm run migrate
npm run etl
npm run dev

# API (otra terminal)
cd mi-barrio-api
npm ci
cp .env.example .env
npm run contracts:verify
npm run dev

# Frontend (otra terminal)
cd mi-barrio-frontend
npm ci
cp .env.example .env
npm run dev

# Pruebas
cd mi-barrio-backend && npm run ci
cd ../mi-barrio-api && npm run ci
cd ../mi-barrio-frontend && npm run ci
cd ../mi-barrio-frontend && npx playwright test --reporter=line
```

Para que las pruebas de integración y geográficas del backend pasen, la base debe estar migrada y
con el ETL ejecutado. El ETL es transaccional y valida hashes, geometría, centroide y manzanas.

## 9. Pendientes declarados

- PT-01 (rendimiento) y auditoría formal de accesibilidad.
- Despliegue staging con HTTPS; no ejecutado.
- Ejecución de los workflows en GitHub Actions; no hay remoto configurado.
- D-7 (JWT corto + refresh + Argon2) para la fase administrativa.
- Fase 2 (HU-03/HU-12) y demás historias: **no iniciadas**.

## 10. Mejoras post-auditoría (sin modificar HU ni iniciar Fase 2)

Se aplicaron únicamente mejoras de mantenimiento y calidad sobre HU-01/HU-02.

| Hallazgo | Estado | Evidencia | Observaciones |
|---|---|---|---|
| H-01 | Pendiente documentado | `migrations.txt`, `db-validation.txt` | No se reejecutó `migrate`; la aplicación de las 5 migraciones se verifica mediante `schema_migrations` |
| H-02 | Pendiente documentado | `.github/workflows/ci.yml` en los 3 repositorios | No existe remoto ni credenciales; la ejecución remota sigue pendiente |
| H-03 | Pendiente documentado | `plan-desarrollo.md`, esta sección | PT-01, auditoría formal de accesibilidad y staging HTTPS no se ejecutaron |
| H-04 | Resuelto | `aceptacion-playwright-post-mejoras.log`, `ficha-mobile-post-mejoras.png` | Se agregó aserción `scrollWidth <= clientWidth` en móvil; 2/2 pruebas pasaron |
| H-05 | Resuelto | `.env.example` de API y frontend, `README.md` de API | Se diferenció desarrollo local de red privada de contenedores |
| H-06 | Resuelto | `docs/README.md` | Se corrigió la referencia a `mi-barrio-docs` como repositorio independiente |
| H-07 | Resuelto | `ci-*-post-mejoras.log` | Nuevos logs generados con `FORCE_COLOR=0` y `NO_COLOR=1`; workflows incluyen `NO_COLOR: "1"` |
| H-08 | Resuelto | `mi-barrio-backend/.github/workflows/ci.yml`, `README.md` | Imagen actualizada a `postgis/postgis:16-3.7`; PostgreSQL 16 se mantiene |

Cambios de código y configuración realizados:

- `mi-barrio-frontend/tests/acceptance/ficha-mapa.spec.ts`: aserción de desbordamiento horizontal en móvil.
- `mi-barrio-api/.env.example`: separación local/contenedores.
- `mi-barrio-frontend/.env.example`: aclaración de despliegue.
- `mi-barrio-api/README.md`: aclaración de red privada.
- `docs/README.md`: corrección de referencia documental.
- `mi-barrio-backend/.github/workflows/ci.yml`: imagen PostGIS `16-3.7` y `NO_COLOR: "1"`.
- `mi-barrio-api/.github/workflows/ci.yml`: `NO_COLOR: "1"`.
- `mi-barrio-frontend/.github/workflows/ci.yml`: `NO_COLOR: "1"`.
- `mi-barrio-backend/README.md`: actualización de versión de PostGIS en CI.

Comandos ejecutados en esta intervención:

```bash
npm run ci
npm run verify:data
npm run contracts:verify
npm run check:lines
npx playwright test --reporter=line
```

Resultados reales:

- Backend: 11/11 pruebas en 6 archivos.
- API: 8/8 pruebas en 4 archivos.
- Frontend: 3/3 pruebas y build de producción.
- Playwright: 2/2 pruebas, incluyendo la nueva aserción de desbordamiento horizontal.

Evidencias nuevas:

- `ci-backend-post-mejoras.log`
- `ci-api-post-mejoras.log`
- `ci-frontend-post-mejoras.log`
- `aceptacion-playwright-post-mejoras.log`
- `ficha-desktop-post-mejoras.png`
- `ficha-mobile-post-mejoras.png`

Los logs y capturas anteriores se conservan como historial.

Limitaciones que continúan pendientes: PT-01, auditoría formal de accesibilidad, staging HTTPS, ejecución remota de GitHub Actions y D-7. HU-01 y HU-02 continúan en `En pruebas`; no se declararon `Validada`.
