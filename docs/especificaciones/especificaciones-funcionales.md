# Especificaciones funcionales — 13 historias de usuario

**Versión:** 1.1 · **Fecha:** 2026-11-15
**Alcance:** definición funcional para implementación. No describe código.
**Criterios completos:** [`../requerimientos/criterios-aceptacion.md`](../requerimientos/criterios-aceptacion.md). Aquí se referencian por ID para no duplicar.
**Revisión 1.1 (2026-11-15):** ajustes de alcance en EF-04 (cobertura parcial), EF-06 (28/15/1), EF-09 (sin rutas/horarios), EF-10 (barrio vs UPZ) y EF-11 (localidad, no barrio).

Cada especificación contiene los 11 campos solicitados: identificador, nombre, descripción, actor, prioridad, precondiciones, flujo principal, flujos alternativos, resultado esperado, criterios de aceptación y requisitos relacionados.

---

## EF-01 · Información general del barrio

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-01 / RF-01 |
| **Nombre** | Ficha general del barrio |
| **Descripción** | Presenta una ficha con los datos oficiales del barrio: nombre, localidad, UPZ, UPL, área, lotes, población estimada, estrato predominante y fuentes. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Alta |
| **Precondiciones** | Existe la ficha del barrio cargada desde la fuente oficial; el servicio de consulta está disponible. |

**Flujo principal**
1. El visitante abre la página de inicio.
2. El sistema solicita la ficha del barrio.
3. El sistema valida que la respuesta tenga nombre, localidad, UPZ y fuentes.
4. El sistema muestra los datos en tarjetas, con el nivel territorial de cada indicador.
5. El visitante puede abrir la fuente de cada dato.

**Flujos alternativos**
- **A1 — Fuente no disponible:** si la consulta falla, se muestra un mensaje de error con reintento y no se muestran datos parciales sin fuente.
- **A2 — Dato ausente:** si un campo no tiene fuente, se muestra "información no disponible" y no se inventa el valor.
- **A3 — Población:** si el dato es estimación oficial, se etiqueta como "estimación" y no como censo.

**Resultado esperado:** el visitante comprende qué es el barrio, dónde está y cuáles son sus características principales, sabiendo de dónde sale cada cifra.

**Criterios de aceptación:** CA-HU01-01, CA-HU01-02, CA-HU01-03, CA-HU01-04.

**Requisitos relacionados:** RF-01, RF-14 · RNF-06, RNF-14, RNF-18 · RN-01, RN-10.

---

## EF-02 · Ubicación geográfica

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-02 / RF-02 |
| **Nombre** | Mapa y límites del barrio |
| **Descripción** | Muestra el polígono oficial del barrio en un mapa interactivo, con encuadre automático, capa base y atribución. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Alta |
| **Precondiciones** | El polígono oficial está cargado con SRID 4326 y validado (58 vértices). |

**Flujo principal**
1. El visitante abre la vista de mapa.
2. El sistema carga la capa base y solicita el GeoJSON del barrio.
3. El sistema valida que el GeoJSON sea un polígono cerrado.
4. El sistema dibuja el polígono y ajusta el encuadre a su extensión con margen.
5. El visitante interactúa (zoom, arrastre) y abre la ventana de información del polígono.
6. El sistema muestra la atribución y la fuente.

**Flujos alternativos**
- **A1 — Geometría inválida:** si el polígono no cierra o tiene menos de 3 vértices, no se dibuja y se registra el error.
- **A2 — Falla del servicio de mapa:** se muestra un aviso y un enlace a la fuente oficial; no se dibuja un límite aproximado.
- **A3 — Dispositivo móvil:** el mapa ocupa el ancho disponible y los controles son táctiles.

**Resultado esperado:** el visitante identifica con precisión la localización y los límites del barrio.

**Criterios de aceptación:** CA-HU02-01..04.

**Requisitos relacionados:** RF-02 · RNF-07, RNF-11, RNF-17 · RN-02.

---

## EF-03 · Lugares de interés

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-03 / RF-03 |
| **Nombre** | Catálogo de lugares de interés |
| **Descripción** | Ofrece un catálogo curado y georreferenciado de lugares relevantes, con búsqueda, detalle y correspondencia entre mapa y listado. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Alta |
| **Precondiciones** | Existen categorías y lugares publicados; el catálogo está cargado y validado. |

**Flujo principal**
1. El visitante abre la sección de lugares.
2. El sistema consulta los lugares publicados de forma paginada.
3. El sistema muestra el listado y los marcadores del mapa con el mismo conjunto.
4. El visitante selecciona un lugar y ve su detalle.
5. El visitante escribe en el buscador y el sistema filtra por nombre o dirección.

**Flujos alternativos**
- **A1 — Sin resultados:** se muestra un mensaje claro y la opción de limpiar la búsqueda.
- **A2 — Lugar sin coordenadas:** no se publica (RN-04); si ya existía, se despublica.
- **A3 — Categoría vacía:** la categoría no se muestra en el filtro hasta tener al menos un lugar publicado.

**Resultado esperado:** el visitante encuentra y comprende los lugares importantes de la zona.

**Criterios de aceptación:** CA-HU03-01..04.

**Requisitos relacionados:** RF-03, RF-14 · RNF-08, RNF-11 · RN-04.

---

## EF-04 · Establecimientos comerciales

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-04 / RF-04 |
| **Nombre** | Búsqueda de establecimientos comerciales |
| **Descripción** | Permite buscar comercios por nombre y filtrarlos por subcategoría, mostrando siempre la fuente y un aviso visible de **cobertura parcial**. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Media |
| **Precondiciones** | Existen establecimientos publicados procedentes de OSM (6 en el bbox), IDT (0 en el entorno) o cargados por el administrador con fuente. |

**Flujo principal**
1. El visitante abre la sección de comercio.
2. El sistema muestra los establecimientos publicados y el aviso de cobertura parcial.
3. El visitante busca por nombre o filtra por subcategoría.
4. El sistema devuelve los coincidentes y actualiza mapa, listado y contador.
5. El visitante abre el detalle y ve la fuente.

**Flujos alternativos**
- **A1 — Sin coincidencias:** mensaje "no se encontraron establecimientos" con sugerencia de limpiar filtros.
- **A2 — Dato de OSM:** se etiqueta como "fuente comunitaria" y se enlaza a OSM.
- **A3 — Servicio externo caído:** se muestran solo los datos propios ya cargados.

**Resultado esperado:** el visitante encuentra comercios cercanos sabiendo que el inventario es **parcial** y **no representa la totalidad** del barrio.

**Criterios de aceptación:** CA-HU04-01..04.

**Requisitos relacionados:** RF-04, RF-14 · RNF-14 · RN-01, RN-07 · Limitación §8 de la investigación.

---

## EF-05 · Parques y zonas verdes

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-05 / RF-05 |
| **Nombre** | Parques y zonas verdes cercanas |
| **Descripción** | Lista los parques y zonas verdes del entorno, con tipo, distancia y ubicación, distinguiendo que no se ubican dentro del polígono. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Media |
| **Precondiciones** | La capa de parques está cargada y el cálculo de distancias está verificado. |

**Flujo principal**
1. El visitante abre la sección de parques.
2. El sistema consulta los parques dentro del área de influencia (barrio + 1 km).
3. El sistema calcula la distancia al centroide y ordena ascendentemente.
4. El sistema muestra nombre, tipo y distancia, con la etiqueta "cercanas".
5. El visitante selecciona uno y el mapa lo resalta.

**Flujos alternativos**
- **A1 — Parque sin nombre:** se identifica por tipo y dirección.
- **A2 — Sin parques en el radio:** se amplía el radio y se informa.
- **A3 — Polígono fuera del área:** se excluye.

**Resultado esperado:** el visitante conoce las opciones de recreación y descanso en el entorno.

**Criterios de aceptación:** CA-HU05-01..03.

**Requisitos relacionados:** RF-05 · RNF-11 · RN-03 (nivel territorial).

---

## EF-06 · Instituciones educativas

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-06 / RF-06 |
| **Nombre** | Instituciones educativas cercanas |
| **Descripción** | Lista colegios y sedes con nombre, sector, dirección y distancia, marcando los que están dentro del barrio y limitando el listado a **≤800 m** del centroide. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Media |
| **Precondiciones** | La capa de colegios está cargada y deduplicada por sede; la ventana de consulta y el radio están documentados. |

**Flujo principal**
1. El visitante abre la sección educativa.
2. El sistema consulta las sedes de la ventana documentada (bbox ±0,006°; 28 registros).
3. El sistema deduplica por nombre de sede y dirección (0 duplicados verificados).
4. El sistema calcula la distancia geodésica, filtra las sedes a ≤800 m y marca las que están dentro del polígono.
5. El sistema muestra el listado ordenado (15 sedes ≤800 m; 1 dentro) y los marcadores.

**Flujos alternativos**
- **A1 — Sede sin coordenadas:** se excluye y se registra.
- **A2 — Duplicado por jornada:** se consolida en una sola ficha.
- **A3 — Sector desconocido:** se muestra "no informado" y no se deduce.

**Resultado esperado:** el visitante identifica la oferta educativa disponible en el sector.

**Criterios de aceptación:** CA-HU06-01..03.

**Requisitos relacionados:** RF-06 · RNF-11 · RN-04.

---

## EF-07 · Servicios de salud

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-07 / RF-07 |
| **Nombre** | Servicios de salud cercanos |
| **Descripción** | Lista prestadores de salud y farmacias con tipo, dirección y distancia, indicando que son servicios cercanos. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Media |
| **Precondiciones** | La capa de salud está cargada y clasificada por tipo. |

**Flujo principal**
1. El visitante abre la sección de salud.
2. El sistema consulta IPS, consultorios y farmacias del área de influencia.
3. El sistema clasifica cada registro por tipo.
4. El sistema calcula la distancia mínima y ordena.
5. El sistema muestra el listado con la etiqueta "cercanos" y los marcadores.

**Flujos alternativos**
- **A1 — Nombre genérico ("CONSULTORIO"):** se muestra con dirección para desambiguar.
- **A2 — Registro sin tipo:** se agrupa en "otro" y se informa.
- **A3 — Sin prestadores en el radio:** se amplía y se informa la distancia mínima.

**Resultado esperado:** el visitante conoce las alternativas de atención disponibles en el entorno.

**Criterios de aceptación:** CA-HU07-01..03.

**Requisitos relacionados:** RF-07 · RNF-11 · RN-03.

---

## EF-08 · Vías y accesos

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-08 / RF-08 |
| **Nombre** | Vías y accesos del barrio |
| **Descripción** | Visualiza la malla vial del barrio y las vías de acceso, diferenciando jerarquía, sin calcular rutas peatonales. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Media |
| **Precondiciones** | La red vial está cargada y clasificada por jerarquía. |

**Flujo principal**
1. El visitante abre la vista de vías.
2. El sistema activa la capa vial sobre el mapa.
3. El sistema dibuja los tramos según jerarquía (residencial, local, arterial).
4. El sistema resalta las vías que conectan el barrio con el entorno.
5. El visitante consulta la leyenda y la fuente.

**Flujos alternativos**
- **A1 — Tramo sin jerarquía:** se dibuja como "sin clasificar" y se informa.
- **A2 — Capa no disponible:** se muestra un aviso y no se dibuja una red aproximada.
- **A3 — Solicitud de ruta:** no se ofrece; se explica que no hay cálculo verificable.

**Resultado esperado:** el visitante reconoce cómo se accede al barrio y cómo se organiza su red vial.

**Criterios de aceptación:** CA-HU08-01..03.

**Requisitos relacionados:** RF-08 · RNF-11 · RN-02 (no dibujar a mano).

---

## EF-09 · Transporte público

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-09 / RF-09 |
| **Nombre** | Transporte público cercano |
| **Descripción** | Muestra paraderos SITP y estaciones/portales de TransMilenio cercanos, con identificador, distancia y ubicación. **No** incluye rutas, horarios, frecuencias ni tiempos de llegada. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Media |
| **Precondiciones** | Las capas F-15 de paraderos, estaciones y portales están cargadas y verificadas; no se requiere GTFS. |

**Flujo principal**
1. El visitante abre la sección de transporte.
2. El sistema consulta paraderos, estaciones y portales del área de influencia.
3. El sistema calcula distancias y ordena por cercanía.
4. El sistema muestra el listado y los marcadores diferenciados.
5. El visitante selecciona uno y el mapa lo centra.

**Flujos alternativos**
- **A1 — Paradero sin código:** se identifica por dirección.
- **A2 — Sin estaciones en el radio:** se amplía el radio y se informa.
- **A3 — Sin GTFS estable:** se declara que la versión **no incluye rutas, horarios ni frecuencias**; no se muestran datos operativos no verificados.

**Resultado esperado:** el visitante conoce la **infraestructura** de transporte público disponible, sin información operativa no confirmada.

**Criterios de aceptación:** CA-HU09-01..03.

**Requisitos relacionados:** RF-09 · RNF-11 · Limitación GTFS (§8).

---

## EF-10 · Información demográfica

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-10 / RF-10 |
| **Nombre** | Indicadores demográficos y socioeconómicos |
| **Descripción** | Presenta **dos paneles separados**: (a) barrio Ciudad Granada con la estimación oficial (3.807 hab., estrato 2, sin edad/sexo) y (b) UPZ 082 Patio Bonito con la proyección 2005–2035 (133.130 hab. en 2025, con sexo y edad). Cada panel declara su nivel, año y fuente. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Baja |
| **Precondiciones** | La serie por UPZ y la estimación del barrio están cargadas con año y fuente, en estructuras separadas. |

**Flujo principal**
1. El visitante abre la sección demográfica.
2. El sistema consulta por separado la estimación del barrio y la serie de la UPZ 082.
3. El sistema etiqueta cada panel con su nivel territorial y año.
4. El panel **barrio** muestra 3.807 hab. (estimación) y estrato 2, sin edad ni sexo; el panel **UPZ 082** muestra 133.130 hab. (2025) con sexo y edad.
5. El visitante consulta la fuente de cada panel.

**Flujos alternativos**
- **A1 — Dato solo de UPZ:** se muestra únicamente en el panel "UPZ 082" y nunca en el panel del barrio.
- **A2 — Año distinto:** se indica el año de cada cifra.
- **A3 — Sin dato de edad por barrio:** se declara la ausencia; no se prorratea la UPZ.

**Resultado esperado:** el visitante comprende el contexto social sin conclusiones falsas sobre el barrio y sin confundir la UPZ con el barrio.

**Criterios de aceptación:** CA-HU10-01..03.

**Requisitos relacionados:** RF-10 · RNF-10, RNF-14 · RN-03.

---

## EF-11 · Seguridad y entorno

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-11 / RF-11 |
| **Nombre** | Seguridad y condiciones del entorno |
| **Descripción** | Presenta el cuadrante de policía que cubre el barrio, indicadores de seguridad **agregados por la localidad 08 Kennedy** y capas ambientales, con su nivel y periodo. Los delitos nunca se atribuyen al barrio. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Baja |
| **Precondiciones** | El cuadrante y las capas ambientales están cargados; los indicadores tienen periodo. |

**Flujo principal**
1. El visitante abre la sección de seguridad y entorno.
2. El sistema muestra el CAI y el cuadrante que cubren el barrio, con teléfono.
3. El sistema muestra los indicadores disponibles con la etiqueta **"Localidad de Kennedy (08)"** y su periodo.
4. El visitante activa capas ambientales (arbolado, ronda, amenaza).
5. El sistema muestra la fuente y la escala de cada capa.

**Flujos alternativos**
- **A1 — Indicador sin barrio:** se muestra solo la agregación de Kennedy y se explica que no es una cifra del barrio.
- **A2 — Teléfono desactualizado:** se enlaza a la fuente oficial.
- **A3 — Capa ambiental sin datos para el barrio:** se informa la ausencia.

**Resultado esperado:** el visitante conoce los aspectos relevantes de seguridad y entorno sin inferencias indebidas ni atribuciones al barrio.

**Criterios de aceptación:** CA-HU11-01..03.

**Requisitos relacionados:** RF-11 · RNF-14 · RN-09.

---

## EF-12 · Filtros del mapa

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-12 / RF-12 |
| **Nombre** | Filtros por categoría |
| **Descripción** | Permite filtrar los lugares del mapa por una o varias categorías, manteniendo consistencia entre mapa, listado y contador. |
| **Actor** | Visitante (AC-01) |
| **Prioridad** | Alta |
| **Precondiciones** | Existen categorías y lugares publicados; el estado del filtro es único para mapa y listado. |

**Flujo principal**
1. El visitante abre el mapa con el catálogo.
2. El sistema muestra las categorías disponibles.
3. El visitante selecciona una o varias.
4. El sistema aplica el filtro con una sola consulta.
5. Mapa, listado y contador se actualizan con el mismo resultado.
6. El visitante limpia los filtros y vuelve al estado completo.

**Flujos alternativos**
- **A1 — Selección vacía:** se interpreta como "todas" y se informa.
- **A2 — Categoría sin lugares:** no se ofrece o se muestra deshabilitada.
- **A3 — Error de consulta:** se conserva el último resultado válido y se avisa.

**Resultado esperado:** el visitante encuentra rápidamente los sitios que le interesan.

**Criterios de aceptación:** CA-HU12-01..04.

**Requisitos relacionados:** RF-12 · RNF-07, RNF-11.

---

## EF-13 · Administración de información

| Campo | Contenido |
|-------|-----------|
| **ID** | HU-13 / RF-13 |
| **Nombre** | Gestión administrativa de lugares |
| **Descripción** | Permite al administrador autenticado crear, editar, despublicar y eliminar lugares y categorías, con validación, auditoría y protección de integridad. |
| **Actor** | Administrador (AC-02) |
| **Prioridad** | Media |
| **Precondiciones** | El administrador está autenticado; el lugar o la categoría existen para editar/eliminar. |

**Flujo principal**
1. El administrador inicia sesión.
2. El sistema valida credenciales y emite un token de sesión.
3. El administrador abre el panel y crea o edita un lugar.
4. El sistema valida campos y coordenadas dentro del área de influencia.
5. El sistema guarda el cambio y registra la auditoría (usuario, fecha, antes/después).
6. La vista pública refleja el cambio.

**Flujos alternativos**
- **A1 — Sin sesión:** 401 y redirección al inicio de sesión.
- **A2 — Datos inválidos:** errores por campo; no se modifica la base.
- **A3 — Coordenadas fuera del área:** se rechaza con mensaje explicativo.
- **A4 — Eliminar categoría con lugares:** se bloquea y se ofrece reasignar (RN-08).
- **A5 — Fuerza bruta:** rate limit y bloqueo temporal.

**Resultado esperado:** la información del barrio se mantiene organizada, actualizada y auditable.

**Criterios de aceptación:** CA-HU13-01..05.

**Requisitos relacionados:** RF-13 · RNF-05, RNF-08, RNF-16 · RN-04, RN-05, RN-06, RN-08.

---

## Matriz de cobertura de las especificaciones

| EF | HU | RF | Criterios | Flujos alternativos |
|----|----|----|-----------|---------------------|
| EF-01 | HU-01 | RF-01 | 4 | 3 |
| EF-02 | HU-02 | RF-02 | 4 | 3 |
| EF-03 | HU-03 | RF-03, RF-14 | 4 | 3 |
| EF-04 | HU-04 | RF-04, RF-14 | 4 | 3 |
| EF-05 | HU-05 | RF-05 | 3 | 3 |
| EF-06 | HU-06 | RF-06 | 3 | 3 |
| EF-07 | HU-07 | RF-07 | 3 | 3 |
| EF-08 | HU-08 | RF-08 | 3 | 3 |
| EF-09 | HU-09 | RF-09 | 3 | 3 |
| EF-10 | HU-10 | RF-10 | 3 | 3 |
| EF-11 | HU-11 | RF-11 | 3 | 3 |
| EF-12 | HU-12 | RF-12 | 4 | 3 |
| EF-13 | HU-13 | RF-13 | 5 | 5 |

13/13 historias especificadas. Ninguna implementada.
