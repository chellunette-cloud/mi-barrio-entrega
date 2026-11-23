# Evidencia Fase 15.2 — Despliegue gratuito en Render y validación real
## 1. Identificación

- Fecha local: 2026-11-22T23:52 a 2026-11-23T00:10 (GMT-5).
- Workspace/projecto de Render: `My Workspace` / `My project` (Production).
- Plan: Hobby, **sin tarjeta**. Facturación al cierre: `Services $0.00`, `Datastores $0.00`, `Total month to date $0.00`, `TOTAL BALANCE $0.00`, `No past invoices`. Uso: 4/25 servicios, 0,45/750 horas Free.
- No se crearon planes pagos, tarjetas, discos, dominios, credenciales adicionales ni suscripciones. Costo total: **USD 0**.
## 2. Versiones publicadas y verificadas

| Repositorio | Rama desplegada | SHA verificado | Remoto |
| --- | --- | --- | --- |
| `mi-barrio-frontend` | `main` | `11aa254ef826ca20367deb4a689123e4ed8a90b8` | `origin/main` coincide |
| `mi-barrio-api` | `fase-15/p0-trust-proxy` | `39684bce72bda72b3d23ba1d3db0724877a97b88` | `origin/fase-15/p0-trust-proxy` coincide |
| `mi-barrio-backend` | `main` | `a6c912542873665659fff4a38c1efdd5f13483be` | `origin/main` coincide |

`b9080ea2c35c19fb4be9624b86115ce5a3d0ecab` se conserva como antecesor del commit de la API; `main` de la API permanece en `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd`. No se hicieron force pushes ni nuevos commits en esta fase.

Hashes de contratos sin cambios: interno `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2`, público `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e`.
## 3. Servicios creados

| Servicio | ID | URL real | Plan / región | Estado | Deploy final |
| --- | --- | --- | --- | --- | --- |
| `mi-barrio-db` | `dpg-dc1sb5jl550s73fdl5s0-a` | interna | Free PostgreSQL 16 / Oregon | Available; expira 2026-12-22 | — |
| `mi-barrio-backend` | `srv-dc1sdnd6e07s73e8ojk0` | `https://mi-barrio-backend-6jp2.onrender.com` | Free Web Service / Oregon | Deploy succeeded | `dep-dc1sj8afngtc738i3r3g` |
| `mi-barrio-api` | `srv-dc1sgalg1s2s73e92jd0` | `https://mi-barrio-api-8bn3.onrender.com` | Free Web Service / Oregon | Deploy succeeded | `dep-dc1sgatg1s2s73e92k2g` |
| `mi-barrio-frontend` | `srv-dc1sg33l550s73fe5jn0` | `https://mi-barrio-frontend.onrender.com` | Free Static Site / global | Deploy succeeded | `dep-dc1sg3bl550s73fe5k6g` |

No quedaron servicios duplicados ni los sandboxes eliminados en Fase 15.1.4.
## 4. Configuración aplicada (sin secretos)

- Backend: `DATABASE_URL`, `SERVICE_TOKEN`, `JWT_SECRET`, `JWT_REFRESH_SECRET`, `ADMIN_USERNAME`, `ADMIN_PASSWORD`, `NODE_ENV=production`, `HOST=0.0.0.0`, `PORT=10000`.
- Backend build: `npm ci --include=dev && npm run build && npm run migrate && npm run etl`; start: `npm start`.
- API: `NODE_ENV=production`, `HOST=0.0.0.0`, `PORT=10000`, `SERVICE_TOKEN`, `FRONTEND_ORIGIN=https://mi-barrio-frontend.onrender.com`, `BACKEND_URL=https://mi-barrio-backend-6jp2.onrender.com`, `RATE_LIMIT_MAX=120`.
- API build: `npm ci --include=dev && npm run build`; start: `npm start`.
- Frontend build: `npm ci --include=dev && npm run build`; publish: `dist`.
- Rewrite del Static Site: `/api/*` → `https://mi-barrio-api-8bn3.onrender.com/api/*`, Action `Rewrite (200)`, verificado tras recargar la configuración.
- Los secretos se generaron y manipularon dentro de la sesión del navegador; **ningún valor se imprimió en archivos, logs ni Git**. La URL de BD se corrigió en Render usando el cuadro Connect sin guardarla localmente.
## 5. Migraciones y ETL

`Pre-Deploy Command` está bloqueado en Free (“Gated feature”), por lo que migración y ETL se incluyeron en el Build Command del backend, con scripts idempotentes.

- El primer intento falló por `DATABASE_URL` con valor enmascarado copiado desde la UI; se corrigió el valor real en Render.
- El segundo intento falló con `type "geometry" does not exist`; se creó `CREATE EXTENSION IF NOT EXISTS postgis;` en la BD desplegada (PostGIS 3.6.2) sin tocar código.
- Deploy final: 9 migraciones ejecutadas (`001`…`009`), seguidas de:
  - `barrio OK: URBANIZACION CIUDAD GRANADA · 58 vértices · centroide 4.641833130667935, -74.17175846032757`
  - `estrato OK: 34 manzanas, todas estrato 2, todas dentro del polígono`
  - `lugares OK: 376 registros`
  - `vias OK: 463 tramos`
  - `ETL Fase 1, 2 y 3 completado en una transacción.`
## 6. Verificación HTTP y de interfaz

Solicitudes reales a `https://mi-barrio-frontend.onrender.com` (rewrite incluido), todas `200`:

| Ruta | Resultado |
| --- | --- |
| `/api/v1/health` | `{"status":"ok","service":"mi-barrio-api"}` |
| `/api/v1/barrio` | objeto con slug, nombre, localidad, UPZ y área |
| `/api/v1/barrio/geometria` | polígono y centroide reales |
| `/api/v1/categorias` | 5 categorías |
| `/api/v1/lugares` | 376 registros |
| `/api/v1/vias` | 463 tramos |
| `/api/v1/estadisticas/demografia` | objetos `barrio` y `upz` separados |
| `/api/v1/estadisticas/seguridad` | cuadrante, indicadores y capas por localidad |

El frontend cargó la ficha oficial, el mapa Leaflet con el polígono y las vías (842 elementos `path` en el DOM), las fuentes F-01/F-02 y el catálogo alimentado por la API. No se encontraron errores de consola que bloqueen la carga inicial.

Protección de servicios: `/internal/v1/health` del backend devolvió **401 sin token** y **200 con `X-Service-Token`**; `/internal/v1/diagnostico-ip` de la API devolvió **401 sin token** y **200 con token**.
## 7. P0-01 — NO APROBADO

Se usó `/internal/v1/diagnostico-ip` con token de servicio (nunca impreso). Con `X-Forwarded-For: 198.51.100.10`, la API respondió `trustProxy=1` y `req.ip` values `10.196.83.180`, `10.192.19.152`, `10.192.19.152`, `10.196.83.180`, `10.195.14.108` en cinco solicitudes secuenciales. Con `X-Forwarded-For: 203.0.113.20`, `req.ip` fue `10.195.14.108`.

Por tanto, la IP del cliente sintético no gobierna la clave del limitador: la misma IP produjo varios `req.ip` de la capa de proxy y la profundidad de confianza actual (`1`) no alcanza para aislar al cliente detrás de la cadena de Render/edge. El contador de tasa queda fragmentado entre hops internos. **P0-01 permanece NO APROBADO**, igual que en Fase 15.1.4; el endpoint de diagnóstico convierte la inferencia en evidencia directa. No se cambió `trust proxy` ni se suplantaron IPs personales.
## 8. P0-02 — validación contra la BD desplegada

Consultas directas sobre `mi-barrio-db` (credenciales usadas solo en la sesión local, sin persistirlas):

| Comprobación | Resultado |
| --- | --- |
| PostGIS instalado | 3.6.2 |
| Barrio | `URBANIZACION CIUDAD GRANADA`, 9,10 ha, 94.551,13 m², 705 lotes, 3.807 habitantes, estrato 2, 58 vértices |
| Centroide WGS84 | 4,641833130667935, -74,17175846032757 |
| Manzanas | 34, todas estrato 2; 34/34 dentro del polígono (`ST_Within`) |
| Categorías | 5 |
| Lugares | 376, todos publicados; 3 marcados `dentro_barrio` |
| Vías | 463; 30 marcadas `dentro_barrio` |
| Fuentes | 7 |

Los mismos totales aparecen en la API desplegada y en el ETL. **P0-02 queda APROBADO para la integridad y carga de datos verificada**, sin extenderlo a cobertura exhaustiva de comercio ni a precisión de fuentes, que siguen siendo limitaciones declaradas.
## 9. Limitaciones y pendientes

- Free Web Services no aceptan tráfico por red privada: el backend es alcanzable públicamente, aunque protegido por `X-Service-Token`. Esto difiere de D-5 (“backend no público”) y debe registrarse como desviación del entorno Free.
- Las instancias Free se apagan por inactividad; la primera petición puede tardar ~50 s o más.
- Free Postgres: 1 GB, expira el 2026-12-22, sin backups ni pooling. No se validó respaldo/restauración.
- PostGIS desplegado es 3.6.2 (la documentación local registra 3.7.0); el proyecto usa funciones estándar y el ETL pasó correctamente.
- El portal `mi-barrio-entrega` se publicó el 2026-11-23 en <https://chellunette-cloud.github.io/mi-barrio-entrega/>; la aplicación está en <https://mi-barrio-frontend.onrender.com>. No se declara aceptación académica.
- PT-01, PT-02, auditoría formal de accesibilidad, respaldos/restauración y corrección de P0-01 siguen pendientes.

No se modificaron contratos, datos geográficos ni funcionalidades verificadas. Solo cambió la configuración de despliegue en Render y se añadió esta evidencia documental.
