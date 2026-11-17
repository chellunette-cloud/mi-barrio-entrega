# Defectos y correcciones — Fase 11.1

Los siguientes defectos se detectaron al implementar los criterios de aceptación de HU-07 a HU-13. Se corrigieron sin eliminar criterios, sin datos ficticios y sin cambiar los contratos públicos.

| # | Defecto | HU / criterio afectado | Corrección | Archivos |
|---|---|---|---|---|
| 1 | El filtro solo admitía una categoría; no era posible combinar categorías. | HU-12 / CA-HU12-02 | El estado del filtro pasó a `string[]`; se filtra en cliente sobre el catálogo cargado y se combinan categorías. | `mi-barrio-frontend/src/features/places/components/PlacesSection.tsx`, `mi-barrio-frontend/src/features/places/hooks/usePlaces.ts` |
| 2 | No existía un contador visible que permitiera comparar contador, lista y mapa. | HU-12 / CA-HU12-03 | Se añadió `N lugares visibles` con `aria-live="polite"`. | `mi-barrio-frontend/src/features/places/components/PlacesSection.tsx` |
| 3 | El botón de restablecimiento se llamaba «Todos», no «Limpiar filtros». | HU-12 / CA-HU12-04 | Se renombró y se actualizaron las pruebas existentes. | `PlacesSection.tsx`, `tests/acceptance/places.spec.ts` |
| 4 | No había estado vacío cuando la búsqueda no devolvía lugares. | HU-12 / estado vacío | Se añadió el mensaje «No se encontraron lugares con los filtros seleccionados». | `PlacesSection.tsx` |
| 5 | La lista mostraba el código de categoría en lugar del tipo de prestador; el detalle no mostraba distancia ni identificador. | HU-07 / CA-HU07-01, CA-HU07-02; HU-09 / CA-HU09-03 | La lista muestra `tipo` y la dirección; el detalle muestra dirección, distancia, identificador interno y fuente. | `PlacesSection.tsx` |
| 6 | No se declaraba la cercanía ni la distancia mínima de salud. | HU-07 / CA-HU07-03 | Se añadió el resumen de servicios cercanos, ausencia dentro del polígono y distancia mínima. | `PlacesSection.tsx` |
| 7 | No se identificaban la estación y el portal más cercanos. | HU-09 / CA-HU09-02 | Se añadió el resumen con estación y portal más cercanos y su distancia; se declara que el código SITP no está en la fuente. | `PlacesSection.tsx` |
| 8 | El mapa no centraba el lugar seleccionado. | HU-09 / CA-HU09-03; HU-05 | Se añadió `MapFocus` con `map.flyTo` al seleccionar un marcador o un elemento de la lista. | `mi-barrio-frontend/src/features/places/components/PlacesMap.tsx` |
| 9 | La jerarquía vial y los accesos no se explicaban en la interfaz. | HU-08 / CA-HU08-01, CA-HU08-02 | Se añadió la leyenda de tramos residenciales/terciarios y el resaltado de terciarios como accesos. | `mi-barrio-frontend/src/features/vias/components/ViasSection.tsx` |
| 10 | La población de la UPZ se mostraba sin separador de miles y no se explicaba el alcance de edad/sexo. | HU-10 / CA-HU10-02, CA-HU10-03 | Se aplicó `formatInteger` y se añadió la nota de que edad y sexo solo están a nivel UPZ y no se prorratean. | `mi-barrio-frontend/src/features/stats/components/StatsSection.tsx` |
| 11 | Los indicadores de delitos de F-09 no se renderizaban; solo se veía el cuadrante y las capas. | HU-11 / CA-HU11-02 | Se añadió la lista de indicadores con nivel «Localidad de Kennedy (08)», periodo y fuente, y la nota de no atribución al barrio. | `StatsSection.tsx` |
| 12 | Un login con contraseña incorrecta devolvía 500 a través de la API porque el cliente administrativo perdía el estado del backend. | HU-13 / CA-HU13-01 | `AdminBackendClient` ahora lanza `BackendError` con estado, código y mensaje; el manejador de errores propaga 400/401 y mantiene el 404 genérico de la API pública. | `mi-barrio-api/src/clients/backend/AdminBackendClient.ts`, `mi-barrio-api/src/http/middleware/errorHandler.ts` |
| 13 | La validación de lugares devolvía un mensaje genérico y no verificaba el área de influencia. | HU-13 / CA-HU13-03 | Se devuelven los campos inválidos y se rechazan coordenadas a más de 2.000 m del centroide con `COORDENADAS_FUERA_AREA`. | `mi-barrio-backend/src/infrastructure/http/controllers/adminLugaresController.ts`, `adminValidation.ts` |
| 14 | El panel administrativo no permitía editar, despublicar ni consultar la auditoría. | HU-13 / CA-HU13-04 | Se añadieron acciones Editar/Despublicar, formulario de actualización y panel de auditoría con actualización manual. | `mi-barrio-frontend/src/features/admin/components/AdminPage.tsx`, `AdminLogin.tsx`, `AdminAudit.tsx`, `services/adminApi.ts` |
| 15 | La suite E2E completa superaba el límite de 120 solicitudes/min y algunas pruebas recibían 429. | Regresión de aceptación | El límite es configurable (`RATE_LIMIT_MAX`); el valor por defecto sigue en 120 y en local se usa 600 para la suite. | `mi-barrio-api/src/config/env.ts`, `src/main.ts`, `src/http/app.ts`, `src/http/middleware/rateLimit.ts`, `.env.example` |
| 16 | El panel administrativo no podía listar ni eliminar lugares despublicados porque la consulta de detalle filtraba `publicado = true`. | HU-13 / CA-HU13-04 | Se añadieron `listLugaresAdmin` y `findLugarAdmin`, sin filtro de publicación, para las rutas administrativas; la vista pública conserva el filtro. | `mi-barrio-backend/src/domain/places/types.ts`, `src/infrastructure/db/PostgresLugarRepository.ts`, `src/infrastructure/db/queries/lugarAdminQueries.ts`, `adminLugaresController.ts` |

## Defectos o brechas no corregidos

| Brecha | Motivo | Tratamiento |
|---|---|---|
| Código SITP por paradero | El ETL de F-15 no incorporó el código del paradero y no se puede inventar. | La UI declara «Código SITP no disponible en la fuente». CA-HU09-01 queda parcial. |
| Distribución por edad de la UPZ | El ETL actual publica total y sexo, no los quinquenios de F-03. | Se declara el nivel y la limitación; no se prorratea. CA-HU10-02 queda parcial en edad. |
| Dirección de una farmacia | El registro F-05 no trae dirección. | Se muestra «Dirección no disponible». CA-HU07-01 queda parcial en ese registro. |
| Administración de categorías y borrado protegido | No existe endpoint ni interfaz de categorías en el alcance implementado. | CA-HU13-05 no se marca como aprobado ni se simula. |
