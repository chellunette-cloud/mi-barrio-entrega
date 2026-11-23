# Matriz de correcciones HU-03 a HU-06 — Fase 12.1

**Fecha:** 2026-11-19
**Fuente canónica:** `docs/requerimientos/criterios-aceptacion.md` (46 criterios).
**Alcance:** cierre de CA-HU03-01, CA-HU03-04 y CA-HU06-02 con evidencia directa y reproducible.
**Regla aplicada:** solo se marca **Aprobado** lo que tiene una prueba ejecutada en esta fase. Las comprobaciones estáticas se declaran por separado.

| ID | Texto original del criterio | Brecha auditada | Cambio realizado | Prueba ejecutada | Resultado | Estado |
|---|---|---|---|---|---|---|
| CA-HU03-01 | Dado un visitante en la sección de lugares, cuando la sección carga, entonces ve una lista de lugares publicados con nombre, categoría y dirección. | El listado mostraba `tipo` en lugar de `nombreCategoria`; la categoría no era comprobable desde el DOM. | `PlaceListItem.tsx` muestra `nombreCategoria(lugar.categoriaCodigo) · etiquetaTipo(lugar.tipo) · direccion`. Se conserva el tipo útil y se mantiene `Dirección no disponible` cuando la fuente no tiene dirección. | `tests/integration/PlaceListItem.test.tsx` (3 pruebas) y `tests/acceptance/hu03-hu06.spec.ts` (HU-03 y HU-04). | 3/3 pruebas unitarias de componente; E2E verifica categoría `Instituciones educativas`, dirección `KR 87 H BIS # 39 A - 23 SUR` y categoría `Establecimientos comerciales`. | **Aprobado** |
| CA-HU03-04 | Dado un visitante que escribe un texto en el buscador, cuando la búsqueda se ejecuta, entonces se filtran los lugares cuyo nombre o dirección coinciden, sin distinguir mayúsculas ni tildes. | Existía normalización implementada, pero no prueba directa de búsqueda por dirección. | Sin cambios en SQL. Se agregaron pruebas con direcciones reales, texto en mayúsculas/minúsculas, acento en la consulta y ausencia de coincidencia; se verificó el reenvío HTTP de `q` con espacios. | `tests/integration/lugarSearch.test.ts`, `tests/unit/lugarQueries.test.ts`, `tests/integration/backendClient.test.ts` y `tests/acceptance/hu03-hu06.spec.ts`. | Backend 24/24; API 15/15; E2E 27/27. `cl 40 sur` y `CL 40 SUR` devuelven `COLEGIO ALEJANDRO MAGNO`; `panadería` devuelve `Panaderia Tennesse`; `direccion-inexistente-xyz` devuelve 0 filas. | **Aprobado** |
| CA-HU06-02 | Dado que existe una sede dentro del polígono, cuando el visitante revisa el listado, entonces esa sede aparece marcada como "dentro del barrio". | La etiqueta se derivaba de `dentroBarrio`, pero no había aserción directa de dentro/fuera ni de ausencia de evidencia. | `PlaceListItem.tsx` usa comparación estricta: `true` → `Dentro del barrio`, `false` → `Cercano`, valor ausente → sin etiqueta. `PlaceDetail.tsx` aplica el mismo criterio defensivo sin cambiar el contrato ni el cálculo geográfico. | `tests/integration/PlaceListItem.test.tsx` y `tests/acceptance/hu03-hu06.spec.ts` (HU-06). | 3/3 pruebas de componente; E2E confirma que entre las sedes a ≤800 m aparecen tanto `Dentro del barrio` como `Cercano`. Consulta de solo lectura: 1 sede educativa `dentro_barrio=t` y 27 `f` en la base local. | **Aprobado** |

## 1. CA-HU03-01 — Categoría y dirección en el listado

**Evidencia directa ejecutada**

- `npm run ci` en `mi-barrio-frontend`: `vitest run` → **13/13**.
- `tests/integration/PlaceListItem.test.tsx`:
  - nombre, categoría, tipo y dirección de `lugarEducacion`;
  - `Establecimientos comerciales · Supermercado · Dirección no disponible` para `lugarComercio`;
  - estado `aria-pressed=false` del botón.
- `npm run test:acceptance` en `mi-barrio-frontend`: **27/27**. El caso HU-03 comprueba en el DOM la categoría y la dirección reales; el caso HU-04 comprueba la categoría comercial y el tipo `Supermercado`.

**Comprobación estática (no sustituye a la prueba):** `nombreCategoria` ya existía en `src/features/places/domain/labels.ts`; no se crearon categorías nuevas.

## 2. CA-HU03-04 — Búsqueda por dirección

**Evidencia directa ejecutada**

- `npm run ci` en `mi-barrio-backend`: **24/24**, incluidas:
  - `q=cl 40 sur` → Dirección `CL 40 SUR` presente;
  - `q=CL 40 SUR` → mismo resultado, sin distinguir mayúsculas;
  - `q=panadería` → `Panaderia Tennesse` (tolerancia a acento);
  - `q=nino` → `JAIRO ANIBAL NIÑO` (tolerancia a ñ);
  - `q=direccion-inexistente-xyz` → 0 resultados.
- `npm run ci` en `mi-barrio-api`: **15/15**, incluida la codificación de `q=cl 40 sur` hacia el backend.
- `npm run test:acceptance`: **27/27**. El caso HU-03 escribe `cl 40 sur`, `CL 40 SUR`, `no-existe-xyz`, `nino` y `NIÑO` en el buscador real.

**Comprobación estática:** `LUGARES_SQL` mantiene parametrización (`$1`) y aplica la misma función `translate(lower(...))` a `l.nombre` y `COALESCE(l.direccion, '')`. No se introdujo interpolación de SQL.

**Limitación verificada:** los snapshots cargados no contienen direcciones con tilde ni ñ. La tolerancia a acentos y ñ se demuestra con nombres reales (`panadería`, `nino`) y la cobertura idéntica de la dirección se comprueba en la expresión SQL. No se inventó una dirección acentuada para forzar la prueba.

## 3. CA-HU06-02 — Dentro/fuera del barrio

**Evidencia directa ejecutada**

- `npm run ci` en `mi-barrio-frontend`: **13/13**.
  - `lugarEducacion` (`dentroBarrio=true`) → `Dentro del barrio · 121 m`.
  - `lugarComercio` (`dentroBarrio=false`) → `Cercano`.
  - objeto con `dentroBarrio` ausente → no aparece `Dentro del barrio` ni `Cercano`.
- `npm run test:acceptance`: **27/27**. El caso HU-06 comprueba que el listado de sedes a ≤800 m contiene al menos una etiqueta `Dentro del barrio` y al menos una `Cercano`.
- Consulta SQL de solo lectura sobre la base local: `educacion|t|1`, `educacion|f|27`; dentro del filtro ≤800 m aparecen ambas situaciones.

**Comprobación estática:** el cálculo georreferenciado de `dentroBarrio` no se modificó; solo se hizo defensiva la presentación en interfaz. El contrato `Lugar.dentroBarrio: boolean` y los hashes de contratos permanecen sin cambios.

## 4. Totales de la corrección

| Criterio | Estado anterior (auditoría Fase 12) | Estado Fase 12.1 | Evidencia directa |
|---|---|---|---|
| CA-HU03-01 | Parcial | **Aprobado** | Sí |
| CA-HU03-04 | Parcial | **Aprobado** | Sí |
| CA-HU06-02 | Parcial | **Aprobado** | Sí |

**Condición de cierre:** los tres criterios cuentan con prueba ejecutada y reproducible en esta fase. No se declara completa ninguna brecha apoyada solo en inspección de código.
