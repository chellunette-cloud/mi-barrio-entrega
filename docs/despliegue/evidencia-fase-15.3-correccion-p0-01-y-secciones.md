# Fase 15.3 — Corrección de P0-01 y de las secciones desplegadas

**Fecha:** 2026-11-23. **Ámbito:** corrección técnica final sobre el despliegue existente; sin infraestructura nueva, sin planes pagos y sin cambios de contrato.

## 1. Versiones desplegadas

| Servicio | Repositorio / rama | SHA verificado | Resultado |
|---|---|---|---|
| API | `mi-barrio-api` / `fase-15/p0-trust-proxy` | `0661782534b979f2497add5402fc2a3c3f3f4091` | Auto-Deploy `Deployed`, 18 s |
| Frontend | `mi-barrio-frontend` / `main` | `4237608525a8df3cbc033aa11376772564f68294` | Auto-Deploy `Deployed`, 18,3 s |
| Backend | `mi-barrio-backend` / `main` | `a6c912542873665659fff4a38c1efdd5f13483be` | Sin cambios |

`git ls-remote` confirmó los dos SHA remotos antes y después del push. Contratos sin cambios: interno `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2`, público `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e`. CI: API 32/32 pruebas; frontend 13/13 pruebas y build; límite de 100 líneas y hashes de contrato verificados en ambos.

## 2. P0-01 — causa real

Render/Cloudflare **añade** su información a `X-Forwarded-For` sin borrar el valor aportado por el cliente. Con `X-Forwarded-For: 198.51.100.10`, el endpoint protegido `/internal/v1/diagnostico-ip` mostró antes de la corrección:

`forwardedFor = 198.51.100.10, 38.226.139.81, 104.22.72.20, <interno>` · `ip = <interno>` · `trustProxy = 1`

La entrada izquierda es falsificable; la derecha es un salto interno de Render. Con `trust proxy = 1`, Express resuelve `req.ip` en ese salto interno, de modo que el contador del limitador se fragmentaba entre hops y no seguía al cliente. `trust proxy = 1` no era una confianza indiscriminada, pero era insuficiente para identificar al cliente.

## 3. Corrección aplicada

- `src/http/middleware/clientIp.ts`: usa `CF-Connecting-IP` solo si `node:net.isIP` lo valida; si no existe, cae a `req.ip` (desarrollo/local).
- `rateLimit.ts`: `keyGenerator: (req) => clientIp(req)`. La cabecera `CF-Connecting-IP` la genera Cloudflare; un valor enviado por el cliente es rechazado por el borde con **403** (verificado en producción).
- `app.ts`: `trust proxy` se mantiene en `1`; el diagnóstico expone ahora `clientIp`, `clientIpSource`, `cfConnectingIp` y el `forwardedFor` recibido.
- `errorHandler.ts` y `rateLimit.ts`: `Cache-Control: no-store` en 404, errores y 429.

Pruebas nuevas (`tests/integration/rateLimitCf.test.ts`, 5 casos): IP distintas con contadores independientes; misma IP agota su contador; `X-Forwarded-For` manipulado no evita el límite; valor inválido no altera la clave; diagnóstico informa la IP efectiva y su origen. Las 5 pasan junto con las 27 pruebas previas de la API.

## 4. Evidencia real en Render (post-despliegue)

Consultas al endpoint protegido con el token de servicio obtenido del panel de Render, **sin imprimirlo**:

| Prueba | Resultado |
|---|---|
| Sin `X-Forwarded-For` | `clientIpSource=cf-connecting-ip`; `clientIp=38.226.***.***`, igual a la IP real que Cloudflare añadió al `forwardedFor` |
| `X-Forwarded-For: 198.51.100.10` | `clientIp` no cambia; sigue siendo la IP real del cliente |
| `X-Forwarded-For: 203.0.113.99, 198.51.100.10, 192.0.2.44` | `clientIp` no cambia; la suplantación del bloque izquierdo no altera la clave |
| `CF-Connecting-IP: 192.0.2.70` enviada por el cliente | **403** del borde Cloudflare |
| Tres solicitudes con XFF distinto desde el mismo cliente | `ratelimit: remaining=119 → 118 → 117` (un solo contador) |
| `GET /api/v1/inexistente` | 404 con `Cache-Control: no-store` |

La separación entre **dos clientes reales con IP pública distinta** se demuestra en las pruebas de integración con `CF-Connecting-IP` y se sostiene en producción por construcción de la clave: el limitador usa exactamente la IP que Cloudflare asigna a cada conexión. En esta sesión no se dispuso de una segunda salida pública para repetir esa comparación en Render; se registra como limitación de la evidencia, no como resultado inventado.

**Estado P0-01: APROBADO** con base en evidencia desplegada (origen de la IP, estabilidad frente a XFF manipulado, rechazo de `CF-Connecting-IP` falsificada y contador compartido por el mismo cliente).

## 5. Secciones que no funcionaban — causa y corrección

Los logs de la API mostraron diez errores `backendStatus=502, code=BACKEND_ERROR` a las 00:34:41 y 00:36:54, mientras el backend Free estaba en arranque en frío (sus logs muestran `npm start` y `escuchando` a las 00:37:30). Las respuestas de error se enviaron con `Cache-Control: public, max-age=300` heredado de las rutas GET. El navegador cacheó esos 502 durante cinco minutos y siguió sirviéndolos aunque la API ya respondía 200: por eso fallaban Inicio, Historia, mapa, catálogo, filtros y estadísticas a la vez.

Corrección: `no-store` en errores/429/404 en la API; `cache: 'no-store'` en `fetchJson` y reintentos ante 502/503/504 a 1 s, 3 s y 6 s en el frontend. No se cambiaron datos, diseño, mapa ni contratos.

## 6. Validación desde la URL pública

Tras el despliegue, en <https://mi-barrio-frontend.onrender.com>:

- Las diez peticiones `/api/v1/*` de la carga inicial devolvieron **200**; consola sin errores.
- Ficha con `3.807`, `LEG00645`, `9,1 ha`, `UPL14`; historia sin fuente verificada se muestra como “Información no disponible”, sin inventarla.
- Mapa con **827 `path`** de Leaflet; **463 tramos** (382 residenciales y 81 terciarios); demografía y seguridad renderizadas.
- Catálogo con 49 lugares en la vista de parques; filtros rápidos generaron `GET /api/v1/lugares?tipo=farmacia` con **200**.
- Navegación comprobada: `#inicio`, `#historia`, `#explorar`, `#buscar`.

Riesgo residual: una instancia Free inactiva puede tardar más de 50 s en despertar; los reintentos cubren hasta 10 s y el botón “Reintentar” sigue disponible. No se contrató ningún plan para eliminar esa espera.

## 7. Pendientes sin cambios

Respaldos/restauración, PT-01, PT-02, auditoría formal de accesibilidad, entrega final, trazabilidad final, verificaciones finales y aceptación académica. PostgreSQL Free expira el 2026-12-22; requiere decisión de continuidad antes de esa fecha.
