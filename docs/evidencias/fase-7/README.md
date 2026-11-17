# Evidencia de Fase 7 — Correcciones de calidad y cierre técnico

## 1. Vulnerabilidades

`npm audit` reporta en cada repositorio 10 vulnerabilidades: 8 moderadas y 2 críticas.

Paquetes afectados:
- `@typescript-eslint/*` (moderada, vía `minimatch`)
- `vitest`, `@vitest/mocker`, `tinypool` (crítica, vía `tinypool`)

Son dependencias de desarrollo. `npm audit fix` no aplicó cambios porque las correcciones requieren versiones major (`typescript-eslint 8.36.0`, `vitest 5.1.0`). No se ejecutó `npm audit fix --force` para evitar cambios incompatibles.

## 2. Rendimiento

Lighthouse sobre servidor de desarrollo:
- Performance: 48/100
- Accessibility: 100/100
- Best Practices: 96/100
- SEO: 91/100
- LCP: 7.9 s
- FCP: 7.9 s
- TBT: 400 ms
- CLS: 0.002

Lighthouse sobre build de producción (`npm run preview`):
- Performance: 99/100
- Accessibility: 100/100
- Best Practices: 96/100
- SEO: 91/100
- LCP: 1.7 s
- FCP: 1.7 s
- TBT: 0 ms

No se modificó código para mejorar métricas artificialmente. La mejora proviene del uso del build de producción.

## 3. Concurrencia PT-01

Escenario controlado: 5 solicitudes concurrentes a `/api/v1/lugares?categoria=educacion&limite=100`, 3 rondas, rate limit activo.

Resultados en `concurrency.json`:
- Ronda 1: 5 respuestas `200`, 232.71 ms.
- Ronda 2: 5 respuestas `200`, 22.98 ms.
- Ronda 3: 5 respuestas `200`, 12.63 ms.

## 4. Seguridad

- Argon2 y JWT implementados en HU-13.
- Endpoints administrativos protegidos.
- Backend no publicado en la configuración documentada.
- CORS restringido al origen del frontend.
- No se encontraron credenciales versionadas.
- Las vulnerabilidades reportadas son de desarrollo.

## 5. Regresión completa

Resultados:
- Backend: `npm run ci` OK, 11/11 pruebas, 9 snapshots OK.
- API: `npm run ci` OK, 8/8 pruebas, contrato interno verificado.
- Frontend: `npm run ci` OK, 3/3 pruebas y build de producción.
- Playwright: 3/3 pruebas de aceptación pasadas.

## 6. Pendientes

- Vulnerabilidades de desarrollo que requieren actualizaciones major.
- PT-01 formal con herramienta dedicada (k6) no disponible.
- Auditoría formal de accesibilidad manual no realizada; Lighthouse reporta 100/100.
- Staging HTTPS no realizado por falta de infraestructura y credenciales.
- GitHub Actions no ejecutado remotamente por ausencia de remoto.
- HU-01 y HU-02 permanecen en `En pruebas`.
- HU-03 a HU-13 permanecen en `En desarrollo`.