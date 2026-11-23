# Matriz global de 46 criterios — actualizada en Fase 13

**Fecha:** 2026-11-19
**Fuente canónica:** `docs/requerimientos/criterios-aceptacion.md` v1.1 (46 criterios; tabla de cobertura al final).
**Estado previo:** 44 aprobados, 2 parciales (CA-HU01-04, CA-HU02-03), 0 no aprobados, 0 no verificables.
**Estado actual:** 46 aprobados, 0 parciales, 0 no aprobados, 0 no verificables.

**Nota de alcance:** CA-HU01-04 se aprueba sobre la interfaz de HU-01/HU-02 y componentes compartidos, con axe y comprobaciones manuales de teclado. No se extiende a una certificación WCAG completa del producto ni a formularios de administración. CA-HU02-03 se aprueba con 8 comportamientos observables verificados en Playwright.

| ID | Criterio | Estado | Evidencia / observación |
|---|---|---|---|
| CA-HU01-01 | Ficha visible | Aprobado | Fase 11.2 + regresión Fase 12/12.1/13 |
| CA-HU01-02 | Procedencia del dato | Aprobado | Fase 11.2 + regresión Fase 12/12.1/13 |
| CA-HU01-03 | Sin invención | Aprobado | Fase 11.2 + regresión Fase 12/12.1/13 |
| CA-HU01-04 | Accesibilidad | **Aprobado** | Fase 13: axe 0 violaciones en 4 análisis + teclado/foco manual automatizado |
| CA-HU02-01 | Polígono oficial | Aprobado | Fase 11.2 + regresión Fase 12/12.1/13 |
| CA-HU02-02 | Encuadre | Aprobado | Fase 11.2 + regresión Fase 12/12.1/13 |
| CA-HU02-03 | Interacción | **Aprobado** | Fase 13: 5 E2E con arrastre, zoom, rueda, popup y marcadores |
| CA-HU02-04 | Fuente visible | Aprobado | Fase 11.2 + regresión Fase 12/12.1/13 |
| CA-HU03-01 | Listado | Aprobado | Fase 12.1: `PlaceListItem.test.tsx` + E2E con categoría y dirección |
| CA-HU03-02 | Detalle | Aprobado | Fase 12: `PlaceDetail.test.tsx` + E2E |
| CA-HU03-03 | Correspondencia mapa–lista | Aprobado | Fase 12: `data-lugar-id`, mapa y lista con el mismo `visibleData` |
| CA-HU03-04 | Búsqueda | Aprobado | Fase 12.1: búsqueda por dirección, acento, ñ y sin coincidencia |
| CA-HU04-01 | Búsqueda por nombre | Aprobado | Fase 12: `PlacesSection.test.tsx` + E2E |
| CA-HU04-02 | Fuente y cobertura | Aprobado | Fase 12: leyenda F-16 y cobertura parcial; sin fuente IDT en snapshots |
| CA-HU04-03 | Subcategorías | Aprobado | Fase 12: `tipo` desde `shop` OSM + filtro HTTP + E2E |
| CA-HU04-04 | Sin datos inventados | Aprobado | Fase 12: `commerceMapper.test.ts` + manifest F-16 |
| CA-HU05-01 | Listado con tipo | Aprobado | Fase 12: `placeLabels.test.ts` + E2E |
| CA-HU05-02 | Distinción territorial | Aprobado | Fase 12: título «cercanas» + etiqueta `Cercano` |
| CA-HU05-03 | Mapa | Aprobado | Fase 12: marcador del centroide con clase `seleccionado` + E2E |
| CA-HU06-01 | Ficha educativa | Aprobado | Fase 12: `PlaceDetail.test.tsx` + E2E |
| CA-HU06-02 | Colegio del barrio identificado | Aprobado | Fase 12.1: `PlaceListItem.test.tsx` + E2E con dentro/fuera/sin evidencia |
| CA-HU06-03 | Orden por cercanía | Aprobado | Fase 12: `ORDER BY distancia_m` + filtro ≤800 m + E2E |
| CA-HU07-01 | Prestadores y farmacias | Aprobado | Fase 11.2 |
| CA-HU07-02 | Tipo distinguido | Aprobado | Fase 11.2 |
| CA-HU07-03 | Cercanía declarada | Aprobado | Fase 11.2 |
| CA-HU08-01 | Trazado vial | Aprobado | Fase 11.2 |
| CA-HU08-02 | Vías de acceso | Aprobado | Fase 11.2 |
| CA-HU08-03 | Sin rutas inventadas | Aprobado | Fase 11.2 |
| CA-HU09-01 | Paraderos | Aprobado | Fase 11.2 + regresión Fase 12/12.1/13 |
| CA-HU09-02 | Estaciones y portales | Aprobado | Fase 11.2 + regresión Fase 12/12.1/13 |
| CA-HU09-03 | Mapa y alcance sin horarios | Aprobado | Fase 11.2 + regresión Fase 12/12.1/13 |
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
| Aprobado | 46 |
| Parcial | 0 |
| No aprobado | 0 |
| No verificable | 0 |
| **Total** | **46** |

## Cambios respecto a Fase 12.1

| ID | Antes | Ahora | Motivo |
|---|---|---|---|
| CA-HU01-04 | Parcial | Aprobado | axe 0 violaciones en ficha, mapa, carga y error; teclado y foco verificados |
| CA-HU02-03 | Parcial | Aprobado | 8 comportamientos de interacción verificados con efectos observables |

El resultado 46/46 se apoya en evidencia ejecutada en esta fase y en las fases anteriores. No se forzó el total: se cerraron exactamente los dos criterios que tenían evidencia directa nueva y reproducible.

---

## Validación remota Fase 14.7 (2026-11-22)

El run E2E #2 (`44979541605`, `success`) aporta **evidencia de regresión remota** para los criterios cubiertos por las 36 pruebas Playwright ejecutadas en 15 archivos. La regresión se ejecutó sobre los SHAs publicados: frontend `332dc94198e40c93b006582bdcb2b45500e72f73`, backend `a6c912542873665659fff4a38c1efdd5f13483be` y API `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd`.

**Alcance preciso:** este run no ejecutó individualmente los 46 criterios. Cubre directamente los recorridos de los 15 archivos de aceptación y confirma que esos criterios siguen pasando tras la publicación y la actualización de dependencias. El total **46 aprobados, 0 parciales, 0 no aprobados** se mantiene sobre la evidencia acumulada de Fase 13 y anteriores, con este run como verificación remota adicional.

Evidencia completa: [`../fase-14-7/ejecucion-e2e-remota.md`](../fase-14-7/ejecucion-e2e-remota.md). Artefacto: `playwright-report`, SHA-256 `c876b01c49a1f003aba73bce4c3facb3ce6cd1eb507b30db5ae29f6e6eedf0e0`.
