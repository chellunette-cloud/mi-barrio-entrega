# Decisiones y limitaciones — Fase 12.1

**Fecha:** 2026-11-19
**Alcance:** cierre de CA-HU03-01, CA-HU03-04 y CA-HU06-02; actualización de trazabilidad y evidencia.

## 1. Decisiones técnicas

1. **Categoría visible sin inventarla.** `PlaceListItem.tsx` muestra `nombreCategoria(lugar.categoriaCodigo)` junto a `etiquetaTipo(lugar.tipo)` y la dirección. La categoría ya existía en el contrato y en `labels.ts`; no se crearon categorías ni se reemplazó el tipo de establecimiento.
2. **Búsqueda por dirección sin cambiar SQL.** La normalización `translate(lower(...))` ya cubre `l.nombre` y `COALESCE(l.direccion, '')`. Se agregaron pruebas con direcciones reales (`CL 40 SUR`) y se mantuvo la parametrización (`$1`). No se introdujo interpolación de SQL ni se cambió la estrategia de normalización.
3. **Ubicación defensiva en interfaz.** Se comparó `dentroBarrio` de forma estricta: `true` → `Dentro del barrio`, `false` → `Cercano`, valor ausente → sin etiqueta. El contrato sigue siendo `boolean`; la rama ausente protege ante respuestas mal formadas sin alterar el cálculo geográfico ni el ETL.
4. **Sin cambios de contrato ni hashes.** No se modificaron `internal.openapi.yaml` ni `public.openapi.yaml` en Fase 12.1. Los hashes verificados siguen siendo `606a2543…` (interno) y `c1602756…` (público).
5. **Sin migraciones ni escrituras en base.** Las pruebas de integración usan `SELECT` parametrizados. No se crearon migraciones, no se regeneraron snapshots y no se insertaron/actualizaron/borraron filas.
6. **Sin cuarto repositorio ni publicación.** `mi-barrio-entrega` no se modificó en esta fase y en ese momento no tenía remoto. No se hicieron commits, push ni despliegues. Nota de estado 2026-11-23: el portal ya tiene remoto, commits y Pages; véase `entrega/estado-publicacion.md` §9.

## 2. Archivos tocados en Fase 12.1

### `mi-barrio-backend`

| Archivo | Acción en 12.1 |
|---|---|
| `tests/integration/lugarSearch.test.ts` | Ampliado: acento en consulta, dirección en minúsculas/mayúsculas y sin coincidencia |
| `tests/unit/lugarQueries.test.ts` | Ampliado: normalización de dirección con `ñ`/`Ñ` |

No se modificó código de producción del backend en esta fase.

### `mi-barrio-api`

| Archivo | Acción en 12.1 |
|---|---|
| `tests/integration/backendClient.test.ts` | Ampliado: reenvío de `q=cl 40 sur` con espacios codificados |

No se modificó código de producción de la API en esta fase.

### `mi-barrio-frontend`

| Archivo | Acción en 12.1 |
|---|---|
| `src/features/places/components/PlaceListItem.tsx` | Muestra categoría + tipo + dirección y etiqueta de ubicación defensiva |
| `src/features/places/components/PlaceDetail.tsx` | Ubicación defensiva coherente con el listado |
| `tests/acceptance/hu03-hu06.spec.ts` | Aserciones directas de categoría, dirección, búsqueda por dirección y dentro/fuera |
| `tests/integration/PlaceListItem.test.tsx` | **Nuevo**: 3 pruebas directas del componente |

### Documentación (carpeta `docs/`, no un repositorio)

| Archivo | Acción en 12.1 |
|---|---|
| `docs/evidencias/fase-12-1/matriz-correcciones-hu-03-a-hu-06.md` | **Nuevo** |
| `docs/evidencias/fase-12-1/resultados-regresion.md` | **Nuevo** |
| `docs/evidencias/fase-12-1/matriz-global-46-criterios.md` | **Nuevo** |
| `docs/evidencias/fase-12-1/decisiones-y-limitaciones.md` | **Nuevo** |
| `docs/evidencias/fase-12/matriz-validacion-hu-03-a-hu-06.md` | Nota de actualización 12.1 en las tres filas afectadas |
| `docs/README.md` | Índice de Fase 12.1 |

### `mi-barrio-entrega`

Sin cambios en Fase 12.1. Conserva el `docs/README.md` modificado y la carpeta `docs/evidencias/fase-12/` generados en Fase 12; en ese momento sin remoto y sin publicación (estado vigente en `entrega/estado-publicacion.md` §9).

## 3. Estado Git y confirmación de committing/push

| Repositorio | HEAD | Estado |
|---|---|---|
| `mi-barrio-backend` | `7b641a8bd2cf116f8f4406575a631e26365a4a12` | `## main...origin/main`, sin adelantos ni retrasos; 5 modificados + 5 nuevos de Fase 12/12.1 |
| `mi-barrio-api` | `76e59be750dfb430f84ea6280b5a943c7f51c51b` | `## main...origin/main`, sin adelantos ni retrasos; 10 modificados |
| `mi-barrio-frontend` | `c5240ac59075c83a517eb5a5618f7d5f9e6d6afa` | `## main...origin/main`, sin adelantos ni retrasos; 7 modificados + 9 nuevos |
| `mi-barrio-entrega` | `399f66f9b7fab2808ada4d62456670ac8aec4704` | `## main`, 0 remotos; cambios preexistentes de Fase 12, intactos en 12.1 |

Los HEAD continúan siendo los publicados en Fase 11.2. No se ejecutó `git commit`, `git push`, `git tag` ni despliegue. `git status -sb` no muestra `ahead` ni `behind` en los tres repositorios públicos.

## 4. Limitaciones y brechas que continúan

1. **Sin direcciones acentuadas en los snapshots.** No hay direcciones con tilde ni ñ en los datos cargados. La tolerancia a acentos/ñ se verificó con nombres reales (`panadería`, `nino`) y la aplicación del mismo normalizador a la dirección se comprobó estáticamente en `LUGARES_SQL`. No se inventó una dirección para forzar la prueba.
2. **CA-HU01-04 y CA-HU02-03 siguen parciales.** Requieren auditoría formal de accesibilidad y pruebas de interacción del mapa; no se modificó su código en esta fase.
3. **`q` sin `maxLength`.** El parámetro de búsqueda pública sigue sin límite declarado en Zod/OpenAPI, tal como se documentó en Fase 12. No se cambió para no alterar contratos/hashes en esta fase.
4. **E2E local.** Playwright se ejecutó en el entorno local con servicios propios; no forma parte del CI remoto.
5. **Auditorías pendientes de alcance mayor.** WCAG formal, seguridad, cross-browser y despliegue HTTPS siguen fuera de esta fase.
6. **Sin publicación de evidencia.** La documentación de Fase 12.1 queda local; no se publicó ni se replicó en `mi-barrio-entrega`.

## 5. Condición de cierre

Los tres criterios objetivos tienen prueba ejecutada y reproducible en esta fase. El trabajo queda a la espera de revisión humana antes de cualquier commit, push, publicación o fase posterior.
