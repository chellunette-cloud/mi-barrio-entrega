# Resultados de validación actuales

## Comandos ejecutados

Backend:
- `npm run ci`: 11/11 pruebas OK.
- `npm run verify:data`: 9/9 snapshots OK.
- `npm run contracts:verify`: OK.
- `npm run check:lines`: OK.

API:
- `npm run ci`: 8/8 pruebas OK.
- `npm run contracts:verify`: OK.
- `npm run check:lines`: OK.

Frontend:
- `npm run ci`: 3/3 pruebas OK.
- `npm run contracts:verify`: OK.
- `npm run check:lines`: OK.

Playwright:
- 3/3 pruebas de aceptación pasadas.

## Resultados de rendimiento

- Lighthouse producción: Performance 99/100, Accessibility 100/100.
- Lighthouse desarrollo: Performance 48/100, Accessibility 100/100.

## Resultados de seguridad

- `npm audit`: 10 vulnerabilidades por repositorio, todas en dependencias de desarrollo.
- No se encontraron credenciales versionadas.

## Limitaciones

- No se ejecutó PT-01 con herramienta dedicada.
- No se realizó auditoría manual formal de accesibilidad.
- No se ejecutó staging HTTPS.
- No se configuraron repositorios remotos.
- Las historias permanecen en `En pruebas` o `En desarrollo`.