# Mi Barrio — Ciudad Granada

Portal de entrega académica del proyecto **Mi Barrio — Ciudad Granada**. Este repositorio principal reúne la documentación y referencia los tres repositorios independientes del sistema mediante enlaces HTTPS y el manifiesto de versiones, sin submódulos ni monorepo.

> **Estado vigente (2026-11-23):** despliegue gratuito en Render **ejecutado y verificado** (frontend, API, backend y PostgreSQL/PostGIS; costo USD 0). La matriz canónica registra **46/46 criterios aprobados** y el E2E remoto (`44979541605`) finalizó en `success` con **36/36 pruebas en 15 archivos**. El frontend y el backend están en `main`; la API se desplegó desde `fase-15/p0-trust-proxy`. **P0-01 permanece NO APROBADO**: la IP del cliente no gobierna el limitador de tasa en Render. No se declara aceptación académica. Evidencia: [`docs/despliegue/evidencia-fase-15.2-despliegue-render.md`](docs/despliegue/evidencia-fase-15.2-despliegue-render.md).

> **Enlaces públicos (no confundir):**
>
> - **Aplicación desplegada (Render):** <https://mi-barrio-frontend.onrender.com>
> - **Portal de documentación (GitHub Pages):** <https://chellunette-cloud.github.io/mi-barrio-entrega/>
>
> El primero abre el sistema en ejecución; el segundo abre este portal de entrega con la documentación. El portal se publica desde un repositorio público independiente; los tres repositorios de código no se modificaron.

> **Registro histórico (2026-11-16):** Fase 11.2 reportada como finalizada el **2026-11-16**. HU-07 a HU-13 en estado **Validada**; HU-01 y HU-02 en **En pruebas**; HU-03 a HU-06 en **En desarrollo**.
>
> La denominación **Validada** de HU-07 a HU-13 corresponde únicamente a ese registro histórico de Fase 11.2; **no representa aceptación académica**. El estado canónico vigente debe consultarse en la documentación de requerimientos del portal, en particular [`historias-usuario.md`](docs/requerimientos/historias-usuario.md) y la matriz de trazabilidad.

---

## 1. Objetivo

Facilitar el acceso ciudadano y académico a información territorial verificable del barrio **Ciudad Granada**, en Bogotá D.C., mediante:

- una ficha general del barrio con fuentes y fechas de consulta;
- un mapa del polígono oficial, el centroide y las vías;
- catálogos de servicios de salud, transporte y lugares de interés;
- paneles de demografía y seguridad con el nivel territorial correcto;
- filtros combinables sobre el catálogo cargado;
- un panel administrativo protegido para el mantenimiento del catálogo y sus categorías.

El principio del proyecto es **no inventar datos**: cada dato publicado debe tener fuente, URL y fecha de consulta. Cuando la fuente no existe o no cubre el barrio, la interfaz lo declara y no estima ni prorratea valores.

---

## 2. Contexto del barrio Ciudad Granada

Ciudad Granada se ubica en la **UPZ 82 Patio Bonito**, localidad **08 Kennedy**, Bogotá D.C.

Datos verificados en la documentación territorial del proyecto:

| Dato | Valor | Nivel territorial |
|---|---|---|
| Polígono oficial | 9,1 ha; 58 vértices; centroide 4,641833, -74,171758 | Barrio |
| Lotes | 705 | Barrio |
| Población | 3.807 habitantes (estimación oficial del barrio) | Barrio |
| Estrato predominante | 2 (34 manzanas) | Barrio |
| Población proyectada 2025 | 133.130 habitantes | UPZ 082, **no** barrio |

> La población de la UPZ 082 y su distribución por edad y sexo se presentan en un panel separado. No se prorratean ni se presentan como datos exclusivos del barrio. Los delitos se muestran por **localidad 08 Kennedy**, nunca por barrio.

La investigación de fuentes, los polígonos y las limitaciones están documentados en [`docs/investigacion/fuentes-territoriales.md`](docs/investigacion/fuentes-territoriales.md).

---

## 3. Arquitectura de tres capas

```text
Navegador
   │  HTTPS / JSON · contrato OpenAPI público
   ▼
mi-barrio-frontend        React + TypeScript + Vite
   │  HTTP /api/v1 · CORS + rate limit
   ▼
mi-barrio-api             Express público · única frontera pública
   │  HTTP interno /internal/v1 · X-Service-Token
   ▼
mi-barrio-backend         Express privado · no expuesto a Internet
   │  SQL / PostGIS
   ▼
PostgreSQL 16 + PostGIS 3.7
```

Reglas de la arquitectura:

- **Tres repositorios independientes**: no hay monorepo ni importaciones de código entre repositorios.
- La comunicación entre repositorios es **solo por contratos HTTP**.
- El **backend no se publica**: solo la API es la frontera pública.
- La API consume el backend con el encabezado `X-Service-Token`.
- Las rutas administrativas de la API están protegidas con **JWT**; las contraseñas se almacenan con **Argon2**.
- Cada frontera HTTP tiene un **OpenAPI canónico** y tipos generados; las copias se sincronizan y se verifican con **SHA-256**.

> **Desviación del despliegue Free (2026-11-23):** los Web Services Free no reciben tráfico por red privada, por lo que el backend está expuesto en una URL pública y protegido con `X-Service-Token`. No se configuraron planes pagos, Private Link ni dominios. Detalle en [`docs/despliegue/evidencia-fase-15.2-despliegue-render.md`](docs/despliegue/evidencia-fase-15.2-despliegue-render.md).

---

## 4. Tecnologías utilizadas

| Capa | Tecnologías principales |
|---|---|
| Frontend | React 19, TypeScript estricto, Vite 7, Tailwind CSS 4, Leaflet 1.9 / React Leaflet 5, Vitest, Playwright |
| API | Node.js 22+, Express 5, TypeScript, Zod, Ajv, JWT, Helmet, express-rate-limit |
| Backend | Node.js 22+, Express 5, TypeScript, `pg`, Argon2, Zod, JWT |
| Datos | PostgreSQL 16, PostGIS 3.7 |
| Contratos | OpenAPI 3.0.3, `openapi-typescript`, verificación SHA-256 |
| Calidad | ESLint, TypeScript `strict`, Vitest, Playwright, límite de 100 líneas por archivo |

---

## 5. Función de cada repositorio

| Repositorio | Tipo | Función |
|---|---|---|
| `mi-barrio-frontend` | Repositorio independiente | Interfaz pública y panel administrativo: ficha, mapa, vías, salud, transporte, demografía, seguridad, filtros y administración. Consume solo la API pública. |
| `mi-barrio-api` | Repositorio independiente | API pública: validación, caché, CORS, rate limit, errores centralizados, autenticación administrativa y publicación del contrato OpenAPI público. |
| `mi-barrio-backend` | Repositorio independiente | Backend privado: dominio, casos de uso, PostgreSQL/PostGIS, ETL de fuentes, contrato interno y protección con token de servicio. |
| `docs/` | Carpeta de este repositorio | Documentación académica, requerimientos, arquitectura, investigación territorial y evidencias por fase. No es un repositorio de código. |

La estructura publicada del portal es independiente: contiene solo documentación y el manifiesto. Los repositorios de código se consultan por sus URL HTTPS y no se incorporan como carpetas ni submódulos:

```text
mi-barrio-entrega/
├── README.md
├── docs/
└── entrega/
```

### 5.1 Repositorios publicados y referencias vigentes

| Repositorio | Remoto `origin` verificado | HEAD vigente en `main` |
|---|---|---|
| `mi-barrio-frontend` | `https://github.com/chellunette-cloud/mi-barrio-frontend.git` | `main` / `11aa254ef826ca20367deb4a689123e4ed8a90b8` |
| `mi-barrio-api` | `https://github.com/chellunette-cloud/mi-barrio-api.git` | `fase-15/p0-trust-proxy` / `39684bce72bda72b3d23ba1d3db0724877a97b88` |
| `mi-barrio-backend` | `https://github.com/chellunette-cloud/mi-barrio-backend.git` | `main` / `a6c912542873665659fff4a38c1efdd5f13483be` |

Estos remotos, ramas y HEADs fueron verificados en los repositorios locales y contra `git ls-remote origin`. `main` de la API sigue en `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd`; el commit desplegado conserva `b9080ea` como antecesor. El portal no usa submódulos: no existe `.gitmodules` ni gitlinks; las versiones de referencia se registran en el manifiesto.

El [manifiesto de versiones del portal](entrega/manifiesto-versiones.md) registra de forma documental estos repositorios, sus SHAs y los hashes de los contratos, sin crear submódulos.

---

## 6. Cómo clonar el proyecto

```bash
git clone https://github.com/chellunette-cloud/mi-barrio-entrega.git
```

URL confirmada del repositorio del portal. Es distinta de la URL pública de la aplicación y de la URL de GitHub Pages indicadas al inicio.

Para acceder a los repositorios de código, clónalos por separado desde sus URL HTTPS (§5.1) o consulta el [manifiesto de versiones](entrega/manifiesto-versiones.md). El portal no incorpora submódulos: no hay `.gitmodules`, gitlinks ni clonación recursiva.

---

## 7. Cómo iniciar cada componente

### Requisitos previos

- Node.js 22 o superior y npm.
- PostgreSQL 16 con PostGIS 3.7 disponible.
- Base de datos `mi_barrio` creada y accesible mediante `DATABASE_URL`.
- Variables de entorno copiadas desde `.env.example` en cada repositorio.

> No se versionan archivos `.env` ni credenciales reales. Cada repositorio incluye únicamente su `.env.example`.

### Orden de arranque

1. PostgreSQL/PostGIS.
2. Backend privado.
3. API pública.
4. Frontend.

### 7.1 Backend privado (`mi-barrio-backend`)

```bash
cd mi-barrio-backend
npm ci
cp .env.example .env          # En PowerShell: Copy-Item .env.example .env
npm run verify:data
npm run migrate
npm run etl
npm run dev
```

El backend escucha por defecto en el puerto **3001** y no debe publicarse en Internet. El ETL valida los hashes SHA-256 de los snapshots antes de cargar los datos.

### 7.2 API pública (`mi-barrio-api`)

```bash
cd mi-barrio-api
npm ci
cp .env.example .env          # En PowerShell: Copy-Item .env.example .env
npm run contracts:verify
npm run dev
```

La API escucha por defecto en el puerto **3000**. Debe apuntar al backend mediante `BACKEND_URL` y compartir `SERVICE_TOKEN` con él.

### 7.3 Frontend (`mi-barrio-frontend`)

```bash
cd mi-barrio-frontend
npm ci
cp .env.example .env          # En PowerShell: Copy-Item .env.example .env
npm run dev
```

Vite sirve la aplicación en **http://127.0.0.1:5173** y usa el proxy `/api` hacia la API local.

### Puertos locales de referencia

| Componente | Puerto | Exposición |
|---|---:|---|
| Frontend | 5173 | Local |
| API | 3000 | Frontera pública |
| Backend | 3001 | Red privada |
| PostgreSQL/PostGIS | 55432 (ejemplo local) | Local |

---

## 8. Contratos y verificación

Cadena de sincronización de contratos:

```text
mi-barrio-backend/contracts/internal.openapi.yaml
        │  copia + SHA-256
        ▼
mi-barrio-api/contracts/internal.openapi.yaml + .sha256
        │  contrato público canónico
        ▼
mi-barrio-api/contracts/public.openapi.yaml
        │  copia + SHA-256
        ▼
mi-barrio-frontend/contracts/public.openapi.yaml + .sha256
```

Comandos de verificación:

```bash
cd mi-barrio-api
npm run contracts:verify

cd ../mi-barrio-frontend
npm run contracts:verify
```

**Hashes vigentes (Fase 14.7):**

| Contrato | SHA-256 |
|---|---|
| Interno (`mi-barrio-api`) | `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` |
| Público (`mi-barrio-frontend`) | `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` |

**Registro histórico:** en Fase 11.2 se registraron `338f3cbe3a7591d09691c0e05ae43bab8783faac1511d22408eb67e05d0f8ddc` (interno) y `af9cda5b6ae3cdad59593ac5dd4abf9d3ca3c2550ee672484ac952ed88b5232e` (público). En Fase 12 se registraron `606a25436e23c4964f44153acc545b4dcb947801ffc726aa1aaf0f565c15a84c` (interno) y `c1602756c9eb7edf98695da489856f76387f3d62874e13e5ce89a1ed461aed59` (público). Estos valores se conservan como evidencia histórica y no deben presentarse como vigentes.

---

## 9. Pruebas

Cada repositorio expone un comando de integración continua local:

```bash
cd mi-barrio-backend
npm run ci

cd ../mi-barrio-api
npm run ci

cd ../mi-barrio-frontend
npm run ci
```

La suite de aceptación del frontend requiere PostgreSQL, backend, API y Vite en ejecución:

```bash
cd mi-barrio-frontend
npm run test:acceptance
```

**Resultado vigente (Fase 14.7):** E2E remoto `44979541605` en `success`, **36/36 pruebas aprobadas en 15 archivos**, job `playwright` correcto y artefacto `playwright-report` verificado. Es evidencia de **regresión remota** de los criterios cubiertos; no ejecutó individualmente los 46 criterios ni implica despliegue. El detalle está en [`docs/evidencias/fase-14-7/ejecucion-e2e-remota.md`](docs/evidencias/fase-14-7/ejecucion-e2e-remota.md), físicamente presente en este portal e incorporado a Git.

**Registro histórico:** en Fase 11.2 se registraron **23/23 pruebas Playwright** y en Fase 12 **27/27**. Ambos resultados se conservan en [`docs/evidencias/fase-11-2/resultados-regresion.md`](docs/evidencias/fase-11-2/resultados-regresion.md) y [`docs/evidencias/fase-12/resultados-regresion.md`](docs/evidencias/fase-12/resultados-regresion.md).

---

## 10. Estado actual del avance

### 10.1 Estado vigente (2026-11-23)

**Fase 15.2 — Despliegue gratuito en Render y validación real**, ejecutada. Las fases de desarrollo y validación hasta la 14.7 siguen cerradas técnicamente; la documentación final y la entrega académica continúan pendientes. La matriz canónica vigente está en [`docs/evidencias/fase-13/matriz-global-46-criterios.md`](docs/evidencias/fase-13/matriz-global-46-criterios.md), físicamente presente en este portal e incorporado a Git; registra:

| Criterios totales | Aprobados | Parciales | No aprobados | No verificables |
|---:|---:|---:|---:|---:|
| 46 | 46 | 0 | 0 | 0 |

La validación remota (`44979541605`, `success`, 36/36 en 15 archivos) es evidencia de regresión de los criterios cubiertos, no ejecución individual de los 46. Los cuatro servicios desplegados están activos, el ETL cargó 376 lugares y 463 vías, y la API responde a través del rewrite del frontend. **P0-02 queda aprobado para la integridad de datos consultada; P0-01 queda NO APROBADO** porque `req.ip` no corresponde a la IP del cliente. Los seis manuales están disponibles en la §12. El portal de documentación fue publicado en GitHub Pages y su enlace único es <https://chellunette-cloud.github.io/mi-barrio-entrega/>. Pendientes reales: **corrección y revalidación de P0-01**, **documentación final de entrega**, **entrega final**, **aceptación académica**, **trazabilidad final**, **respaldos/restauración** y **verificaciones finales**. PT-01, PT-02 y la auditoría formal de accesibilidad permanecen sin evidencia de cierre. Ver [`docs/despliegue/evidencia-fase-15.2-despliegue-render.md`](docs/despliegue/evidencia-fase-15.2-despliegue-render.md).

### 10.2 Registro histórico (2026-11-16, Fase 11.2)

**Fase 11.2 — Resolución de brechas y cierre de validación funcional**, reportada como finalizada el 2026-11-16.

| HU | Estado | Alcance |
|---|---|---|
| HU-01 | En pruebas | Información general del barrio |
| HU-02 | En pruebas | Ubicación geográfica |
| HU-03 | En desarrollo | Lugares de interés |
| HU-04 | En desarrollo | Establecimientos comerciales |
| HU-05 | En desarrollo | Parques y zonas verdes |
| HU-06 | En desarrollo | Instituciones educativas |
| HU-07 | Validada | Servicios de salud |
| HU-08 | Validada | Vías |
| HU-09 | Validada | Transporte público |
| HU-10 | Validada | Información demográfica |
| HU-11 | Validada | Seguridad |
| HU-12 | Validada | Filtros |
| HU-13 | Validada | Administración de información |

#### Criterios de aceptación

| Criterios totales | Aprobados | Parciales | No verificables |
|---:|---:|---:|---:|
| 46 | 36 | 0 | 0 |

Los **10 criterios restantes** pertenecen a HU-03 a HU-06 y no se declaran aprobados ni se inventan. La matriz completa está en [`docs/evidencias/fase-11-2/matriz-validacion-final.md`](docs/evidencias/fase-11-2/matriz-validacion-final.md).

---

## 11. Limitaciones y verificaciones pendientes

### Limitaciones de las fuentes

- **Comercio:** cobertura parcial (OSM en el área de estudio; IDT sin registros en el entorno). No representa la totalidad del comercio del barrio.
- **Demografía:** los quinquenios de edad y la distribución por sexo corresponden al nivel **UPZ 082**; no se prorratean al barrio.
- **Seguridad:** los delitos se presentan por **localidad 08 Kennedy**, no por barrio.
- **Transporte:** se publican paraderos, estaciones y portales; no se publican rutas, horarios, frecuencias ni tiempos de llegada.
- **Direcciones:** cuando la fuente oficial no contiene una dirección verificable, la interfaz muestra “Dirección no disponible”; no se infiere.

### Verificaciones: estado vigente

**Ejecutadas y verificadas (Fases 14.7 y 15.2):** E2E remoto `44979541605` en `success` (**36/36** pruebas en **15** archivos, job `playwright` correcto y artefacto `playwright-report` verificado), remotos/HEADs confirmados y despliegue real en Render con servicios, endpoints, mapa, ETL y datos verificados. Esto es regresión remota más evidencia de despliegue; **no** equivale a cierre de las verificaciones formales ni a aceptación académica.

Los manuales de usuario, técnico, instalación, operación, pruebas y despliegue están disponibles en la §12. **Sigue pendiente sin evidencia de cierre:** corrección y revalidación de **P0-01**, auditoría formal de accesibilidad, prueba formal de rendimiento **PT-01**, pruebas formales **PT-02**, respaldos/restauración, documentación final de entrega, trazabilidad final y verificaciones finales. La publicación del portal y el enlace único ya están resueltos. La red privada y el backend no expuesto no están disponibles en el plan Free aplicado; véase la limitación registrada en la §3 y en la evidencia de despliegue.

**Registro histórico (Fase 11.2):** en su momento se listaron como pendientes la auditoría formal de accesibilidad, **PT-01**, **PT-02**, el despliegue en staging con HTTPS, la ejecución remota de GitHub Actions y la publicación de los repositorios y del portal. La ejecución remota y la publicación de los repositorios quedaron cubiertas después; los demás ítems se conservan arriba como pendientes vigentes.

Estas limitaciones están explicadas en [`docs/evidencias/fase-11-2/decisiones-y-limitaciones.md`](docs/evidencias/fase-11-2/decisiones-y-limitaciones.md).

---

## 12. Documentación y evidencias disponibles

| Documento | Contenido |
|---|---|
| [`docs/requerimientos/historias-usuario.md`](docs/requerimientos/historias-usuario.md) | Las 13 historias de usuario |
| [`docs/requerimientos/requisitos.md`](docs/requerimientos/requisitos.md) | Requisitos funcionales, no funcionales y reglas de negocio |
| [`docs/requerimientos/criterios-aceptacion.md`](docs/requerimientos/criterios-aceptacion.md) | 46 criterios de aceptación |
| [`docs/requerimientos/matriz-trazabilidad.md`](docs/requerimientos/matriz-trazabilidad.md) | Trazabilidad HU → requisito → criterio → evidencia |
| [`docs/arquitectura/arquitectura-solucion.md`](docs/arquitectura/arquitectura-solucion.md) | Arquitectura, contratos, SOLID y decisiones |
| [`docs/especificaciones/especificaciones-funcionales.md`](docs/especificaciones/especificaciones-funcionales.md) | Especificaciones funcionales por HU |
| [`docs/investigacion/fuentes-territoriales.md`](docs/investigacion/fuentes-territoriales.md) | Fuentes, URLs, fechas y limitaciones territoriales |
| [`docs/manuales/manual-usuario.md`](docs/manuales/manual-usuario.md) | Uso de la interfaz, mapa, filtros, administración y limitaciones |
| [`docs/manuales/manual-tecnico.md`](docs/manuales/manual-tecnico.md) | Arquitectura, contratos, HTTP, autenticación, PostGIS y repositorios |
| [`docs/manuales/manual-instalacion.md`](docs/manuales/manual-instalacion.md) | Clonado, entorno, base de datos, migraciones, arranque y verificación |
| [`docs/manuales/manual-operacion.md`](docs/manuales/manual-operacion.md) | Health checks, logs, migraciones, errores, seguridad y recuperación |
| [`docs/manuales/manual-pruebas.md`](docs/manuales/manual-pruebas.md) | Comandos, evidencias, E2E remoto y pruebas pendientes |
| [`docs/manuales/manual-despliegue.md`](docs/manuales/manual-despliegue.md) | Despliegue propuesto, HTTPS, CORS, red privada y verificaciones |
| [`docs/despliegue/evidencia-fase-15.2-despliegue-render.md`](docs/despliegue/evidencia-fase-15.2-despliegue-render.md) | Despliegue real en Render, configuración, ETL, P0-01 y P0-02 |
| [`docs/evidencias/fase-11-2/matriz-validacion-final.md`](docs/evidencias/fase-11-2/matriz-validacion-final.md) | Matriz final de validación |
| [`docs/evidencias/fase-11-2/resultados-regresion.md`](docs/evidencias/fase-11-2/resultados-regresion.md) | CI, builds, contratos, snapshots y Playwright |
| [`docs/evidencias/fase-11-2/decisiones-y-limitaciones.md`](docs/evidencias/fase-11-2/decisiones-y-limitaciones.md) | Decisiones y limitaciones de la fase |
| [`docs/evidencias/fase-11-2/resolucion-hu-07.md`](docs/evidencias/fase-11-2/resolucion-hu-07.md) | Cierre de la brecha de direcciones en salud |
| [`docs/evidencias/fase-11-2/resolucion-hu-09.md`](docs/evidencias/fase-11-2/resolucion-hu-09.md) | Cierre de la brecha del código SITP |
| [`docs/evidencias/fase-11-2/resolucion-hu-10.md`](docs/evidencias/fase-11-2/resolucion-hu-10.md) | Quinquenios de edad de la UPZ 082 |
| [`docs/evidencias/fase-11-2/resolucion-hu-13.md`](docs/evidencias/fase-11-2/resolucion-hu-13.md) | Administración de categorías |
| [`docs/evidencias/fase-11-1/trazabilidad-pruebas.md`](docs/evidencias/fase-11-1/trazabilidad-pruebas.md) | Trazabilidad criterio por criterio antes del cierre |

> `docs/README.md` conserva el índice histórico de la Fase 1 y, además, el subíndice de evidencias de las fases 12–14.7. El estado vigente del proyecto se registra en la §10.1 de este documento y en [`docs/evidencias/fase-13/matriz-global-46-criterios.md`](docs/evidencias/fase-13/matriz-global-46-criterios.md) y [`docs/evidencias/fase-14-7/ejecucion-e2e-remota.md`](docs/evidencias/fase-14-7/ejecucion-e2e-remota.md), físicamente presentes en este portal. Los seis manuales de `docs/manuales/` son un reflejo controlado de la fuente canónica `docs/manuales/` del workspace principal; no se editen por separado. Las evidencias de Fase 12.1, Fase 13 y Fase 14.7 están presentes en este portal e **incorporadas a Git**; su presencia no implica revisión ni aceptación académica. La publicación del portal y el enlace único están resueltos en <https://chellunette-cloud.github.io/mi-barrio-entrega/>.

---

## 13. Reglas de datos del proyecto

1. No se inventan datos, establecimientos, estadísticas, rutas ni límites.
2. Todo dato publicado lleva fuente, URL y fecha de consulta.
3. Los datos de UPZ o localidad no se presentan como datos exclusivos del barrio.
4. Ningún archivo de código supera las 100 líneas.
5. Una prueba no se declara aprobada sin ejecutarla y registrar la evidencia.
6. No se duplican contratos: cada frontera HTTP tiene una fuente canónica y copias verificadas por hash.
