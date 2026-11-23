# Resolución HU-05 — Parques y zonas verdes

**Fecha:** 2026-11-19  
**Alcance:** CA-HU05-01 a CA-HU05-03. Sin commits, push ni despliegue.

## Brechas encontradas

- El listado ya mostraba tipo y distancia, pero no existía una prueba que verificara ambos campos por registro.
- No había evidencia automatizada de centrado y resaltado al seleccionar un parque.

## Cambios implementados

- `PlaceListItem.tsx` expone `data-tipo` y `data-distancia` en cada registro, además de las etiquetas visibles `etiquetaTipo(lugar.tipo)` y `distanciaTexto(lugar)`.
- La distinción territorial se conserva: el título cambia a **Parques y zonas verdes cercanas** y cada registro indica **Dentro del barrio** o **Cercano**.
- `PlacesMap.tsx` centra el mapa con `flyTo` en el marcador seleccionado, aplica radio y color distintivos y expone `data-centro` para verificación.
- El `key` del marcador incluye el estado de selección, de modo que React actualiza la clase `seleccionado` de forma determinista.

## Pruebas que respaldan la resolución

- `tests/unit/placeLabels.test.ts`: formato de distancia y tipo legible.
- `tests/acceptance/hu03-hu06.spec.ts` (HU-05):
  - cada parque tiene `data-tipo` y `data-distancia` numérica;
  - el texto visible incluye distancia y condición territorial;
  - al seleccionar, `data-centro` coincide con las coordenadas del registro;
  - existe exactamente un marcador con clase `seleccionado`;
  - el número de marcadores iguala el número de registros listados.

## Resultado

**3/3 criterios aprobados.** El criterio permite resaltar el polígono *o* el marcador; esta implementación usa el marcador representativo calculado por el ETL a partir del polígono F-06.
