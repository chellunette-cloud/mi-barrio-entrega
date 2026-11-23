# Resolución HU-04 — Establecimientos comerciales

**Fecha:** 2026-11-19  
**Alcance:** CA-HU04-01 a CA-HU04-04. Sin commits, push ni despliegue.

## Investigación de fuentes

- `data/source/manifest.json` registra F-16 (OpenStreetMap contributors, ODbL 1.0, consultada 2026-11-15) y describe 25 establecimientos con etiqueta `shop` en la ventana del barrio.
- El snapshot contiene 87 elementos con `shop`; el ETL filtra por bbox y obtiene exactamente 25, de acuerdo con el manifiesto.
- Los 15 valores reales dentro del barrio son: `supermarket`, `bakery`, `greengrocer`, `convenience`, `hardware`, `clothes`, `shoes`, `butcher`, `chemist`, `stationery`, `furniture`, `tyres`, `beauty`, `confectionery`, `travel_agency`.
- No existe en los snapshots una fuente IDT con clasificación comercial alternativa, por lo que no se inventó ninguna categoría.

## Decisión

La subcategoría ya estaba disponible de forma verificable en `tipo`, alimentado desde `tags.shop` por `commerceMapper.ts`. Se reutiliza ese campo; no se agregó una columna ni un diccionario inventado. Las etiquetas en español son traducciones documentadas de esos valores OSM.

## Cambios implementados

- Filtro opcional `tipo` en contratos interno y público, con validación `maxLength: 60` y propagación backend → API → frontend.
- `SubcategoryFilter.tsx` ofrece un selector con las subcategorías deducidas de los registros de comercio cargados desde la API.
- `PlacesSection.tsx` envía `categoria=comercio` y `tipo=<shop>` cuando se selecciona una subcategoría; la lista y el mapa comparten el mismo conjunto filtrado.
- Se mantiene visible la leyenda de cobertura parcial y la procedencia F-16.
- El buscador existente produce un mensaje claro cuando no hay coincidencias.

## Pruebas que respaldan la resolución

- `tests/unit/commerceMapper.test.ts`: 25 semillas, todas con `tipo` OSM y fuente F-16.
- `tests/integration/placesHttp.test.ts` y `tests/integration/lugarSearch.test.ts`: filtro `tipo` en HTTP y PostgreSQL.
- `tests/integration/http.test.ts` y `tests/integration/backendClient.test.ts` (API): propagación y codificación de `q`/`tipo`.
- `tests/integration/PlacesSection.test.tsx`: selección `supermarket`, sincronización lista/mapa y estado vacío.
- `tests/acceptance/hu03-hu06.spec.ts` (HU-04): procedencia visible, solo `tipo=supermarket` y mensaje de sin resultados.

## Resultado

**4/4 criterios aprobados**, con la limitación de cobertura parcial documentada en `decisiones-y-limitaciones.md`.
