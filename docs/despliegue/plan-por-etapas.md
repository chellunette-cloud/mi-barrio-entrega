# Plan de implementación por etapas — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**  
**Estado: PROPUESTO / PENDIENTE DE EJECUCIÓN. No se ha ejecutado ninguna etapa, no se crearon recursos ni se desplegó servicio.**

Este plan convierte la [arquitectura propuesta](arquitectura-propuesta.md) y la [alternativa recomendada](comparacion-alternativas.md) en una secuencia controlada de once etapas. Toma como estado inicial los hechos de la [auditoría](auditoria-estado-despliegue.md): tres repositorios limpios, contratos con hashes coincidentes, workflows de CI/E2E sin publicación y ausencia de Dockerfile, compose, manifiestos, dominio o infraestructura.

**Regla de ejecución:** ninguna etapa se inicia sin autorización explícita, sin que la anterior haya sido aceptada y sin que exista decisión humana sobre proveedor, plan, región y dominios. Los nombres de plataforma que aparecen aquí proceden de la recomendación de la comparación; **siguen pendientes de decisión externa**.

Convención: **[EXISTENTE]**, **[PROPUESTA]**, **[PENDIENTE]** y **[NO VERIFICADO]** con el mismo significado que en la auditoría y la arquitectura.

---

## 1. Resumen de etapas

| # | Etapa | Resultado esperado | Estado |
|---|---|---|---|
| 1 | Gobernanza y decisión formal | Proveedor, plan, dominios y responsable aprobados | **[PENDIENTE]** |
| 2 | Congelación de versiones y contratos | SHAs y hashes registrados; CI en verde | **[EXISTENTE]** la disciplina; **[PENDIENTE]** aplicarla al despliegue |
| 3 | Definición de empaquetado | Especificación de build sin crear archivos en esta entrega | **[PENDIENTE]** |
| 4 | Cuentas, red privada y DNS | Entorno aislado y nombres internos definidos | **[PENDIENTE]** |
| 5 | Base PostgreSQL + PostGIS | Extensión, migraciones y ETL verificados | **[PENDIENTE]** |
| 6 | Backend privado | Health protegido y sin exposición pública | **[PENDIENTE]** |
| 7 | API pública | CORS, rate limit y health verificados contra el origen real | **[PENDIENTE]** |
| 8 | Frontend estático | `dist/` publicado por HTTPS con la API correcta | **[PENDIENTE]** |
| 9 | Validación en staging | Regresión sobre topología desplegada, no efímera | **[PENDIENTE]** |
| 10 | Promoción a producción y verificación final | Servicios, dominio, TLS y monitores operativos | **[PENDIENTE]** |
| 11 | Cierre académico y entrega | Evidencias, pendientes reales y handbook actualizados | **[PENDIENTE]** |

---

## 2. Etapas detalladas

### Etapa 1 — Gobernanza y decisión formal

- **Prerrequisito:** autorización humana para contratar y crear infraestructura.
- **Acciones propuestas:** aprobar la alternativa A o la contingencia B de la [comparación](comparacion-alternativas.md); fijar proveedor, plan, región, dominios de frontend y API, y responsable de la cuenta. Registrar la decisión sin imprimir secretos.
- **Verificación:** existe un registro con fecha, decisión y responsable; no hay recursos creados antes de esa decisión.
- **Aceptación:** decisión aprobada y compatible con los criterios de la comparación §1.
- **Reversión:** no contratar; la planificación queda documentada y sin coste.

### Etapa 2 — Congelación de versiones y contratos

- **Prerrequisito:** etapa 1 aceptada.
- **Acciones propuestas:** registrar los HEAD aprobados de los tres repositorios; ejecutar `contracts:verify` y confirmar los hashes de la auditoría §5.2; conservar la disciplina de SHAs fijados del workflow E2E.
- **Verificación:** los hashes calculados coinciden con los archivos `.sha256`; los tres repositorios están limpios; el registro de SHAs existe antes de cualquier build de publicación.
- **Aceptación:** versión congelada sin cambios de contrato.
- **Reversión:** descartar el registro y repetir la congelación con nuevos SHAs autorizados.

### Etapa 3 — Definición de empaquetado

- **Prerrequisito:** etapa 2 aceptada.
- **Acciones propuestas:** definir, **sin crear todavía**, la estrategia de imagen OCI o proceso gestionado para API y backend, usando los comandos reales `npm ci`, `build` y `start` documentados. El frontend se tratará como artefacto estático `dist/`.
- **Verificación:** la estrategia no añade dependencias, no modifica `package.json`, contratos ni workflows, y permite inyectar variables por entorno.
- **Aceptación:** diseño de empaquetado aprobado; los archivos correspondientes se crearán solo con autorización específica.
- **Reversión:** mantener el estado actual sin Dockerfile ni manifiestos; no publicar.

### Etapa 4 — Cuentas, red privada y DNS

- **Prerrequisito:** etapas 1–3 aceptadas.
- **Acciones propuestas:** crear el entorno de staging, la red privada que permita a la API resolver al backend y las zonas DNS de los dominios aprobados. Configurar TLS mediante el mecanismo de la plataforma.
- **Verificación:** el backend no tiene IP o puerto público; la API resuelve el nombre interno; los certificados cubren los dominios exactos aprobados.
- **Aceptación:** topología privada y nombres confirmados antes de desplegar servicios.
- **Reversión:** eliminar DNS y red creados; no afecta a los repositorios.

### Etapa 5 — Base PostgreSQL + PostGIS

- **Prerrequisito:** etapa 4 aceptada.
- **Acciones propuestas:** aprovisionar la instancia privada, habilitar PostGIS **antes** de migrar, inyectar `DATABASE_URL` como secreto y ejecutar de forma controlada `npm run migrate`, `npm run etl` y `npm run verify:data`.
- **Verificación:** `PostGIS` disponible; migraciones `001`–`009` idempotentes; ETL transaccional y hashes de snapshots coincidentes; credenciales no versionadas ni impresas.
- **Aceptación:** base lista con datos reproducibles y sin acceso desde Internet.
- **Reversión:** restaurar desde el punto de la etapa 5 del [plan de respaldo](respaldo-observabilidad.md) o descartar la instancia si aún no hay datos administrativos.

### Etapa 6 — Backend privado

- **Prerrequisito:** etapa 5 aceptada.
- **Acciones propuestas:** desplegar el backend con `SERVICE_TOKEN`, secretos JWT y `DATABASE_URL` inyectados; mantener `HOST=0.0.0.0` solo dentro de la red privada y sin puerto publicado.
- **Verificación:** `GET /internal/v1/health` responde `{"status":"ok","service":"mi-barrio-backend"}` con token y `401 NO_AUTORIZADO` sin token; desde Internet no hay respuesta.
- **Aceptación:** backend accesible solo para la API.
- **Reversión:** detener el servicio y volver al SHA anterior registrado en la etapa 2.

### Etapa 7 — API pública

- **Prerrequisito:** etapa 6 aceptada.
- **Acciones propuestas:** desplegar la API con `FRONTEND_ORIGIN`, `BACKEND_URL`, `SERVICE_TOKEN`, `RATE_LIMIT_MAX` y `NODE_ENV=production`. Ajustar `HOST` a `0.0.0.0` si el empaquetado lo requiere.
- **Verificación:** `GET /api/v1/health` responde `{"status":"ok","service":"mi-barrio-api"}` por HTTPS; CORS rechaza orígenes distintos al aprobado; `RATE_LIMIT_MAX` no supera el límite de producción; las rutas críticas devuelven el contrato público válido.
- **Aceptación:** frontera pública operativa sin acceso directo a base.
- **Reversión:** desactivar el servicio o promover el SHA anterior; el backend permanece intacto.

### Etapa 8 — Frontend estático

- **Prerrequisito:** etapas 6 y 7 aceptadas.
- **Acciones propuestas:** construir `dist/` con `VITE_API_BASE_URL` apuntando al dominio de la API aprobado y publicarlo en el punto estático seleccionado.
- **Verificación:** carga de SPA por HTTPS, mapa con atribución OpenStreetMap visible, llamadas `/api/v1/**` al dominio correcto y sin `localhost`.
- **Aceptación:** frontend accesible únicamente con el origen usado en `FRONTEND_ORIGIN`.
- **Reversión:** republicar el artefacto del SHA anterior; no requiere cambios de base.

### Etapa 9 — Validación en staging

- **Prerrequisito:** etapas 5–8 aceptadas.
- **Acciones propuestas:** ejecutar la regresión E2E contra la topología desplegada, usando SHAs fijados y los secretos de staging. No reutilizar los secretos del workflow como secretos de producción.
- **Verificación:** resultados de la suite, health checks, CORS real y rutas administrativas registrados. La ejecución remota previa `44979541605` sigue siendo solo evidencia de código.
- **Aceptación:** staging reproduce el comportamiento esperado sin exponer backend ni base.
- **Reversión:** detener la promoción y corregir en staging; nunca promover con fallos abiertos.

### Etapa 10 — Promoción a producción y verificación final

- **Prerrequisito:** etapa 9 aceptada y decisión formal de publicación.
- **Acciones propuestas:** crear el entorno de producción con secretos propios, publicar dominio/TLS, activar sondas y alertas definidas en [respaldo y observabilidad](respaldo-observabilidad.md) y promover exactamente los SHAs congelados.
- **Verificación obligatoria antes de considerar terminado el despliegue:**
  1. Health de API y backend con y sin token.
  2. HTTPS, redirección y certificado vigente en frontend y API.
  3. CORS desde el origen real y rechazo de otro origen.
  4. Contratos público e interno con los hashes de la etapa 2.
  5. Rutas públicas críticas y panel administrativo con JWT válido.
  6. Migraciones/ETL ya aplicados y `verify:data` correcto.
  7. Backend y base inaccesibles desde Internet.
  8. Logs capturados y sondas/alertas activas.
  9. Respaldo configurado y prueba de restauración documentada.
  10. Atribución de OpenStreetMap visible.
- **Aceptación:** los diez puntos anteriores están registrados con fecha y responsable. **No basta con que el E2E esté en verde.**
- **Reversión:** reapuntar DNS al artefacto/versión anterior, detener nueva versión y ejecutar la restauración de la etapa 5 si hay inconsistencia de datos.

### Etapa 11 — Cierre académico y entrega

- **Prerrequisito:** etapa 10 aceptada.
- **Acciones propuestas:** enlazar evidencias de despliegue, actualizar el estado de publicación del portal de entrega, y registrar los pendientes reales: PT-01, PT-02, auditoría formal de accesibilidad y aceptación académica. Mantener los documentos del Bloque C como referencia.
- **Verificación:** los enlaces internos del índice resuelven; no hay secretos en documentos; el estado de los tres repositorios y sus HEAD queda registrado; se distingue publicación de GitHub, E2E y despliegue.
- **Aceptación:** entrega final sin afirmar tareas no ejecutadas.
- **Reversión:** mantener el sistema desplegado y marcar los pendientes como abiertos; no revertir evidencias existentes.

---

## 3. Puertas de calidad transversales

Antes de cada promoción se comprueban, sin reemplazar las verificaciones específicas:

- `contracts:verify` y hashes de la auditoría §5.2.
- Límite de 100 líneas y CI de los tres repositorios en verde.
- SHAs fijados, sin cambios de contrato ni dependencias nuevas.
- Secretos por entorno, sin valores impresos ni reutilización E2E.
- Registro de quién aprueba y cuándo, con posibilidad de reversión.

---

## 4. Límites de este plan

- No crea cuentas, recursos, DNS, certificados, imágenes, workflows ni archivos de empaquetado.
- No ejecuta migraciones, ETL, builds de publicación ni pruebas.
- No modifica código, contratos, variables de entorno, workflows ni infraestructura.
- No fija precios, cuotas, regiones, dominios ni proveedores definitivos.
- La [configuración de producción](arquitectura-propuesta.md#9-variables-de-entorno-necesarias-por-servicio-sin-valores-secretos) y las [validaciones previas](arquitectura-propuesta.md#16-aspectos-que-necesitan-validación-antes-de-implementar-el-despliegue) siguen siendo la referencia técnica.

---

## Referencias internas verificadas

- [Índice de planificación de despliegue](README.md)
- [Auditoría del estado de despliegue](auditoria-estado-despliegue.md)
- [Arquitectura propuesta de despliegue](arquitectura-propuesta.md)
- [Comparación de alternativas](comparacion-alternativas.md)
- [Respaldo y observabilidad propuestos](respaldo-observabilidad.md)
- [Guía de despliegue y publicación](../manuales/manual-despliegue.md)

Este plan queda a la espera de revisión. No ejecutar etapa alguna sin autorización explícita.
