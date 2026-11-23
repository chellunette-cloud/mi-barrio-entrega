# Matriz de validación HU-03 a HU-06 — Fase 12

**Fecha:** 2026-11-19  
**Fuente canónica:** `docs/requerimientos/criterios-aceptacion.md` (46 criterios; esta matriz cubre los 14 de HU-03 a HU-06).  
**Leyenda:** **Aprobado** = criterio con texto original completo y evidencia automatizada; **Parcial** = parte del criterio sin evidencia; **No verificable** = faltan datos o entorno.

**Actualización Fase 12.1 (2026-11-19):** las filas de CA-HU03-01, CA-HU03-04 y CA-HU06-02 se ajustan con evidencia directa ejecutada en [`../fase-12-1/matriz-correcciones-hu-03-a-hu-06.md`](../fase-12-1/matriz-correcciones-hu-03-a-hu-06.md). El total global se recalcula en [`../fase-12-1/matriz-global-46-criterios.md`](../fase-12-1/matriz-global-46-criterios.md).

> **Nota de alcance histórico (Fase 12 / Fase 12.1):** el resumen `14 aprobados / 0 parciales / 0 no verificables` de esta matriz corresponde a la validación original de Fase 12. En la auditoría de Fase 12.1 los criterios `CA-HU03-01`, `CA-HU03-04` y `CA-HU06-02` se registraron como **Parcial** en el estado previo y se cerraron con evidencia directa reproducible (ver `../fase-12-1/matriz-correcciones-hu-03-a-hu-06.md` y `../fase-12-1/matriz-global-46-criterios.md`, donde el estado previo global es `43/3/0/0` y el actual `44/2/0/0`). Este documento conserva el resumen histórico de Fase 12 sin aplicar el recálculo posterior ni modificar los estados de los 14 criterios.

| ID | Criterio original (texto literal) | Estado | Evidencia Fase 12 |
|---|---|---|---|
| CA-HU03-01 | Dado un visitante en la sección de lugares, cuando la sección carga, entonces ve una lista de lugares publicados con nombre, categoría y dirección. | **Aprobado** | Fase 12.1: `PlaceListItem.tsx` muestra categoría + tipo + dirección; `PlaceListItem.test.tsx` (3/3) y E2E con categoría y dirección reales. |
| CA-HU03-02 | Dado un lugar del listado, cuando el visitante lo selecciona, entonces se abre su detalle con descripción, categoría, coordenadas y fuente. | **Aprobado** | `PlaceDetail.tsx`; `PlaceDetail.test.tsx`; Playwright HU-03. |
| CA-HU03-03 | Dado un conjunto de lugares publicados, cuando el visitante compara el mapa con la lista, entonces cada lugar listado tiene su marcador y cada marcador corresponde a un lugar listado. | **Aprobado** | `visibleData` compartido por lista y mapa; `data-lugar-id`; Playwright HU-03 y HU-04. |
| CA-HU03-04 | Dado un visitante que escribe un texto en el buscador, cuando la búsqueda se ejecuta, entonces se filtran los lugares cuyo nombre o dirección coinciden, sin distinguir mayúsculas ni tildes. | **Aprobado** | Fase 12.1: `lugarSearch.test.ts` (dirección `cl 40 sur`/`CL 40 SUR`, `panadería`, sin coincidencia), `lugarQueries.test.ts`, `backendClient.test.ts` y E2E. |
| CA-HU04-01 | Dado un visitante en la sección de comercio, cuando busca un término, entonces obtiene los establecimientos publicados que coinciden y un mensaje claro si no hay resultados. | **Aprobado** | Búsqueda `q` + estado vacío; `PlacesSection.test.tsx`; Playwright HU-04. |
| CA-HU04-02 | Dado un establecimiento mostrado, cuando el visitante consulta su origen, entonces ve la fuente (OSM o IDT) y una advertencia visible de **cobertura parcial** que indica que el inventario no representa la totalidad de establecimientos del barrio. | **Aprobado** | Leyenda F-16 y cobertura parcial; `PlaceDetail`; Playwright HU-04. No hay fuente IDT en los snapshots. |
| CA-HU04-03 | Dado un conjunto de establecimientos, cuando el visitante filtra por subcategoría, entonces solo se muestran los de esa subcategoría en mapa y listado. | **Aprobado (con limitación documentada)** | `tipo` desde `shop` OSM; `SubcategoryFilter.tsx`; filtro HTTP opcional; Playwright HU-04. Cobertura solo de 25 registros F-16. |
| CA-HU04-04 | Dado que no hay registro oficial completo, cuando no existe información de un negocio, entonces no se crea ni se completa manualmente sin fuente. | **Aprobado** | `commerceMapper.test.ts`; manifest F-16; sin nuevos campos ni datos sintéticos. |
| CA-HU05-01 | Dado un visitante en la sección de parques, cuando la sección carga, entonces ve los parques y zonas verdes con nombre, tipo y distancia al barrio. | **Aprobado** | `data-tipo`/`data-distancia`; `placeLabels.test.ts`; Playwright HU-05. |
| CA-HU05-02 | Dado que ningún parque cae dentro del polígono, cuando se muestra la sección, entonces el título indica "parques y zonas verdes cercanas" y no "del barrio". | **Aprobado** | Título condicional en `PlacesSection.tsx`; etiqueta `Cercano`; Playwright HU-05. |
| CA-HU05-03 | Dado un parque del listado, cuando el visitante lo selecciona, entonces el mapa centra y resalta su polígono o marcador. | **Aprobado (marcador)** | `MapFocus` + `class="... seleccionado"`; `data-centro`; Playwright HU-05. Se usa el marcador del centroide, permitido por el criterio. |
| CA-HU06-01 | Dado un visitante en la sección educativa, cuando la sección carga, entonces ve nombre del establecimiento, sede, sector (oficial/privado), dirección y distancia. | **Aprobado** | `PlaceDetail.tsx` con sede/naturaleza/dirección/distancia; `PlaceDetail.test.tsx`; Playwright HU-06. |
| CA-HU06-02 | Dado que existe una sede dentro del polígono, cuando el visitante revisa el listado, entonces esa sede aparece marcada como "dentro del barrio". | **Aprobado** | Fase 12.1: `PlaceListItem.test.tsx` comprueba dentro/fuera/sin evidencia; E2E verifica ambas etiquetas en el listado de sedes. |
| CA-HU06-03 | Dado un listado de instituciones, cuando el visitante lo consulta, entonces está ordenado por distancia ascendente desde el centroide del barrio y solo incluye las sedes a **≤800 m** (distancia geodésica); las de la ventana de consulta que superan 800 m no se listan. | **Aprobado** | `ORDER BY l.distancia_m` + filtro `<=800`; `lugarSearch.test.ts`; Playwright HU-06. |

## Resumen

| Estado | Cantidad |
|---|---:|
| Aprobado | 14 |
| Parcial | 0 |
| No verificable | 0 |

**Criterios pendientes en HU-03 a HU-06:** ninguno. Las limitaciones de cobertura y representación se registran en `decisiones-y-limitaciones.md` y no alteran el texto original de los criterios.
