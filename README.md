# Mi Barrio — Ciudad Granada

Portal de entrega académica del proyecto **Mi Barrio — Ciudad Granada**. Este repositorio principal reúne la documentación y está preparado para referenciar los tres repositorios independientes del sistema mediante **Git Submodules**, sin convertirlos en un monorepo.

> **Estado del avance:** Fase 11.2 reportada como finalizada el **2026-11-16**. HU-07 a HU-13 en estado **Validada**; HU-01 y HU-02 en **En pruebas**; HU-03 a HU-06 en **En desarrollo**.

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
| `mi-barrio-frontend` | Submódulo | Interfaz pública y panel administrativo: ficha, mapa, vías, salud, transporte, demografía, seguridad, filtros y administración. Consume solo la API pública. |
| `mi-barrio-api` | Submódulo | API pública: validación, caché, CORS, rate limit, errores centralizados, autenticación administrativa y publicación del contrato OpenAPI público. |
| `mi-barrio-backend` | Submódulo | Backend privado: dominio, casos de uso, PostgreSQL/PostGIS, ETL de fuentes, contrato interno y protección con token de servicio. |
| `docs/` | Carpeta de este repositorio | Documentación académica, requerimientos, arquitectura, investigación territorial y evidencias por fase. No es un submódulo. |

Cuando los submódulos estén configurados, la estructura del portal será:

```text
mi-barrio-entrega/
├── README.md
├── docs/
├── entrega/
├── mi-barrio-frontend/   ← submódulo
├── mi-barrio-api/        ← submódulo
└── mi-barrio-backend/    ← submódulo
```

---

## 6. Cómo clonar el proyecto

```bash
git clone --recurse-submodules <URL_DE_ESTE_REPOSITORIO>
```

Sustituye `<URL_DE_ESTE_REPOSITORIO>` por la URL confirmada del repositorio principal. En este documento no se fija una URL de GitHub no verificada.

Si ya clonaste el repositorio sin submódulos:

```bash
git submodule update --init --recursive
```

Para actualizar los submódulos a las revisiones registradas por el repositorio principal:

```bash
git submodule update --recursive
```

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

Hashes finales registrados en la Fase 11.2:

| Contrato | SHA-256 |
|---|---|
| Interno (`mi-barrio-api`) | `338f3cbe3a7591d09691c0e05ae43bab8783faac1511d22408eb67e05d0f8ddc` |
| Público (`mi-barrio-frontend`) | `af9cda5b6ae3cdad59593ac5dd4abf9d3ca3c2550ee672484ac952ed88b5232e` |

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

Resultados finales de la Fase 11.2: **23/23 pruebas Playwright aprobadas**, CI en verde en los tres repositorios, contratos verificados, 10 snapshots de datos verificados y builds de producción correctos. El detalle está en [`docs/evidencias/fase-11-2/resultados-regresion.md`](docs/evidencias/fase-11-2/resultados-regresion.md).

---

## 10. Estado actual del avance

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

### Criterios de aceptación

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

### Verificaciones pendientes

- Auditoría formal de accesibilidad.
- Prueba formal de rendimiento **PT-01**.
- Pruebas formales **PT-02**.
- Despliegue en staging con HTTPS.
- Ejecución remota de GitHub Actions.
- Publicación de los repositorios y del portal de entrega.

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
| [`docs/evidencias/fase-11-2/matriz-validacion-final.md`](docs/evidencias/fase-11-2/matriz-validacion-final.md) | Matriz final de validación |
| [`docs/evidencias/fase-11-2/resultados-regresion.md`](docs/evidencias/fase-11-2/resultados-regresion.md) | CI, builds, contratos, snapshots y Playwright |
| [`docs/evidencias/fase-11-2/decisiones-y-limitaciones.md`](docs/evidencias/fase-11-2/decisiones-y-limitaciones.md) | Decisiones y limitaciones de la fase |
| [`docs/evidencias/fase-11-2/resolucion-hu-07.md`](docs/evidencias/fase-11-2/resolucion-hu-07.md) | Cierre de la brecha de direcciones en salud |
| [`docs/evidencias/fase-11-2/resolucion-hu-09.md`](docs/evidencias/fase-11-2/resolucion-hu-09.md) | Cierre de la brecha del código SITP |
| [`docs/evidencias/fase-11-2/resolucion-hu-10.md`](docs/evidencias/fase-11-2/resolucion-hu-10.md) | Quinquenios de edad de la UPZ 082 |
| [`docs/evidencias/fase-11-2/resolucion-hu-13.md`](docs/evidencias/fase-11-2/resolucion-hu-13.md) | Administración de categorías |
| [`docs/evidencias/fase-11-1/trazabilidad-pruebas.md`](docs/evidencias/fase-11-1/trazabilidad-pruebas.md) | Trazabilidad criterio por criterio antes del cierre |

> `docs/README.md` conserva el índice histórico de la Fase 1. El estado vigente del proyecto es el registrado en `docs/evidencias/fase-11-2/`.

---

## 13. Reglas de datos del proyecto

1. No se inventan datos, establecimientos, estadísticas, rutas ni límites.
2. Todo dato publicado lleva fuente, URL y fecha de consulta.
3. Los datos de UPZ o localidad no se presentan como datos exclusivos del barrio.
4. Ningún archivo de código supera las 100 líneas.
5. Una prueba no se declara aprobada sin ejecutarla y registrar la evidencia.
6. No se duplican contratos: cada frontera HTTP tiene una fuente canónica y copias verificadas por hash.
