# Resultados de regresión — Fase 12

**Fecha:** 2026-11-19  
**Entorno:** PostgreSQL/PostGIS portátil documentado en 127.0.0.1:55432, backend 3001, API 3000, Vite 5173. Servicios iniciados solo para pruebas; sin despliegue.

## CI por repositorio

| Repositorio | Comando | Resultado |
|---|---|---|
| `mi-barrio-backend` | `npm run ci` | OK: lint, typecheck, ≤100 líneas, 10 snapshots, 20/20 pruebas |
| `mi-barrio-api` | `npm run ci` | OK: lint, typecheck, ≤100 líneas, contrato interno, 14/14 pruebas |
| `mi-barrio-frontend` | `npm run ci` | OK: lint, typecheck, ≤100 líneas, contrato público, 10/10 pruebas, build |

## Builds adicionales

- `npm run build` en `mi-barrio-backend`: OK (`tsc -p tsconfig.build.json`).
- `npm run build` en `mi-barrio-api`: OK (`tsc -p tsconfig.build.json`).
- `npm run build` en `mi-barrio-frontend`: OK (Vite 7.3.8, 111 módulos).

## E2E (Playwright)

- Comando: `npm run test:acceptance` con `E2E_ADMIN_USERNAME`/`E2E_ADMIN_PASSWORD` cargadas desde el `.env` local del backend, sin imprimir valores.
- Resultado final: **27/27 pruebas superadas**, incluidas las 4 nuevas de `tests/acceptance/hu03-hu06.spec.ts`.
- Duración de la corrida final: 55.6 s, 1 worker, canal Chrome.
- No se eliminó ni debilitó ninguna prueba existente. Se conservaron etiquetas heredadas del detalle para mantener HU-09 en verde.

## Contratos y hashes SHA-256

| Contrato | Hash final |
|---|---|
| Interno (backend → API) | `606a25436e23c4964f44153acc545b4dcb947801ffc726aa1aaf0f565c15a84c` |
| Público (API → frontend) | `c1602756c9eb7edf98695da489856f76387f3d62874e13e5ce89a1ed461aed59` |

Cambio contractual: parámetro opcional `tipo` (máx. 60 caracteres) en `GET /internal/v1/lugares` y `GET /api/v1/lugares`. Es retrocompatible: si no se envía, la consulta se comporta como antes. Se regeneraron `internal-schema.ts` y `api-schema.ts`.

## Snapshots verificados (`npm run verify:data`)

10/10 contra `manifest.json`:

- `barrio-ciudad-granada.geojson` — `6339B395069A18E71CA003E33D50AF2E1021CA0106C951EB18AC8C55DF000D74`
- `estrato-ciudad-granada.geojson` — `DD60ED59E304E29AFB44C4886ADC8DFE3EBF1A5BB689C005AF137AB07610E994`
- `barrio-atributos-oficial.json` — `A504B1F04E312C69B8AEA081AEF652C8CD6B34331737B6ABD235251E828010F6`
- `poblacion-upz-082-2025.json` — `5A82B06B401CA564D9BB0255FF72A0AD910B3E68A29847A076D61C756980F03D`
- `colegios-ciudad-granada.geojson` — `3DCFBD4B77E0605EE2D04BCCDD224C04F375896C77E93BE652FA34BB26D9D960`
- `parques-ciudad-granada.geojson` — `C5A6E216F52E27E78FB9744069F81D2C9C82809C76DA23853587053D30570413`
- `comercio-osm-ciudad-granada.json` — `AB55F3B8DC600803D6ED6A82AA09DD045F0CA4939BE6014FE702768A40FBDA74`
- `salud-ciudad-granada.geojson` — `3EE0A471B6EDE49C93D910DF12D38FECF236DC34614EDCF55F1982B5AA473B1B`
- `transporte-ciudad-granada.geojson` — `708429780751F7B3F91C1242C1DC7304457EBA671C0E201B599812D2DD3E8B92`
- `vias-ciudad-granada.geojson` — `E1E7452CE3ACEAFA7E48E743C94E876C79FDE85A3C8A815A2684A933F9B78EC4`

## ETL

`npm run etl` completado en una transacción:

- barrio OK: 58 vértices, centroide 4.641833130667935, -74.17175846032757.
- estrato OK: 34 manzanas, todas estrato 2 y dentro del polígono.
- lugares OK: 376 registros.
- vías OK: 463 tramos.

## Límites y alcance

- `check:lines` OK en los tres repositorios: todos los archivos de código tienen ≤100 líneas.
- No se crearon commits, no se hizo push, no se desplegó y no se inició Fase 12+ ni HU-01/HU-02.
- No se modificaron `temp-reference/`, los requisitos académicos originales ni los snapshots de datos.

## Estado Git final

Los HEAD permanecen en los commits ya publicados; no hay commits nuevos.

| Repositorio | HEAD | Cambios |
|---|---|---|
| `mi-barrio-backend` | `7b641a8bd2cf116f8f4406575a631e26365a4a12` | 5 modificados, 5 nuevos |
| `mi-barrio-api` | `76e59be750dfb430f84ea6280b5a943c7f51c51b` | 10 modificados |
| `mi-barrio-frontend` | `c5240ac59075c83a517eb5a5618f7d5f9e6d6afa` | 7 modificados, 9 nuevos |

Detalle en el informe final de la sesión. `mi-barrio-entrega` solo recibió la réplica local de estas evidencias y el índice actualizado; en esa fecha seguía sin remoto (_publicado después el 2026-11-23, véase `entrega/estado-publicacion.md` §9_).
