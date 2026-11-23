# Resultados de regresión — Fase 12.1

**Fecha:** 2026-11-19
**Entorno:** PostgreSQL 16.13 + PostGIS 3.7.0 local en `127.0.0.1:55432`; backend y API ya en ejecución en `3001` y `3000`; Vite iniciado por la configuración de Playwright en `5173`.
**Regla:** todo lo listado como «ejecutado» corresponde a un comando real lanzado en esta fase.

## 1. Comandos ejecutados

| Repositorio | Comando | Resultado exacto |
|---|---|---|
| `mi-barrio-backend` | `npm run ci` | `lint` OK · `typecheck` OK · `check:lines` OK · `verify:data` **10/10** · `vitest run` **24/24** |
| `mi-barrio-backend` | `npm run build` | `tsc -p tsconfig.build.json` sin errores |
| `mi-barrio-api` | `npm run ci` | `lint` OK · `typecheck` OK · `check:lines` OK · `contracts:verify` OK · `vitest run` **15/15** |
| `mi-barrio-api` | `npm run build` | `tsc -p tsconfig.build.json` sin errores |
| `mi-barrio-frontend` | `npm run ci` | `lint` OK · `typecheck` OK · `check:lines` OK · `contracts:verify` OK · `vitest run` **13/13** · `vite build` sin errores |
| `mi-barrio-frontend` | `npm run test:acceptance -- --reporter=line` | **27 passed (27) in 12.4s** |

## 2. Detalle de verificaciones

### Backend

- `npm run ci` ejecutó `npm run lint`, `npm run typecheck`, `npm run check:lines`, `npm run verify:data` y `npm run test`.
- `verify:data` validó los **10** snapshots por hash: barrio, estrato, atributos oficiales, población UPZ, colegios, parques, comercio OSM, salud, transporte y manzanas. No se regeneraron ni modificaron archivos de datos.
- Suite `vitest`: **24 pruebas aprobadas**, sin fallos ni omitidas. Las pruebas nuevas son:
  - `lugarSearch.test.ts`: acento en consulta, dirección en minúsculas/mayúsculas y sin coincidencia.
  - `lugarQueries.test.ts`: normalización de dirección con `ñ`/`Ñ`.
- `npm run build` compiló sin errores.

### API

- `npm run ci` ejecutó `lint`, `typecheck`, `check:lines`, `contracts:verify` y `test`.
- `contracts:verify`: contrato interno sincronizado con hash `606a25436e23c4964f44153acc545b4dcb947801ffc726aa1aaf0f565c15a84c`.
- Suite `vitest`: **15 pruebas aprobadas**, incluida la nueva propagación de `q=cl 40 sur` al backend con espacios codificados correctamente.
- `npm run build` compiló sin errores.

### Frontend

- `npm run ci` ejecutó `lint`, `typecheck`, `check:lines`, `contracts:verify`, `test` y `build`.
- `contracts:verify`: contrato público sincronizado con hash `c1602756c9eb7edf98695da489856f76387f3d62874e13e5ce89a1ed461aed59`.
- Suite `vitest`: **13 pruebas aprobadas**, incluidas las 3 nuevas de `PlaceListItem.test.tsx`.
- `vite build` generó el bundle de producción sin errores.

### Playwright

- Comando: `npm run test:acceptance -- --reporter=line`.
- Resultado: **27 passed (27) in 12.4s**.
- Cobertura relevante de esta fase:
  - HU-03: búsqueda por dirección en dos capitalizaciones, ausencia de resultados, búsqueda `nino`/`NIÑO`, categoría y dirección visibles en el listado.
  - HU-04: categoría comercial y tipo `Supermercado` en el listado.
  - HU-06: etiquetas `Dentro del barrio` y `Cercano` presentes en el listado de sedes.
- Las variables `E2E_ADMIN_USERNAME` y `E2E_ADMIN_PASSWORD` se cargaron en memoria desde `mi-barrio-backend/.env`; sus valores no se imprimieron ni se copiaron a la documentación.

## 3. Verificaciones de solo lectura adicionales

| Verificación | Método | Resultado |
|---|---|---|
| Hashes de snapshots | `npm run verify:data` en backend | 10/10 OK |
| Hashes de contratos | `contracts:verify` en API y frontend | `606a2543…` y `c1602756…` sin cambios |
| `dentroBarrio` en datos reales | Consulta SQL `SELECT ... GROUP BY dentro_barrio` | `educacion\|t\|1`, `educacion\|f\|27`; una sede dentro del polígono |
| Dirección de prueba | Consulta SQL `WHERE direccion ILIKE '%CL 40 SUR%'` | `COLEGIO ALEJANDRO MAGNO \| CL 40 SUR # 90 B - 21` y otros registros reales |
| Estado Git | `git status -sb`, `git rev-parse HEAD` | Sin commits ni push; detalles en `decisiones-y-limitaciones.md` |

## 4. Lo que NO se ejecutó ni se debe inferir como ejecutado

- No se ejecutó `npm install` ni actualización de dependencias.
- No se ejecutó ETL ni regeneración de snapshots.
- No se ejecutaron auditorías WCAG formales, pruebas cross-browser ni escaneos de seguridad.
- No se desplegó ningún servicio ni se publicó documentación.
- No se modificó `mi-barrio-entrega`.
