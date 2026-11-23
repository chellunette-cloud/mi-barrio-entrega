# Manual técnico del sistema — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**

Este manual describe la arquitectura implementada, las responsabilidades de cada repositorio y los mecanismos de comunicación, contratos, autenticación y persistencia. Complementa el diseño descrito en [`arquitectura/arquitectura-solucion.md`](../arquitectura/arquitectura-solucion.md).

---

## 1. Arquitectura de tres capas

El sistema separa la interfaz pública de la lógica de negocio y de los datos. La API pública es la única frontera HTTP expuesta al frontend; el backend permanece privado.

```text
Navegador
    │  HTTP/JSON  /api/v1/**
    ▼
mi-barrio-frontend  (Vite + React + TypeScript + Leaflet)
    │  proxy local /api → 127.0.0.1:3000
    ▼
mi-barrio-api       (Express + TypeScript)
    │  HTTP/JSON  /internal/v1/**  +  X-Service-Token
    ▼
mi-barrio-backend   (Express + TypeScript)
    │  SQL / PostGIS
    ▼
PostgreSQL 16 + PostGIS 3.7.0
```

En desarrollo local los tres procesos se ejecutan por separado. En un despliegue propuesto, el frontend se sirve como contenido estático, la API queda expuesta públicamente y el backend junto con la base de datos permanecen en una red privada. El [manual de despliegue](manual-despliegue.md) describe esa propuesta; **el sistema no está desplegado**.

---

## 2. Responsabilidades por componente

| Componente | Responsabilidad | No hace |
|---|---|---|
| `mi-barrio-frontend` | Presentar ficha, mapa, lugares, vías, estadísticas y panel administrativo. Consume solo la API pública. | Acceder a PostgreSQL ni al backend directamente. |
| `mi-barrio-api` | Exponer la API pública, aplicar CORS, caché, límite de solicitudes, manejo de errores y reenviar peticiones al backend. | Acceder directamente a la base de datos. |
| `mi-barrio-backend` | Dominio, casos de uso, repositorios PostgreSQL/PostGIS, ETL, autenticación administrativa y contrato interno. | Exponer endpoints públicos ni CORS. |
| PostgreSQL/PostGIS | Persistir geometrías, catálogos, lugares, vías, usuarios administrativos y auditoría. | Servir directamente al frontend. |

---

## 3. Comunicación HTTP

### 3.1 Frontera pública

El frontend consume rutas bajo `/api/v1`. En desarrollo, `vite.config.ts` define el proxy `/api` hacia `http://127.0.0.1:3000`. Para un despliegue con dominios separados se define `VITE_API_BASE_URL`; el valor por defecto es cadena vacía.

Rutas públicas implementadas:

- `GET /api/v1/health`
- `GET /api/v1/barrio`
- `GET /api/v1/barrio/geometria`
- `GET /api/v1/categorias`
- `GET /api/v1/lugares?categoria=&q=&tipo=&limite=`
- `GET /api/v1/lugares/{id}`
- `GET /api/v1/vias?highway=`
- `GET /api/v1/estadisticas/demografia`
- `GET /api/v1/estadisticas/seguridad`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- rutas `/api/v1/admin/**` protegidas con JWT.

Las respuestas de datos públicos incluyen `Cache-Control: public, max-age=300, stale-while-revalidate=60`. Health, autenticación y administración no usan esa caché.

### 3.2 Frontera privada

La API llama al backend mediante `BACKEND_URL`, con cabeceras `Accept: application/json`, `Content-Type: application/json` y `X-Service-Token`. El timeout real es de 5 segundos mediante `AbortSignal.timeout(5000)`.

Rutas internas relevantes:

- `GET /internal/v1/health`
- `GET /internal/v1/barrio`, `/internal/v1/barrio/geometria`
- `GET /internal/v1/categorias`, `/internal/v1/lugares`, `/internal/v1/lugares/{id}`
- `GET /internal/v1/vias`
- `GET /internal/v1/estadisticas/demografia`, `/internal/v1/estadisticas/seguridad`
- `POST /internal/v1/auth/login`, `/internal/v1/auth/refresh`
- `/internal/v1/admin/**`.

### 3.3 Formato de error y trazabilidad

Todas las respuestas de error usan:

```json
{
  "error": {
    "code": "...",
    "message": "...",
    "requestId": "..."
  }
}
```

El `requestId` se toma de `X-Request-Id` cuando llega en la petición o se genera con `randomUUID()`, y se devuelve en la cabecera `X-Request-Id`. Códigos habituales: `NO_AUTORIZADO`, `ID_INVALIDO`, `FILTRO_INVALIDO`, `DATOS_INVALIDOS`, `NO_ENCONTRADO`, `RUTA_NO_ENCONTRADA`, `DEMASIADAS_SOLICITUDES`, `TIEMPO_AGOTADO`, `DEPENDENCIA_NO_DISPONIBLE`, `CONTRATO_INTERNO_INVALIDO` y `ERROR_INTERNO`.

---

## 4. Tecnologías y dependencias principales

| Ámbito | Tecnologías verificadas |
|---|---|
| Común | Node.js `>=22` en los tres repositorios; CI de GitHub Actions usa Node 24; TypeScript y npm. |
| Frontend | Vite, React, Leaflet, Vitest, Playwright, ESLint, `openapi-typescript`. |
| API | Express, Zod, Ajv, Helmet, `cors`, Vitest, ESLint, `tsx`. |
| Backend | Express, Zod, Ajv, Helmet, Argon2, JWT, Vitest, ESLint, `tsx`, PostgreSQL/PostGIS. |
| Datos | PostgreSQL 16 y PostGIS 3.7.0; snapshots verificados por SHA-256. |
| Contratos | OpenAPI 3.0.3, copias con fichero `.sha256`, verificación mediante scripts Node. |

Los repositorios no incluyen Dockerfile, compose ni manifiestos de despliegue. La calidad local se controla con `npm run lint`, `npm run typecheck`, `npm run check:lines`, `npm run contracts:verify` y `npm run ci`.

---

## 5. Contratos y validación

Existe un contrato público y otro interno:

| Contrato | Archivo canónico | Consumidor | Hash vigente |
|---|---|---|---|
| Público | `mi-barrio-api/contracts/public.openapi.yaml` | Frontend | `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` |
| Interno | `mi-barrio-backend/contracts/internal.openapi.yaml` | API | `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` |

Reglas:

- los contratos se sincronizan, no se editan a mano en el consumidor;
- la API verifica el contrato interno con `npm run contracts:verify` en `mi-barrio-api`;
- el frontend verifica el contrato público con `npm run contracts:verify` en `mi-barrio-frontend`;
- la ruta de origen por defecto es `../mi-barrio-backend/contracts/internal.openapi.yaml` para la API y `../mi-barrio-api/contracts/public.openapi.yaml` para el frontend, por lo que los tres repositorios deben estar como hermanos;
- en tiempo de ejecución, la API valida las respuestas del backend con Ajv; si falla, responde `502 CONTRATO_INTERNO_INVALIDO`;
- el backend no tiene un script `contracts:verify`; su equivalente local es `npm run test:contract`.

Los hashes históricos se conservan en el [manual de instalación](manual-instalacion.md) y en los índices de entrega; no deben presentarse como vigentes.

---

## 6. Autenticación, autorización y errores

Existen dos mecanismos independientes:

1. **Token de servicio** `SERVICE_TOKEN`: compartido entre API y backend, enviado como `X-Service-Token`. El backend lo compara con `timingSafeEqual` y responde `401 NO_AUTORIZADO` si falta o no coincide.
2. **Sesión administrativa JWT**: el backend valida credenciales con hash Argon2 y emite access token de 15 minutos y refresh token de 7 días. La API reenvía el `Authorization: Bearer <token>` al backend; no verifica el JWT localmente.

Protecciones adicionales:

- CORS en la API acepta un único origen configurado en `FRONTEND_ORIGIN`, con métodos `GET`, `POST`, `PUT`, `DELETE`, cabeceras `Content-Type` y `Authorization`, y `maxAge: 86400`;
- Helmet y desactivación de `x-powered-by` en API y backend;
- cuerpo JSON limitado a 8 kb;
- límite global de 120 solicitudes por minuto por IP; en `production` no puede superar ese valor;
- el backend no expone CORS público y debe permanecer sin puerto público en despliegue.

---

## 7. Base de datos PostgreSQL/PostGIS

El backend es el único componente que accede a la base de datos. Las migraciones están en `mi-barrio-backend/migrations/` y van de `001` a `009`:

- geometrías `GEOMETRY(Point/Polygon, 4326)` y validación de SRID;
- estratos por manzana;
- catálogo de fuentes y relaciones por campo;
- índices GiST espaciales;
- categorías, lugares y vías con sus fuentes;
- usuarios administrativos y auditoría;
- columna `lugar.codigo` para identificadores externos como SITP.

El migrador crea `schema_migrations`, ejecuta cada archivo en una transacción, registra la versión y permite repetir la ejecución sin aplicar dos veces una misma migración.

La carga de datos se realiza con `npm run etl`, en una sola transacción: barrio → estrato → lugares → vías. Antes de usar cada snapshot se verifica su SHA-256 contra `data/source/manifest.json`. El ETL valida un único polígono de 58 vértices, SRID 4326, centroide cercano a `4.641833, -74.171758` y 34 manzanas de estrato 2 contenidas en el polígono.

Las migraciones **no crean** la extensión PostGIS: esta debe existir previamente en la base. Para diagnóstico en Windows consulte [`arquitectura/entorno-postgis-windows.md`](../arquitectura/entorno-postgis-windows.md).

---

## 8. Estructura de los repositorios

```text
mi-barrio-frontend/
├── .github/workflows/     ci.yml, e2e.yml
├── contracts/             public.openapi.yaml, public.openapi.sha256
├── scripts/               check-line-limit.mjs, sync-public-contract.mjs
├── src/
│   ├── app/, pages/, features/, shared/, styles/
│   └── main.tsx
├── tests/                 unit/, integration/, acceptance/, fixtures
├── playwright.config.ts, vitest.config.ts, vite.config.ts
└── package.json, .env.example, README.md

mi-barrio-api/
├── .github/workflows/ci.yml
├── contracts/             public.openapi.yaml, internal.openapi.yaml, internal.openapi.sha256
├── scripts/               sync-internal-contract.mjs, check-line-limit.mjs
├── src/
│   ├── config/, application/, clients/backend/, contracts/
│   └── http/              app.ts, controllers/, middleware/, routes/v1/
├── tests/                 unit/, integration/, contract/
└── package.json, .env.example, README.md

mi-barrio-backend/
├── .github/workflows/ci.yml
├── contracts/internal.openapi.yaml
├── data/source/           10 snapshots, manifest.json, README.md
├── migrations/            001…009 *.sql
├── scripts/               verify-data-hashes.mjs, check-line-limit.mjs, extract-poblacion-upz.py
├── src/
│   ├── config/, domain/, application/
│   └── infrastructure/    auth/, db/, etl/, http/, stats/
├── tests/                 unit/, integration/, contract/, geographic/
└── package.json, .env.example, README.md
```

---

## 9. Estado vigente y límites técnicos

- La matriz canónica registra 46/46 criterios aprobados; el E2E remoto `44979541605` registró 36/36 pruebas en 15 archivos y es regresión de criterios cubiertos, no ejecución individual de los 46.
- No hay despliegue público ni staging HTTPS.
- No hay procedimientos de respaldo o restauración en los repositorios.
- PT-01, PT-02 y la auditoría formal de accesibilidad no tienen evidencia de cierre.
- Las evidencias de Fase 12.1, Fase 13 y Fase 14.7 están físicamente presentes en `docs/evidencias/` de este portal, incorporadas a Git; la opción C mantiene los repositorios de código como proyectos independientes referenciados por URL HTTPS y manifiesto de versiones.

Para ejecutar el sistema desde cero, siga el [manual de instalación y configuración local](manual-instalacion.md). Para mantenimiento, consulte el [manual de operación](manual-operacion.md) y la [guía de pruebas](manual-pruebas.md).
