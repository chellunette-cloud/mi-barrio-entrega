# Resultados de regresión — Fase 13

**Fecha:** 2026-11-19
**Entorno:** PostgreSQL 16.13 + PostGIS 3.7.0 local; backend en `3001`, API en `3000`, Vite iniciado por Playwright en `5173`.

## 1. Comandos ejecutados

| Repositorio | Comando | Resultado |
|---|---|---|
| `mi-barrio-backend` | `npm run ci` | lint OK · typecheck OK · check:lines OK · verify:data **10/10** · **24/24** pruebas · exit 0 |
| `mi-barrio-backend` | `npm run build` | OK |
| `mi-barrio-api` | `npm run ci` | lint OK · typecheck OK · check:lines OK · contracts:verify OK · **15/15** pruebas · exit 0 |
| `mi-barrio-api` | `npm run build` | OK |
| `mi-barrio-frontend` | `npm run ci` | lint OK · typecheck OK · check:lines OK · contracts:verify OK · **13/13** pruebas · `vite build` OK |
| `mi-barrio-frontend` | `npx playwright test tests/acceptance/accesibilidad.spec.ts tests/acceptance/mapa-interaccion.spec.ts --reporter=list` | **9/9** (4 accesibilidad + 5 interacción) |
| `mi-barrio-frontend` | `npm run test:acceptance -- --reporter=line` | **36 passed (36)** |

La suite Playwright pasó de 27 a 36 pruebas: se añadieron 4 de accesibilidad y 5 de interacción del mapa. La spec original `ficha-mapa.spec.ts` se actualizó para usar los nombres accesibles en español y el rol del polígono; sus 2 pruebas siguen pasando.

## 2. Verificaciones específicas

| Verificación | Resultado |
|---|---|
| `check:lines` en backend, API y frontend | OK: ningún archivo de código supera 100 líneas |
| `verify:data` en backend | 10/10 snapshots por hash |
| Contrato interno (API) | `606a25436e23c4964f44153acc545b4dcb947801ffc726aa1aaf0f565c15a84c`, sin cambios |
| Contrato público (frontend) | `c1602756c9eb7edf98695da489856f76387f3d62874e13e5ce89a1ed461aed59`, sin cambios |
| axe-core en HU-01/HU-02 | 4 análisis, **0 violaciones** |
| Arrastre, zoom, rueda, popup y marcadores | 5 pruebas E2E, **5/5** |
| Compilación de los tres repositorios | OK |

## 3. Dependencia añadida

Se instaló `@axe-core/playwright` como dependencia de desarrollo del frontend (`package.json` y `package-lock.json`). El comando informó:

```text
added 2 packages, and audited 322 packages
10 vulnerabilities (8 moderate, 2 critical)
```

No se ejecutó `npm audit fix` ni `npm audit fix --force`: las vulnerabilidades son preexistentes en el árbol de dependencias y su corrección queda fuera del alcance de CA-HU01-04/CA-HU02-03. Se documentan como brecha pendiente.

## 4. Lo que NO se ejecutó

- No se ejecutaron migraciones, ETL ni regeneración de snapshots.
- No se modificaron datos ni se hicieron escrituras en base; las pruebas de integración usan `SELECT` y las E2E solo leen la API.
- No se ejecutó `git commit`, `git push`, tags ni despliegue.
- No se publicó documentación.
- No se modificó `mi-barrio-entrega`.
- No se ejecutaron auditorías WCAG externas con lector de pantalla, cross-browser ni escaneo de seguridad.
