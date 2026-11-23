# Comparación de alternativas de despliegue — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**  
**Estado: PROPUESTA PENDIENTE DE DECISIÓN EXTERNA. No se contrató proveedor, no se registró dominio, no se crearon recursos ni se desplegó servicio.**

Este documento complementa la [arquitectura propuesta](arquitectura-propuesta.md), que deliberadamente no eligió proveedores. Aquí se registra la alternativa recomendada, su justificación y la contingencia, reutilizando la revisión de fuentes oficiales realizada previamente el 2026-11-22. **No se repiten consultas externas ni se introducen precios, límites numéricos ni datos no verificados.**

Convención:

- **[EXISTENTE]**: comprobado en la [auditoría](auditoria-estado-despliegue.md) o en código.
- **[PROPUESTA]**: recomendación sujeta a aprobación humana.
- **[NO VERIFICADO]**: requiere comprobación en el momento de la contratación.

---

## 1. Criterios de comparación

Los criterios derivan de las decisiones ya aprobadas en la [arquitectura propuesta](arquitectura-propuesta.md) y de las restricciones de la [auditoría](auditoria-estado-despliegue.md):

| Criterio | Requisito | Origen |
|---|---|---|
| Frontend | Contenido estático HTTPS desde `dist/` | Arquitectura §2.1 y §5 |
| API | Servicio Node público, sin acceso a base | Arquitectura §2.2 y §5 |
| Backend | Servicio Node privado, sin puerto público, protegido por `X-Service-Token` | Arquitectura §2.3 y §6 |
| Base | PostgreSQL + PostGIS en red privada; migraciones y ETL controlados | Arquitectura §2.4 y §12 |
| Contratos | Sin cambios en OpenAPI; hashes verificados | Auditoría §5.2 |
| Secretos | Inyección por plataforma; sin valores en repositorio; E2E ≠ producción | Arquitectura §10 |
| Red | API resuelve al backend por nombre interno; backend y base inaccesibles desde Internet | Arquitectura §5 y §6 |
| Operación | Health checks, logs de stdout/stderr, reversión por SHA | Arquitectura §13 y §14 |
| Alcance académico | Sin dependencias nuevas ni modificación de código/workflows | Arquitectura §1.2 y §15.1 |

**Regla aplicada:** ninguna alternativa que obligue a exponer el backend o la base, a reescribir contratos o a añadir dependencias al código puede ser seleccionada.

---

## 2. Alternativas evaluadas

La tabla resume la valoración cualitativa. Los importes y las cifras de límites se dejaron fuera deliberadamente: dependen de cuenta, región y fecha de contratación, y no fueron verificados en esta entrega.

| Alternativa | Frontend | API + backend | PostgreSQL + PostGIS | Valoración frente a la arquitectura |
|---|---|---|---|---|
| **A. Cloudflare Pages + Render Web Service + Render Private Service + Render Postgres** | Estático en Pages | Web Service público y Private Service interno en la misma red | Base gestionada de Render con PostGIS según documentación oficial | **Seleccionada.** Cubre los cuatro componentes, mantiene backend y base privados y concentra la operación en un proveedor para los servicios con estado. |
| **B. Cloudflare Pages + Fly.io + Aiven** | Estático en Pages | Servicios Fly.io con red privada interna | Base gestionada Aiven con PostGIS según documentación oficial | **Contingencia.** Más flexible si Render no cumple requisitos de red, PostGIS o disponibilidad; exige validar la interconexión entre proveedores. |
| **C. Vercel o Netlify + servicios Node gestionados + base externa** | Estático en la plataforma correspondiente | Requiere adaptar la ejecución de Node a su modelo | Depende de proveedor externo | Evaluada. Las condiciones de uso y créditos de planes personales no garantizan el modelo de servicio privado continuo; no se selecciona sin decisión formal. |
| **D. GitHub Pages + Cloud Run + Cloud SQL** | Estático en Pages | Cloud Run permite separar servicios | Cloud SQL con PostGIS según documentación oficial | Evaluada. Técnicamente viable, pero introduce una combinación de tres plataformas y revisión de permisos/costes de Google Cloud; no se selecciona por defecto. |
| **E. Railway o Supabase/Neon como base** | Requiere alojamiento estático acompañante | Railway admite servicios, pero su modelo debe verificarse | Supabase y Neon documentan PostGIS/planes, con particularidades de red y Free tier | Evaluada. Queda como opción de estudio, no como recomendación, porque no se verificó en la revisión previa que cubra simultáneamente red privada, backend sin exposición y continuidad académica sin cambios. |

> Las denominaciones de planes y servicios se usan solo como categorías. **No se afirma que exista cuenta, saldo, cuota disponible ni SLA**; todo eso es **[NO VERIFICADO]**.

---

## 3. Alternativa seleccionada y justificación

### 3.1 Selección propuesta

**[PROPUESTA] Alternativa A:**

- **Frontend:** Cloudflare Pages, publicando el artefacto `dist/` generado por `npm run build`.
- **API:** Render Web Service, accesible públicamente por HTTPS, con `FRONTEND_ORIGIN`, `SERVICE_TOKEN`, `BACKEND_URL`, `RATE_LIMIT_MAX` y `NODE_ENV` inyectados como secretos/variables de entorno.
- **Backend:** Render Private Service, sin puerto público, resoluble desde la API por nombre interno, con `DATABASE_URL`, `SERVICE_TOKEN` y secretos JWT inyectados.
- **Base:** Render Postgres, con extensión PostGIS habilitada antes de ejecutar las migraciones `001`–`009` y el ETL.

### 3.2 Por qué esta alternativa

1. **Ajuste exacto a la topología aprobada.** La [arquitectura](arquitectura-propuesta.md) exige navegador → frontend → API → backend → base. La alternativa A mantiene esa cadena sin exponer backend ni base.
2. **Reutiliza el código actual.** No requiere cambiar CORS, `X-Service-Token`, validación JWT en backend, health checks ni contratos; solo aporta ubicación y secretos.
3. **Red privada verificable.** Render permite un servicio privado dentro de su red, lo que hace aplicable el nombre interno ya documentado como ejemplo `http://mi-barrio-backend:3001`, sin publicarlo.
4. **PostGIS en la capa de datos.** La documentación oficial de Render Postgres incluye soporte PostGIS; debe confirmarse en el plan contratado antes de migrar.
5. **Operación concentrada.** API, backend y base quedan bajo un mismo modelo de secretos, logs y reinicios, lo que simplifica la [verificación final](plan-por-etapas.md) y el [plan de respaldo y observabilidad](respaldo-observabilidad.md).
6. **Reversibilidad.** La publicación de cada SHA y la existencia de health checks permiten volver a una versión anterior sin cambiar contratos, tal como exige la arquitectura §14.2.
7. **Coherencia con la evidencia.** La regresión E2E documentada continúa siendo válida como prueba de código; el despliegue se validará por separado, sin reinterpretarla como publicación.

### 3.3 Contingencia

**[PROPUESTA] Alternativa B:** Cloudflare Pages + Fly.io + Aiven.

Se activaría solo si, al intentar contratar la alternativa A, aparece alguno de estos bloqueos:

- El plan disponible de Render no ofrece Postgres con PostGIS o red privada compatible.
- Las condiciones de Render impiden mantener el backend sin puerto público.
- La decisión académica prefiere separar proveedor de base y servicios.

Antes de adoptarla hay que verificar, sin darla por hecha, la conectividad privada entre Fly.io y Aiven, la habilitación de PostGIS y la inyección de secretos. **No se ejecuta ni se da por válida en este documento.**

---

## 4. Fuentes oficiales reutilizadas

Estas fuentes fueron consultadas en la revisión previa del **2026-11-22** y todas respondieron correctamente en ese momento. **No se volvieron a consultar en esta entrega**, en cumplimiento de la instrucción de no repetir investigaciones. Los nombres de planes y límites deben reconfirmarse al contratar.

| Proveedor | Documentación oficial consultada | Uso en la comparación |
|---|---|---|
| Cloudflare | Cloudflare Pages — límites y build settings | Frontend estático de las alternativas A y B |
| Vercel | Vercel — Hobby plan / límites | Alternativa C, no seleccionada |
| Netlify | Netlify — créditos y límites de plan | Alternativa C, no seleccionada |
| GitHub | GitHub Pages — límites y contenido estático | Alternativa D y frente de las alternativas A/B |
| Render | Render — precios, Web Services, Private Services y Postgres/PostGIS | Base de la alternativa A |
| Railway | Railway — precios y modelo de servicios | Alternativa E, no seleccionada |
| Fly.io | Fly.io — precios y redes privadas | Contingencia B |
| Google Cloud | Cloud Run — precios; Cloud SQL — PostGIS y precios | Alternativa D, no seleccionada |
| Aiven | Aiven — precios, plan Free y PostGIS | Contingencia B |
| Supabase | Supabase — precios y PostGIS | Alternativa E, no seleccionada |
| Neon | Neon — planes | Alternativa E, no seleccionada |

Son **17 páginas oficiales** agrupadas en los 11 proveedores/productos de la tabla. No se transcriben cifras porque no fueron verificadas de nuevo y podrían cambiar.

---

## 5. Riesgos y condiciones previas

| Riesgo | Clasificación | Mitigación |
|---|---|---|
| Proveedor o plan sin PostGIS | **[NO VERIFICADO]** | Confirmar en documentación oficial antes de crear la base; activar contingencia B |
| Red privada no equivalente al nombre de ejemplo | **[NO VERIFICADO]** | Probar resolución y token desde la API antes de liberar tráfico |
| Secretos E2E reutilizados en producción | **[EXISTENTE]** el riesgo en arquitectura §10 | Generar secretos nuevos por entorno; no copiar los del workflow |
| Límites de planes personales insuficientes | **[NO VERIFICADO]** | Revisar tarifa vigente y créditos antes de contratar; no asumir plan gratuito |
| Dominio/TLS sin decidir | **[EXISTENTE]** ausencia verificada en auditoría §6.3 | Aprobar nombres antes de configurar CORS y publicar |
| E2E verde interpretado como despliegue | **[EXISTENTE]** interpretación incorrecta documentada | Aplicar las verificaciones del [plan por etapas](plan-por-etapas.md) |

---

## 6. Decisión pendiente

La alternativa A queda **recomendada pero no ejecutada**. Para convertirla en definitiva se requiere decisión humana sobre proveedor, plan, región, dominios y responsable de la cuenta. Hasta entonces:

- No se crean cuentas ni recursos.
- No se modifica `README.md`, código, contratos, workflows ni infraestructura.
- No se publica ni se despliega nada.
- La [configuración de producción](arquitectura-propuesta.md#9-variables-de-entorno-necesarias-por-servicio-sin-valores-secretos) y las [verificaciones finales](plan-por-etapas.md) siguen siendo las referencias obligatorias.

---

## Referencias internas verificadas

- [Índice de planificación de despliegue](README.md)
- [Auditoría del estado de despliegue](auditoria-estado-despliegue.md)
- [Arquitectura propuesta de despliegue](arquitectura-propuesta.md)
- [Plan de implementación por etapas](plan-por-etapas.md)
- [Respaldo y observabilidad propuestos](respaldo-observabilidad.md)
- [Guía de despliegue y publicación](../manuales/manual-despliegue.md)

Este documento queda a la espera de revisión. No continuar con ejecución, contratación ni publicación sin autorización explícita.
