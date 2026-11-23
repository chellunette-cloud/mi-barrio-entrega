# Evidencia Fase 15.1.4 — Validación definitiva de P0-01 (rate limit por IP real)

## 1. Identificación

- Fecha/hora local: 2026-11-22T22:07:08-05:00 a 2026-11-22T22:11:45-05:00
- Fecha/hora UTC: 2026-11-23T03:07:08Z a 2026-11-23T03:11:45Z
- SHA validado: `b9080ea2c35c19fb4be9624b86115ce5a3d0ecab` (`fix(api): configure trusted proxy for rate limiting`)
- Base original: `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd`
- Rama: `fase-15/p0-trust-proxy`
- Estado de P0-01 al cierre: **NO APROBADO — PARCIAL/BLOQUEADO para producción**

## 2. Estado Git verificado

| Comprobación | Resultado |
| --- | --- |
| Rama actual | `fase-15/p0-trust-proxy` |
| HEAD | `b9080ea2c35c19fb4be9624b86115ce5a3d0ecab` |
| `git status --porcelain` | Vacío |
| `origin/fase-15/p0-trust-proxy` | Igual a HEAD |
| Diff contra la base | Solo `src/http/app.ts` y `tests/integration/rateLimit.test.ts` |
| `main` | Sin modificaciones |
| Commits/push/ramas creados o eliminados en esta fase | Ninguno |

## 3. Servicios de staging verificados

| Servicio | ID | URL | Estado | Plan | Región | Repositorio / rama / SHA | Auto-deploy |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `mi-barrio-api-p0` | `srv-dc1q4enf3r2c73de8n8g` | `https://mi-barrio-api-p0.onrender.com` | Live | Free, $0/month, 0.1 CPU / 512 MB | Oregon (US West) | `chellunette-cloud/mi-barrio-api` / `fase-15/p0-trust-proxy` / `b9080ea` | Off |
| `mi-barrio-static-p0` | `srv-dc1q6i4s728c73d4msg0` | `https://mi-barrio-static-p0.onrender.com` | Live | Free, $0/month | Oregon (US West) | `chellunette-cloud/mi-barrio-frontend` / `main` / `332dc94` | Off |

Configuración relevante confirmada (sin valores secretos):

- API: `NODE_ENV=production`, `NODE_VERSION=22`, `HOST=0.0.0.0`, `PORT=10000`, `RATE_LIMIT_MAX=3`, `FRONTEND_ORIGIN=https://mi-barrio-static-p0.onrender.com`, `BACKEND_URL=http://127.0.0.1:9`. La clave `SERVICE_TOKEN` existe en staging; su valor no fue consultado, mostrado ni registrado.
- Build API: `npm ci --include=dev && npm run build`; start: `npm start`.
- Health check interno de Render: desactivado (evita consumir el cupo de `/api/v1/health`).
- Instancias: 1; autoscaling/manual scaling no disponibles en Free y sin cambios.
- Rewrite estático: `/api/*` → `https://mi-barrio-api-p0.onrender.com/api/*` (verificado en la configuración de Redirects/Rewrites).
- Código bajo prueba: `app.set('trust proxy', 1)` antes de `createPublicRateLimit`; `windowMs=60_000`, `limit=3`, `standardHeaders='draft-7'`, sin `keyGenerator` personalizado.

No se crearon planes pagos, tarjetas, discos, dominios, suscripciones ni recursos adicionales. Costo total: USD 0.

## 4. Procedimiento

1. Verificación secuencial de Git y de los dos servicios en el dashboard de Render.
2. Solicitudes HTTP secuenciales (nunca concurrentes) contra `/api/v1/health`, tanto directo como a través del rewrite del Static Site.
3. Se usaron únicamente IPs sintéticas de documentación en `X-Forwarded-For`: `198.51.100.10`, `192.0.2.10`, `192.0.2.20`, `192.0.2.50`, `192.0.2.60`, `192.0.2.61`, `192.0.2.62`, `192.0.2.70` y `203.0.113.20`. No se registraron IPs personales, tokens ni secretos.
4. Para separar ventanas de 60 s se esperaron 70 s entre baterías. Cada batería usó un único proceso PowerShell y manejó explícitamente respuestas 429.
5. No se modificó código, configuración, manifiesto ni repositorios; no se generaron commits.

## 5. Resultados

### 5.1 Contador y contrato 429 — ruta directa

Ruta: `GET https://mi-barrio-api-p0.onrender.com/api/v1/health`. Ventana iniciada el 2026-11-22T22:11:28-05:00, `X-Forwarded-For: 198.51.100.10` (P1).

| # | Ruta | Estado | `ratelimit` | Código de error | `x-request-id` | Esperado | Observado |
| --- | --- | --- | --- | --- | --- | --- | --- |
| P1-1 | `/api/v1/health` | 200 | `limit=3, remaining=2, reset=60` | — | `4c1e42a8-34cd-4b95-86d1-acc37c2772b8` | Primer hit de un único contador | 200, contador aparentemente nuevo |
| P1-2 | `/api/v1/health` | 200 | `limit=3, remaining=2, reset=60` | — | `10ef4108-ca4e-4820-894e-1d33b203df89` | `remaining=1` | `remaining=2`; contador distinto |
| P1-3 | `/api/v1/health` | 200 | `limit=3, remaining=2, reset=60` | — | `6da12259-5967-4c74-93cb-7f0d4822d0fe` | `remaining=0` | `remaining=2`; tercer contador distinto |
| P1-4 | `/api/v1/health` | 200 | `limit=3, remaining=1, reset=60` | — | `a0ad7552-b6be-4462-a25a-fecd2ce49b36` | 429 | 200 |
| P1-5 | `/api/v1/health` | 200 | `limit=3, remaining=1, reset=60` | — | `f6a6c644-3e17-4737-a01a-1b0c201ce7b1` | 429 | 200 |
| P1-6 | `/api/v1/health` | 200 | `limit=3, remaining=0, reset=59` | — | `35652533-8723-45e2-80c7-082fa45b4947` | 429 en el 4.º hit | 200 en el 6.º hit |

### 5.2 IP sintética distinta — misma ventana

Ruta: `GET https://mi-barrio-api-p0.onrender.com/api/v1/health`, ejecutada 1,8 s después de P1 con `X-Forwarded-For: 203.0.113.20` (P2).

| # | Ruta | Estado | `ratelimit` | Código de error | `x-request-id` | Esperado | Observado |
| --- | --- | --- | --- | --- | --- | --- | --- |
| P2-1 | `/api/v1/health` | 429 | `limit=3, remaining=0, reset=59` | `DEMASIADAS_SOLICITUDES` | `ec81cfec-c641-412b-888d-28d6e9082cf9` | Contador nuevo e independiente (`remaining=2`) | 429, mismo `reset` que P1 |
| P2-2 | `/api/v1/health` | 200 | `limit=3, remaining=0, reset=59` | — | `0d04761c-8543-4051-94bb-dfdaf99a661c` | `remaining=1` | 200 con `remaining=0` |
| P2-3 | `/api/v1/health` | 429 | `limit=3, remaining=0, reset=59` | `DEMASIADAS_SOLICITUDES` | `43d922d6-5e09-4ec3-bab6-5cbc2a266914` | `remaining=0` | 429 |
| P2-4 | `/api/v1/health` | 429 | `limit=3, remaining=0, reset=58` | `DEMASIADAS_SOLICITUDES` | `1ce8989a-f596-453e-ac0a-159ded64de52` | 429 | 429 |
| P2-5 | `/api/v1/health` | 429 | `limit=3, remaining=0, reset=58` | `DEMASIADAS_SOLICITUDES` | `1fabaf0a-d541-4665-920a-d2cf4dca48c1` | 429 | 429 |
| P2-6 | `/api/v1/health` | 429 | `limit=3, remaining=0, reset=58` | `DEMASIADAS_SOLICITUDES` | `9dc158cd-9e2e-4f8b-abc1-8a2245122458` | 429 | 429 |

### 5.3 Directo vs rewrite y contrato de error

Ruta: `GET https://mi-barrio-static-p0.onrender.com/api/v1/health` (rewrite `/api/*`), `X-Forwarded-For: 192.0.2.70`. Se registraron respuestas 429 consecutivas con `ratelimit: limit=3, remaining=0, reset=39…37` y código `DEMASIADAS_SOLICITUDES`. Entre los identificadores de solicitud observados: `36a8a288-6d13-46d6-bf7a-c66cc7b6190c`, `d823b304-e943-4c62-a5f5-07fed6fe41ea`, `6506253c-4b06-497f-9b8e-41213aed3636`, `55f4e439-882d-4d6c-9019-d1221d6852ac`, `300ffda9-ebf4-4a30-be25-932e8952bb9e`, `71b96faa-ecd5-48aa-b819-af3215be85dd`, `92993ad4-0593-4e84-8f6e-cd2463f8683f`. El rewrite alcanza la API y conserva el contrato 429; no permite por sí solo identificar la IP del cliente.

### 5.4 Otras observaciones

- Con `X-Forwarded-For: 192.0.2.61`, tras 70 s de inactividad, 10 solicitudes secuenciales devolvieron `remaining` 2, 2, 2, 1, 0, 429, 1, 429, 429, 429 con `reset` 60/59. Tres contadores nuevos y simultáneos confirman la fragmentación.
- Con `X-Forwarded-For: 192.0.2.60`, una IP sintética nunca usada recibió 429 en el primer intento (`reset=12`), lo que descarta que el contador se derive del valor proporcionado por el cliente.
- Las respuestas incluyeron `ratelimit-policy: 3;w=60`, `x-request-id` único por solicitud y `x-render-origin-server: Render`; no se observaron credenciales ni secretos en los encabezados.

## 6. Criterios

| Criterio | Estado | Justificación |
| --- | --- | --- |
| A. Contador compartido para la misma IP | **FALLIDO** | Tres solicitudes consecutivas con la misma IP sintética iniciaron tres contadores distintos (`remaining=2` cada una). |
| B. HTTP 429 y contrato `DEMASIADAS_SOLICITUDES` con `ratelimit` y `requestId` | **APROBADO** | Confirmado en ruta directa y vía rewrite. |
| C. Contadores independientes por IP sintética | **FALLIDO / NO COMPROBABLE** | Cambiar de `198.51.100.10` a `203.0.113.20` no creó un contador nuevo; reutilizó los mismos buckets con `reset` 59/58. |
| D. Suplantación del salto izquierdo de `X-Forwarded-For` | **PARCIAL** | El valor sintético no gobierna la clave, por lo que no se pudo suplantar; tampoco se pudo demostrar que `req.ip` sea la IP real del cliente. |
| E. Directo vs rewrite | **PARCIAL** | El rewrite funciona y propaga el contrato 429; la identidad de la IP detrás de ambos caminos no quedó demostrada. |
| F. Sin secretos, sin producción, sin cambios de código, costo USD 0 | **APROBADO** | Verificado durante toda la fase. |

## 7. Conclusión

P0-01 **no debe aprobarse** para despliegue a producción con el estado actual. La implementación local y el commit `b9080ea` son correctos en el entorno de pruebas (6/6 pruebas de proxy en local), pero en Render la clave del limitador no sigue la IP sintética proporcionada: se fragmenta en varios contadores y se comparte entre IPs distintas dentro de la misma ventana. El comportamiento observado es compatible con que `req.ip` esté resolviendo a una dirección de la capa de proxy y no a la IP real del cliente; con `trust proxy=1` no se puede afirmar lo contrario. El commit permanece publicado en `origin/fase-15/p0-trust-proxy` y no se ha modificado.

## 8. Limitaciones

- No existe un endpoint de diagnóstico que exponga `req.ip`/`req.ips`; la determinación se infiere del comportamiento de la cabecera `ratelimit`, sin alterar la confianza del proxy ni usar IPs personales.
- No se ejecutó una prueba sin `X-Forwarded-For` controlado para evitar involucrar la IP real del entorno; ese escenario queda como **BLOQUEADO** por diseño de esta validación.
- No se realizaron cambios correctivos (por ejemplo, ajustar la profundidad de confianza o usar una cabecera de IP delegada), porque estaban expresamente fuera de alcance.
- Para revalidar sería necesario recrear el staging; los servicios de esta fase se eliminaron después de guardar esta evidencia.

## 9. Limpieza

Tras verificar nombres e IDs, se eliminaron `mi-barrio-api-p0` (`srv-dc1q4enf3r2c73de8n8g`) y `mi-barrio-static-p0` (`srv-dc1q6i4s728c73d4msg0`). La verificación posterior mostró `Production is empty` y 0 servicios en el proyecto; Facturación mostró `Unbilled Charges $0.00`, `TOTAL BALANCE $0.00` y `No past invoices`. No se eliminaron repositorios, ramas ni commits. No quedan servicios de staging, planes pagos, discos, dominios ni cargos asociados a esta fase.

Nota de alcance: el repositorio de entrega ya tenía cambios y archivos no rastreados anteriores a esta fase; no se tocaron. El único archivo creado aquí es este documento de evidencia, sin commit.
