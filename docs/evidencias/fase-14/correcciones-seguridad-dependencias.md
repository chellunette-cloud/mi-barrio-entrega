# Fase 14.6 — Corrección controlada de dependencias vulnerables

**Fecha:** 2026-11-21  
**Alcance:** tres repositorios independientes (`mi-barrio-backend`, `mi-barrio-api`, `mi-barrio-frontend`).  
**Tipo de cambio:** actualización de dependencias de desarrollo y commits locales de seguridad.  
**Restricciones cumplidas:** sin push, sin GitHub Actions remotas, sin secretos, sin despliegue, sin `mi-barrio-entrega`, sin repositorios nuevos, sin `--force`, sin `npm audit fix`, sin reescritura de historial.

---

## 1. Estado real verificado antes de modificar

| Repositorio | HEAD anterior | Estado |
|---|---|---|
| `mi-barrio-backend` | `4ead2d13e73f190445968f92efecbd23d7acac5e` | Limpio, `main...origin/main [ahead 1]` |
| `mi-barrio-api` | `c2603bb666cfa0f470fefd71ffc8ac8bfb0789f2` | Limpio, `main...origin/main [ahead 1]` |
| `mi-barrio-frontend` | `4aadc066c0a2f608230540d9b48dd2abf59642d4` | Limpio, `main...origin/main [ahead 1]` |

Versiones reales instaladas, confirmadas con `npm ls --all` y sin asumir informes previos:

| Paquete | Versión anterior |
|---|---|
| `typescript-eslint` | `8.72.2` |
| `vitest` | `3.2.7` |
| `@vitest/mocker` | `3.2.7` |
| `tinypool` | `1.1.1` |
| `minimatch` (anidado en `typescript-estree`) | `10.2.6` |

Manifests y scripts revisados:

- `typescript-eslint`: `^8.48.0` → permite `8.73.0` sin cambio de major.
- `vitest`: `^3.2.7` → `5.1.1` requiere cambio de major.
- Scripts sin cambios: `ci`, `test`, `build`, `lint`, `typecheck`, `check:lines`, `contracts:verify`, `verify:data`, `test:acceptance`.

### Discrepancia documental Vitest 5.1.1 vs 3.2.7

No existía tal discrepancia:

- Ningún informe previo afirmó que estuviera instalado Vitest `5.1.1`.
- La evidencia de Fase 7 menciona `vitest 5.1.0` como **versión major requerida para corregir**, no como versión instalada.
- El `fixAvailable` del audit apuntaba a `vitest 5.1.1`.
- La versión instalada real era `3.2.7`, coherente con el manifest `^3.2.7`.

---

## 2. Cambios aplicados

| Paquete | Antes | Después |
|---|---|---|
| `typescript-eslint` | `8.72.2` instalado | `8.73.0` |
| `@typescript-eslint/typescript-estree` | `8.72.2` | `8.73.0` |
| `minimatch` anidado | `10.2.6` | `11.0.9` |
| `vitest` | `3.2.7` | `5.1.1` |
| `@vitest/mocker` | `3.2.7` | `5.1.1` |
| `tinypool` | `1.1.1` | **Eliminado** (Vitest 4+ reemplaza pools sin esta dependencia) |

Comando ejecutado en los tres repositorios:

```bash
npm install --save-dev typescript-eslint@8.73.0 vitest@5.1.1
```

No se usaron overrides, ni `npm audit fix`, ni `npm audit fix --force`.

---

## 3. Vulnerabilidades resueltas

Los 10 hallazgos de Fase 14.5 desaparecieron:

- 7 hallazgos moderados de la familia `typescript-eslint` / `minimatch` → resueltos con `typescript-eslint 8.73.0`, que usa `minimatch ^11.0.1`.
- 1 hallazgo moderado de `@vitest/mocker` → resuelto con `@vitest/mocker 5.1.1`.
- 2 hallazgos críticos de `tinypool` / `vitest` → resueltos porque Vitest 5 ya no depende de `tinypool`.

Resultado confirmado tras `npm ci` y de forma independiente con `npm audit`:

| Repositorio | `npm audit` completo | `npm audit --omit=dev` |
|---|---:|---:|
| `mi-barrio-backend` | 0 | 0 |
| `mi-barrio-api` | 0 | 0 |
| `mi-barrio-frontend` | 0 | 0 |

---

## 4. Compatibilidad y cambios por la migración de Vitest

### Compatibilidad verificada

- Node local: `v24.13.1`; node de CI del workflow: `24`; engines de los repos: `>=22`.
- Vitest 5.1.1 requiere Node `^22.12.0 || ^24.0.0 || >=26.0.0` y Vite `>=6.4.0`.
- Vite instalado: `7.3.8` en los tres repositorios.
- Vitest 4 eliminó `tinypool`; no se requirió override de `tinypool`.
- Configuraciones locales revisadas:
  - `fileParallelism: false`, `testTimeout`, `hookTimeout`, `environment`, `include`, `setupFiles` y `css` siguen siendo válidos.
  - No se usaban `poolOptions`, `workspace`, `bench`, `test.sequential`, reporters removidos ni APIs de entrypoints eliminados.
- Patrones de tests revisados:
  - `vi.mock` aparece a nivel superior del módulo, requisito de Vitest 5.
  - `expect(...).rejects` está correctamente awaitado.
  - Los `expect.poll` encontrados pertenecen a Playwright, no a Vitest.

### Cambios necesarios en código

**Ninguno.** Solo cambiaron `package.json` y `package-lock.json` en cada repositorio. No se modificaron contratos, datos fuente, tests, configuración ni workflow.

El reporter de Vitest 5 muestra un resumen distinto (`Test Files`, `Tests`, `Duration`, `Isolate`), sin impacto funcional.

---

## 5. Validaciones posteriores

| Validación | Backend | API | Frontend |
|---|---|---|---|
| `npm ci` | 0 | 0 | 0 |
| `npm run ci` | 0, **30/30** | 0, **19/19** | 0, **13/13** |
| `npm run build` | 0 | 0 | 0 |
| `contracts:verify` | n/a | 0, hash `ab080fd0…` | 0, hash `a2ed68fa…` |
| `verify:data` | 0, 10/10 | n/a | n/a |
| `check:lines` | 0 | 0 | 0 |
| `npm audit` completo | 0 | 0 | 0 |
| `npm audit --omit=dev` | 0 | 0 | 0 |
| `git diff --check` | 0 | 0 | 0 |
| YAML del workflow | — | — | `YAML_OK` |
| Escaneo de secretos/artefactos | Sin hallazgos | Sin hallazgos | Sin hallazgos |

Validación adicional:

- Playwright completo: **36/36**, exit `0`, 58,4 s.
- Health local con servicios efímeros: `backend=200; backend_sin_token=401; api=200`.
- Credenciales E2E leídas desde `.env` en memoria, sin imprimir valores; `E2E_TRACE=off`.
- PostgreSQL temporal iniciado para las pruebas y detenido al finalizar.

---

## 6. Contratos

Los hashes no cambiaron:

| Contrato | SHA-256 |
|---|---|
| Interno | `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` |
| Público | `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` |

---

## 7. Commits locales de seguridad

| Repositorio | Commit | Mensaje | Archivos |
|---|---|---|---|
| `mi-barrio-backend` | `a6c912542873665659fff4a38c1efdd5f13483be` | `fix(deps): actualizar typescript-eslint y vitest a versiones seguras` | `package.json`, `package-lock.json` |
| `mi-barrio-api` | `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd` | `fix(deps): actualizar typescript-eslint y vitest a versiones seguras` | `package.json`, `package-lock.json` |
| `mi-barrio-frontend` | `332dc94198e40c93b006582bdcb2b45500e72f73` | `fix(deps): actualizar typescript-eslint y vitest a versiones seguras` | `package.json`, `package-lock.json` |

No se modificaron los commits anteriores (`4ead2d1`, `c2603bb`, `4aadc06`).

---

## 8. Estado final y bloqueos

| Repositorio | Rama | Estado |
|---|---|---|
| `mi-barrio-backend` | `main...origin/main [ahead 2]` | Limpio |
| `mi-barrio-api` | `main...origin/main [ahead 2]` | Limpio |
| `mi-barrio-frontend` | `main...origin/main [ahead 2]` | Limpio |

Bloqueos restantes para publicación: autorización explícita para push, configuración de secretos en GitHub, `workflow_dispatch` con los SHAs publicados, verificación remota y aceptación humana final.

No se ejecutó ninguna acción remota.
