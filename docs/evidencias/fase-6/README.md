# Evidencia de Fase 6 — Verificación de calidad y preparación de despliegue

**Alcance:** HU-01 a HU-13, sin nuevas funcionalidades.

## 1. PT-01 — Rendimiento

Herramienta: Node.js `fetch`, una solicitud por endpoint para no activar el rate limit de 120 solicitudes/minuto.

Resultados reales en `performance.json`:

| Endpoint | Estado | Tiempo (ms) | Bytes |
|---|---:|---:|---:|
| `/api/v1/health` | 200 | 49.96 | 41 |
| `/api/v1/barrio` | 200 | 228.77 | 1227 |
| `/api/v1/barrio/geometria` | 200 | 25.16 | 2348 |
| `/api/v1/categorias` | 200 | 8.43 | 642 |
| `/api/v1/lugares?categoria=educacion&limite=100` | 200 | 21.26 | 9039 |
| `/api/v1/vias?highway=tertiary` | 200 | 16.37 | 24114 |
| `/api/v1/estadisticas/demografia` | 200 | 13.35 | 401 |
| `/api/v1/estadisticas/seguridad` | 200 | 7.67 | 474 |

No se realizó prueba de concurrencia final porque el rate limit de la API es 120 solicitudes/minuto. Una prueba previa de concurrencia generó respuestas `429`, documentadas como limitación del entorno local.

## 2. Accesibilidad

Herramienta: Lighthouse 13.6.0 en Chrome headless sobre `http://127.0.0.1:5173`.

Resultados en `lighthouse.json`:

| Categoría | Puntaje |
|---|---:|
| Performance | 0.48 |
| Accessibility | 1.00 |
| Best Practices | 0.96 |
| SEO | 0.91 |

El puntaje de accesibilidad es 100/100. El puntaje de rendimiento corresponde al entorno local de desarrollo y no a producción.

## 3. Seguridad

- `npm audit` reporta 10 vulnerabilidades en cada repositorio: 8 moderadas y 2 críticas.
- Las vulnerabilidades corresponden a dependencias de desarrollo (`vitest`, `tinypool`, `@typescript-eslint`).
- No se encontraron credenciales versionadas.
- El backend no se publica en Internet en la configuración documentada.
- Los endpoints internos requieren `X-Service-Token`.
- No se ejecutó `npm audit fix --force` para no introducir cambios incompatibles.

Detalle en `npm-audit.txt`.

## 4. GitHub Actions

- Los workflows existen en los tres repositorios.
- No se ejecutaron remotamente porque no hay remoto configurado ni credenciales autorizadas.
- No se realizó push.
- La validación equivalente se ejecutó localmente: `npm run ci`, contratos y límite de líneas.

## 5. Staging HTTPS

No se realizó despliegue HTTPS.

Motivo: requiere proveedor, dominio, certificado TLS, base de datos PostgreSQL/PostGIS y credenciales de entorno que no están disponibles en esta intervención.

Se documenta como pendiente con intervención humana. No se afirmó un staging funcional.

## 6. Estado de validación

- HU-01 y HU-02 permanecen en `En pruebas`.
- HU-03 a HU-13 permanecen en `En desarrollo`.
- Ninguna historia se marcó como `Validada`.
- Los criterios de rendimiento y accesibilidad se documentan como evidencia, pero no bastan por sí solos para marcar `Validada`.