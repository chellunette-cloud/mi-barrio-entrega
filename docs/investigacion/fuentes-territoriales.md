# Investigación territorial — Ciudad Granada, Kennedy (Bogotá D.C.)

**Versión:** 1.0 · **Fecha de consulta de todas las fuentes:** 2026-11-15
**Método:** consulta directa a las API de Datos Abiertos Bogotá (CKAN), a los geoservicios REST de IDECA/UAECD y a la API de OpenStreetMap. No se usaron resúmenes de terceros para las cifras.
**Regla:** todo dato de este documento es reproducible con la URL indicada. Lo que no se pudo verificar se declara como tal.

---

## 1. Identificación del barrio

| Atributo | Valor verificado | Fuente |
|----------|------------------|--------|
| Nombre oficial en el catálogo | **URBANIZACION CIUDAD GRANADA** | F-01 |
| Código de registro | `LEG00645` | F-01 |
| Localidad | **08 — Kennedy** | F-01 |
| UPZ | **82 — Patio Bonito** | F-01 |
| UPL | UPL14 | F-01 |
| Escala de captura | 1:500 | F-01 |
| Plano | K56/4-00 | F-01 |

> **Homónimos descartados:** el buscador geográfico devuelve "Villas de Granada" (Engativá) y "Rincón de Granada" (Suba). No corresponden al barrio asignado y no se usaron. Tampoco se usó la descripción del código postal 110881 como límite (ver §4).

---

## 2. Ficha territorial verificada

| Dato | Valor | Observación |
|------|-------|-------------|
| Área | **9,1 ha** (atributo oficial) · **94.551,13 m²** geodésicos · **94.627,10 m²** `SHAPE.AREA` proyectado | El atributo oficial (91.000 m²) difiere ~3,9 % del área geodésica; se publica 9,1 ha y se usa 94.551,13 m² para validación geométrica |
| Número de lotes | **705** | Fuente SDP |
| Población estimada | **3.807 habitantes** | Estimación oficial del registro, no censo y no proyección |
| Densidad reportada | 77,47 | Coincide con 705 lotes / 9,1 ha; se interpreta como **lotes/ha** (pendiente de confirmar en el diccionario de datos) |
| Áreas de zona verde | 305 | Unidad de la fuente por confirmar antes de publicar |
| Estrato predominante | **2** | 34 manzanas con centroide dentro del polígono, todas estrato 2; verificación en §12 |
| Centroide | **4,641833, -74,171758** | `ST_Centroid` sobre el polígono oficial (SRID 4326 y EPSG:3116 coinciden). El valor anterior 4,641641, -74,171701 se descarta por ser un punto de etiqueta a 22 m |
| Bounding box | 4,639412 / -74,173791 → 4,644294 / -74,169695 | 58 vértices, SRID 4326 |

**Contraste con la UPZ (no confundir niveles):**

| Indicador | Barrio | UPZ 082 Patio Bonito | Año |
|-----------|--------|----------------------|-----|
| Población | 3.807 (estimada) | **133.130** (proyección) | 2025 |
| Hombres | no disponible | 66.175 | 2025 |
| Mujeres | no disponible | 66.955 | 2025 |
| Edad y sexo | **no disponible por barrio** | disponible por quinquenios | 2025 |

Fuente: F-02 y F-03. La proyección por edad y sexo existe solo a nivel de UPZ; **no se prorrateará** al barrio (RN-03).

---

## 3. Delimitación territorial

- **Polígono oficial:** capa "Barrio legalizado" de la SDP, publicada también en el geoservicio IDECA `ordenamientoterritorial/barrioslegalizados`.
- **Geometría:** 58 vértices, polígono cerrado, SRID 4326 (WGS84).
- **Validación cruzada:** el centroide geométrico calculado (4,641833, -74,171758) está a ~4 m de la referencia independiente del agregador de códigos postales (4,641796, -74,171761). El valor anterior (4,641641, -74,171701) se descarta: era un punto de etiqueta, no el centroide geométrico, y estaba a ~22 m.
- **Decisión:** se adopta el polígono oficial como única fuente de límites (RN-02). El barrio no se dibuja a mano ni se aproxima con un rectángulo.

---

## 4. Discrepancia documentada: código postal vs. barrio

El código postal **110881** se describe como la zona entre la Calle 40 Sur, la Calle 49 Sur, la Avenida Carrera 86 y el río Bogotá. Esa descripción:

- cubre un área de varios km², muy superior a las 9,1 ha del polígono oficial;
- agrupa al menos 13 barrios (Ciudad de Cali, Dindalito, El Jazmín, Las Acacias, Las Margaritas, Los Almendros, Osorio XII, Provivienda Occidental, Tintalito, Villa Alexandra, El Triunfo, entre otros).

**Conclusión:** el código postal es una unidad postal, no un límite barrial. Se usa solo como dato de contacto y **nunca** como geometría del barrio.

---

## 5. Catálogo de fuentes

| ID | Fuente | Institución | URL | Información que aporta | Formato | Consultado | Licencia | Limitaciones |
|----|--------|-------------|-----|------------------------|---------|------------|----------|--------------|
| F-01 | Barrio legalizado. Bogotá D.C. | Secretaría Distrital de Planeación (SDP) | `https://datosabiertos.bogota.gov.co/dataset/barrio-legalizado-bogota-d-c` · GeoJSON: `https://datosabiertos.bogota.gov.co/dataset/36a80ef3-02c1-4a48-b3c7-c285e1de4323/resource/ba69f395-13ed-4071-802d-3808e2ba9062/download/barriolegalizado.json` | Polígono, nombre, UPZ, localidad, área, lotes, población estimada, densidad | GeoJSON/Esri JSON, SHP, GPKG | 2026-11-15 | CC BY 4.0 | Solo barrios legalizados; el archivo `.json` es en realidad Esri JSON con coordenadas proyectadas (requiere `outSR=4326` vía REST) |
| F-02 | Estrato Socioeconómico. Bogotá D.C. | SDP | `https://datosabiertos.bogota.gov.co/dataset/estrato-socioeconomico-bogota-d-c` · REST: `https://serviciosgis.catastrobogota.gov.co/arcgis/rest/services/ordenamientoterritorial/estratificacion/MapServer/1` | Estrato por manzana | CSV (lote), polígonos REST | 2026-11-15 | CC BY 4.0 | El CSV usa códigos prediales sin nombre de barrio; se requiere cruce espacial |
| F-03 | Proyecciones y retroproyecciones de Población por UPZ (2005–2035) | SDP | `https://datosabiertos.bogota.gov.co/dataset/0f1fb76a-1595-43d5-9257-0abcc3db908a` · ODS UPZ: `.../resource/96583ea9-9c0b-40c3-9797-156d173eb734/download/202503_upz_proyeccion_retroproyeccion_poblacion_2005_2035.ods` | Población por UPZ, sexo y quinquenios | ODS | 2026-11-15 | CC BY 4.0 | Solo UPZ; sin desagregación por barrio; sin endpoint de datos |
| F-04 | Colegios. Bogotá D.C. | Secretaría de Educación (SED) | `https://datosabiertos.bogota.gov.co/dataset/colegios-bogota-d-c` · REST: `.../educacion/infraestructuraeducativa/MapServer/0` | Nombre, sede, dirección, sector, calendario, jornada, coordenadas | REST, GeoJSON, SHP | 2026-11-15 | CC BY-SA 4.0 | Sedes duplicadas por jornada; requiere deduplicación |
| F-05 | Instituciones Prestadoras de Salud | Secretaría Distrital de Salud (SDS) | `https://datosabiertos.bogota.gov.co/dataset/instituciones-prestadoras-de-salud-bogota` · REST: `.../salud/instituciones/MapServer/0` | IPS, consultorios, farmacias, coordenadas | REST, GeoJSON | 2026-11-15 | CC BY 4.0 | Nombres genéricos en consultorios; sin horarios ni niveles de atención |
| F-06 | Parques. POT Bogotá D.C. | SDP | `https://datosabiertos.bogota.gov.co/dataset/parque-bogota-d-c` · REST: `.../recreaciondeporte/parquesyescenarios/MapServer/1` | Nombre, tipo, nivel, estrato, polígono | REST, GeoJSON, SHP | 2026-11-15 | CC BY 4.0 | Capa POT; no incluye zonas verdes informales ni mantenimiento |
| F-07 | Malla vial intermedia. POT | SDP | `https://datosabiertos.bogota.gov.co/dataset/malla-vial-intermedia-bogota-d-c` | Trazado y jerarquía vial | GeoJSON, SHP | 2026-11-15 | CC BY 4.0 | No incluye vías locales menores; se complementa con OSM |
| F-08 | Cuadrante de Policía. Bogotá D.C. | SDSCJ | `https://datosabiertos.bogota.gov.co/dataset/cuadrantes-de-policia-bogota-d-c` · REST: `https://oaiee.scj.gov.co/agc/rest/services/Tematicos_NR/EquipamientoPMSDSCJ/MapServer/25` | CAI, cuadrante, teléfono, UPZ | REST, GeoJSON | 2026-11-15 | CC BY-SA 4.0 | Polígonos de cuadrante; el teléfono puede cambiar sin aviso |
| F-09 | Delito de Alto Impacto. Bogotá D.C. | SDSCJ | `https://datosabiertos.bogota.gov.co/dataset/delito-de-alto-impacto-bogota-d-c` · REST: `https://oaiee.scj.gov.co/agc/rest/services/Tematicos_Pub/CifrasSCJ/MapServer/0` | Conteos por localidad y año (2018–2026) | REST, GeoJSON | 2026-11-15 | CC BY-SA 4.0 | **Solo localidad**; sin barrio; requiere diccionario de campos |
| F-10 | Arbolado Urbano. Bogotá D.C. | Jardín Botánico (JBB) | `https://datosabiertos.bogota.gov.co/dataset/censo-arbolado-urbano` | Individuos arbóreos georreferenciados | GeoJSON, SHP | 2026-11-15 | CC BY 4.0 | Registro de censo; no refleja siembras posteriores |
| F-11 | Zona de Ronda de Protección del Río Bogotá | Secretaría Distrital de Ambiente (SDA) | `https://datosabiertos.bogota.gov.co/dataset/objeto-geografico-zona-de-ronda-de-proteccion-del-rio-bogota-urbana-rural-2018` | Ronda y franja de protección | GeoJSON, SHP | 2026-11-15 | CC BY 4.0 | Escala 2018; no sustituye estudio de riesgo |
| F-12 | Amenaza de inundación por desbordamiento. POT | SDP | `https://datosabiertos.bogota.gov.co/dataset/amenaza-de-inundacion-por-desbordamiento-bogota-d-c` | Zonas de amenaza | GeoJSON, SHP | 2026-11-15 | CC BY 4.0 | Insumo de ordenamiento, no alerta en tiempo real |
| F-13 | Establecimiento de Gastronomía y Bar | Instituto Distrital de Turismo (IDT) | `https://datosabiertos.bogota.gov.co/dataset/establecimiento-de-gastronomia-y-bar-bogota` · GeoJSON: `.../resource/ce4ae41c-dacf-4405-9cb2-a78c43d8f139/download/egba.geojson` | Restaurantes y bares registrados | GeoJSON, REST, SHP | 2026-11-15 | CC BY-SA 4.0 | Solo 184 registros en toda la ciudad y **0 en el entorno del barrio**; no cubre comercio general; el servicio REST no respondió en el tiempo de consulta |
| F-14 | Especificación GTFS - SITP | Transmilenio S.A. | `https://datosabiertos.bogota.gov.co/dataset/especificacion-gtfs-general-transport-feed-specification-sitp` | Paraderos, rutas y horarios (feed GTFS) | Documento + enlace a Hub | 2026-11-15 | CC BY-SA 4.0 | **Sin descarga directa estable** en el catálogo; requiere portal de Transmilenio |
| F-15 | Paraderos, estaciones y portales | Transmilenio / IDECA | `https://serviciosgis.catastrobogota.gov.co/arcgis/rest/services/movilidad/transportepublico/MapServer` (capas 1, 2, 5) | Paradero SITP, estación y portal TM | REST | 2026-11-15 | Términos IDECA | Capa de infraestructura; no incluye tiempos de llegada |
| F-16 | OpenStreetMap | OpenStreetMap contributors | `https://www.openstreetmap.org` · API `https://api.openstreetmap.org/api/0.6/map` | Vías, POI, parques, paraderos | XML/Overpass | 2026-11-15 | ODbL 1.0 | Cobertura comunitaria y desigual; comercio muy incompleto |

---

## 6. Evidencia de consulta (resumen reproducible)

| Consulta | Resultado |
|----------|-----------|
| `NOMBRE LIKE '%CIUDAD GRANADA%'` en F-01 | 1 registro: `LEG00645`, UPZ 82, localidad 08, 9,1 ha, 705 lotes, 3.807 hab. |
| Polígono vía REST con `outSR=4326` | 58 vértices; centroide 4,641833, -74,171758; bbox §2 |
| Manzanas F-02: bbox ±0,006° / centroide dentro del polígono | **802** polígonos en la ventana; **34** con centroide dentro del barrio, **todas estrato 2** (ver §12) |
| F-03, fila UPZ 082 / año 2025 | 133.130 hab. (66.175 H, 66.955 M) |
| F-04 bbox ±0,006° | 28 registros de sede; **1 dentro del polígono** (Colegio Alejandro Magno, Calle 40 Sur # 90B-21); **15 a ≤800 m** del centroide; 0 duplicados nombre+dirección |
| F-05 ventana ±0,01° / radio 1,1 km | 3 IPS a ≤1,1 km (la más cercana a 520 m); 50 farmacias y 53 consultorios a ≤1,1 km; **0 dentro** |
| F-06 ventana ±0,01° / radio 300 m | 90 polígonos de parque; 5 polígonos a ≤300 m, 3 de ellos son "Las Palmeras"; 3 parques con nombre (Las Palmeras 212 m, El Rosario 251 m, Urbanización El Paraíso 291 m); **0 dentro** |
| F-15 capa 5 (paradero SITP) | 160 paraderos en ±0,01°; **2 dentro** (528A08 a 72 m, 405A08 a 217 m); 53 a ≤800 m |
| F-15 capas 1 y 2 | Estación Patio Bonito a 1.246 m; Portal de las Américas a 1.419 m |
| F-08 cuadrante que cubre el centroide | CAI Bellavista · cuadrante `MEBOGMNVCCC03E08C04000011` · tel. 300 202 6917 · UPZ82 |
| OSM API, bbox del barrio | 858 nodos, 202 vías; 87 tramos residenciales, 28 terciarios, 5 parques, 4 paradas de bus, 2 colegios, **6 comercios** |
| F-09 | Capa "Delitos Alto Impacto Localidad": polígonos por localidad, sin barrio |
| F-13 | GeoJSON de gastronomía: 184 registros en Bogotá; **0** dentro del entorno consultado |

### 6.1 Método de conteo y radio

Todas las distancias son geodésicas WGS84 (`pyproj.Geod`), medidas desde el centroide **4,641833, -74,171758**. La ventana de consulta es un rectángulo, no un radio; por eso el número de registros de la ventana no debe presentarse como "a X metros".

| Consulta | Ventana / radio | Método | Resultado |
|---|---|---|---|
| Colegios | bbox del barrio ±0,006° (xmin -74,179791, ymin 4,633412, xmax -74,163695, ymax 4,650294) | `esriSpatialRelIntersects`, todos los registros, sin deduplicar | **28 sedes** |
| Colegios | radio 800 m | distancia geodésica punto–centroide ≤ 800 m | **15 sedes** |
| Colegios | dentro del polígono | `ST_Contains` / `shapely.contains` | **1 sede** |
| Colegios | duplicados | agrupación por `NOMBRE_SED` + `DIRECCION` | **0 duplicados** |
| Parques | bbox ±0,01° / radio 300 m | distancia del centroide al polígono del parque | 90 polígonos / 5 ≤300 m |
| Salud | bbox ±0,01° / radio 1,1 km | distancia punto–centroide | 13 IPS / 3 ≤1,1 km |
| Transporte | bbox ±0,01° / radio 800 m | distancia punto–centroide | 160 paraderos / 53 ≤800 m |

**Reconciliación 14 vs 28 sedes:** el informe anterior citó "14 sedes a menos de 800 m". Esa cifra provenía de un conteo parcial y queda **reemplazada** por 15, obtenida al evaluar los 28 registros de la ventana con distancia geodésica. No es un cambio de fuente ni de polígono: es la aplicación completa del método. El número 28 **no** significa "28 sedes a 800 m", sino "28 registros en la ventana rectangular"; los dos números miden cosas distintas y ahora se documentan por separado.

**Parques:** la capa contiene varios polígonos por parque (por ejemplo, tres polígonos de "Las Palmeras"). El conteo de 5 polígonos ≤300 m no equivale a 5 parques; la deduplicación por nombre/ID se hará en la fase de HU-05. Por eso no se publica aún un total de "parques cercanos".

---

## 7. Disponibilidad de datos por historia

| HU | Necesidad | Fuente | Veredicto |
|----|-----------|--------|-----------|
| HU-01 | Ficha general | F-01, F-02, F-03 | ✅ **Suficiente** (con nota de que la población es estimación) |
| HU-02 | Límites y mapa | F-01 | ✅ **Suficiente** |
| HU-03 | Lugares de interés | F-04, F-05, F-06, F-13, F-16 | 🟡 **Suficiente con curaduría** (no hay capa única de "lugares de interés") |
| HU-04 | Comercio | F-16, F-13 | 🔴 **Parcial** — OSM 6 comercios en el bbox; IDT 184 en toda la ciudad y 0 en el entorno; no existe registro abierto completo ni totalidad |
| HU-05 | Parques y zonas verdes | F-06 | 🟡 **Parcial** — 0 dentro; 5 polígonos ≤300 m (3 son "Las Palmeras"); deduplicar antes de publicar |
| HU-06 | Educación | F-04 | ✅ **Suficiente** — 28 sedes en bbox ±0,006°; 15 ≤800 m; 1 dentro; 0 duplicados nombre+dirección |
| HU-07 | Salud | F-05 | ✅ **Suficiente** (servicios cercanos; 0 dentro) |
| HU-08 | Vías y accesos | F-07, F-16 | ✅ **Suficiente** |
| HU-09 | Transporte público | F-15 | ✅ **Suficiente solo para paraderos, estaciones y portales**; ⛔ rutas, horarios y frecuencias **fuera de alcance v1** hasta tener GTFS estable |
| HU-10 | Demografía | F-03, F-01, F-02 | 🟡 **Parcial** — panel del barrio (estimación 3.807) separado del panel UPZ 082 (proyección 133.130); sin prorrateo |
| HU-11 | Seguridad y entorno | F-08, F-09, F-10, F-11, F-12 | 🟡 **Parcial** — delitos solo por **localidad 08 Kennedy**; nunca por barrio |
| HU-12 | Filtros | Datos propios | ✅ **No requiere fuente externa** |
| HU-13 | Administración | Datos propios | ✅ **No requiere fuente externa** |

**Resumen:** 8 historias implementables con datos suficientes (HU-01, 02, 06, 07, 08, 09, 12, 13), 2 con curaduría (HU-03, HU-05), 3 con limitación estructural (HU-04, HU-10, HU-11).

---

## 8. Limitaciones y alternativas realistas

| Limitación | Impacto | Alternativa documentada | Alternativa descartada |
|-----------|---------|----------------------|------------------------|
| No existe registro abierto de todos los comercios | HU-04 no puede ser exhaustiva | Mostrar OSM + IDT con aviso visible de **cobertura parcial** (no totalidad) y permitir que el administrador agregue locales con fuente verificable (HU-13) | Inventar locales, copiar listados de Google sin licencia o afirmar que el listado es completo |
| No hay proyecciones por barrio | HU-10 no puede dar edad/sexo del barrio | **Panel barrio:** estimación oficial 3.807. **Panel UPZ 082:** proyección 133.130 (2025), edad y sexo por quinquenios. Etiquetar cada panel; no sumar ni prorratear | Presentar la UPZ como barrio o prorratear por área/población sin método publicado |
| Delitos solo por localidad | HU-11 no puede dar cifras del barrio | Mostrar el indicador de la **localidad 08 Kennedy** con periodo y enlace a la fuente; complementar con cuadrante y capas ambientales | Inferir delitos por barrio a partir de la localidad o rotularlos como "Ciudad Granada" |
| Ningún parque dentro del polígono | HU-05 podría parecer vacía | Sección "parques y zonas verdes cercanas" con distancia, previa deduplicación de polígonos | Incluir parques de otros barrios como si fueran del barrio o contar polígonos como parques |
| GTFS sin descarga directa | HU-09 sin horarios | Paraderos, estaciones y portales desde F-15 | Publicar rutas, frecuencias o horarios no verificados |
| Historia del barrio sin fuente | HU-01 sin relato histórico | Omitir el relato y declarar "información no disponible" | Copiar textos de blogs o Wikipedia sin verificación |

---

## 9. Búsqueda negativa (lo que NO se encontró)

1. **Capa única de "lugares de interés"** para el barrio: no existe; debe componerse.
2. **Registro mercantil abierto** por barrio: no está en Datos Abiertos Bogotá.
3. **Proyecciones de población por barrio**: no existen en el catálogo consultado.
4. **Delitos por barrio**: la capa disponible agrega por localidad.
5. **Historia documental del barrio**: no se localizó fuente institucional verificable.
6. **Descarga directa del GTFS**: el recurso apunta a un Hub sin URL estable.
7. **Gastronomía y bares en el entorno**: el GeoJSON oficial F-13 tiene 184 registros en toda la ciudad y **0 en el entorno del barrio**; el servicio REST no respondió y se usó el archivo directo.

Ninguna de estas ausencias se suplió con datos inventados.

---

## 10. Conclusión de viabilidad

El barrio **sí** puede documentarse con fuentes oficiales verificables: existe un polígono oficial, una ficha territorial completa, estratificación, educación, salud, parques cercanos, transporte y seguridad a nivel de cuadrante/localidad. Las tres limitaciones estructurales (comercio, demografía fina y delitos) son **declarables en la interfaz** y no impiden construir la aplicación; obligan a mostrar el nivel y la fuente de cada dato.

**Siguiente paso:** la Fase 1 (fundaciones + HU-01/HU-02) está implementada y en pruebas; el ETL reprodujo las cifras de este documento. La evidencia está en [`../evidencias/fase-1/README.md`](../evidencias/fase-1/README.md). No se declaró ninguna historia `Validada` y la Fase 2 no se inició. D-7 no bloquea esta fase.

---

## 11. Ajustes de alcance aplicados (2026-11-15)

| Tema | Ajuste documentado | Dónde se aplica |
|------|--------------------|-----------------|
| Colegios 14 vs 28 | **28** = registros en bbox ±0,006°; **15** = sedes a ≤800 m; **1** = dentro. El 14 previo queda reemplazado por 15. | §6.1, HU-06, EF-06, CA-HU06-03 |
| HU-09 transporte | v1 solo paraderos, estaciones y portales. Sin rutas, horarios, frecuencias ni tiempos de llegada hasta GTFS estable. | HU-09, EF-09, CA-HU09-03 |
| HU-10 demografía | Panel barrio (estimación 3.807) separado del panel UPZ 082 (proyección 133.130). No sumar, no prorratear, no rotular la UPZ como barrio. | HU-10, EF-10, CA-HU10-01..03 |
| HU-11 seguridad | Los delitos corresponden a la **localidad 08 Kennedy**, no a Ciudad Granada. Etiqueta y periodo visibles. | HU-11, EF-11, CA-HU11-02 |
| HU-04 comercio | Inventario **parcial** (OSM 6; IDT 0 en el entorno). No representa la totalidad. Aviso visible. | HU-04, EF-04, CA-HU04-02 |
| Trazabilidad | Los ajustes no cambian IDs de HU, RF ni CA; se reflejan en la matriz y en las pruebas. | `matriz-trazabilidad.md` §5 |
| Estados | Ninguna HU se marca implementada o validada sin prueba ejecutada y evidencia. | `matriz-trazabilidad.md` |

---

## 12. Verificación de estratificación por manzana (2026-11-15)

**Fuente:** F-02, capa `Manzanas de estrato` de IDECA/UAECD:
`https://serviciosgis.catastrobogota.gov.co/arcgis/rest/services/ordenamientoterritorial/estratificacion/MapServer/1`

**Consulta ejecutada:**

| Parámetro | Valor |
|-----------|-------|
| Ventana | bbox del barrio ±0,006°: `-74.179791,4.633412,-74.163695,4.650294` |
| Filtro espacial | `esriSpatialRelIntersects` |
| Campos | `OBJECTID`, `CODIGO_MANZANA`, `ESTRATO`, `CODIGO_ZONA_ESTRATO` |
| SR de salida | `4326` |
| Formato | `geojson` |
| Fecha de consulta | 2026-11-15 |

**Resultados:**

| Nivel | Registros | Significado |
|-------|-----------|-------------|
| Ventana rectangular (bbox) | **802** polígonos | Todo lo que intersecta la ventana; **no** son manzanas del barrio |
| Centroide dentro del polígono oficial | **34** manzanas | Recorte del barrio |
| Estrato de esas 34 manzanas | **2** en las 34 | Estrato predominante = 2 |

El criterio de recorte fue **centroide dentro del polígono oficial** (`shapely.contains`), no intersección de áreas. Esto evita contar manzanas vecinas que solo tocan el borde y hace reproducible el número 34.

**Artefactos:**

| Archivo | Estado | Tamaño | SHA-256 |
|---------|--------|--------|---------|
| `docs/evidencias/fase-0/estrato-ciudad-granada.geojson` | Conservado | 98.550 bytes | `175E3BA4BAD361863B1731669AD7A9E1EFD7F2B531FA950EE170D5D8619591E9` |
| `%TEMP%\opencode\estrato_bbox.geojson` | Temporal, no versionado | 1.342.687 bytes | `23871D893F8B9C2CABD65562BD7816E578C414391FEC4C7CD52E79C36C42BDA2` |
| `docs/evidencias/fase-0/filtrar_estrato.py` | Conservado | — | — |

El archivo temporal contiene las 802 entidades del bbox; el conservado contiene solo las 34 del barrio. El script de filtro y las instrucciones de reproducción están en [`../evidencias/fase-0/README.md`](../evidencias/fase-0/README.md). La ejecución de comprobación del 2026-11-15 reprodujo el mismo SHA-256 y el conteo `{2: 34}`.

**Lectura correcta:** la ficha puede afirmar **“34 manzanas de estrato 2”**. No debe afirmar “802 manzanas” ni presentar la ventana de consulta como si fuera el barrio.
