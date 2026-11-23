# Matriz global de 46 criterios — actualizada en Fase 12.1

**Fecha:** 2026-11-19
**Fuente canónica:** `docs/requerimientos/criterios-aceptacion.md` v1.1 (46 criterios; tabla de cobertura al final).
**Estado previo:** 43 aprobados, 3 parciales (CA-HU03-01, CA-HU03-04, CA-HU06-02), 0 no aprobados, 0 no verificables (auditoría de Fase 12).
**Estado actual:** 44 aprobados, 2 parciales, 0 no aprobados, 0 no verificables.

**Regla aplicada:** los tres parciales de HU-03/HU-06 se cierran con pruebas ejecutadas en Fase 12.1. CA-HU01-04 y CA-HU02-03 se mantienen como **Parcial** según la instrucción de esta fase: requieren auditoría formal de accesibilidad y pruebas de interacción del mapa, respectivamente. No se modificó código de HU-01, HU-02 ni HU-07 a HU-13.

| ID | Criterio | Estado | Evidencia / observación |
|---|---|---|---|
| CA-HU01-01 | Ficha visible | Aprobado | Fase 11.2 + regresión Fase 12/12.1 |
| CA-HU01-02 | Procedencia del dato | Aprobado | Fase 11.2 + regresión Fase 12/12.1 |
| CA-HU01-03 | Sin invención | Aprobado | Fase 11.2 + regresión Fase 12/12.1 |
| CA-HU01-04 | Accesibilidad | **Parcial** | Falta auditoría formal WCAG; se mantiene sin cambios en 12.1 |
| CA-HU02-01 | Polígono oficial | Aprobado | Fase 11.2 + regresión Fase 12/12.1 |
| CA-HU02-02 | Encuadre | Aprobado | Fase 11.2 + regresión Fase 12/12.1 |
| CA-HU02-03 | Interacción | **Parcial** | Faltan pruebas automatizadas de arrastre/zoom y apertura/cierre del popup; se mantiene sin cambios en 12.1 |
| CA-HU02-04 | Fuente visible | Aprobado | Fase 11.2 + regresión Fase 12/12.1 |
| CA-HU03-01 | Listado | **Aprobado** | Fase 12.1: `PlaceListItem.test.tsx` + E2E con categoría y dirección reales |
| CA-HU03-02 | Detalle | Aprobado | Fase 12: `PlaceDetail.test.tsx` + E2E |
| CA-HU03-03 | Correspondencia mapa–lista | Aprobado | Fase 12: `data-lugar-id`, mapa y lista con el mismo `visibleData` |
| CA-HU03-04 | Búsqueda | **Aprobado** | Fase 12.1: `lugarSearch.test.ts`, `lugarQueries.test.ts`, `backendClient.test.ts` + E2E |
| CA-HU04-01 | Búsqueda por nombre | Aprobado | Fase 12: `PlacesSection.test.tsx` + E2E |
| CA-HU04-02 | Fuente y cobertura | Aprobado | Fase 12: leyenda F-16 y cobertura parcial; sin fuente IDT en snapshots |
| CA-HU04-03 | Subcategorías | Aprobado | Fase 12: `tipo` desde `shop` OSM + filtro HTTP + E2E |
| CA-HU04-04 | Sin datos inventados | Aprobado | Fase 12: `commerceMapper.test.ts` + manifest F-16 |
| CA-HU05-01 | Listado con tipo | Aprobado | Fase 12: `placeLabels.test.ts` + E2E |
| CA-HU05-02 | Distinción territorial | Aprobado | Fase 12: título «cercanas» + etiqueta `Cercano` |
| CA-HU05-03 | Mapa | Aprobado | Fase 12: marcador del centroide con clase `seleccionado` + E2E |
| CA-HU06-01 | Ficha educativa | Aprobado | Fase 12: `PlaceDetail.test.tsx` + E2E |
| CA-HU06-02 | Colegio del barrio identificado | **Aprobado** | Fase 12.1: `PlaceListItem.test.tsx` + E2E con dentro/fuera/sin evidencia |
| CA-HU06-03 | Orden por cercanía | Aprobado | Fase 12: `ORDER BY distancia_m` + filtro ≤800 m + E2E |
| CA-HU07-01 | Prestadores y farmacias | Aprobado | Fase 11.2 |
| CA-HU07-02 | Tipo distinguido | Aprobado | Fase 11.2 |
| CA-HU07-03 | Cercanía declarada | Aprobado | Fase 11.2 |
| CA-HU08-01 | Trazado vial | Aprobado | Fase 11.2 |
| CA-HU08-02 | Vías de acceso | Aprobado | Fase 11.2 |
| CA-HU08-03 | Sin rutas inventadas | Aprobado | Fase 11.2 |
| CA-HU09-01 | Paraderos | Aprobado | Fase 11.2 + regresión Fase 12/12.1 |
| CA-HU09-02 | Estaciones y portales | Aprobado | Fase 11.2 + regresión Fase 12/12.1 |
| CA-HU09-03 | Mapa y alcance sin horarios | Aprobado | Fase 11.2 + regresión Fase 12/12.1 |
| CA-HU10-01 | Nivel territorial explícito | Aprobado | Fase 11.2 |
| CA-HU10-02 | Indicadores separados por nivel | Aprobado | Fase 11.2 |
| CA-HU10-03 | Prohibición de inferencia | Aprobado | Fase 11.2 |
| CA-HU11-01 | Cuadrante | Aprobado | Fase 11.2 |
| CA-HU11-02 | Agregación declarada | Aprobado | Fase 11.2 |
| CA-HU11-03 | Entorno | Aprobado | Fase 11.2 |
| CA-HU12-01 | Filtro simple | Aprobado | Fase 11.2 |
| CA-HU12-02 | Filtro múltiple | Aprobado | Fase 11.2 |
| CA-HU12-03 | Consistencia | Aprobado | Fase 11.2 |
| CA-HU12-04 | Restablecer | Aprobado | Fase 11.2 |
| CA-HU13-01 | Acceso restringido | Aprobado | Fase 11.2 |
| CA-HU13-02 | Crear lugar | Aprobado | Fase 11.2 |
| CA-HU13-03 | Validación | Aprobado | Fase 11.2 |
| CA-HU13-04 | Editar y despublicar | Aprobado | Fase 11.2 |
| CA-HU13-05 | Eliminar con protección | Aprobado | Fase 11.2 |

## Resumen

| Estado | Cantidad |
|---|---:|
| Aprobado | 44 |
| Parcial | 2 |
| No aprobado | 0 |
| No verificable | 0 |
| **Total** | **46** |

## Cambios respecto a la auditoría de Fase 12

| ID | Antes | Ahora | Motivo |
|---|---|---|---|
| CA-HU03-01 | Parcial | Aprobado | Evidencia directa de categoría y dirección en el listado |
| CA-HU03-04 | Parcial | Aprobado | Evidencia directa de búsqueda por dirección y mayúsculas |
| CA-HU06-02 | Parcial | Aprobado | Evidencia directa de dentro/fuera y de ausencia de evidencia |
| CA-HU01-04 | Aprobado | **Parcial** | Reclasificado por instrucción Fase 12.1: auditoría WCAG formal pendiente |
| CA-HU02-03 | Aprobado | **Parcial** | Reclasificado por instrucción Fase 12.1: pruebas de interacción del mapa pendientes |

El resultado `44/2/0/0` es el derivado de las evidencias reales de esta fase y de la instrucción expresa de mantener esos dos criterios de HU-01/HU-02 como parciales. No se impuso el total de referencia sin verificación.
