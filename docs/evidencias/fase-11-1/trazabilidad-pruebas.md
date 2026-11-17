# Trazabilidad de pruebas — Fase 11.1

**Fecha:** 2026-11-15
**Alcance:** pruebas de aceptación de HU-07 a HU-13.
**Regla:** una prueba aprobada no convierte automáticamente una HU en `Validada`. Las brechas de datos o funcionalidad se registran como parciales o no verificables.

## Matriz solicitada

| HU | Criterios | Pruebas implementadas | Aprobadas | Fallidas |
|---|---:|---:|---:|---:|
| HU-07 | 3 | 2 | 2 | 0 |
| HU-08 | 3 | 2 | 2 | 0 |
| HU-09 | 3 | 3 | 3 | 0 |
| HU-10 | 3 | 2 | 2 | 0 |
| HU-11 | 3 | 3 | 3 | 0 |
| HU-12 | 4 | 3 | 3 | 0 |
| HU-13 | 5 | 4 | 4 | 0 |
| **Total** | **24** | **19** | **19** | **0** |

> La columna «Pruebas implementadas» cuenta casos de Playwright, no criterios. Un caso puede cubrir más de un criterio (por ejemplo, CA-HU07-01 y CA-HU07-02). El detalle por criterio está abajo.

## Cobertura por criterio

| Criterio | Estado | Evidencia / limitación |
|---|---|---|
| CA-HU07-01 | Parcial | Nombre, tipo, dirección y distancia visibles; una farmacia no tiene dirección en F-05 y se muestra «Dirección no disponible». |
| CA-HU07-02 | Aprobado | Se distinguen IPS, consultorio y farmacia. |
| CA-HU07-03 | Aprobado | Se declara cercanía, ausencia dentro del polígono y distancia mínima. |
| CA-HU08-01 | Aprobado | Mapa y trazados visibles; jerarquía residencial/terciaria declarada. |
| CA-HU08-02 | Aprobado | Tramos terciarios resaltados como accesos al entorno. |
| CA-HU08-03 | Aprobado | Se declara que no se calculan rutas y no hay rutas sugeridas. |
| CA-HU09-01 | Parcial | Paraderos con nombre, dirección y distancia; el código SITP no está en la fuente y no se inventa. |
| CA-HU09-02 | Aprobado | Estación y portal más cercanos con distancia. |
| CA-HU09-03 | Aprobado | Selección muestra identificador interno; no se publican rutas, horarios, frecuencias ni tiempos de llegada. |
| CA-HU10-01 | Aprobado | Paneles de barrio y UPZ etiquetados por nivel. |
| CA-HU10-02 | Parcial | Población, estrato, año, fuente y sexo visibles; los quinquenios de edad no están en el ETL actual. |
| CA-HU10-03 | Aprobado | No se prorratea edad/sexo al barrio; el panel UPZ no contiene la cifra del barrio. |
| CA-HU11-01 | Aprobado | CAI, cuadrante, teléfono y UPZ visibles. |
| CA-HU11-02 | Aprobado | Indicador etiquetado «Localidad de Kennedy (08)», periodo y fuente F-09; nota de no atribución al barrio. |
| CA-HU11-03 | Aprobado | Arbolado, ronda y amenaza de inundación con fuente y escala. |
| CA-HU12-01 | Aprobado | Filtro simple deja solo la categoría seleccionada. |
| CA-HU12-02 | Aprobado | Combinación de educación y comercio muestra ambas categorías. |
| CA-HU12-03 | Aprobado | Contador, elementos de lista y marcadores del mapa coinciden; estado vacío y error visibles. |
| CA-HU12-04 | Aprobado | «Limpiar filtros» restablece el catálogo completo. |
| CA-HU13-01 | Aprobado | 401 sin token y con token inválido; el panel no expone datos de gestión. |
| CA-HU13-02 | Aprobado | Creación desde UI, publicación en API pública y auditoría con usuario/acción/ID. |
| CA-HU13-03 | Aprobado | 400 por campo incompleto y 400 por coordenadas fuera de 2.000 m; no persiste. |
| CA-HU13-04 | Aprobado | Edición reflejada; despublicación retira de la API pública; auditoría `crear` y `editar`. |
| CA-HU13-05 | No verificable | No existe endpoint ni UI de categorías para intentar el borrado protegido con reasignación. No se simula. |

## Relación con las historias de usuario

| HU | Estado sugerido | Justificación |
|---|---|---|
| HU-07 | `En pruebas` | Criterios cubiertos; CA-HU07-01 parcial por dirección ausente en la fuente. |
| HU-08 | `En pruebas` | Los tres criterios tienen prueba ejecutada. |
| HU-09 | `En pruebas` | CA-HU09-01 parcial por código SITP ausente en la fuente. |
| HU-10 | `En pruebas` | CA-HU10-02 parcial por edad no publicada por el ETL. |
| HU-11 | `En pruebas` | Los tres criterios tienen prueba ejecutada. |
| HU-12 | `En pruebas` | Los cuatro criterios tienen prueba ejecutada. |
| HU-13 | `En pruebas` | CA-HU13-01..04 aprobados; CA-HU13-05 no verificable. |

Ninguna HU se marca `Validada` en esta fase.

## Relación con la regresión

| Verificación | Resultado |
|---|---|
| Backend `npm run ci` | 11/11 pruebas; 9 snapshots OK. |
| API `npm run ci` | 8/8 pruebas; contrato interno verificado. |
| Frontend `npm run ci` | 3/3 pruebas; contrato público verificado; build de producción OK. |
| Playwright | 22/22 pruebas. |
| Límite de líneas | OK en los tres repositorios. |
| Contratos | Interno `ec2755ca…`; público `1100c6bb…`, sin cambios en esta fase. |
