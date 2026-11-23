# Matriz de trazabilidad — requisitos → implementación → pruebas

**Nota de vigencia (2026-11-22):** este documento conserva su contenido histórico de 2026-11-15, incluidas las menciones a «Estado actual» de ese momento. La **matriz vigente** es [`../evidencias/fase-13/matriz-global-46-criterios.md`](../evidencias/fase-13/matriz-global-46-criterios.md), con 46/46 criterios aprobados. La regresión E2E remota de Fase 14.7 se documenta en [`../evidencias/fase-14-7/ejecucion-e2e-remota.md`](../evidencias/fase-14-7/ejecucion-e2e-remota.md). Este aviso no modifica los criterios, sus resultados ni los estados históricos registrados más abajo, y no implica despliegue ni aceptación académica.

> **Estado vigente a 23 de noviembre de 2026:** la trazabilidad vigente es la [matriz canónica de Fase 13](../evidencias/fase-13/matriz-global-46-criterios.md), con **46/46 criterios aprobados acumulados**. Las secciones 1 a 6 conservan el estado de 2026-11-15 y describen la ejecución de Fase 1; sus etiquetas «Estado actual» son históricas. El run remoto de Fase 14.7 (`44979541605`, `success`, 36/36 en 15 archivos) es regresión de los recorridos Playwright y **no ejecutó individualmente los 46 criterios**. El despliegue se ejecutó en Fase 15.2 con P0-01 NO APROBADO en esa fecha y P0-02 aprobado para la integridad consultada; P0-01 quedó aprobado en Fase 15.3. Siguen pendientes documentación final, PT-01, PT-02, auditoría WCAG formal y aceptación académica.

**Versión:** 1.2 · **Fecha:** 2026-11-15
**Regla:** una historia solo pasa a `Validada` cuando todas sus pruebas asociadas se ejecutaron y la evidencia está enlazada.
**Revisión 1.1 (2026-11-15):** se incorporan las restricciones de alcance y el método de conteo aplicados; ver §5. No cambiaron IDs ni el número de criterios.
**Revisión 1.2 (2026-11-15):** HU-01 y HU-02 pasan a `En pruebas` con evidencia real de Fase 1; ver §6. Las demás siguen `Registrada` y no hay historias `Validadas`.

Leyenda de estado: `Registrada` · `En desarrollo` · `En pruebas` · `Validada` · `Bloqueada`.
**Estado histórico (2026-11-15):** HU-01 y HU-02 en `En pruebas`; las otras 11 seguían `Registrada` y no había código ni pruebas de HU-03…HU-13 en ese momento.

---

## 1. Matriz principal

| HU | Funcionalidad | Requisitos asociados | Criterios de aceptación | Módulo del sistema | Evidencia (prevista o ejecutada) | Prueba relacionada | Estado |
|----|---------------|----------------------|-------------------------|--------------------|--------------------|--------------------|--------|
| HU-01 | Ficha general del barrio | RF-01 · RNF-06, RNF-14 | CA-HU01-01..04 | FE `barrio` · API `barrio` · BE `barrio` | `GET /api/v1/barrio` 200; [`api-barrio.json`](../evidencias/fase-1/api-barrio.json); capturas y teclado en [`fase-1/README.md`](../evidencias/fase-1/README.md) | UT-BAR-01, IT-BAR-01, AT-BAR-01, FT-HU01-01 | En pruebas |
| HU-02 | Mapa y límites | RF-02 · RNF-17, RNF-11 | CA-HU02-01..04 | FE `map` · API `barrio` · BE `geo` | `GET /api/v1/barrio/geometria` 200; [`api-geometria.json`](../evidencias/fase-1/api-geometria.json); GT-01 y capturas en [`fase-1/README.md`](../evidencias/fase-1/README.md) | GT-01, AT-GEO-01, FT-HU02-01 | En pruebas |
| HU-03 | Catálogo de lugares | RF-03, RF-14 · RNF-08, RNF-11 | CA-HU03-01..04 | FE `places` · API `places` · BE `places` | `GET /api/v1/lugares` paginado; detalle `GET /lugares/{id}`; consistencia mapa–lista | AT-PLA-01, AT-PLA-02, IT-PLA-01, UT-PLA-01, FT-HU03-01 | En desarrollo 
| HU-04 | Comercio | RF-04, RF-14 · RNF-14 | CA-HU04-01..04 | FE `places` · API `places` · BE `places` | Búsqueda `?q=` y `?categoria=`: **cobertura parcial** (OSM 6; IDT 0 en el entorno); aviso visible de no totalidad | AT-PLA-03, UT-PLA-02, FT-HU04-01 | En desarrollo 
| HU-05 | Parques y zonas verdes | RF-05 · RNF-11 | CA-HU05-01..03 | FE `places` · API `places` · BE `places` | Listado ordenado por distancia; etiqueta "cercanas"; selección centra el mapa | AT-PLA-04, UT-PLA-03, FT-HU05-01 | En desarrollo 
| HU-06 | Instituciones educativas | RF-06 · RNF-11 | CA-HU06-01..03 | FE `places` · API `places` · BE `places` | Listado con sede, sector y distancia; **28** registros en bbox ±0,006°, **15** ≤800 m, **1** dentro; marca "dentro del barrio" | AT-PLA-05, UT-PLA-04, GT-EDU-01, FT-HU06-01 | En desarrollo 
| HU-07 | Servicios de salud | RF-07 · RNF-11 | CA-HU07-01..03 | FE `places` · API `places` · BE `places` | Listado con tipo IPS/consultorio/farmacia y distancia mínima | AT-PLA-06, UT-PLA-05, FT-HU07-01 | En desarrollo |
| HU-08 | Vías y accesos | RF-08 · RNF-11 | CA-HU08-01..03 | FE `map` · API `geo` · BE `geo` | Capa de vías por jerarquía; accesos resaltados; sin rutas sugeridas | GT-02, AT-GEO-02, FT-HU08-01 | En desarrollo |
| HU-09 | Transporte público | RF-09 · RNF-11 | CA-HU09-01..03 | FE `map` · API `places` · BE `places` | **Solo paraderos/estaciones/portales** con distancia; sin rutas, horarios ni frecuencias; selección centra el mapa | AT-PLA-07, UT-PLA-06, FT-HU09-01 | En desarrollo |
| HU-10 | Demografía | RF-10 · RNF-10, RNF-14 | CA-HU10-01..03 | FE `stats` · API `stats` · BE `stats` | **Panel barrio** (3.807, estimación) separado del **panel UPZ 082** (133.130, proyección 2025); sin prorrateo | AT-STA-01, UT-STA-01, FT-HU10-01 | Registrada |
| HU-11 | Seguridad y entorno | RF-11 · RNF-14, RN-09 | CA-HU11-01..03 | FE `map` · API `stats` · BE `stats` | Cuadrante CAI Bellavista; delitos **localidad 08 Kennedy** con periodo; capas ambientales | AT-STA-02, UT-STA-02, FT-HU11-01 | Registrada |
| HU-12 | Filtros del mapa | RF-12 · RNF-07, RNF-11 | CA-HU12-01..04 | FE `filters` · API `places` · BE `places` | Filtro simple y múltiple; contador/mapa/lista coincidentes; limpiar filtros | UT-FIL-01, AT-PLA-08, FT-HU12-01, PT-02 | Registrada |
| HU-13 | Administración | RF-13 · RNF-05, RNF-08 | CA-HU13-01..05 | FE `admin` · API `admin`+`auth` · BE `admin`+`auth` | 401 sin sesión; CRUD validado; auditoría con antes/después; borrado protegido | ST-01, AT-ADM-01, AT-ADM-02, IT-ADM-01, UT-ADM-01, FT-HU13-01 | Registrada |

---

## 2. Catálogo de pruebas previstas

| ID | Tipo | Objeto | Descripción | HU |
|----|------|--------|-------------|-----|
| UT-BAR-01 | Unitaria | BE `barrio` | Transforma la fila de BD en DTO con fuentes y etiquetas | HU-01 |
| UT-PLA-01 | Unitaria | BE `places` | Construye filtros y paginación válidos | HU-03 |
| UT-PLA-02 | Unitaria | BE `places` | Búsqueda sin tildes ni mayúsculas | HU-04 |
| UT-PLA-03 | Unitaria | BE `places` | Orden por distancia y etiqueta de nivel | HU-05 |
| UT-PLA-04 | Unitaria | BE `places` | Marca "dentro del barrio" por geometría | HU-06 |
| UT-PLA-05 | Unitaria | BE `places` | Agrupa por tipo de prestador | HU-07 |
| UT-PLA-06 | Unitaria | BE `places` | Cálculo de distancia haversine | HU-09 |
| UT-HU09-01 | Unitaria | Contrato transporte | No expone rutas, horarios ni frecuencias | HU-09 |
| UT-FIL-01 | Unitaria | FE `filters` | Reducer de categorías múltiples | HU-12 |
| UT-STA-01 | Unitaria | BE `stats` | Etiqueta nivel barrio vs UPZ | HU-10 |
| UT-STA-02 | Unitaria | BE `stats` | Formatea periodo y agregación | HU-11 |
| UT-ADM-01 | Unitaria | BE `admin` | Validación de coordenadas en área de influencia | HU-13 |
| IT-BAR-01 | Integración | BE + BD | Consulta espacial del polígono y ficha | HU-01 |
| IT-PLA-01 | Integración | BE + BD | Filtro espacial + categoría sobre PostGIS | HU-03 |
| IT-ADM-01 | Integración | BE + BD | Transacción de creación con auditoría | HU-13 |
| AT-BAR-01 | API | `GET /barrio` | 200, contrato y fuentes | HU-01 |
| AT-GEO-01 | API | `GET /barrio/geometria` | GeoJSON válido, SRID 4326 | HU-02 |
| AT-GEO-02 | API | `GET /geo/vias` | FeatureCollection con jerarquía | HU-08 |
| AT-PLA-01 | API | `GET /lugares` | Paginación y envelope | HU-03 |
| AT-PLA-02 | API | `GET /lugares/{id}` | 200 / 404 | HU-03 |
| AT-PLA-03 | API | `GET /lugares?q=` | Búsqueda y sin resultados | HU-04 |
| AT-PLA-04 | API | `GET /lugares?categoria=parque` | Filtro y orden | HU-05 |
| AT-PLA-05 | API | `GET /lugares?categoria=educacion` | Sector y sede | HU-06 |
| AT-PLA-06 | API | `GET /lugares?categoria=salud` | Tipo de prestador | HU-07 |
| AT-PLA-07 | API | `GET /lugares?categoria=transporte` | Paradero/estación | HU-09 |
| AT-PLA-08 | API | `GET /lugares?categorias=a,b` | Filtro múltiple | HU-12 |
| AT-STA-01 | API | `GET /estadisticas/demografia` | Nivel territorial explícito | HU-10 |
| AT-STA-02 | API | `GET /estadisticas/seguridad` | Agregación y periodo | HU-11 |
| AT-ADM-01 | API | `POST /admin/lugares` | 401 sin token; 201 con token | HU-13 |
| AT-ADM-02 | API | `PATCH /admin/lugares/{id}` | Validación y auditoría | HU-13 |
| GT-01 | Geográfica | Polígono | Vértices, cierre, área y centroide contra fuente | HU-02 |
| GT-EDU-01 | Geográfica | Colegios | 28 registros en bbox, 15 ≤800 m, 1 dentro, 0 duplicados | HU-06 |
| GT-02 | Geográfica | Vías | Conectividad y contención en el área | HU-08 |
| FT-HU01-01 … FT-HU13-01 | Funcional (E2E) | UI | Recorrido de cada historia en navegador | 01–13 |
| ST-01 | Seguridad | Admin | Fuerza bruta, token expirado, roles | HU-13 |
| PT-01 | Rendimiento | Mapa | Carga inicial < 3 s en 3G rápida | HU-02 |
| PT-02 | Rendimiento | Filtros | Interacción < 300 ms p95 | HU-12 |

---

## 3. Trazabilidad resumida

| HU | RF | Criterios | Pruebas | Módulos | Evidencia | Estado |
|----|----|-----------|---------|---------|-----------|--------|
| HU-01 | RF-01 | 4 | 4 | 3 | API + UI + teclado | En pruebas |
| HU-02 | RF-02 | 4 | 3 | 3 | GeoJSON + GT + captura | En pruebas |
| HU-03 | RF-03, RF-14 | 4 | 5 | 3 | API + consistencia | En desarrollo 
| HU-04 | RF-04, RF-14 | 4 | 3 | 3 | API + aviso de fuente | En desarrollo 
| HU-05 | RF-05 | 3 | 3 | 3 | API + etiqueta | En desarrollo 
| HU-06 | RF-06 | 3 | 3 | 3 | API + marca | En desarrollo 
| HU-07 | RF-07 | 3 | 3 | 3 | API + tipo | En desarrollo |
| HU-08 | RF-08 | 3 | 3 | 3 | Capa + GT | En desarrollo |
| HU-09 | RF-09 | 3 | 3 | 3 | API + mapa | En desarrollo |
| HU-10 | RF-10 | 3 | 3 | 3 | Serie + etiqueta | Registrada |
| HU-11 | RF-11 | 3 | 3 | 3 | Cuadrante + agregación | Registrada |
| HU-12 | RF-12 | 4 | 4 | 3 | Filtro + consistencia | Registrada |
| HU-13 | RF-13 | 5 | 6 | 3 | 401 + CRUD + auditoría | Registrada |

**Cobertura de definición:** 13/13 HU con RF, criterios, módulo, evidencia y prueba previstos.
**Cobertura de ejecución histórica (Fase 1, 2026-11-15):** 2/13 en `En pruebas` (HU-01, HU-02); 0/13 `Validadas`. Las pruebas y evidencias ejecutadas en ese momento están en §6. El estado vigente es el aviso «Estado vigente a 22 de noviembre de 2026» y la matriz canónica de Fase 13.

---

## 4. Reglas de actualización

1. Toda prueba debe dejar evidencia enlazable (salida, reporte o captura) en el repositorio correspondiente.
2. Un criterio no se marca cumplido por inspección visual: requiere prueba automatizada o guion manual registrado.
3. Si cambia un requisito, se actualizan las tres columnas afectadas (criterio, prueba, evidencia) y se anota la fecha.
4. Las historias con limitación de datos (HU-04, HU-10, HU-11) solo pueden pasar a `Validada` si la limitación está visible en la interfaz y documentada.

---

## 5. Restricciones de alcance y método de conteo (2026-11-15)

| HU | Restricción / método | Criterio afectado | Verificación prevista |
|----|----------------------|-------------------|-----------------------|
| HU-04 | Cobertura **parcial**: OSM 6 en el bbox; IDT 0 en el entorno; no representa la totalidad | CA-HU04-02 | Aviso visible + prueba de UI |
| HU-06 | **28** registros en bbox ±0,006°; **15** sedes ≤800 m; **1** dentro; **0** duplicados nombre+dirección | CA-HU06-03 | GT-EDU-01 + IT/AT de conteo y orden |
| HU-09 | Solo paraderos, estaciones y portales; **sin** rutas, horarios, frecuencias ni tiempos de llegada | CA-HU09-03 | Prueba que verifica ausencia de campos operativos |
| HU-10 | **Panel barrio:** 3.807 (estimación, sin edad/sexo). **Panel UPZ 082:** 133.130 (proyección 2025, con sexo/edad). No sumar ni prorratear | CA-HU10-01..03 | Prueba de contrato + prueba de etiquetas en UI |
| HU-11 | Delitos de la **localidad 08 Kennedy**, nunca del barrio Ciudad Granada | CA-HU11-02 | Prueba de etiqueta y contrato |
| Todas | Ninguna HU pasa a `Validada` sin prueba ejecutada y evidencia enlazada | — | Revisión de esta matriz |

**Nota de conteo:** el número 28 es el total de registros de la ventana rectangular; 15 es el subconjunto a ≤800 m del centroide. No son intercambiables. El detalle del método está en [`../investigacion/fuentes-territoriales.md`](../investigacion/fuentes-territoriales.md) §6.1.

---

## 6. Evidencia ejecutada de Fase 1 (2026-11-15)

**Alcance:** solo HU-01 y HU-02. La Fase 2 no se inició.

| Prueba | Repositorio / ejecución | Resultado real |
|---|---|---|
| UT-BAR-01 | `mi-barrio-backend/tests/unit/mapBarrio.test.ts` | DTO y fuentes F-01/F-02 verificados |
| IT-BAR-01 | `mi-barrio-backend/tests/integration/repository.test.ts` | PostgreSQL/PostGIS devuelve 3.807, 34 manzanas y 58 vértices |
| AT-BAR-01 | `mi-barrio-api/tests/contract/public.test.ts` + [`api-barrio.json`](../evidencias/fase-1/api-barrio.json) | `200` y contrato público válido |
| AT-GEO-01 | `mi-barrio-api/tests/contract/public.test.ts` + [`api-geometria.json`](../evidencias/fase-1/api-geometria.json) | `200`, SRID 4326 y GeoJSON válido |
| GT-01 | `mi-barrio-backend/tests/geographic/geometry.test.ts` | Polígono válido, 58 vértices, igual al snapshot, centroide ≤ 5 m, 34/34 estrato 2, 0 fuera |
| FT-HU01-01 | `mi-barrio-frontend/tests/acceptance/ficha-mapa.spec.ts` | Ficha, fuentes, “Información no disponible” y foco por teclado |
| FT-HU02-01 | `mi-barrio-frontend/tests/acceptance/ficha-mapa.spec.ts` | Mapa encuadrado, zoom, popup, atribución y responsive |

**Ejecuciones:** backend 11/11, API 8/8 y frontend 3/3; Playwright 2/2. Logs en
[`evidencias/fase-1/`](../evidencias/fase-1/). Capturas:
[`ficha-desktop.png`](../evidencias/fase-1/ficha-desktop.png) y
[`ficha-mobile.png`](../evidencias/fase-1/ficha-mobile.png).

**Pendiente y no declarado:** PT-01 (rendimiento), auditoría formal de accesibilidad y despliegue
staging HTTPS. Por eso HU-01/HU-02 quedan en **`En pruebas`**, nunca en `Validada`.
