# Resolución HU-06 — Instituciones educativas

**Fecha:** 2026-11-19  
**Alcance:** CA-HU06-01 a CA-HU06-03. Sin commits, push ni despliegue.

## Datos verificables utilizados

- Fuente F-04, Secretaría de Educación (SED), snapshot `colegios-ciudad-granada.geojson`.
- 12 sedes dentro de la ventana de consulta; `SECTOR=2` → `oficial`, `SECTOR=1` → `privado`, otro valor → `no informado`.
- `NOMBRE_SED` se muestra como **Sede**, `DIRECCION` como dirección y `distancia_m` como distancia geodésica al centroide.
- El señalamiento **Dentro del barrio / Fuera del polígono, en el entorno** usa el campo calculado `dentro_barrio`.

## Cambios implementados

- `PlaceDetail.tsx` muestra para educación: nombre, sede, sector/naturaleza, descripción, dirección, coordenadas, distancia, fuente e identificador interno.
- La naturaleza pública/privada solo se afirma cuando `sector` es `oficial` o `privado`; en caso contrario se muestra **No informada por la fuente**.
- Se mantiene el filtro de distancia `<= 800 m` y el orden ascendente por `distancia_m` en la consulta y en la vista.
- `schoolMapper.test.ts` verifica que el ETL conserva dirección, sector, tipo y fuente sin completar valores ausentes.

## Pruebas que respaldan la resolución

- `tests/unit/schoolMapper.test.ts`: sector válido, dirección no nula, fuente F-04.
- `tests/unit/placeLabels.test.ts`: naturaleza pública/privada frente a dato no informado.
- `tests/integration/lugarSearch.test.ts`: educación ordenada por cercanía.
- `tests/acceptance/hu03-hu06.spec.ts` (HU-06): todas las distancias visibles son `<= 800`, están ordenadas y la ficha contiene sede, naturaleza, dirección y distancia.

## Resultado

**3/3 criterios aprobados.** No se inventaron sedes, sectores, direcciones ni distancias.
