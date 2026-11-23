# Decisiones y limitaciones — Fase 13

**Fecha:** 2026-11-19
**Alcance:** CA-HU01-04 (accesibilidad de HU-01/HU-02 y componentes compartidos) y CA-HU02-03 (interacción del mapa).

## 1. Decisiones técnicas

1. **Herramienta automatizada.** Se añadió `@axe-core/playwright` como dependencia de desarrollo del frontend. No se modifica el bundle de producción ni el contrato público.
2. **Alcance de axe.** Los análisis se limitaron a `section[aria-labelledby="ficha-title"]`, `section[aria-labelledby="mapa-title"]`, `[role="status"]` y `[role="alert"]`. Así se evita declarar como evaluadas secciones HU-03 a HU-13 que no son objeto de esta fase.
3. **Nombres accesibles en español.** Se conservaron los controles de Leaflet y solo se sobrescribieron `aria-label`/`title` de zoom y cierre de popup. El cambio está justificado por `lang="es"` del documento y por el defecto reproducible de nombres en inglés. No se alteró el comportamiento de zoom, arrastre ni eventos.
4. **Popup del polígono operable por teclado.** Se asignaron `tabindex`, `role="button"` y `aria-label` al `<path>`, y se habilitó `Enter`/`Espacio`. Es la corrección mínima al defecto 2.1.1/4.1.2 detectado.
5. **`scrollWheelZoom` se mantiene en `false`.** Es la configuración existente de los tres mapas; se verificó su efecto observable en lugar de modificarla. No hay defecto reproducible que justifique habilitarla.
6. **Sin marcadores nuevos en HU-02.** El criterio describe el polígono y su ventana de información. Para cubrir el punto 5 de la solicitud se verificó un marcador real del mapa de lugares, sin cambiar su lógica.
7. **Correcciones semánticas y visuales mínimas.** `<dd>` en lugar de `<p>` dentro de `<dl>`, contraste `slate-600`, anillo `:focus-visible`, `tabIndex={-1}` en `main`, `aria-describedby` en la región del mapa y aviso `sr-only` para enlaces externos.
8. **Sin cambios de backend, API, contratos ni datos.** No se crearon migraciones, no se ejecutó ETL y no se modificaron hashes de contratos ni snapshots.
9. **Sin cuarto repositorio ni publicación.** `mi-barrio-entrega` no se tocó. No se publicó documentación.

## 2. Archivos modificados y creados

### `mi-barrio-frontend` — modificados

- `package.json`, `package-lock.json` (nueva dependencia de desarrollo)
- `src/app/App.tsx`
- `src/features/barrio/components/BarrioFicha.tsx`
- `src/features/mapa/components/MapaBarrio.tsx`
- `src/features/mapa/components/MapaLeaflet.tsx`
- `src/shared/ui/DatoFicha.tsx`
- `src/shared/ui/ErrorPanel.tsx`
- `src/shared/ui/FuenteDato.tsx`
- `src/styles/index.css`
- `tests/acceptance/ficha-mapa.spec.ts`

### `mi-barrio-frontend` — creados

- `tests/acceptance/accesibilidad.spec.ts`
- `tests/acceptance/mapa-interaccion.spec.ts`

### `mi-barrio-backend` y `mi-barrio-api`

Sin cambios de código en Fase 13. Solo se ejecutaron sus verificaciones.

### Documentación (`docs/`, no un repositorio)

- `docs/evidencias/fase-13/auditoria-accesibilidad.md`
- `docs/evidencias/fase-13/pruebas-interaccion-mapa.md`
- `docs/evidencias/fase-13/resultados-regresion.md`
- `docs/evidencias/fase-13/matriz-global-46-criterios.md`
- `docs/evidencias/fase-13/decisiones-y-limitaciones.md`
- `docs/README.md` (índice)

### `mi-barrio-entrega`

Sin cambios en Fase 13. En esa fecha permanecía local, sin remoto y sin publicación; estado posterior en `entrega/estado-publicacion.md` §9.

## 3. Estado Git

| Repositorio | HEAD | Estado |
|---|---|---|
| `mi-barrio-backend` | `7b641a8bd2cf116f8f4406575a631e26365a4a12` | `## main...origin/main`, sin adelantos ni retrasos |
| `mi-barrio-api` | `76e59be750dfb430f84ea6280b5a943c7f51c51b` | `## main...origin/main`, sin adelantos ni retrasos |
| `mi-barrio-frontend` | `c5240ac59075c83a517eb5a5618f7d5f9e6d6afa` | `## main...origin/main`, sin adelantos ni retrasos |
| `mi-barrio-entrega` | `399f66f9b7fab2808ada4d62456670ac8aec4704` | `## main`, 0 remotos, sin cambios en esta fase |

Los HEAD continúan siendo los publicados. No se ejecutó `git commit`, `git push`, `git tag`, despliegue ni publicación de documentación.

## 4. Limitaciones que continúan

1. **Conformidad WCAG no certificada.** axe sin violaciones no equivale a auditoría WCAG completa; no se usó lector de pantalla real.
2. **Alcance de la auditoría.** No se evaluaron formularios de administración (HU-13) ni se profundizó en HU-03 a HU-12 más allá de la regresión funcional.
3. **Contraste sobre mosaicos.** No se midió exhaustivamente el contraste de enlaces del mapa sobre todos los mosaicos y niveles de zoom.
4. **Dependencias.** `npm install` informó 10 vulnerabilidades preexistentes (8 moderadas, 2 críticas). No se ejecutó `npm audit fix` por estar fuera de alcance.
5. **E2E local.** Playwright se ejecuta en el entorno local; no está integrado en el CI remoto.
6. **`q` sin `maxLength`.** Limitación heredada de Fase 12, documentada y fuera de esta fase.
7. **Sin publicación.** Evidencia y cambios permanecen locales a la espera de revisión humana.

## 5. Condición de cierre

Los dos criterios de la fase cuentan con evidencia directa, automatizada y reproducible. El trabajo se detiene aquí para revisión; no se inicia otra fase ni se publica nada.
