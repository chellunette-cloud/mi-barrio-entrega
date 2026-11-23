# Auditoría del estado de despliegue — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**

Esta auditoría registra el estado **real y comprobado** del proyecto para la planificación del despliegue. Es un ejercicio de **solo lectura**: no se crearon cuentas, no se desplegó ningún servicio, no se hicieron commits ni pushes, no se modificaron secretos ni variables de entorno y **no se imprimieron valores secretos** de los archivos `.env`.

**Ámbito inspeccionado**

- Workspace: `<WORKSPACE>`.
- Repositorios: `mi-barrio-frontend`, `mi-barrio-api` y `mi-barrio-backend`.
- Documentación: `docs/`, `docs/despliegue/`, `docs/manuales/`, `docs/arquitectura/`, `docs/planificacion/`, `docs/evidencias/` y `mi-barrio-entrega/entrega/`.

**Método:** lectura de archivos, comandos Git de solo lectura (`status`, `branch`, `rev-parse`, `log`, `remote`, `stash`, `ls-files`), búsqueda de nombres de archivos de infraestructura y cálculo local de hashes SHA-256 de los contratos. No se ejecutaron scripts `npm` ni workflows.

> **Aclaración importante:** la publicación de los tres repositorios en GitHub **no es** el despliegue de la aplicación en Internet. En esta auditoría no se encontró evidencia de servicios desplegados, dominios propios, certificados TLS, respaldos operativos ni configuración de producción.

---

## 1. Estado real de Git de los tres repositorios

Hecho comprobado con `git status --porcelain=v1 --branch`, `git rev-parse HEAD`, `git branch -vv`, `git log -1`, `git remote -v` y `git stash list`.

| Repositorio | Rama | HEAD local | Seguimiento | Estado del árbol de trabajo | Remoto `origin` | Stash |
|---|---|---|---|---|---|---|
| `mi-barrio-frontend` | `main` | `332dc94198e40c93b006582bdcb2b45500e72f73` | `origin/main` | `## main...origin/main`: limpio, sin cambios rastreables ni desfase | `https://github.com/chellunette-cloud/mi-barrio-frontend.git` | Vacío |
| `mi-barrio-api` | `main` | `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd` | `origin/main` | `## main...origin/main`: limpio, sin cambios rastreables ni desfase | `https://github.com/chellunette-cloud/mi-barrio-api.git` | Vacío |
| `mi-barrio-backend` | `main` | `a6c912542873665659fff4a38c1efdd5f13483be` | `origin/main` | `## main...origin/main`: limpio, sin cambios rastreables ni desfase | `https://github.com/chellunette-cloud/mi-barrio-backend.git` | Vacío |

- Último commit de los tres repositorios: `fix(deps): actualizar typescript-eslint y vitest a versiones seguras`, fechado `2026-11-21T21:36:58-05:00`.
- **No se ejecutó `git fetch` ni se accedió a GitHub en línea**: el estado de `origin/main` corresponde a la referencia de seguimiento local. El HEAD remoto actual en GitHub **no fue verificado en esta sesión**.
- Los tres `.gitignore` excluyen `.env`, `.env.*` (con excepción de `.env.example`), `node_modules/`, `dist/`, `coverage/` y `*.log`.
- `git ls-files` confirma que `.env.example` está versionado en los tres repositorios y que `.env` **no** está versionado.
- Existen archivos `.env` locales en `mi-barrio-api` y `mi-barrio-backend`; están ignorados por Git. **No se leyó su contenido**. En `mi-barrio-frontend` solo existe `.env.example`.

---

## 2. Infraestructura y configuración de despliegue

### 2.1 Archivos de infraestructura: resultado negativo

Búsqueda realizada en todo el workspace, incluyendo archivos ocultos. No se encontraron en los tres repositorios:

- `Dockerfile`, `Dockerfile.*`, `dockerfile`.
- `docker-compose.yml`, `docker-compose.yaml`, `compose.yml`, `compose.yaml`.
- `Procfile`, `render.yaml`, `fly.toml`, `vercel.json`, `netlify.toml`, `railway.json`.
- `Jenkinsfile`, `.gitlab-ci.yml`, `azure-pipelines.yml`, manifiestos `*.tf`.

Las únicas coincidencias de nombres como `compose` o `publish` estaban dentro de `node_modules/` y corresponden a dependencias de terceros, no a configuración del proyecto.

Las carpetas `scripts/` contienen apoyo al desarrollo y a la integridad, **no despliegue**: verificación de contratos, límite de 100 líneas, verificación de hashes de datos y extracción de datos territoriales.

### 2.2 Workflows de GitHub Actions existentes

| Repositorio | Workflow | Disparadores | Función | ¿Publica/despliega? |
|---|---|---|---|---|
| `mi-barrio-frontend` | `.github/workflows/ci.yml` | `push`, `pull_request` | `npm ci`, `contracts:verify`, `npm run ci` | No |
| `mi-barrio-api` | `.github/workflows/ci.yml` | `push`, `pull_request` | `npm ci`, `contracts:verify`, `npm run ci` | No |
| `mi-barrio-backend` | `.github/workflows/ci.yml` | `push`, `pull_request` | Servicio efímero `postgis/postgis:16-3.7`, `verify:data`, `migrate`, `etl`, `npm run ci` | No |
| `mi-barrio-frontend` | `.github/workflows/e2e.yml` | Solo `workflow_dispatch`, con SHAs exactos de backend y API | Checkout de los tres repositorios en SHAs fijados, base PostGIS efímera, migraciones, ETL, builds, health checks y Playwright; publica un artefacto `playwright-report` | No |

El workflow E2E valida que `backend_ref` y `api_ref` sean SHAs de 40 caracteres hexadecimales, exige secretos para token de servicio, JWT y administrador E2E, y espera hasta 60 intentos por los health checks. **No contiene jobs de publicación, despliegue, DNS, certificados ni infraestructura.**

---

## 3. Variables de entorno y secretos (sin valores)

### 3.1 Backend (`mi-barrio-backend`)

Declaradas en `src/config/env.ts` y `.env.example`:

| Variable | Carácter | Uso verificado en código |
|---|---|---|
| `PORT` | Opcional, default `3001` | Puerto HTTP |
| `HOST` | Opcional, default `0.0.0.0` | Interfaz de escucha |
| `DATABASE_URL` | Obligatoria | Cadena de conexión PostgreSQL/PostGIS |
| `SERVICE_TOKEN` | Obligatoria, mínimo 16 caracteres | Token compartido con la API |
| `JWT_SECRET` | Obligatoria, mínimo 16 caracteres | Firma de tokens de acceso |
| `JWT_REFRESH_SECRET` | Obligatoria, mínimo 16 caracteres | Firma de tokens de refresco |
| `ADMIN_USERNAME` | Opcional | Creación de administrador local al arrancar |
| `ADMIN_PASSWORD` | Opcional, mínimo 8 caracteres | Creación de administrador local al arrancar |
| `NODE_ENV` | Opcional, default `development` | Entorno de ejecución |

### 3.2 API (`mi-barrio-api`)

Declaradas en `src/config/env.ts` y `.env.example`:

| Variable | Carácter | Uso verificado en código |
|---|---|---|
| `PORT` | Opcional, default `3000` | Puerto HTTP |
| `HOST` | Opcional, default `127.0.0.1` | Interfaz de escucha; en contenedores debe ser `0.0.0.0` |
| `BACKEND_URL` | Opcional, default local | URL privada del backend |
| `SERVICE_TOKEN` | Obligatoria, mínimo 16 caracteres | Debe coincidir con el backend |
| `FRONTEND_ORIGIN` | Opcional, default local | Origen único permitido por CORS |
| `RATE_LIMIT_MAX` | Opcional, default `120` | Solicitudes por minuto por IP; `NODE_ENV=production` rechaza valores mayores a 120 |
| `NODE_ENV` | Opcional, default `development` | `development`, `test` o `production` |

### 3.3 Frontend (`mi-barrio-frontend`)

| Variable | Carácter | Uso verificado |
|---|---|---|
| `VITE_API_BASE_URL` | Opcional, vacío por defecto | Prefijo de la API pública; en local se usa el proxy `/api` de Vite |
| `PUBLIC_CONTRACT_PATH` | Opcional | Solo scripts de sincronización de contrato |
| `E2E_ADMIN_USERNAME` / `E2E_ADMIN_PASSWORD` | Solo pruebas E2E | No hay credenciales por defecto en el repositorio |
| `E2E_TRACE` | Solo pruebas E2E | Controla el trace de Playwright |

### 3.4 Secretos en GitHub Actions

El documento `docs/evidencias/fase-14-7/ejecucion-e2e-remota.md` registra como presentes, **solo por nombre**, estos secretos del repositorio frontend: `SERVICE_TOKEN`, `JWT_SECRET`, `JWT_REFRESH_SECRET`, `E2E_ADMIN_USERNAME` y `E2E_ADMIN_PASSWORD`.

**No verificado:** esta auditoría no consultó la API de GitHub, por lo que **no confirma** que esos secretos sigan configurados ni sus valores. Tampoco leyó los `.env` locales.

---

## 4. CORS, comunicación entre servicios y base de datos

### 4.1 CORS y frontera pública

Verificado en `mi-barrio-api/src/http/app.ts`:

- `cors` con `origin: FRONTEND_ORIGIN` (un único origen).
- Métodos permitidos: `GET`, `POST`, `PUT`, `DELETE`.
- Cabeceras permitidas: `Content-Type`, `Authorization`.
- `maxAge: 86400`.
- `helmet()`, `x-powered-by` desactivado y límite de cuerpo JSON de 8 kb.
- Health público: `GET /api/v1/health` responde `{"status":"ok","service":"mi-barrio-api"}`.
- Rate limit de 120 solicitudes/minuto por IP con respuesta `429 DEMASIADAS_SOLICITUDES`.

El backend **no configura CORS**, solo `helmet()` y el router interno. No se encontró evidencia de un origen CORS de producción definido.

### 4.2 Comunicación API → Backend

Verificado en `BackendClient.ts`, `AdminBackendClient.ts` y `serviceToken.ts`:

- La API llama a rutas `/internal/v1/**` con cabecera `X-Service-Token` y timeout de 5 segundos.
- El backend compara el token con `timingSafeEqual` en **todo** el router interno y responde `401 NO_AUTORIZADO` si falta o no coincide.
- La API valida cada respuesta interna contra el contrato con Ajv; si falla, devuelve `502 CONTRATO_INTERNO_INVALIDO`.
- Las rutas administrativas añaden autenticación JWT; el backend valida el token.
- Documentación de red privada: `BACKEND_URL=http://mi-barrio-backend:3001` y backend sin puerto público. **Es una guía, no una topología desplegada.**

### 4.3 Base de datos

Verificado en código y contratos:

- `mi-barrio-backend` usa `pg`; `mi-barrio-api` **no** tiene dependencia de base de datos.
- `DATABASE_URL` es obligatoria en el backend; el pool se crea en `src/main.ts`.
- Migraciones `001` a `009` presentes. El migrador crea `schema_migrations`, ejecuta cada archivo en transacción y es idempotente.
- El ETL es transaccional y valida hashes de los snapshots antes de confirmar.
- La migración `001_create_barrio.sql` usa `GEOMETRY(..., 4326)` y no crea la extensión PostGIS, coherente con lo documentado en `manual-operacion.md`.
- El contrato interno declara como servidor de red privada `http://mi-barrio-backend:3001`.

No se encontró configuración de una instancia de base de datos gestionada ni credenciales de producción.

---

## 5. Pruebas y verificaciones relacionadas con despliegue

### 5.1 Health checks implementados

| Servicio | Ruta | Protección | Respuesta |
|---|---|---|---|
| API | `/api/v1/health` | Pública | `{"status":"ok","service":"mi-barrio-api"}` |
| Backend | `/internal/v1/health` | `X-Service-Token` | `{"status":"ok","service":"mi-barrio-backend"}` |

Evidencia local: `mi-barrio-backend/tests/integration/health.test.ts` cubre token ausente, token incorrecto y token válido. El workflow E2E comprueba además que la petición sin token falla.

### 5.2 Contratos verificados en esta auditoría

Hashes SHA-256 calculados localmente y comparados con los archivos `.sha256` versionados:

| Artefacto | Hash calculado | Hash registrado | Resultado |
|---|---|---|---|
| `mi-barrio-backend/contracts/internal.openapi.yaml` | `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` | `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` | Coincide |
| `mi-barrio-api/contracts/internal.openapi.yaml` | `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` | `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` | Coincide |
| `mi-barrio-api/contracts/public.openapi.yaml` | `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` | `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` | Coincide |
| `mi-barrio-frontend/contracts/public.openapi.yaml` | `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` | `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` | Coincide |

### 5.3 Ejecución remota documentada

`docs/evidencias/fase-14-7/ejecucion-e2e-remota.md` registra el run `44979541605` del workflow `E2E` con estado `success`, 36 pruebas Playwright en 15 archivos, artefacto `playwright-report` y SHAs iguales a los HEAD locales verificados arriba.

**Interpretación correcta:** es una **regresión remota** sobre servicios efímeros del runner. **No es un despliegue**, no ejecuta individualmente los 46 criterios y no cierra la aceptación académica. Esta auditoría **no reejecutó** ese run ni las suites locales.

---

## 6. Revisión de la documentación existente

### 6.1 Terminado o verificado

- Código de los tres repositorios, contratos sincronizados y hashes coincidentes.
- Workflows de CI presentes en los tres repositorios y workflow E2E con SHAs fijados.
- Health checks y pruebas asociadas en código.
- Migraciones, ETL, verificación de datos y artefactos generables con comandos reales.
- Manuales `manual-usuario.md`, `manual-tecnico.md`, `manual-instalacion.md`, `manual-operacion.md`, `manual-pruebas.md` y `manual-despliegue.md`.
- Documentación de arquitectura y plan de desarrollo con estado vigente al 2026-11-22.
- Registro histórico de publicación de repositorios y ejecución E2E remota.
- Estado Git limpio de los tres repositorios al momento de esta auditoría.

### 6.2 Parcialmente preparado

- `docs/despliegue/README.md` existe como índice del Bloque C y define la convención de estados. Enlaza cinco documentos además de sí mismo: `auditoria-estado-despliegue.md`, `arquitectura-propuesta.md`, `comparacion-alternativas.md`, `plan-por-etapas.md` y `respaldo-observabilidad.md`. **Registro histórico (auditoría original):** en ese momento faltaban cuatro documentos de planificación (`arquitectura-propuesta.md`, `comparacion-alternativas.md`, `plan-por-etapas.md` y `respaldo-observabilidad.md`) y solo estaba disponible `auditoria-estado-despliegue.md`. **Estado vigente a 22 de noviembre de 2026:** los seis documentos de `docs/despliegue/` existen actualmente.
- Las plantillas `.env.example` incluyen notas de despliegue en red privada y producción, pero no hay una configuración de producción aplicada.
- La **arquitectura de solución** (`docs/arquitectura/arquitectura-solucion.md`) fue implementada y validada técnicamente en Fases 1–14.7, y `docs/manuales/manual-despliegue.md` documenta esa topología junto con los procedimientos previstos. La **infraestructura de despliegue** descrita sigue siendo una **propuesta pendiente de decisión y ejecución**: no existe todavía un despliegue de producción.
- CORS, rate limit y health checks están implementados, pero sin origen de producción ni verificación en un entorno público.
- El portal `mi-barrio-entrega` está publicado según `entrega/estado-publicacion.md` §9; enlace único: <https://chellunette-cloud.github.io/mi-barrio-entrega/>.

### 6.3 Pendiente

- Despliegue real: frontend estático, API como frontera pública, backend en red privada y base PostgreSQL/PostGIS gestionada.
- Dominio, DNS, certificados TLS, staging HTTPS y selección de proveedor.
- Dockerfile/compose o manifiestos de infraestructura y job de publicación.
- Definición del `FRONTEND_ORIGIN` de producción y gestión centralizada de secretos.
- Procedimiento de respaldo y restauración; no existe en los repositorios.
- Agregación, rotación y retención de logs; supervisión y alertas.
- (Ejecutado) Publicación del portal de entrega y enlace único.
- Cierre de PT-01, PT-02, auditoría formal de accesibilidad y aceptación académica (estado documental, no verificado en esta auditoría).
- Nada documental dentro de Bloque C: los seis documentos del índice están disponibles. Siguen pendientes las acciones de despliegue y verificación real descritas arriba.

---

## 7. Clasificación solicitada

| Categoría | Contenido |
|---|---|
| **Hechos comprobados** | HEADs, ramas, limpieza Git, remotos configurados, ausencia de Dockerfile/compose/manifiestos, estructura de workflows, implementación de CORS/token/health checks/rate limit, dependencias de base de datos y coincidencia de hashes de contratos. |
| **Evidencias disponibles** | Código fuente y contratos versionados, workflows, pruebas locales, `.env.example`, manuales, `estado-publicacion.md`, matriz `46/46` y registro del run E2E `44979541605`. |
| **Aspectos no verificados** | HEAD remoto en GitHub (sin `fetch`), secretos actuales en GitHub Actions, valores reales de `.env`, dominios/DNS/TLS, proveedores, servicios en Internet, respaldos, monitorización, resultados de ejecuciones en esta sesión y estado de aceptación académica. |
| **Tareas pendientes** | Las listadas en §6.3, en especial PT-01, PT-02, auditoría WCAG formal y aceptación académica. El despliegue real y la publicación del portal ya están ejecutados. La documentación de Bloque C está completa; no queda ningún documento planificado ausente. |

---

## 8. Límites y registro de esta auditoría

- No se accedió a GitHub en línea, a proveedores de hosting, a DNS ni a ningún entorno desplegado.
- No se ejecutaron pruebas, builds, migraciones ni ETL en esta auditoría; las ejecuciones citadas son evidencia documental preexistente.
- No se modificaron código, configuraciones, workflows, contratos, secretos ni variables de entorno.
- No se crearon commits, tags, ramas ni pushes.
- **Registro histórico de la auditoría original:** en ese momento este era el único archivo creado y no se crearon, modificaron ni eliminaron otros archivos.
- **Estado vigente a 22 de noviembre de 2026:** los cinco documentos restantes de `docs/despliegue/` ya están disponibles y esta auditoría se ha actualizado solo para reflejar ese hecho. La planificación sigue a la espera de decisión, autorización y ejecución real.
