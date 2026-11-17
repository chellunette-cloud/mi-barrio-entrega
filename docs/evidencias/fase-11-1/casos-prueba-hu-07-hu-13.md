# Casos de prueba de aceptación — HU-07 a HU-13 (Fase 11.1)

**Fecha de ejecución:** 2026-11-15
**Navegador:** Google Chrome (Playwright `channel: chrome`)
**Aplicación:** frontend `http://127.0.0.1:5173`, API `http://127.0.0.1:3000`, backend `http://127.0.0.1:3001`
**Datos:** PostgreSQL/PostGIS local con ETL de Fase 9; no se usan mocks para los recorridos principales.

Los recorridos se implementaron en `mi-barrio-frontend/tests/acceptance/`. Cada archivo usa las utilidades compartidas de `helpers.ts` y los datos reales publicados por la API.

## HU-07 — Servicios de salud

| Criterio | Prueba | Comprobación |
|---|---|---|
| CA-HU07-01 | `hu07.salud.spec.ts` · «CA-HU07-01 y CA-HU07-02 listan nombre, tipo, dirección y distancia» | El listado muestra nombre, tipo, dirección y distancia; el detalle conserva tipo, dirección, distancia y fuente. |
| CA-HU07-02 | Misma prueba | Se distinguen `ips`, `consultorio` y `farmacia` en los datos visibles. |
| CA-HU07-03 | `hu07.salud.spec.ts` · «CA-HU07-03 declara cercanía, ausencia dentro del polígono y distancia mínima» | Se muestra «Servicios de salud cercanos», «No hay prestadores dentro del polígono» y la distancia mínima en metros. |

**Observación de datos:** un registro de farmacia no trae dirección en la fuente F-05. La interfaz muestra «Dirección no disponible»; no se inventa un valor.

## HU-08 — Vías y accesos

| Criterio | Prueba | Comprobación |
|---|---|---|
| CA-HU08-01 | `hu08.vias.spec.ts` · «CA-HU08-01 dibuja la malla vial y declara su jerarquía disponible» | Se carga el mapa Leaflet, se dibujan trazados y se informa la jerarquía disponible: residencial y terciaria. |
| CA-HU08-02 | `hu08.vias.spec.ts` · «CA-HU08-02 y CA-HU08-03 resaltan accesos y no presentan rutas inventadas» | Se declara que los tramos terciarios se resaltan en azul como accesos al entorno. |
| CA-HU08-03 | Misma prueba | Se declara «no se presentan rutas calculadas» y no aparece una ruta sugerida ni indicaciones paso a paso. |

## HU-09 — Transporte público

| Criterio | Prueba | Comprobación |
|---|---|---|
| CA-HU09-01 | `hu09.transporte.spec.ts` · «CA-HU09-01 lista paraderos con nombre, ubicación y distancia» | Se listan paraderos con nombre, dirección y distancia. |
| CA-HU09-02 | `hu09.transporte.spec.ts` · «CA-HU09-02 identifica la estación y el portal más cercanos» | Se muestra la estación y el portal más cercanos con su distancia. |
| CA-HU09-03 | `hu09.transporte.spec.ts` · «CA-HU09-03 selecciona un elemento y no publica rutas, horarios ni frecuencias» | Al seleccionar un paradero se muestra su identificador interno; no se publican rutas, horarios, frecuencias ni tiempos de llegada confirmados. |

**Observación de datos:** el ETL de F-15 no incorporó el código SITP del paradero. La interfaz declara «Código SITP no disponible en la fuente» y no inventa un código. CA-HU09-01 queda **parcial** por este motivo.

## HU-10 — Información demográfica

| Criterio | Prueba | Comprobación |
|---|---|---|
| CA-HU10-01 | `hu10.demografia.spec.ts` · «CA-HU10-01 y CA-HU10-02 separan barrio y UPZ con año y fuente» | Cada panel declara su nivel territorial (barrio o UPZ) y su fuente. |
| CA-HU10-02 | Misma prueba | Panel barrio: 3.807 habitantes, estrato 2, fuente F-01. Panel UPZ 082: 133.130 habitantes en 2025, 66.175 H / 66.955 M, fuente F-03. |
| CA-HU10-03 | `hu10.demografia.spec.ts` · «CA-HU10-03 no prorratea edad ni sexo de la UPZ al barrio» | El panel del barrio no contiene H/M ni quinquenios; el panel UPZ no contiene 3.807; se declara que no se prorratea al barrio. |

**Observación de datos:** la fuente F-03 tiene edad por quinquenios a nivel UPZ, pero el ETL actual solo publica el total y la distribución por sexo. No se inventan los quinquenios; CA-HU10-02 queda **parcial** en el componente de edad.

## HU-11 — Seguridad y entorno

| Criterio | Prueba | Comprobación |
|---|---|---|
| CA-HU11-01 | `hu11.seguridad.spec.ts` · «CA-HU11-01 muestra CAI, cuadrante, teléfono y UPZ» | Se muestra CAI Bellavista, código de cuadrante, teléfono y UPZ. |
| CA-HU11-02 | `hu11.seguridad.spec.ts` · «CA-HU11-02 etiqueta los delitos como Localidad de Kennedy (08)» | El indicador visible usa «Localidad de Kennedy (08)», periodo 2018-2026 y fuente F-09; se declara que no es una cifra del barrio. |
| CA-HU11-03 | `hu11.seguridad.spec.ts` · «CA-HU11-03 muestra capas ambientales con fuente y escala» | Se muestran arbolado, ronda del río y amenaza de inundación con fuente y escala. |

## HU-12 — Filtros del mapa

| Criterio | Prueba | Comprobación |
|---|---|---|
| CA-HU12-01 | `hu12.filtros.spec.ts` · «CA-HU12-01 y CA-HU12-03 filtro simple consistente entre contador, lista y mapa» | Al seleccionar salud, solo hay elementos de salud en la lista. |
| CA-HU12-02 | `hu12.filtros.spec.ts` · «CA-HU12-02 y CA-HU12-04 combinan categorías y restablecen todos los lugares» | Educación + comercio muestran elementos de ambas categorías. |
| CA-HU12-03 | Primera y segunda prueba | El contador «N lugares visibles», la lista y los marcadores del mapa coinciden en número. También se prueban estado vacío y error de carga. |
| CA-HU12-04 | Segunda prueba | «Limpiar filtros» restablece el catálogo y vuelven a aparecer salud y transporte. |

## HU-13 — Administración de información

| Criterio | Prueba | Comprobación |
|---|---|---|
| CA-HU13-01 | `hu13.acceso.spec.ts` · «CA-HU13-01 rechaza acceso sin token y no expone datos de gestión» y «rechaza credenciales incorrectas sin iniciar sesión» | `GET /api/v1/admin/lugares` responde 401 sin token y con token inválido; el panel no muestra datos de gestión; credenciales incorrectas no abren sesión. |
| CA-HU13-02 | `hu13.admin.spec.ts` · «CA-HU13-02 y CA-HU13-04 persisten, publican, despublican y auditan» | Un lugar creado desde la UI se publica, aparece en la API pública y genera auditoría con usuario, acción e identificador. |
| CA-HU13-03 | `hu13.validacion.spec.ts` · «CA-HU13-03 rechaza campos incompletos y coordenadas fuera del área» | Nombre vacío responde 400 con el campo `nombre`; coordenadas 0,0 responden 400 `COORDENADAS_FUERA_AREA`; no se persiste el lugar. |
| CA-HU13-04 | `hu13.admin.spec.ts` | La edición cambia el nombre y se refleja en la lista; «Despublicar» retira el lugar de la vista pública; la auditoría registra `crear` y `editar` con valores anteriores y posteriores. |
| CA-HU13-05 | No implementada | No existe endpoint ni interfaz de administración de categorías que permita intentar el borrado protegido y ofrecer reasignación. Se registra como brecha; no se simula una prueba. |

## Ejecución

```powershell
cd mi-barrio-frontend
npx playwright test --reporter=line
```

Resultado final: **22 pruebas aprobadas, 0 fallidas**, incluidas las 19 pruebas de HU-07 a HU-13 y las 3 pruebas existentes de HU-01 a HU-06.
