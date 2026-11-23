# Resolución HU-03 — Lugares de interés

**Fecha:** 2026-11-19  
**Alcance:** CA-HU03-01 a CA-HU03-04. Sin commits, push ni despliegue.

## Brechas encontradas

1. El detalle no hacía explícitos descripción, coordenadas ni disponibilidad de datos.
2. No había prueba automatizada de correspondencia entre listado y marcadores.
3. La búsqueda dependía de `ILIKE`, sensible a tildes en el entorno local.

## Cambios implementados

- `PlaceDetail.tsx` muestra categoría legible, descripción, dirección, coordenadas WGS84, distancia, fuente principal y fuentes; los campos ausentes muestran **No disponible**.
- `labels.ts` centraliza etiquetas y estados de ausencia, evitando duplicación de texto.
- `lugarQueries.ts` reemplaza `ILIKE` por normalización con `translate(lower(...))`, que cubre tildes, ñ y sus mayúsculas sin depender de la extensión `unaccent` (no disponible en el runtime local).
- `LUGARES_SQL` acepta el parámetro opcional `tipo` (`$4`) para filtrar subcategorías verificables, propagado por backend → API → frontend.
- `PlaceListItem.tsx` expone `data-lugar-id`, `data-lat` y `data-lon`; `PlacesMap.tsx` genera un marcador por elemento visible y `data-centro` cuando hay selección.
- El detalle conserva las etiquetas heredadas `Identificador interno` y `Código SITP` para no romper pruebas previas de HU-09.

## Pruebas que respaldan la resolución

- `tests/unit/lugarQueries.test.ts`: normalización sin `ILIKE` y presencia del filtro `$4`.
- `tests/integration/lugarSearch.test.ts`: `q=nino` encuentra `JAIRO ANIBAL NIÑO`; filtro `tipo=supermarket`; orden por distancia.
- `tests/integration/PlaceDetail.test.tsx`: detalle completo y mensajes **No disponible**.
- `tests/acceptance/hu03-hu06.spec.ts` (HU-03): búsqueda `nino` y `NIÑO`, detalle con coordenadas/fuente y conteo igual de elementos listados y marcadores.

## Resultado

**4/4 criterios aprobados.** No se crearon datos nuevos; todas las etiquetas y valores mostrados proceden de fuentes F-04, F-15, F-16 o del contrato público.
