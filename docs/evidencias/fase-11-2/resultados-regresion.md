# Resultados de regresión — Fase 11.2

**Fecha:** 2026-11-16  
**Alcance:** Fase 11.2 — resolución de brechas y cierre de validación funcional.

## Backend

- `npm run ci`: **OK**.
- Pasos del CI: `lint`, `typecheck`, `check:lines`, `verify:data`, `test`.
- Pruebas: **11/11 OK**.
- Verificación de datos fuente: **OK**.
- Build: **OK**.
- Snapshots: **10 OK** tras la incorporación del snapshot de F-03.

## API

- `npm run ci`: **OK**.
- Pasos del CI: `lint`, `typecheck`, `check:lines`, `contracts:verify`, `test`.
- Contrato interno: **verificado**.
- Pruebas: **OK**.
- Build: **OK**.

## Frontend

- `npm run ci`: **OK**.
- Pasos del CI: `lint`, `typecheck`, `check:lines`, `contracts:verify`, `test`, `build`.
- Pruebas unitarias/integración: **3/3 OK**.
- Contrato público: **verificado**.
- Build de producción: **OK**.

## Contratos y hashes

- Contrato interno final: `338f3cbe3a7591d09691c0e05ae43bab8783faac1511d22408eb67e05d0f8ddc`.
- Contrato público final: `af9cda5b6ae3cdad59593ac5dd4abf9d3ca3c2550ee672484ac952ed88b5232e`.

## Playwright

- Comando final: `npm run test:acceptance` / `npx playwright test --reporter=line`.
- Resultado final: **23/23 pruebas aprobadas**, **0 fallidas**, **0 omitidas**.
- Navegador: Chrome.
- Servicios: Vite, API, backend y PostgreSQL/PostGIS locales.

## Resumen de regresión final

| Verificación | Resultado |
|---|---|
| Backend `npm run ci` | OK |
| API `npm run ci` | OK |
| Frontend `npm run ci` | OK |
| Backend build | OK |
| API build | OK |
| Frontend build | OK |
| Contrato interno | OK |
| Contrato público | OK |
| Playwright final | 23/23 OK |
| Límite de líneas | OK |
| Verificación fuente | OK |
| Snapshots | 10 OK |

## Conclusión

La regresión final de Fase 11.2 terminó en verde en los tres repositorios y en la suite E2E completa.
