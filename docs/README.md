# Mi Barrio – Ciudad Granada · Documentación del proyecto

Repositorio de documentación y orquestación académica (**carpeta `docs/` del espacio de trabajo**).
El código está en tres repositorios independientes: `mi-barrio-frontend`, `mi-barrio-api` y `mi-barrio-backend`. La carpeta `docs/` no es un repositorio Git independiente; conserva la trazabilidad académica sin modificar la estructura aprobada.

> **Estado histórico (2026-11-15):** Fase 1 implementada y **en pruebas** con evidencia real; **no validada**. **D-2…D-6 aprobadas**; **D-7 pendiente** para la fase de administración y sin bloqueo para HU-01/HU-02. Los tres repositorios existen, están inicializados como Git independientes y tienen commits locales. No se inició la Fase 2.

> **Estado vigente (2026-11-23):** desarrollo funcional, validaciones técnicas y **despliegue gratuito en Render** ejecutados y verificados. Las fases hasta la 14.7 están cerradas técnicamente; la matriz canónica registra **46/46 criterios aprobados** y el E2E remoto finalizó en `success` con 36/36 pruebas en 15 archivos y artefacto verificado. Ese run es regresión remota, no ejecución individual de los 46 criterios. El frontend y el backend están en `main`; la API se desplegó desde `fase-15/p0-trust-proxy`. **P0-02 aprobado para los datos consultados; P0-01 APROBADO** desde la Fase 15.3 con `CF-Connecting-IP` como clave del limitador y evidencia desplegada en Render. El portal de documentación ya está publicado en <https://chellunette-cloud.github.io/mi-barrio-entrega/> y la aplicación en <https://mi-barrio-frontend.onrender.com>. Siguen pendientes la **documentación final**, la **entrega académica**, la **trazabilidad final**, **respaldos/restauración** y las **verificaciones finales**; PT-01, PT-02 y la auditoría formal de accesibilidad permanecen sin evidencia de cierre. No se declara aceptación académica. Ver [matriz canónica](evidencias/fase-13/matriz-global-46-criterios.md), [evidencia E2E remota](evidencias/fase-14-7/ejecucion-e2e-remota.md), [evidencia de despliegue](despliegue/evidencia-fase-15.2-despliegue-render.md), [corrección final de P0-01 y secciones](despliegue/evidencia-fase-15.3-correccion-p0-01-y-secciones.md) y [publicación del portal](../entrega/estado-publicacion.md#9-publicación-del-portal-en-github-pages-2026-11-23).

---

## 1. Etapas de definición

| Etapa | Contenido | Estado |
|-------|-----------|--------|
| Fase 1 | Análisis del repositorio de referencia del docente | ✅ Cerrada (con corrección) |
| Fase 2 | Investigación territorial de Ciudad Granada | ✅ Documentada |
| Fase 3 | Modelo de requerimientos, criterios y trazabilidad | ✅ Documentada (2026-11-15) |
| Fase 4 | Especificaciones funcionales, arquitectura y plan | ✅ Documentada (2026-11-15) |

La documentación de requerimientos, arquitectura y plan está elaborada; la documentación final de entrega sigue pendiente. **D-2…D-6 están aprobadas**; **D-7 quedó pendiente** en el registro de Fase 1 y no bloqueó HU-01/HU-02, pero ya fue aprobada e implementada (ver §5). La Fase 1 se implementó con HU-01/HU-02 en **`En pruebas`**; no hay historias `Validadas` en el sentido de aceptación académica. Este párrafo conserva el estado histórico de 2026-11-15; el estado vigente está en el aviso del inicio y en la §2.

**Corrección de la Fase 1:** los "13/14 criterios" no eran una rúbrica del docente; son las **13 historias de usuario** del enunciado. El bloqueo quedó resuelto el 2026-11-15 y se registró sin borrar el análisis previo.

## 2. Fases de implementación

| Fase | Historias / alcance | Estado vigente (2026-11-22) |
|------|---------------------|-----------------------------|
| 1 | Fundaciones + HU-01, HU-02 | ✅ Ejecutada; criterios cerrados en Fase 13 |
| 2 | HU-03 + HU-12 | ✅ Ejecutada; detalle en el registro histórico |
| 3 | HU-05, HU-06, HU-07, HU-08, HU-09 | ✅ Ejecutada; detalle en el registro histórico |
| 4 | HU-13 | ✅ Ejecutada; detalle en el registro histórico |
| 5 | HU-04, HU-10, HU-11 | ✅ Ejecutada; detalle en el registro histórico |
| 6 | Calidad, despliegue y entrega | 🟡 Calidad y despliegue ejecutados; **entrega final pendiente** |
| 7–14.7 | Pruebas, accesibilidad, cierres, publicación y validación remota | ✅ Ejecutadas; **Fase 14.7 cerrada técnicamente** |
| 15 | Despliegue y entrega final | 🟡 Despliegue ejecutado en Render; **entrega final pendiente**; P0-01 aprobado en 15.3 |

> **Nota sobre HU-03 a HU-06:** las Fases 12 y 12.1 no redistribuyeron las historias entre las fases de implementación. Fueron un lote de **validación y cierre** de los 14 criterios de HU-03 a HU-06, documentado en [`evidencias/fase-12/matriz-validacion-hu-03-a-hu-06.md`](evidencias/fase-12/matriz-validacion-hu-03-a-hu-06.md) y [`evidencias/fase-12-1/matriz-correcciones-hu-03-a-hu-06.md`](evidencias/fase-12-1/matriz-correcciones-hu-03-a-hu-06.md). La tabla anterior sigue la planificación original de [`planificacion/plan-desarrollo.md`](planificacion/plan-desarrollo.md) §2.

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

### Manuales

| Documento | Contenido |
|-----------|-----------|
| [`manuales/manual-usuario.md`](manuales/manual-usuario.md) | Uso de la interfaz pública, mapa, filtros, administración y limitaciones de datos |
| [`manuales/manual-tecnico.md`](manuales/manual-tecnico.md) | Arquitectura de tres capas, contratos, HTTP, autenticación, PostGIS y estructura de repositorios |
| [`manuales/manual-instalacion.md`](manuales/manual-instalacion.md) | Requisitos, clonado, variables de entorno, base de datos, migraciones, arranque y verificación |
| [`manuales/manual-operacion.md`](manuales/manual-operacion.md) | Health checks, logs, dependencias, migraciones, errores, seguridad y recuperación |
| [`manuales/manual-pruebas.md`](manuales/manual-pruebas.md) | Comandos reales, evidencias, E2E remoto, resultados ejecutados y pruebas pendientes |
| [`manuales/manual-despliegue.md`](manuales/manual-despliegue.md) | Arquitectura propuesta, HTTPS, CORS, red privada, base de datos y verificaciones posteriores |

### Evidencias

| Documento | Contenido |
|-----------|-----------|
| [`evidencias/fase-0/README.md`](evidencias/fase-0/README.md) | Artefactos territoriales, hashes, archivos temporales y reproducción |
| [`evidencias/fase-1/README.md`](evidencias/fase-1/README.md) | Implementación HU-01/HU-02, respuestas reales, pruebas, capturas y límites |
| [`evidencias/fase-8/auditoria-integral.md`](evidencias/fase-8/auditoria-integral.md) | Auditoría de 46 criterios y brechas detectadas |
| [`evidencias/fase-11-2/matriz-validacion-final.md`](evidencias/fase-11-2/matriz-validacion-final.md) | Matriz 36/46 previa a Fase 12 |
| [`evidencias/fase-12/matriz-validacion-hu-03-a-hu-06.md`](evidencias/fase-12/matriz-validacion-hu-03-a-hu-06.md) | Resolución de 14 criterios HU-03 a HU-06, regresiones y decisiones |
| [`evidencias/fase-12-1/matriz-correcciones-hu-03-a-hu-06.md`](evidencias/fase-12-1/matriz-correcciones-hu-03-a-hu-06.md) | Cierre con evidencia directa de los 3 parciales de HU-03/HU-06 |
| [`evidencias/fase-12-1/resultados-regresion.md`](evidencias/fase-12-1/resultados-regresion.md) | Comandos y resultados exactos de CI, build, E2E y hashes |
| [`evidencias/fase-12-1/matriz-global-46-criterios.md`](evidencias/fase-12-1/matriz-global-46-criterios.md) | Matriz global actualizada: 44 aprobados, 2 parciales, 0 no aprobados |
| [`evidencias/fase-12-1/decisiones-y-limitaciones.md`](evidencias/fase-12-1/decisiones-y-limitaciones.md) | Decisiones, archivos tocados, estado Git y brechas pendientes |
| [`evidencias/fase-14/correcciones-bloqueos-altos.md`](evidencias/fase-14/correcciones-bloqueos-altos.md) | Correcciones de los bloqueos altos: health protegido, contrato `q` y workflow E2E |
| [`evidencias/fase-14/correcciones-seguridad-dependencias.md`](evidencias/fase-14/correcciones-seguridad-dependencias.md) | Fase 14.6: actualización de `typescript-eslint` y Vitest, audit en 0 y commits de seguridad |
| [`evidencias/fase-13/matriz-global-46-criterios.md`](evidencias/fase-13/matriz-global-46-criterios.md) | Matriz canónica actualizada: 46 aprobados, 0 parciales, 0 no aprobados |
| [`evidencias/fase-14-7/ejecucion-e2e-remota.md`](evidencias/fase-14-7/ejecucion-e2e-remota.md) | Fase 14.7: publicación verificada, E2E #2 en verde, artefacto y advertencia de Node.js 20 |
| [`despliegue/evidencia-fase-15.3-correccion-p0-01-y-secciones.md`](despliegue/evidencia-fase-15.3-correccion-p0-01-y-secciones.md) | Fase 15.3: corrección de P0-01, error cacheado de las secciones y verificación final |
| [`despliegue/evidencia-fase-15.2-despliegue-render.md`](despliegue/evidencia-fase-15.2-despliegue-render.md) | Fase 15.2: despliegue real en Render, configuración, ETL, P0-01 y P0-02 (registro histórico) |

### Evidencias de cierre (fases 12–14.7)

| Fase | Documento | Contenido | Estado Git |
|------|-----------|-----------|------------|
| 12 | [`evidencias/fase-12/matriz-validacion-hu-03-a-hu-06.md`](evidencias/fase-12/matriz-validacion-hu-03-a-hu-06.md) | Resolución de 14 criterios de HU-03 a HU-06 | Presente; sin seguimiento (`untracked`) |
| 12 | [`evidencias/fase-12/resolucion-hu-03.md`](evidencias/fase-12/resolucion-hu-03.md) | Cierre documentado de HU-03 | Presente; sin seguimiento (`untracked`) |
| 12 | [`evidencias/fase-12/resolucion-hu-04.md`](evidencias/fase-12/resolucion-hu-04.md) | Cierre documentado de HU-04 | Presente; sin seguimiento (`untracked`) |
| 12 | [`evidencias/fase-12/resolucion-hu-05.md`](evidencias/fase-12/resolucion-hu-05.md) | Cierre documentado de HU-05 | Presente; sin seguimiento (`untracked`) |
| 12 | [`evidencias/fase-12/resolucion-hu-06.md`](evidencias/fase-12/resolucion-hu-06.md) | Cierre documentado de HU-06 | Presente; sin seguimiento (`untracked`) |
| 12 | [`evidencias/fase-12/resultados-regresion.md`](evidencias/fase-12/resultados-regresion.md) | Comandos y resultados de CI, builds y regresiones | Presente; sin seguimiento (`untracked`) |
| 12 | [`evidencias/fase-12/decisiones-y-limitaciones.md`](evidencias/fase-12/decisiones-y-limitaciones.md) | Decisiones, alcance y limitaciones del lote | Presente; sin seguimiento (`untracked`) |
| 12.1 | [`evidencias/fase-12-1/matriz-correcciones-hu-03-a-hu-06.md`](evidencias/fase-12-1/matriz-correcciones-hu-03-a-hu-06.md) | Cierre con evidencia directa de los 3 parciales | Presente; sin seguimiento (`untracked`) |
| 12.1 | [`evidencias/fase-12-1/matriz-global-46-criterios.md`](evidencias/fase-12-1/matriz-global-46-criterios.md) | Matriz global intermedia: 44 aprobados, 2 parciales | Presente; sin seguimiento (`untracked`) |
| 12.1 | [`evidencias/fase-12-1/resultados-regresion.md`](evidencias/fase-12-1/resultados-regresion.md) | Regresión tras las correcciones | Presente; sin seguimiento (`untracked`) |
| 12.1 | [`evidencias/fase-12-1/decisiones-y-limitaciones.md`](evidencias/fase-12-1/decisiones-y-limitaciones.md) | Decisiones y estado Git del lote | Presente; sin seguimiento (`untracked`) |
| 13 | [`evidencias/fase-13/matriz-global-46-criterios.md`](evidencias/fase-13/matriz-global-46-criterios.md) | Matriz canónica: 46/46 aprobados | Presente; sin seguimiento (`untracked`) |
| 13 | [`evidencias/fase-13/auditoria-accesibilidad.md`](evidencias/fase-13/auditoria-accesibilidad.md) | Revisión interna; no auditoría formal externa | Presente; sin seguimiento (`untracked`) |
| 13 | [`evidencias/fase-13/pruebas-interaccion-mapa.md`](evidencias/fase-13/pruebas-interaccion-mapa.md) | Interacción de mapa ejecutada | Presente; sin seguimiento (`untracked`) |
| 13 | [`evidencias/fase-13/resultados-regresion.md`](evidencias/fase-13/resultados-regresion.md) | Regresión de cierre de la matriz canónica | Presente; sin seguimiento (`untracked`) |
| 13 | [`evidencias/fase-13/decisiones-y-limitaciones.md`](evidencias/fase-13/decisiones-y-limitaciones.md) | Decisiones y limitaciones de la fase | Presente; sin seguimiento (`untracked`) |
| 14 | [`evidencias/fase-14/correcciones-bloqueos-altos.md`](evidencias/fase-14/correcciones-bloqueos-altos.md) | Correcciones de bloqueos altos y health checks | Presente; sin seguimiento (`untracked`) |
| 14 | [`evidencias/fase-14/correcciones-seguridad-dependencias.md`](evidencias/fase-14/correcciones-seguridad-dependencias.md) | Fase 14.6: dependencias y auditoría en 0 | Presente; sin seguimiento (`untracked`) |
| 14.7 | [`evidencias/fase-14-7/ejecucion-e2e-remota.md`](evidencias/fase-14-7/ejecucion-e2e-remota.md) | Run `44979541605`: `success`, 36/36 y artefacto verificado | Presente; sin seguimiento (`untracked`) |

> Los 19 archivos de este subíndice están físicamente presentes en el portal e **incorporados a Git**; su presencia no implica aprobación académica ni cierre de PT-01, PT-02 o auditoría formal de accesibilidad. Las afirmaciones de cada documento están fechadas y se conservan como registro histórico. La matriz de Fase 13 (46/46) y el run de Fase 14.7 (36/36) mantienen su distinción: el E2E es regresión de los criterios cubiertos, no ejecución individual de los 46.

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
| D-7 | JWT corto + refresh token + contraseñas Argon2 | ✅ **Aprobada e implementada (2026-11-22)**; antes pendiente en Fase 1 |

**Condiciones aprobadas:** D-2 mantiene una sola fuente de verdad por frontera HTTP (documentos y contratos tipados, sin duplicar criterios); D-5 usa un token de servicio y el backend no se expone públicamente; D-6 usa contratos tipados por repo, sin importar código entre repositorios. **D-7** quedó resuelta con la implementación de la administración; el detalle y las referencias de evidencia están en [`arquitectura/arquitectura-solucion.md`](arquitectura/arquitectura-solucion.md).

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
| GitHub Actions remoto | ✅ Resuelto: E2E #2 `44979541605` en `success`, 36/36 y artefacto verificado |

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

El desarrollo funcional, las validaciones técnicas y el despliegue gratuito en Render están ejecutados; la documentación final y la entrega académica siguen pendientes. La referencia vigente es la [matriz canónica de 46 criterios](evidencias/fase-13/matriz-global-46-criterios.md), con 46/46 aprobados, la [evidencia E2E remota](evidencias/fase-14-7/ejecucion-e2e-remota.md) (`44979541605`, `success`, 36/36 pruebas en 15 archivos) y la [evidencia de despliegue](despliegue/evidencia-fase-15.2-despliegue-render.md). El run E2E es regresión remota de los criterios cubiertos, no ejecución individual de los 46 criterios; el despliegue real tiene **P0-01 APROBADO desde la Fase 15.3** y **P0-02 aprobado para los datos consultados**. Véase la [corrección final](despliegue/evidencia-fase-15.3-correccion-p0-01-y-secciones.md).

Los seis manuales ya están disponibles en la §3 (`manuales/`). **Sigue pendiente:** documentación final de entrega, entrega final y aceptación académica; trazabilidad final, respaldos/restauración y verificaciones finales. P0-01 quedó corregido y aprobado en la Fase 15.3. El portal ya está publicado con enlace único. PT-01, PT-02 y la auditoría formal de accesibilidad permanecen como pendientes históricos sin evidencia de cierre. La configuración de producción y CORS quedaron aplicados en Render, con la limitación de red privada documentada. No se declara aceptación académica ni se inicia el siguiente bloque sin revisión. El estado de Fase 1 y sus pendientes originales (PT-01, auditoría formal de accesibilidad y staging HTTPS) se conservan como registro histórico en las secciones anteriores y en [`evidencias/fase-1/README.md`](evidencias/fase-1/README.md).
