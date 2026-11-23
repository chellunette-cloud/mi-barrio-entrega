# Manual de instalación y configuración local — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**

Este manual permite preparar el sistema en un entorno local a partir de los tres repositorios independientes. Los comandos se tomaron de los `package.json` y `README.md` reales de cada repositorio. No incluye credenciales reales ni describe un despliegue.

---

## 1. Requisitos previos

| Requisito | Versión / observación |
|---|---|
| Node.js | `>=22` en los tres repositorios; los workflows usan Node 24. |
| npm | Incluido con Node; se usa `npm ci` para instalación reproducible. |
| Git | Para clonar los tres repositorios. |
| PostgreSQL | 16. |
| PostGIS | 3.7.0; la extensión debe existir en la base antes de migrar. |
| Chrome | Requerido por Playwright para las pruebas E2E. |
| Shell | Los comandos usan sintaxis POSIX (`cp`); en Windows puede usar Git Bash o WSL. |

Puertos locales de referencia:

| Servicio | Puerto |
|---|---:|
| Frontend (Vite) | 5173 |
| API pública | 3000 |
| Backend privado | 3001 |
| PostgreSQL local documentado | 55432 |

En Windows, la guía de diagnóstico de PostGIS está en [`arquitectura/entorno-postgis-windows.md`](../arquitectura/entorno-postgis-windows.md).

---

## 2. Clonado de los repositorios

Los tres repositorios son independientes y deben quedar como carpetas hermanas, porque los scripts de verificación de contratos usan rutas relativas `../mi-barrio-api/...` y `../mi-barrio-backend/...`.

```bash
git clone https://github.com/chellunette-cloud/mi-barrio-backend.git
git clone https://github.com/chellunette-cloud/mi-barrio-api.git
git clone https://github.com/chellunette-cloud/mi-barrio-frontend.git
```

Estructura resultante:

```text
miBarrio/
├── mi-barrio-backend/
├── mi-barrio-api/
├── mi-barrio-frontend/
├── docs/
└── mi-barrio-entrega/
```

---

## 3. Variables de entorno

Cada repositorio incluye un `.env.example`. Copie la plantilla y complete los valores en `.env`; ese archivo está ignorado por Git.

```bash
cp .env.example .env
```

### 3.1 Backend (`mi-barrio-backend`)

| Variable | Estado | Descripción |
|---|---|---|
| `PORT` | Opcional, default `3001` | Puerto HTTP del backend. |
| `HOST` | Opcional, default `0.0.0.0` | Interfaz de escucha. |
| `DATABASE_URL` | Obligatoria | Cadena de conexión PostgreSQL. La plantilla usa `postgresql://postgres@127.0.0.1:55432/mi_barrio`. |
| `SERVICE_TOKEN` | Obligatoria, mínimo 16 caracteres | Token compartido con la API, enviado como `X-Service-Token`. |
| `JWT_SECRET` | Obligatoria, mínimo 16 caracteres | Firma de access tokens (15 min). |
| `JWT_REFRESH_SECRET` | Obligatoria, mínimo 16 caracteres | Firma de refresh tokens (7 días). |
| `ADMIN_USERNAME` | Opcional | Crea el administrador local al arrancar. |
| `ADMIN_PASSWORD` | Opcional, mínimo 8 caracteres si se define | Se almacena con hash Argon2. |
| `NODE_ENV` | Opcional, `development`/`test`/`production` | Declarada en la configuración; no aparece en `.env.example`. |

### 3.2 API (`mi-barrio-api`)

| Variable | Estado | Descripción |
|---|---|---|
| `PORT` | Opcional, default `3000` | Puerto HTTP de la API. |
| `HOST` | Opcional, default `127.0.0.1` | Interfaz de escucha; en contenedores usar `0.0.0.0`. |
| `BACKEND_URL` | Opcional, default `http://127.0.0.1:3001` | URL del backend privado. En red de contenedores: `http://mi-barrio-backend:3001`. |
| `SERVICE_TOKEN` | Obligatoria, mínimo 16 caracteres | Debe coincidir con el del backend. |
| `FRONTEND_ORIGIN` | Opcional, default `http://127.0.0.1:5173` | Origen único permitido por CORS. |
| `RATE_LIMIT_MAX` | Opcional, default `120` | Solicitudes por minuto por IP; en producción no puede superar 120. |
| `NODE_ENV` | Opcional | Afecta la validación de `RATE_LIMIT_MAX`. |
| `INTERNAL_CONTRACT_PATH` | Opcional, solo scripts | Ruta de origen para `contracts:sync`; por defecto `../mi-barrio-backend/contracts/internal.openapi.yaml`. |

### 3.3 Frontend (`mi-barrio-frontend`)

| Variable | Estado | Descripción |
|---|---|---|
| `VITE_API_BASE_URL` | Opcional, default cadena vacía | Prefijo de las rutas públicas. En local se usa el proxy `/api`; la plantilla muestra como ejemplo no secreto `https://api.mi-barrio.example`. |
| `E2E_ADMIN_USERNAME` | Requerida para E2E | Usuario administrativo de las pruebas; no hay valor por defecto en el repositorio. |
| `E2E_ADMIN_PASSWORD` | Requerida para E2E | Contraseña administrativa de las pruebas; no hay valor por defecto en el repositorio. |
| `E2E_TRACE` | Opcional | Si es `off`, desactiva el trace de Playwright. |
| `PUBLIC_CONTRACT_PATH` | Opcional, solo scripts | Origen para sincronizar el contrato; por defecto `../mi-barrio-api/contracts/public.openapi.yaml`. |

No copie valores reales de `.env` en documentos, tickets ni repositorios. Los ejemplos `.example` son marcadores, no despliegues existentes.

---

## 4. Preparación de la base de datos

1. Instale PostgreSQL 16 y PostGIS 3.7.0.
2. Cree una base vacía denominada `mi_barrio` o ajuste `DATABASE_URL`.
3. Confirme que la extensión PostGIS ya existe en esa base. Las migraciones del repositorio **no** ejecutan `CREATE EXTENSION`.
4. Complete `DATABASE_URL` en `mi-barrio-backend/.env`.

La carga de datos usa los 10 snapshots verificados de `mi-barrio-backend/data/source/manifest.json`. No edite los snapshots: el ETL valida sus hashes antes de cargarlos.

---

## 5. Migraciones y carga de datos

Desde `mi-barrio-backend`, después de configurar `.env`:

```bash
npm ci
npm run verify:data
npm run migrate
npm run etl
```

`npm run migrate` aplica las migraciones `001` a `009` de forma idempotente. `npm run etl` carga barrio, estrato, lugares y vías en una sola transacción. Si el usuario administrativo debe existir, defina `ADMIN_USERNAME` y `ADMIN_PASSWORD` antes de iniciar el backend.

---

## 6. Ejecución de los componentes

El orden de arranque es backend → API → frontend.

### 6.1 Backend

```bash
cd mi-barrio-backend
npm ci
cp .env.example .env
# edite .env
npm run verify:data
npm run migrate
npm run etl
npm run dev
```

Para ejecutar el artefacto compilado:

```bash
npm run build
npm run start
```

### 6.2 API pública

En otra terminal, desde la carpeta hermana:

```bash
cd ../mi-barrio-api
npm ci
cp .env.example .env
# edite .env con BACKEND_URL, SERVICE_TOKEN y FRONTEND_ORIGIN
npm run contracts:verify
npm run dev
```

Para ejecutar el artefacto compilado:

```bash
npm run build
npm run start
```

### 6.3 Frontend

En otra terminal:

```bash
cd ../mi-barrio-frontend
npm ci
cp .env.example .env
# edite .env si la API no está en el proxy local
npm run dev
```

Para servir el build local:

```bash
npm run build
npm run preview
```

---

## 7. Verificación de funcionamiento

### 7.1 Contratos

```bash
cd ../mi-barrio-api && npm run contracts:verify
cd ../mi-barrio-frontend && npm run contracts:verify
```

La salida esperada incluye `OK contrato interno <sha256>` y `OK contrato público <sha256>`. Los hashes vigentes son:

- interno: `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2`
- público: `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e`

### 7.2 Health checks

```bash
curl -fsS --max-time 3 -H "X-Service-Token: $SERVICE_TOKEN" http://127.0.0.1:3001/internal/v1/health
curl -fsS --max-time 3 http://127.0.0.1:3000/api/v1/health
```

Respuestas esperadas:

```json
{"status":"ok","service":"mi-barrio-backend"}
{"status":"ok","service":"mi-barrio-api"}
```

La misma petición al backend **sin** `X-Service-Token` debe fallar con `401`.

### 7.3 Interfaz

Abra `http://127.0.0.1:5173`. Debe aparecer la ficha del barrio, el mapa con el polígono oficial, lugares, vías y estadísticas. Si alguna sección muestra “No pudimos cargar esta sección”, use “Reintentar” y compruebe que API y backend siguen activos.

### 7.4 Pruebas rápidas

```bash
cd ../mi-barrio-backend && npm run ci
cd ../mi-barrio-api && npm run ci
cd ../mi-barrio-frontend && npm run ci
```

La suite E2E requiere además backend, API y frontend en ejecución:

```bash
cd ../mi-barrio-frontend
npm run test:acceptance
```

Detalle completo en la [guía de pruebas](manual-pruebas.md).

---

## 8. Solución de problemas frecuentes

| Síntoma | Causa probable | Acción |
|---|---|---|
| `contracts:verify` falla | El repositorio vecino no está en la ruta esperada o el contrato cambió | Verifique la estructura de carpetas y ejecute `npm run contracts:sync` en el consumidor correspondiente. |
| El backend no conecta | `DATABASE_URL` incorrecta o PostgreSQL/PostGIS ausente | Revise la cadena y la extensión PostGIS. |
| El API responde 502 | Backend caído, token distinto o contrato interno inválido | Repita el health check interno y verifique `SERVICE_TOKEN` y `npm run contracts:verify`. |
| El frontend no carga datos | `VITE_API_BASE_URL` mal definido o proxy inactivo | En local deje la variable vacía y confirme que la API escucha en 3000. |
| E2E sin credenciales | Faltan `E2E_ADMIN_USERNAME` o `E2E_ADMIN_PASSWORD` | Defínalas en el entorno de ejecución; no hay valores por defecto. |

---

## 9. Referencias

- [Manual técnico](manual-tecnico.md)
- [Manual de operación y mantenimiento](manual-operacion.md)
- [Guía de pruebas y verificación](manual-pruebas.md)
- [Guía de despliegue y publicación](manual-despliegue.md)
- [Fuentes territoriales](../investigacion/fuentes-territoriales.md)
