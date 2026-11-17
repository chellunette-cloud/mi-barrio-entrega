# Mi Barrio – Ciudad Granada · Documentación del proyecto

Repositorio de documentación y orquestación académica (**carpeta `docs/` del espacio de trabajo**).
El código está en tres repositorios independientes: `mi-barrio-frontend`, `mi-barrio-api` y `mi-barrio-backend`. La carpeta `docs/` no es un repositorio Git independiente; conserva la trazabilidad académica sin modificar la estructura aprobada.

> **Estado:** Fase 1 implementada y **en pruebas** con evidencia real; **no validada**. **D-2…D-6 aprobadas**; **D-7 pendiente** para la fase de administración y sin bloqueo para HU-01/HU-02. Los tres repositorios existen, están inicializados como Git independientes y tienen commits locales. No se inició la Fase 2.

---

## 1. Etapas de definición

| Etapa | Contenido | Estado |
|-------|-----------|--------|
| Fase 1 | Análisis del repositorio de referencia del docente | ✅ Cerrada (con corrección) |
| Fase 2 | Investigación territorial de Ciudad Granada | ✅ Documentada |
| Fase 3 | Modelo de requerimientos, criterios y trazabilidad | ✅ Documentada (2026-11-15) |
| Fase 4 | Especificaciones funcionales, arquitectura y plan | ✅ Documentada (2026-11-15) |

La documentación está elaborada. **D-2…D-6 están aprobadas**; **D-7 queda pendiente** para la fase administrativa y no bloquea HU-01/HU-02. La Fase 1 se implementó con HU-01/HU-02 en **`En pruebas`**; no hay historias `Validadas` ni se inició la Fase 2.

**Corrección de la Fase 1:** los "13/14 criterios" no eran una rúbrica del docente; son las **13 historias de usuario** del enunciado. El bloqueo quedó resuelto el 2026-11-15 y se registró sin borrar el análisis previo.

## 2. Fases de implementación

| Fase | Historias | Estado |
|------|-----------|--------|
| 1 | Fundaciones + HU-01, HU-02 | 🟡 En pruebas — implementada con evidencia; revisión pendiente |
| 2 | HU-03 a HU-06 | 🟡 En desarrollo — implementación inicial realizada; pruebas y evidencia pendientes |
| 3 | HU-05, HU-06, HU-07, HU-08, HU-09 | ⬜ No iniciada |
| 4 | HU-13 | ⬜ No iniciada |
| 5 | HU-04, HU-10, HU-11 | ⬜ No iniciada |
| 6 | Calidad, despliegue y entrega | ⬜ No iniciada |

Detalle en [`planificacion/plan-desarrollo.md`](planificacion/plan-desarrollo.md).

---

## 3. Índice de documentos

### Requerimientos
| Documento | Contenido |
|-----------|-----------|
| [`requerimientos/historias-usuario.md`](requerimientos/historias-usuario.md) | Las 13 HU con actor, prioridad, dependencias y estado |
| [`requerimientos/requisitos.md`](requerimientos/requisitos.md) | RF-01…RF-14, RNF-01…RNF-20, reglas de negocio, alcance |
| [`requerimientos/criterios-aceptacion.md`](requerimientos/criterios-aceptacion.md) | 46 criterios Dado–Cuando–Entonces |
| [`requerimientos/matriz-trazabilidad.md`](requerimientos/matriz-trazabilidad.md) | HU → RF/RNF → criterio → módulo → evidencia → prueba |

### Investigación
| Documento | Contenido |
|-----------|-----------|
| [`investigacion/fuentes-territoriales.md`](investigacion/fuentes-territoriales.md) | Ficha verificada, 16 fuentes, disponibilidad por HU, limitaciones |

### Especificaciones y arquitectura
| Documento | Contenido |
|-----------|-----------|
| [`especificaciones/especificaciones-funcionales.md`](especificaciones/especificaciones-funcionales.md) | 13 especificaciones con 11 campos cada una |
| [`arquitectura/arquitectura-solucion.md`](arquitectura/arquitectura-solucion.md) | 3 capas, contratos, SOLID, PostGIS, diagramas, riesgos |
| [`arquitectura/entorno-postgis-windows.md`](arquitectura/entorno-postgis-windows.md) | Diagnóstico DLL, corrección local, versiones y reproducibilidad |
| [`planificacion/plan-desarrollo.md`](planificacion/plan-desarrollo.md) | 6 fases, dependencias, entregables, pruebas |

### Evidencias

| Documento | Contenido |
|-----------|-----------|
| [`evidencias/fase-0/README.md`](evidencias/fase-0/README.md) | Artefactos territoriales, hashes, archivos temporales y reproducción |
| [`evidencias/fase-1/README.md`](evidencias/fase-1/README.md) | Implementación HU-01/HU-02, respuestas reales, pruebas, capturas y límites |

### Fase 1 (histórico)
| Documento | Contenido |
|-----------|-----------|
| [`fase-1/01-informe-analisis-repositorio.md`](fase-1/01-informe-analisis-repositorio.md) | Inventario verificado, convenciones, defectos H-1…H-12 |
| [`fase-1/02-matriz-criterios-docente.md`](fase-1/02-matriz-criterios-docente.md) | Búsqueda de criterios (resuelta) + requisitos antecedentes |

---

## 4. Hallazgos territoriales clave

- **Ciudad Granada** = UPZ **82 Patio Bonito**, localidad **08 Kennedy**, UPL14.
- Polígono oficial: **9,1 ha**, 58 vértices, centroide **4,641833, -74,171758**; área geodésica 94.551,13 m².
- **705 lotes**, **3.807 habitantes** (estimación oficial del barrio), estrato **2** (34 manzanas).
- **Colegios:** 28 registros en bbox ±0,006°, **15** sedes a ≤800 m, **1** dentro (Colegio Alejandro Magno). El "14" previo queda reemplazado; método en `investigacion/fuentes-territoriales.md` §6.1.
- UPZ 082 (2025): **133.130 habitantes** (dato de UPZ, **no** del barrio; panel separado).
- **Delitos:** solo por **localidad 08 Kennedy**, nunca por barrio.
- **Comercio:** inventario **parcial** (OSM 6; IDT 0 en el entorno); no representa la totalidad.
- El código postal **110881 no es el límite del barrio**; cubre una zona mucho mayor.

**Verificación reciente:** la capa F-02 devolvió **802 polígonos** en el bbox y **34 manzanas** con centroide dentro del polígono, todas estrato 2; ver `investigacion/fuentes-territoriales.md` §12. PostgreSQL 16.13 + PostGIS 3.7.0 se reinició y se volvió a consultar correctamente; ver `arquitectura/entorno-postgis-windows.md`.

---

## 5. Decisiones

| ID | Decisión | Estado |
|----|----------|--------|
| D-1 | `mi-barrio-docs` como 4.º repositorio | Documentada (implícita en la solicitud) |
| D-2 | Markdown para documentación + contratos tipados para interfaces; fuente única de verdad | ✅ **Aprobada (2026-11-15)** |
| D-3 | Tres repositorios independientes, sin imports cruzados | ✅ **Aprobada (2026-11-15; restricción del profesor)** |
| D-4 | PostgreSQL 16 + PostGIS 3.7.0 | ✅ **Aprobada (2026-11-15)** |
| D-5 | API ↔ Backend por HTTP interno autenticado con `X-Service-Token`; backend no público | ✅ **Aprobada (2026-11-15)** |
| D-6 | React + TypeScript + Vite + Tailwind CSS + Leaflet | ✅ **Aprobada (2026-11-15)** |
| D-7 | JWT corto + refresh token + contraseñas Argon2 | 🟡 **Pendiente — fase de administración; no bloquea HU-01/HU-02** |

**Condiciones aprobadas:** D-2 mantiene una sola fuente de verdad por frontera HTTP (documentos y contratos tipados, sin duplicar criterios); D-5 usa un token de servicio y el backend no se expone públicamente; D-6 usa contratos tipados por repo, sin importar código entre repositorios. **D-7** se resolverá cuando se implemente la administración; su ausencia no impide la ficha ni el mapa públicos.

---

## 6. Bloqueos

| Bloqueo | Estado |
|---------|--------|
| Criterios del docente (13/14) | ✅ Resuelto: son las 13 HU |
| Conteo de colegios (14 vs 28) | ✅ Resuelto: 28 en bbox, 15 ≤800 m, 1 dentro; método en §6.1 |
| Delimitación territorial | ✅ Resuelto: polígono oficial SDP verificado |
| Datos de comercio exhaustivos | 🔴 Limitación estructural: no existen; se declara |
| Demografía por barrio | 🔴 Limitación estructural: solo UPZ; se declara |
| Delitos por barrio | 🔴 Limitación estructural: solo localidad; se declara |
| GTFS con descarga directa | 🟡 Pendiente de verificar en el portal de Transmilenio |

---

## 7. Reglas del proyecto

1. Trabajar por fases; no construir toda la aplicación de una vez.
2. No inventar datos, establecimientos, estadísticas ni límites.
3. Todo dato publicado lleva fuente, URL y fecha de consulta.
4. Ningún archivo de código supera **100 líneas** (verificado en CI).
5. No se declara una prueba como aprobada sin ejecutarla.
6. Los documentos no se duplican: cada tema tiene un archivo canónico.

---

## 8. Próximo paso

Revisar los entregables de Fase 1 y la evidencia en [`evidencias/fase-1/README.md`](evidencias/fase-1/README.md).
HU-01/HU-02 quedan en **`En pruebas`**. **No se avanza a la Fase 2 ni se implementan HU-03…HU-13 sin
revisión y aprobación del usuario.** Pendientes declarados: PT-01, auditoría formal de accesibilidad y
despliegue staging HTTPS.
