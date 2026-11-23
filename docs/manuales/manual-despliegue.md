# Guía de despliegue y publicación — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**

Esta guía describe la arquitectura de despliegue **propuesta** y los pasos de verificación posteriores. Después de su redacción, el sistema **sí fue desplegado** en Render con planes Free, sin dominio propio ni red privada, y con P0-01 NO APROBADO; véase [`../despliegue/evidencia-fase-15.2-despliegue-render.md`](../despliegue/evidencia-fase-15.2-despliegue-render.md). El portal de entrega se publicó el 2026-11-23 en <https://chellunette-cloud.github.io/mi-barrio-entrega/>; véase `entrega/estado-publicacion.md` §9.

---

## 1. Estado del despliegue

| Elemento | Estado |
|---|---|
| Repositorios de código | Publicados en `main` en `https://github.com/chellunette-cloud/`. |
| Portal de entrega | Publicado en GitHub Pages; enlace único en <https://chellunette-cloud.github.io/mi-barrio-entrega/>. |
| Staging HTTPS | Pendiente. |
| Producción | No desplegada. |
| E2E remoto | Ejecutado como regresión (`44979541605`, 36/36), no como despliegue. |
| Infraestructura | Sin Dockerfile, compose ni manifiestos en los repositorios. |

---

## 2. Arquitectura propuesta

```text
                    HTTPS
Navegador ───────────────────────► Contenido estático
                                   mi-barrio-frontend (dist/)
                                          │
                                          │ HTTPS /api/v1/**
                                          ▼
                                   mi-barrio-api
                                   (frontera pública)
                                          │
                          HTTP privado /internal/v1/**
                          X-Service-Token + JWT admin
                                          ▼
                                   mi-barrio-backend
                                   (sin puerto público)
                                          │
                                          ▼
                                 PostgreSQL + PostGIS
                                 (red privada)
```

Principios:

- solo la API y el frontend se exponen al exterior;
- el backend y la base de datos permanecen en red privada;
- los secretos se suministran por variables de entorno del entorno de ejecución;
- la API es el único consumidor autorizado del contrato interno;
- el frontend consume únicamente el contrato público.

---

## 3. Requisitos de HTTPS

- Terminar TLS en el punto de entrada del frontend y de la API.
- Usar un certificado válido para el dominio aprobado; los nombres `https://mi-barrio.example` y `https://api.mi-barrio.example` que aparecen en las plantillas son **ejemplos no desplegados**.
- No exponer el backend por HTTPS público.
- Redirigir el tráfico HTTP al canal HTTPS en el frontend y la API.
- No publicar URLs que no hayan sido verificadas.

La interfaz usa teselas de OpenStreetMap; la atribución debe permanecer visible.

---

## 4. CORS

La API usa `cors` con un único origen permitido, configurado en `FRONTEND_ORIGIN`:

| Parámetro | Valor implementado |
|---|---|
| `origin` | `deps.frontendOrigin`, es decir, `FRONTEND_ORIGIN` |
| `methods` | `GET`, `POST`, `PUT`, `DELETE` |
| `allowedHeaders` | `Content-Type`, `Authorization` |
| `maxAge` | `86400` |
| Default local | `http://127.0.0.1:5173` |
| Ejemplo de plantilla | `https://mi-barrio.example` |

No hay lista de orígenes múltiples. En producción debe definirse un único origen aprobado antes de habilitar el tráfico. En desarrollo, el proxy de Vite evita el cambio de origen.

---

## 5. Variables de entorno

Las plantillas `.env.example` son la fuente de nombres y valores de ejemplo. No copie secretos reales a repositorios ni documentos.

### 5.1 Backend

| Variable | Uso |
|---|---|
| `PORT` | Puerto HTTP, default `3001`. |
| `HOST` | Interfaz de escucha, default `0.0.0.0`. |
| `DATABASE_URL` | Cadena PostgreSQL; obligatoria. |
| `SERVICE_TOKEN` | Token compartido con la API; mínimo 16 caracteres. |
| `JWT_SECRET` | Firma de access tokens; mínimo 16 caracteres. |
| `JWT_REFRESH_SECRET` | Firma de refresh tokens; mínimo 16 caracteres. |
| `ADMIN_USERNAME` | Usuario administrativo opcional creado al arrancar. |
| `ADMIN_PASSWORD` | Contraseña administrativa opcional; mínimo 8 caracteres. |
| `NODE_ENV` | `development`, `test` o `production`. |

### 5.2 API

| Variable | Uso |
|---|---|
| `PORT` | Puerto HTTP, default `3000`. |
| `HOST` | Interfaz de escucha; en contenedores, `0.0.0.0`. |
| `BACKEND_URL` | URL privada del backend. En red de contenedores, `http://mi-barrio-backend:3001`. |
| `SERVICE_TOKEN` | Debe coincidir con el del backend. |
| `FRONTEND_ORIGIN` | Origen único permitido por CORS. |
| `RATE_LIMIT_MAX` | Solicitudes por minuto por IP; máximo 120 en producción. |
| `NODE_ENV` | Ajusta validaciones de producción. |
| `INTERNAL_CONTRACT_PATH` | Solo scripts de sincronización del contrato interno. |

### 5.3 Frontend

| Variable | Uso |
|---|---|
| `VITE_API_BASE_URL` | Prefijo de la API pública. Vacío si se sirve bajo el mismo origen o mediante proxy. |
| `PUBLIC_CONTRACT_PATH` | Solo scripts de sincronización del contrato público. |
| `E2E_ADMIN_USERNAME` / `E2E_ADMIN_PASSWORD` | Solo pruebas E2E; no hay credenciales por defecto. |
| `E2E_TRACE` | `off` desactiva el trace de Playwright. |

---

## 6. Comunicación privada API–backend

La API envía `X-Service-Token` en cada petición interna. El backend compara el valor con `timingSafeEqual` y responde `401 NO_AUTORIZADO` si falta o no coincide.

En una red de contenedores, la API debe usar:

```text
BACKEND_URL=http://mi-barrio-backend:3001
```

El backend no debe publicar su puerto. Las rutas administrativas además exigen `Authorization: Bearer <token>`; el backend valida el JWT. La API no verifica el JWT localmente.

Antes de habilitar tráfico, compruebe:

```bash
curl -fsS --max-time 3 -H "X-Service-Token: $SERVICE_TOKEN" http://mi-barrio-backend:3001/internal/v1/health
```

La petición sin token debe fallar con `401`.

---

## 7. Configuración de la base de datos

- PostgreSQL 16 y PostGIS 3.7.0.
- La extensión PostGIS debe existir antes de ejecutar migraciones.
- Las migraciones están en `mi-barrio-backend/migrations/` (`001`–`009`) y son idempotentes.
- La carga de datos se ejecuta con `npm run etl` y verifica los hashes del manifiesto.
- La API no accede a la base de datos.
- No existe un procedimiento de respaldo o restauración implementado; sigue siendo pendiente.

Secuencia de preparación, ejecutada en el entorno del backend:

```bash
npm ci
npm run verify:data
npm run migrate
npm run etl
```

---

## 8. Artefactos y arranque

No hay Dockerfile ni compose en los repositorios. La preparación de artefactos se realiza con los comandos reales:

```bash
# backend
npm ci
npm run build
npm run start

# API
npm ci
npm run contracts:verify
npm run build
npm run start

# frontend
npm ci
npm run contracts:verify
npm run build
npm run preview
```

`npm run build` del frontend genera `dist/`, que es el contenido estático a publicar. `npm run preview` solo lo sirve localmente; no constituye despliegue.

---

## 9. Health checks y pruebas posteriores

Antes de aceptar un despliegue:

1. Comprobar la API pública:

   ```bash
   curl -fsS --max-time 3 https://<dominio-api>/api/v1/health
   ```

   Respuesta esperada: `{"status":"ok","service":"mi-barrio-api"}`.

2. Comprobar el backend desde la red privada con `X-Service-Token`.

   Respuesta esperada: `{"status":"ok","service":"mi-barrio-backend"}`.

3. Cargar el frontend por HTTPS y verificar ficha, mapa, lugares, vías y estadísticas.
4. Verificar que el origen del navegador coincide con `FRONTEND_ORIGIN` y que las peticiones `/api/v1/**` responden.
5. Repetir `npm run contracts:verify` en API y frontend.
6. Ejecutar las suites de la [guía de pruebas](manual-pruebas.md).
7. Si se dispone de los SHA aprobados, disparar el workflow E2E remoto con `backend_ref` y `api_ref`.
8. Registrar resultados, HEADs, hashes y cualquier incidencia con `requestId`.

Un `success` de E2E no sustituye la verificación de despliegue, no implica que los 46 criterios se ejecutaran individualmente y no cierra PT-01, PT-02 ni la auditoría formal de accesibilidad.

---

## 10. Pendientes de infraestructura

- Dominio y certificados TLS aprobados.
- Entorno de staging con HTTPS.
- Selección de proveedor y mecanismo de publicación del frontend estático.
- Ejecución de API y backend como servicios, con backend sin puerto público.
- Definición del origen CORS de producción.
- Gestión centralizada de secretos.
- Respaldo y restauración de PostgreSQL.
- Agregación, rotación y retención de logs.
- Supervisión y alertas.
- Cierre formal de PT-01 y PT-02.
- Auditoría formal de accesibilidad.
- (Ejecutado) Despliegue en Render y publicación del portal con enlace único; ya no figura como pendiente.
- Verificaciones finales y entrega académica.

Para la operación posterior consulte el [manual de operación y mantenimiento](manual-operacion.md).
