# Respaldo y observabilidad propuestos — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**  
**Estado: PROPUESTO / PENDIENTE DE EJECUCIÓN. No existe hoy un procedimiento de respaldo, restauración, agregación de logs ni alertas en los repositorios.**

Este documento desarrolla, sin duplicarlos, los puntos que la [auditoría](auditoria-estado-despliegue.md) marca como pendientes (§6.3) y que la [arquitectura propuesta](arquitectura-propuesta.md) solo enuncia en sus secciones 12 y 13. Es un **procedimiento objetivo**, no una configuración aplicada: frecuencias, retenciones, umbrales y destinos quedan como decisiones a aprobar. La ejecución forma parte de las etapas 5, 9 y 10 del [plan por etapas](plan-por-etapas.md).

Convención: **[EXISTENTE]**, **[PROPUESTA]**, **[PENDIENTE]** y **[NO VERIFICADO]** con el mismo significado que en la auditoría.

---

## 1. Alcance y principios

### 1.1 Qué se protege

| Dato | Situación actual | Tratamiento propuesto |
|---|---|---|
| Esquema de aplicación y datos territoriales | PostgreSQL + PostGIS; migraciones `001`–`009` y ETL reproducible | Incluir en el respaldo de la base privada |
| `admin_usuario` y `auditoria` | Tablas del backend | Incluir explícitamente: **no se reconstruyen desde los snapshots** |
| Snapshots fuente | Archivos versionados y verificados por `verify:data` | Se conservan como artefacto reproducible; no sustituyen al respaldo |
| Artefacto `dist/` | Generable desde el SHA congelado | Republicable; no requiere respaldo de estado |
| Logs | `console.log` / `console.error` en API y backend | Captura de stdout/stderr por la plataforma |

### 1.2 Principios

1. **[EXISTENTE]** La única fuente de estado es la base de datos; API y backend no guardan estado local.
2. **[PROPUESTA]** El respaldo se apoya en el mecanismo gestionado de la plataforma elegida en la [comparación](comparacion-alternativas.md), sin añadir librerías al código.
3. **[PROPUESTA]** Toda restauración termina con `npm run migrate`, `npm run verify:data` y health checks; las migraciones son idempotentes.
4. **[PROPUESTA]** Los secretos nunca aparecen en logs, documentos ni comandos registrados.
5. **[PENDIENTE]** Frecuencia, retención, cifrado, destino, RPO y RTO deben aprobarse antes de producción. **No se inventan valores.**

---

## 2. Respaldo propuesto

### 2.1 Política a decidir

La plataforma seleccionada ofrecerá copias gestionadas; sin embargo, **no se afirma que estén activas**, porque no hay cuenta ni instancia creada. Antes de la etapa 10 se registrará:

- Tipo de copia disponible en el plan contratado (instantánea, punto de restauración o equivalente).
- Frecuencia y ventana de retención aprobadas.
- Cifrado en reposo y control de acceso al destino.
- Responsable de verificar que la copia se completó.
- Separación entre entornos: staging y producción no comparten destino ni credenciales.

### 2.2 Comprobación sin ejecutar

Cada copia debe poder responder, como mínimo, a estas preguntas:

1. ¿Incluye el esquema de la aplicación, los datos territoriales, `admin_usuario` y `auditoria`?
2. ¿PostGIS estaba habilitado en el momento de la copia?
3. ¿La copia es restaurable en una instancia privada distinta?
4. ¿El registro de la copia identifica SHA de código y versión de migración?
5. ¿El acceso a la copia está restringido a roles autorizados?

**[PENDIENTE]** Responder estas preguntas con evidencia de la plataforma antes de dar por terminado el despliegue.

---

## 3. Restauración propuesta

### 3.1 Procedimiento

1. **Declarar incidencia** y detener la promoción de nuevos SHAs; registrar hora y responsable.
2. **Aislar escrituras** administrativas para evitar divergencia durante la restauración.
3. **Crear una instancia privada de destino** con PostGIS habilitado; nunca reutilizar credenciales de producción en staging.
4. **Restaurar la copia aprobada** mediante el mecanismo de la plataforma.
5. **Verificar integridad lógica:** ejecutar `npm run migrate`, `npm run verify:data` y comprobar tablas `admin_usuario` y `auditoria`.
6. **Arrancar el backend** con el SHA congelado y comprobar `/internal/v1/health` con y sin `X-Service-Token`.
7. **Arrancar la API** y comprobar `/api/v1/health`, CORS y una ruta pública crítica.
8. **Reanudar tráfico** solo después de la verificación final del plan por etapas §2, etapa 10.
9. **Registrar el resultado**: copia usada, SHA, responsable, duración y diferencias observadas.

### 3.2 Criterios de éxito

- Migraciones idempotentes sin errores.
- `verify:data` correcto.
- Health checks con comportamiento esperado.
- Sin secretos impresos ni credenciales copiadas entre entornos.
- Datos administrativos y auditoría presentes.

### 3.3 Reversión de la restauración

Si la copia restaurada es inválida, se conserva la instancia original sin borrarla, se documenta el fallo y se repite desde otra copia aprobada. **No se considera terminada una restauración solo porque el proceso haya finalizado sin error.**

---

## 4. Logs y correlación

### 4.1 Existente

- API y backend escriben en `console.log` / `console.error`.
- Las respuestas de error incluyen `code`, `message` y `requestId` **[EXISTENTE]**.
- El workflow E2E redirige salidas a archivos efímeros del runner; no es un sistema de logs **[EXISTENTE]**.

### 4.2 Propuesto

- Capturar stdout/stderr de API y backend con la plataforma seleccionada; frontend estático no genera logs de aplicación propios más allá de los del punto de entrega.
- Usar `X-Request-Id` / `requestId` para correlacionar una petición del navegador con la llamada interna y la respuesta.
- No añadir librerías de logging al código.
- Definir antes de producción: destino, retención, control de acceso, formato y qué campos quedan excluidos (tokens, cadenas de conexión, credenciales).
- Verificar que los mensajes de error públicos no filtran detalle interno.

### 4.3 Límites

No se instalará agregador propio, no se creará un esquema de índices y no se modificarán los mensajes del código sin autorización. La retención y el coste del destino son **[NO VERIFICADO]** hasta que exista cuenta y plan.

---

## 5. Health checks y comprobaciones sintéticas

| Comprobación | Destino | Expectativa | Estado |
|---|---|---|---|
| API pública | `GET /api/v1/health` por HTTPS | `{"status":"ok","service":"mi-barrio-api"}` | Implementado; sin entorno desplegado |
| Backend privado | `GET /internal/v1/health` desde la red privada | `200` con token; `401 NO_AUTORIZADO` sin token | Implementado; sin entorno desplegado |
| Frontend | Carga de SPA y ruta pública crítica | HTTPS, mapa, atribución OSM y llamadas a la API correcta | Propuesto |
| CORS | Petición desde el origen aprobado y desde otro | Aceptación/rechazo según `FRONTEND_ORIGIN` | Propuesto |
| Contratos | Hashes de la auditoría §5.2 | Coincidencia con `.sha256` | Verificado localmente; pendiente en producción |

Las sondas se ejecutarán desde la plataforma final; el workflow E2E actual no sustituye a esta supervisión.

---

## 6. Alertas propuestas

Se activarán solo cuando la plataforma esté contratada y se hayan aprobado umbrales. No se fijan cifras en este documento.

| Señal | Motivo | Respuesta inicial |
|---|---|---|
| Health de API o backend fallido | Indisponibilidad | Revisar logs correlacionados y reversión por SHA |
| Aumento de respuestas `5xx` | Error de servicio | Comparar con despliegue anterior y contratos |
| Exceso de `429` | Posible abuso o mala configuración de `RATE_LIMIT_MAX` | Verificar origen y límite vigente |
| Latencia alta en rutas críticas | Degradación | Revisar backend y pool de base |
| Saturación de conexiones a base | Cuello de botella | Revisar dimensionamiento antes de escalar |
| Certificado próximo a expirar | Riesgo de caída HTTPS | Renovación según plataforma |
| Fallo de verificación de contrato | Incompatibilidad API/backend | Detener promoción y comparar hashes |
| Copia de respaldo no completada | Riesgo de pérdida | Registrar incidencia y reprogramar verificación |

La escalada, los destinatarios y los umbrales quedan **[PENDIENTES]** de decisión humana.

---

## 7. Recuperación y continuidad

- **RPO y RTO:** no definidos; deben aprobarse con la política de respaldo antes de producción.
- **Reversión de código:** promoción por SHA registrado, según la arquitectura §14.2 y el plan por etapas.
- **Reversión de datos:** solo mediante copia restaurada y verificada; el ETL reproduce datos territoriales, **no** cambios administrativos ni auditoría.
- **Evidencia:** cada incidencia debe dejar registro de copia usada, SHA, responsable y resultado de health checks.
- **Frontend:** artefacto inmutable por versión; una reversión no altera la base.

---

## 8. Limitaciones y tareas pendientes reales

1. No hay instancia de base, copia ni destino de respaldo configurado.
2. No hay política de retención, cifrado, RPO ni RTO aprobada.
3. No hay destino de logs ni control de acceso definido.
4. No hay sondas externas ni alertas activas.
5. No se ha probado ninguna restauración.
6. No hay dominio, certificado ni entorno HTTPS desplegado.
7. No se han reutilizado ni validado secretos de producción; los secretos E2E no deben servir para producción.
8. El run E2E `44979541605` y los 36/36 tests siguen siendo evidencia de regresión de código, **no** de respaldo, observabilidad ni despliegue.

---

## Referencias internas verificadas

- [Índice de planificación de despliegue](README.md)
- [Auditoría del estado de despliegue](auditoria-estado-despliegue.md)
- [Arquitectura propuesta de despliegue](arquitectura-propuesta.md)
- [Comparación de alternativas](comparacion-alternativas.md)
- [Plan de implementación por etapas](plan-por-etapas.md)
- [Guía de despliegue y publicación](../manuales/manual-despliegue.md)

Este documento queda a la espera de revisión. No ejecutar respaldo, restauración ni configuración de monitoreo sin autorización explícita.
