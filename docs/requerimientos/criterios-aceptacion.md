# Criterios de aceptación — 13 historias de usuario

**Versión:** 1.1 · **Fecha:** 2026-11-15
**Formato:** Dado–Cuando–Entonces (Gherkin simplificado).
**Regla:** un criterio solo se marca cumplido cuando existe una prueba ejecutada y su evidencia registrada en la matriz de trazabilidad.
**Revisión 1.1 (2026-11-15):** se precisaron CA-HU04-02, CA-HU06-03, CA-HU09-03, CA-HU10-02 y CA-HU11-02. No cambiaron IDs ni el total de 46 criterios.

> **Estado vigente a 22 de noviembre de 2026:** los 46 criterios definidos en este documento están registrados como **aprobados de forma acumulada** en la [matriz canónica de Fase 13](../evidencias/fase-13/matriz-global-46-criterios.md) (46/46). La regresión remota de Fase 14.7 (`44979541605`, `success`, 36/36 pruebas en 15 archivos) cubre los recorridos de las pruebas Playwright y **no ejecutó individualmente los 46 criterios**. Este aviso no declara despliegue, PT-01, PT-02, auditoría WCAG formal ni aceptación académica.

Nomenclatura: `CA-HUxx-nn`.

---

## HU-01 · Información general del barrio

**CA-HU01-01 — Ficha visible**
Dado un visitante en la página de inicio,
cuando la página termina de cargar,
entonces ve el nombre oficial del barrio, localidad, UPZ, UPL, área, lotes y población estimada.

**CA-HU01-02 — Procedencia del dato**
Dado un dato de la ficha,
cuando el visitante consulta su fuente,
entonces ve la entidad responsable, la URL y la fecha de consulta del dato.

**CA-HU01-03 — Sin invención**
Dado que no existe fuente documental para un texto histórico,
cuando se construye la ficha,
entonces el campo no se publica y se muestra "información no disponible" en lugar de un texto inventado.

**CA-HU01-04 — Accesibilidad**
Dado un visitante que navega solo con teclado,
cuando recorre la ficha,
entonces puede leer todo el contenido y el foco es visible en cada elemento interactivo.

---

## HU-02 · Ubicación geográfica

**CA-HU02-01 — Polígono oficial**
Dado un visitante en la vista de mapa,
cuando se carga la capa del barrio,
entonces se dibuja el polígono oficial de la SDP (no un rectángulo ni un límite dibujado a mano).

**CA-HU02-02 — Encuadre**
Dado que el polígono se dibujó,
cuando el mapa se inicializa,
entonces el encuadre contiene el polígono completo con un margen visible y el centroide calculado por el sistema coincide con el almacenado (tolerancia ≤ 5 m).

**CA-HU02-03 — Interacción**
Dado un visitante con ratón o pantalla táctil,
cuando arrastra y hace zoom,
entonces el polígono permanece correctamente georreferenciado y se puede cerrar/abrir su ventana de información.

**CA-HU02-04 — Fuente visible**
Dado el mapa en pantalla,
cuando el visitante busca la atribución,
entonces ve la fuente del polígono y la licencia correspondiente.

---

## HU-03 · Lugares de interés

**CA-HU03-01 — Listado**
Dado un visitante en la sección de lugares,
cuando la sección carga,
entonces ve una lista de lugares publicados con nombre, categoría y dirección.

**CA-HU03-02 — Detalle**
Dado un lugar del listado,
cuando el visitante lo selecciona,
entonces se abre su detalle con descripción, categoría, coordenadas y fuente.

**CA-HU03-03 — Correspondencia mapa–lista**
Dado un conjunto de lugares publicados,
cuando el visitante compara el mapa con la lista,
entonces cada lugar listado tiene su marcador y cada marcador corresponde a un lugar listado.

**CA-HU03-04 — Búsqueda**
Dado un visitante que escribe un texto en el buscador,
cuando la búsqueda se ejecuta,
entonces se filtran los lugares cuyo nombre o dirección coinciden, sin distinguir mayúsculas ni tildes.

---

## HU-04 · Establecimientos comerciales

**CA-HU04-01 — Búsqueda por nombre**
Dado un visitante en la sección de comercio,
cuando busca un término,
entonces obtiene los establecimientos publicados que coinciden y un mensaje claro si no hay resultados.

**CA-HU04-02 — Fuente y cobertura**
Dado un establecimiento mostrado,
cuando el visitante consulta su origen,
entonces ve la fuente (OSM o IDT) y una advertencia visible de **cobertura parcial** que indica que el inventario no representa la totalidad de establecimientos del barrio.

**CA-HU04-03 — Subcategorías**
Dado un conjunto de establecimientos,
cuando el visitante filtra por subcategoría,
entonces solo se muestran los de esa subcategoría en mapa y listado.

**CA-HU04-04 — Sin datos inventados**
Dado que no hay registro oficial completo,
cuando no existe información de un negocio,
entonces no se crea ni se completa manualmente sin fuente.

---

## HU-05 · Parques y zonas verdes

**CA-HU05-01 — Listado con tipo**
Dado un visitante en la sección de parques,
cuando la sección carga,
entonces ve los parques y zonas verdes con nombre, tipo y distancia al barrio.

**CA-HU05-02 — Distinción territorial**
Dado que ningún parque cae dentro del polígono,
cuando se muestra la sección,
entonces el título indica "parques y zonas verdes cercanas" y no "del barrio".

**CA-HU05-03 — Mapa**
Dado un parque del listado,
cuando el visitante lo selecciona,
entonces el mapa centra y resalta su polígono o marcador.

---

## HU-06 · Instituciones educativas

**CA-HU06-01 — Ficha educativa**
Dado un visitante en la sección educativa,
cuando la sección carga,
entonces ve nombre del establecimiento, sede, sector (oficial/privado), dirección y distancia.

**CA-HU06-02 — Colegio del barrio identificado**
Dado que existe una sede dentro del polígono,
cuando el visitante revisa el listado,
entonces esa sede aparece marcada como "dentro del barrio".

**CA-HU06-03 — Orden por cercanía**
Dado un listado de instituciones,
cuando el visitante lo consulta,
entonces está ordenado por distancia ascendente desde el centroide del barrio y solo incluye las sedes a **≤800 m** (distancia geodésica); las de la ventana de consulta que superan 800 m no se listan.

---

## HU-07 · Servicios de salud

**CA-HU07-01 — Prestadores y farmacias**
Dado un visitante en la sección de salud,
cuando la sección carga,
entonces ve prestadores de salud y farmacias con nombre, tipo, dirección y distancia.

**CA-HU07-02 — Tipo distinguido**
Dado un elemento del listado,
cuando el visitante lo revisa,
entonces puede distinguir si es IPS, consultorio o farmacia.

**CA-HU07-03 — Cercanía declarada**
Dado que no hay prestadores dentro del polígono,
cuando se muestra la sección,
entonces se indica que los servicios son "cercanos" y se muestra la distancia mínima.

---

## HU-08 · Vías y accesos

**CA-HU08-01 — Trazado vial**
Dado un visitante en la vista de vías,
cuando activa la capa,
entonces se dibuja la malla vial del barrio y su jerarquía (residencial, local, arterial).

**CA-HU08-02 — Vías de acceso**
Dado el conjunto de vías,
cuando el visitante consulta los accesos,
entonces se resaltan las vías que conectan el barrio con su entorno.

**CA-HU08-03 — Sin rutas inventadas**
Dado que no se calculan rutas peatonales,
cuando el visitante usa la vista,
entonces no se muestra ninguna ruta sugerida sin cálculo verificable.

---

## HU-09 · Transporte público

**CA-HU09-01 — Paraderos**
Dado un visitante en la sección de transporte,
cuando la sección carga,
entonces ve los paraderos SITP cercanos con código, distancia y ubicación.

**CA-HU09-02 — Estaciones y portales**
Dado el conjunto de estaciones,
cuando el visitante consulta el listado,
entonces ve la estación y el portal de TransMilenio más cercanos con su distancia.

**CA-HU09-03 — Mapa y alcance sin horarios**
Dado un paradero o estación,
cuando el visitante lo selecciona,
entonces el mapa lo centra y muestra su identificador, y la interfaz **no** presenta rutas, horarios, frecuencias ni tiempos de llegada como información confirmada.

---

## HU-10 · Información demográfica

**CA-HU10-01 — Nivel territorial explícito**
Dado un indicador demográfico,
cuando el visitante lo consulta,
entonces ve si el dato corresponde al barrio o a la UPZ.

**CA-HU10-02 — Indicadores separados por nivel**
Dado un visitante en la sección demográfica,
cuando la sección carga,
entonces ve **dos paneles separados y etiquetados**: (a) **Barrio Ciudad Granada**, con la estimación oficial de 3.807 habitantes y estrato 2, sin edad ni sexo; y (b) **UPZ 082 Patio Bonito**, con la proyección de 133.130 habitantes para 2025 y su distribución por sexo y edad, cada uno con año y fuente.

**CA-HU10-03 — Prohibición de inferencia**
Dado que la proyección por edad y sexo es de UPZ,
cuando se muestra,
entonces no se presenta como dato del barrio ni se prorratea sin método documentado.

---

## HU-11 · Seguridad y entorno

**CA-HU11-01 — Cuadrante**
Dado un visitante en la sección de seguridad,
cuando la sección carga,
entonces ve el CAI y el cuadrante que cubren el barrio, con teléfono de contacto.

**CA-HU11-02 — Agregación declarada**
Dado un indicador de delitos,
cuando el visitante lo consulta,
entonces ve la etiqueta **"Localidad de Kennedy (08)"**, el periodo y la fuente, y en ningún lugar se presenta como cifra del barrio Ciudad Granada.

**CA-HU11-03 — Entorno**
Dado un visitante que activa capas ambientales,
cuando se cargan,
entonces ve arbolado, ronda o amenaza de inundación con su fuente y escala.

---

## HU-12 · Filtros del mapa

**CA-HU12-01 — Filtro simple**
Dado un visitante en el mapa,
cuando selecciona una categoría,
entonces el mapa y el listado muestran solo esa categoría.

**CA-HU12-02 — Filtro múltiple**
Dado un visitante que selecciona varias categorías,
cuando aplica el filtro,
entonces se muestran los lugares de cualquiera de las categorías seleccionadas.

**CA-HU12-03 — Consistencia**
Dado un filtro aplicado,
cuando el visitante compara contador, mapa y listado,
entonces los tres coinciden en número y elementos.

**CA-HU12-04 — Restablecer**
Dado un filtro activo,
cuando el visitante pulsa "limpiar filtros",
entonces se muestran todos los lugares publicados.

---

## HU-13 · Administración de información

**CA-HU13-01 — Acceso restringido**
Dado un usuario no autenticado,
cuando intenta acceder al panel de administración,
entonces recibe 401 y no ve datos de gestión.

**CA-HU13-02 — Crear lugar**
Dado un administrador autenticado,
cuando crea un lugar con datos válidos y coordenadas dentro del área de influencia,
entonces el lugar se guarda, se publica y queda auditado.

**CA-HU13-03 — Validación**
Dado un administrador que envía un formulario incompleto o con coordenadas fuera del área,
cuando guarda,
entonces recibe errores de validación por campo y no se modifica la base.

**CA-HU13-04 — Editar y despublicar**
Dado un lugar existente,
cuando el administrador lo edita o lo despublica,
entonces el cambio se refleja en la vista pública y queda registrado con usuario, fecha y valores anteriores.

**CA-HU13-05 — Eliminar con protección**
Dado un lugar asociado a una categoría,
cuando el administrador intenta eliminar la categoría,
entonces el sistema lo impide y ofrece reasignar los lugares (RN-08).

---

## Cobertura

| HU | Criterios | HU | Criterios |
|----|-----------|----|-----------|
| HU-01 | 4 | HU-08 | 3 |
| HU-02 | 4 | HU-09 | 3 |
| HU-03 | 4 | HU-10 | 3 |
| HU-04 | 4 | HU-11 | 3 |
| HU-05 | 3 | HU-12 | 4 |
| HU-06 | 3 | HU-13 | 5 |
| HU-07 | 3 | **Total** | **46** |

**Estado histórico (2026-11-15):** Todos los criterios estaban en estado **Pendiente de verificación** en la versión original. El estado vigente es el aviso «Estado vigente a 22 de noviembre de 2026» al inicio de este documento y la [matriz canónica de Fase 13](../evidencias/fase-13/matriz-global-46-criterios.md), con 46/46 criterios aprobados acumulados.
