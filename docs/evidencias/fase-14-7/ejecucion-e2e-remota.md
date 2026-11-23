# Fase 14.7 — Publicación y validación remota E2E

**Fecha real de ejecución:** 2026-11-22, `03:12:11Z` a `03:13:53Z` (UTC), duración **1 m 42 s**.  
**Estado:** ✅ Cerrada con evidencia real de GitHub Actions.  
**Alcance:** publicación de los tres repositorios y ejecución remota del workflow E2E.  
**Restricciones cumplidas:** sin cambios de código, sin cambios de workflows, sin secretos modificados, sin commits, sin push, sin despliegue y sin Fase 15.

---

## 1. Incidente previo: E2E #1

La primera ejecución (`run 44978953334`) falló en `Checkout API (SHA verificado)`:

```text
fatal: remote error: upload-pack: not our ref 40c92fb2651ad31f7d33f9c14e0abc8bfb0789f2
```

La causa fue un `api_ref` transcrito de forma incorrecta. El SHA real publicado era `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd`; el valor usado compartía los primeros 32 hexadecimales pero difería en el sufijo. No hubo pérdida de commit, force-push, fallo de contrato ni problema de secretos. El `backend_ref` de esa ejecución sí era correcto.

---

## 2. Ejecución E2E #2

| Dato | Valor |
|---|---|
| Run ID | `44979541605` |
| URL | https://github.com/chellunette-cloud/mi-barrio-frontend/actions/runs/44979541605 |
| Workflow | `E2E` |
| Evento | `workflow_dispatch` |
| Rama | `main` |
| Estado | `success` |
| Job | `playwright` → `success` |
| Inicio | `2026-11-22T03:12:11Z` |
| Fin | `2026-11-22T03:13:53Z` |
| Duración | 1 m 42 s |

### Referencias utilizadas

| Repositorio | Referencia | SHA |
|---|---|---|
| Frontend | `github.sha` / rama `main` | `332dc94198e40c93b006582bdcb2b45500e72f73` |
| Backend | `backend_ref` | `a6c912542873665659fff4a38c1efdd5f13483be` |
| API | `api_ref` | `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd` |

Los tres SHAs coinciden con el HEAD remoto de cada repositorio y con el HEAD local verificado.

---

## 3. Validación remota comprobada

| Elemento | Resultado |
|---|---|
| Checkout frontend | ✅ SHA `332dc94…` |
| Checkout backend | ✅ SHA `a6c9125…` |
| Checkout API | ✅ SHA `40c92fb…0ff976f9dd` |
| Instalación reproducible | ✅ `npm ci` en backend, API y frontend |
| PostgreSQL/PostGIS temporal | ✅ Servicio `postgis/postgis:16-3.7`, base efímera `mi_barrio` |
| Migraciones y ETL | ✅ Ejecutadas sobre la base efímera del workflow |
| Builds | ✅ backend, API y frontend |
| Contrato interno | ✅ Sincronizado, SHA-256 `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` |
| Contrato público | ✅ Sincronizado, SHA-256 `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` |
| Administrador E2E | ✅ Creado con credenciales de secretos, sin valores expuestos |
| Health del backend | ✅ Con token `200`; sin token rechazado |
| Health de la API | ✅ `200` |
| Playwright | ✅ **36 aprobados, 0 fallidos** |
| Jobs pendientes/fallidos/cancelados | ✅ Ninguno |

### Cobertura de las pruebas E2E

Playwright ejecutó **36 pruebas en 15 archivos**:

1. `accesibilidad.spec.ts`
2. `ficha-mapa.spec.ts`
3. `hu03-hu06.spec.ts`
4. `hu07.salud.spec.ts`
5. `hu08.vias.spec.ts`
6. `hu09.transporte.spec.ts`
7. `hu10.demografia.spec.ts`
8. `hu11.seguridad.spec.ts`
9. `hu12.filtros.spec.ts`
10. `hu13.acceso.spec.ts`
11. `hu13.admin.spec.ts`
12. `hu13.categorias.spec.ts`
13. `hu13.validacion.spec.ts`
14. `mapa-interaccion.spec.ts`
15. `places.spec.ts`

Estas pruebas cubren directamente los criterios de aceptación correspondientes a esos recorridos. No implican que los 46 criterios se ejecutaran individualmente en este run; la matriz global mantiene 46/46 sobre la evidencia acumulada de fases anteriores, con este run como **regresión remota** de los criterios cubiertos.

---

## 4. Artefacto

| Dato | Valor |
|---|---|
| Nombre | `playwright-report` |
| ID | `14737372046` |
| Tamaño | `234574 bytes` (≈229 KB) |
| SHA-256 | `c876b01c49a1f003aba73bce4c3facb3ce6cd1eb507b30db5ae29f6e6eedf0e0` |
| URL | https://github.com/chellunette-cloud/mi-barrio-frontend/actions/runs/44979541605/artifacts/14737372046 |
| Estado | Disponible, no expirado |

No se encontraron valores de secretos en logs ni en el artefacto; GitHub mostró los valores sensibles enmascarados cuando aparecieron en comandos.

---

## 5. Advertencia de Node.js 20

El log del job incluyó esta advertencia:

```text
##[warning]Node.js 20 is deprecated. The following actions target Node.js 20 but are being forced to run on Node.js 24: actions/checkout@v4, actions/setup-node@v4, actions/upload-artifact@v4. For more information see: https://github.blog/changelog/2025-09-19-deprecation-of-node-20-on-github-actions-runners/
```

**Interpretación:** es una advertencia del runner sobre el runtime target de esas actions, no un fallo. El job `playwright` terminó en `success` y el artefacto se generó correctamente. No se modificó el workflow.

Otras advertencias no bloqueantes del log: `punycode` y `url.parse()` deprecados por dependencias, `eslint@9.39.5` marcado como no soportado, `NO_COLOR` ignorado por `FORCE_COLOR`, y `POSTGRES_HOST_AUTH_METHOD=trust` en el servicio efímero. Ninguna impidió la ejecución.

---

## 6. Estado de publicación y secretos

| Repositorio | Rama | HEAD remoto | Verificación |
|---|---|---|---|
| `mi-barrio-backend` | `main` | `a6c912542873665659fff4a38c1efdd5f13483be` | ✅ |
| `mi-barrio-api` | `main` | `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd` | ✅ |
| `mi-barrio-frontend` | `main` | `332dc94198e40c93b006582bdcb2b45500e72f73` | ✅ |

Secretos configurados en `mi-barrio-frontend` (solo nombres, sin valores): `SERVICE_TOKEN`, `JWT_SECRET`, `JWT_REFRESH_SECRET`, `E2E_ADMIN_USERNAME`, `E2E_ADMIN_PASSWORD`. Los cinco están presentes.

---

## 7. Cierre de Fase 14.7

No quedan bloqueos técnicos para Fase 14.7: publicación verificada, secretos presentes, workflow en verde, artefacto válido y sin jobs pendientes.

Quedan fuera de esta fase la aceptación humana final, Fase 15, despliegue y cualquier entrega posterior. Este documento no declara terminado el proyecto completo.
