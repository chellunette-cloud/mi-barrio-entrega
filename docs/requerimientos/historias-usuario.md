# Historias de usuario — Mi Barrio, Ciudad Granada

**Versión:** 1.3 · **Fecha:** 2026-11-22
**Convención:** `HU-NN`. Actor: `AC-01` Visitante, `AC-02` Administrador.
**Revisión 1.1 (2026-11-15):** se aplicaron los ajustes de alcance para HU-04 (cobertura parcial), HU-06 (método 28/15/1), HU-09 (sin rutas/horarios), HU-10 (barrio vs UPZ) y HU-11 (localidad, no barrio). No cambiaron IDs ni el número de historias.
**Revisión 1.2 (2026-11-15):** HU-01 y HU-02 pasan a `En pruebas` con evidencia real de Fase 1. Las demás siguen `Registrada`; no hay historias `Validadas` ni `Desplegadas`.
**Revisión 1.3 (2026-11-22):** se añade la §2.1 con los **criterios de aceptación aprobados en la matriz canónica**. No cambian IDs, criterios ni los estados históricos de las revisiones anteriores.
Estados permitidos: `Registrada` → `En análisis` → `Aprobada` → `En desarrollo` → `En pruebas` → `Validada` → `Desplegada`.
**Estado vigente:** ver §2.1. El sistema está desplegado en Render desde la Fase 15.2 con P0-01 NO APROBADO y P0-02 aprobado para la integridad consultada; no se declara aceptación académica.

---

## 1. Registro de las 13 historias

| ID | Historia | Actor | Prioridad | Depende de | RF | RNF principales | Estado |
|----|----------|-------|-----------|------------|----|-----------------|--------|
| HU-01 | Información general del barrio | AC-01 | Alta | — | RF-01 | RNF-06, RNF-14 | En pruebas |
| HU-02 | Ubicación geográfica | AC-01 | Alta | HU-01 | RF-02 | RNF-17, RNF-11 | En pruebas |
| HU-03 | Lugares de interés | AC-01 | Alta | HU-02 | RF-03, RF-14 | RNF-08, RNF-11 | En desarrollo |
| HU-04 | Establecimientos comerciales | AC-01 | Media | HU-03, HU-12 | RF-04, RF-14 | RNF-14 | En desarrollo |
| HU-05 | Parques y zonas verdes | AC-01 | Media | HU-03 | RF-05 | RNF-11 | En desarrollo |
| HU-06 | Instituciones educativas | AC-01 | Media | HU-03 | RF-06 | RNF-11 | En desarrollo |
| HU-07 | Servicios de salud | AC-01 | Media | HU-03 | RF-07 | RNF-11 | Registrada |
| HU-08 | Vías y accesos | AC-01 | Media | HU-02 | RF-08 | RNF-11 | Registrada |
| HU-09 | Transporte público | AC-01 | Media | HU-02 | RF-09 | RNF-11 | Registrada |
| HU-10 | Información demográfica | AC-01 | Baja | HU-01 | RF-10 | RNF-10, RNF-14 | Registrada |
| HU-11 | Seguridad y entorno | AC-01 | Baja | HU-02 | RF-11 | RNF-14, RN-09 | Registrada |
| HU-12 | Filtros del mapa | AC-01 | Alta | HU-03 | RF-12 | RNF-07, RNF-11 | Registrada |
| HU-13 | Administración de información | AC-02 | Media | HU-03 | RF-13 | RNF-05, RNF-08 | Registrada |

### Criterio de priorización

- **Alta:** sostiene el resto de la aplicación (ficha, mapa, catálogo, filtros). Sin ellas no hay producto demostrable.
- **Media:** completa la utilidad pública con datos oficiales disponibles; requiere curaduría.
- **Baja:** depende de datos agregados o de menor granularidad; se entrega con limitaciones declaradas.

### 2.1 Estado actual según la matriz canónica (2026-11-22)

La tabla siguiente resume los **criterios de aceptación aprobados en la matriz canónica** [`../evidencias/fase-13/matriz-global-46-criterios.md`](../evidencias/fase-13/matriz-global-46-criterios.md), que registra 46/46 aprobados. La regresión remota de Fase 14.7 se documenta en [`../evidencias/fase-14-7/ejecucion-e2e-remota.md`](../evidencias/fase-14-7/ejecucion-e2e-remota.md).

| HU | Criterios aprobados | Total |
|---|---:|---:|
| HU-01 | 4 | 4 |
| HU-02 | 4 | 4 |
| HU-03 | 4 | 4 |
| HU-04 | 4 | 4 |
| HU-05 | 3 | 3 |
| HU-06 | 3 | 3 |
| HU-07 | 3 | 3 |
| HU-08 | 3 | 3 |
| HU-09 | 3 | 3 |
| HU-10 | 3 | 3 |
| HU-11 | 3 | 3 |
| HU-12 | 4 | 4 |
| HU-13 | 5 | 5 |
| **Total** | **46** | **46** |

**Alcance:** estos valores reflejan **criterios de aceptación aprobados en la matriz canónica**; no implican una ejecución individual de los 46 criterios en el run remoto, ni sistema desplegado, ni que el profesor haya realizado la aceptación académica. Las filas `Estado:` de la §2 se conservan como registro histórico de las versiones 1.1 y 1.2.

---

## 2. Fichas de historia

### HU-01 · Información general del barrio
**Como** visitante, **quiero** consultar una descripción general del barrio Ciudad Granada, **para** conocer su ubicación y características principales.

- **Actor:** AC-01 · **Prioridad:** Alta · **Estado:** En pruebas
- **Dependencias:** ninguna
- **Requisitos:** RF-01 · RNF-06, RNF-14
- **Datos disponibles:** ficha oficial SDP/UAECD (nombre, UPZ 82 Patio Bonito, localidad 08 Kennedy, UPL14, 9,1 ha, 705 lotes, 3.807 hab. estimados), estrato 2 (34 manzanas), proyección UPZ.
- **Restricción:** no se publicará historia del barrio sin fuente documental (RN-10).

### HU-02 · Ubicación geográfica
**Como** visitante, **quiero** visualizar la ubicación geográfica del barrio en un mapa interactivo, **para** identificar sus límites y localización.

- **Actor:** AC-01 · **Prioridad:** Alta · **Estado:** En pruebas
- **Dependencias:** HU-01 (ficha y nombre oficial)
- **Requisitos:** RF-02 · RNF-17, RNF-11
- **Datos disponibles:** polígono oficial de 58 vértices, centroide **4,641833, -74,171758**, SRID 4326. El centroide anterior (4,641641, -74,171701) se descartó por ser un punto de etiqueta a 22 m.
- **Restricción:** el polígono no se dibuja manualmente (RN-02).

### HU-03 · Lugares de interés
**Como** visitante, **quiero** consultar los lugares de interés del barrio, **para** conocer los espacios importantes de la zona.

- **Actor:** AC-01 · **Prioridad:** Alta · **Estado:** En desarrollo
- **Dependencias:** HU-02
- **Requisitos:** RF-03, RF-14 · RNF-08, RNF-11
- **Datos disponibles:** capas oficiales de parques, colegios, salud, equipamientos culturales y comunales; se consolidan en un catálogo curado.
- **Restricción:** "lugar de interés" no es una capa única; la selección se documenta y se aprueba.

### HU-04 · Establecimientos comerciales
**Como** visitante, **quiero** buscar establecimientos comerciales, **para** encontrar tiendas, restaurantes y otros servicios cercanos.

- **Actor:** AC-01 · **Prioridad:** Media · **Estado:** En desarrollo
- **Dependencias:** HU-03, HU-12
- **Requisitos:** RF-04, RF-14 · RNF-14
- **Datos disponibles:** **6 comercios OSM** en el bbox del barrio y **0 registros IDT** de gastronomía/bares en el entorno (184 en toda la ciudad).
- **Limitación:** **cobertura parcial**: no existe registro abierto de todos los establecimientos y este inventario **no representa la totalidad** del barrio. Se mostrará la fuente, la fecha y un aviso visible de cobertura.

### HU-05 · Parques y zonas verdes
**Como** visitante, **quiero** consultar los parques y zonas verdes del barrio, **para** identificar los espacios destinados a la recreación y el descanso.

- **Actor:** AC-01 · **Prioridad:** Media · **Estado:** En desarrollo
- **Dependencias:** HU-03
- **Requisitos:** RF-05 · RNF-11
- **Datos disponibles:** capa SDP de Parques POT. Ningún polígono cae dentro del barrio; el más cercano es "Las Palmeras" (parque de bolsillo) a 212 m. La capa contiene varios polígonos por parque, que se deduplicarán en la fase de HU-05.
- **Restricción:** se rotulará como "parques cercanos", no "parques del barrio".

### HU-06 · Instituciones educativas
**Como** visitante, **quiero** conocer los centros educativos cercanos, **para** identificar las instituciones disponibles en el sector.

- **Actor:** AC-01 · **Prioridad:** Media · **Estado:** En desarrollo
- **Dependencias:** HU-03
- **Requisitos:** RF-06 · RNF-11
- **Datos disponibles:** SED. **1 colegio dentro** del polígono (Colegio Alejandro Magno, Calle 40 Sur # 90B-21); **15 sedes a ≤800 m** del centroide. La ventana de consulta (bbox ±0,006°) devuelve **28 registros**; el "14" de una versión anterior era un conteo parcial y queda reemplazado. Método y radio en `investigacion/fuentes-territoriales.md` §6.1.

### HU-07 · Servicios de salud
**Como** visitante, **quiero** consultar los centros de salud y servicios médicos cercanos, **para** conocer las alternativas de atención disponibles.

- **Actor:** AC-01 · **Prioridad:** Media · **Estado:** En desarrollo
- **Dependencias:** HU-03
- **Requisitos:** RF-07 · RNF-11
- **Datos disponibles:** SDS. 3 IPS a ≤1,1 km (la más cercana a 520 m), 50 farmacias y 53 consultorios a ≤1,1 km (registros; 49 y 52 únicos por nombre+dirección).
- **Limitación:** ningún prestador dentro del polígono; se muestra como "servicios cercanos".

### HU-08 · Vías y accesos
**Como** visitante, **quiero** visualizar las vías y rutas de acceso al barrio, **para** reconocer las posibilidades de desplazamiento.

- **Actor:** AC-01 · **Prioridad:** Media · **Estado:** En desarrollo
- **Dependencias:** HU-02
- **Requisitos:** RF-08 · RNF-11
- **Datos disponibles:** red vial OSM verificada (87 tramos residenciales, 28 terciarios) + capa SDP de malla vial intermedia.
- **Restricción:** no se publican rutas peatonales sugeridas sin cálculo verificable.

### HU-09 · Transporte público
**Como** visitante, **quiero** consultar información sobre el transporte público disponible, **para** conocer las alternativas de movilidad.

- **Actor:** AC-01 · **Prioridad:** Media · **Estado:** En desarrollo
- **Dependencias:** HU-02
- **Requisitos:** RF-09 · RNF-11
- **Datos disponibles:** 160 paraderos SITP en la ventana ±0,01°, **2 dentro del barrio** (528A08 a 72 m, 405A08 a 217 m); 53 a ≤800 m. Estación Patio Bonito a 1.246 m y Portal de las Américas a 1.419 m.
- **Alcance v1 (definido 2026-11-15):** solo **paraderos, estaciones y portales** con código, nombre, distancia y ubicación. **No** se publican rutas, horarios, frecuencias ni tiempos de llegada.
- **Limitación:** el feed GTFS oficial no tiene descarga directa estable en el catálogo; cualquier dato de ruta/horario queda fuera de alcance hasta verificarlo.

### HU-10 · Información demográfica
**Como** visitante, **quiero** consultar información demográfica y características de la población, **para** comprender mejor el contexto social del barrio.

- **Actor:** AC-01 · **Prioridad:** Baja · **Estado:** Registrada
- **Dependencias:** HU-01
- **Requisitos:** RF-10 · RNF-10, RNF-14
- **Datos disponibles — dos niveles separados:**
  - **Barrio Ciudad Granada (estimación oficial SDP, no proyección):** 3.807 habitantes; estrato 2 (34 manzanas). Sin desagregación por edad o sexo; sin serie temporal.
  - **UPZ 082 Patio Bonito (proyección SDP 2005–2035):** 133.130 habitantes en 2025 (66.175 H, 66.955 M), con edad y sexo por quinquenios.
- **Limitación:** no existen proyecciones por barrio (RN-03). Los dos paneles se muestran separados y etiquetados; **nunca** se suman, se prorratean ni se presenta la UPZ como si fuera el barrio.

### HU-11 · Seguridad y entorno
**Como** visitante, **quiero** consultar información sobre seguridad y condiciones del entorno, **para** conocer aspectos relevantes de la zona.

- **Actor:** AC-01 · **Prioridad:** Baja · **Estado:** Registrada
- **Dependencias:** HU-02
- **Requisitos:** RF-11 · RNF-14, RN-09
- **Datos disponibles:** cuadrante de policía (CAI Bellavista, tel. 300 202 6917), capas ambientales (arbolado, ronda, amenaza de inundación) y delitos **agregados por la localidad 08 Kennedy**.
- **Limitación:** los datos delictivos **corresponden a Kennedy, no al barrio Ciudad Granada**; no hay cifras por barrio y no se infieren ni prorratean. Se muestran con la etiqueta "Localidad de Kennedy", periodo y fuente.

### HU-12 · Filtros del mapa
**Como** visitante, **quiero** filtrar los lugares del mapa por categorías, **para** encontrar fácilmente los sitios que me interesan.

- **Actor:** AC-01 · **Prioridad:** Alta · **Estado:** Registrada
- **Dependencias:** HU-03
- **Requisitos:** RF-12 · RNF-07, RNF-11
- **Datos disponibles:** no requiere fuente externa; depende del catálogo y sus categorías.
- **Restricción:** el filtro se refleja en mapa y listado de forma consistente (misma consulta).

### HU-13 · Administración de información
**Como** administrador, **quiero** actualizar y gestionar la información del barrio, **para** mantener los datos de la aplicación organizados y actualizados.

- **Actor:** AC-02 · **Prioridad:** Media · **Estado:** Registrada
- **Dependencias:** HU-03 (modelo de lugares)
- **Requisitos:** RF-13 · RNF-05, RNF-08
- **Datos disponibles:** no requiere fuente externa; opera sobre la base propia.
- **Restricción:** autenticación obligatoria, auditoría de cambios y validación de coordenadas (RN-04, RN-05, RN-06).

---

## 3. Casos de uso derivados

| CU | Nombre | Actor | HUs |
|----|--------|-------|-----|
| CU-01 | Consultar ficha del barrio | Visitante | HU-01 |
| CU-02 | Explorar el mapa y límites | Visitante | HU-02, HU-08 |
| CU-03 | Explorar lugares y filtrar | Visitante | HU-03, HU-05, HU-06, HU-07, HU-12 |
| CU-04 | Buscar un establecimiento | Visitante | HU-04 |
| CU-05 | Consultar movilidad | Visitante | HU-09 |
| CU-06 | Consultar contexto social | Visitante | HU-10, HU-11 |
| CU-07 | Gestionar lugares | Administrador | HU-13 |

---

## 4. Nota de honestidad documental

Ninguna historia se marca como `Validada` ni `Desplegada`. HU-01 y HU-02 están en `En pruebas` con la evidencia de Fase 1; las demás siguen `Registrada`. El avance real, las pruebas ejecutadas y los pendientes se mantienen en la matriz de trazabilidad.
