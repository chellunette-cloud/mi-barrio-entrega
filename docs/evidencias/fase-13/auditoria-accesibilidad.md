# Auditoría de accesibilidad — CA-HU01-04 (Fase 13)

**Fecha:** 2026-11-19
**Referencia:** WCAG 2.2 nivel AA.
**Alcance:** interfaz de HU-01 (ficha general), HU-02 (mapa del polígono) y componentes compartidos usados por ambos: `EstadoCarga`, `ErrorPanel`, `FuenteDato`, `DatoFicha`, `App` y estilos globales.
**Herramienta automatizada:** `@axe-core/playwright` integrado como dependencia de desarrollo del frontend.

## 1. Diagnóstico inicial

No existía ninguna herramienta automatizada de accesibilidad en el repositorio. El diagnóstico inicial se hizo por inspección de código y de las pruebas E2E existentes; por ello **no se dispone de una ejecución de axe anterior a las correcciones**. Los hallazgos iniciales se enumeran abajo con su criterio WCAG y se corrigieron antes de la primera ejecución de axe.

| # | Hallazgo inicial | WCAG | Elemento afectado | Corrección |
|---|---|---|---|---|
| 1 | El popup del polígono solo se abría con clic; el `<path>` no tenía `tabindex`, `role` ni nombre accesible | 2.1.1 Teclado; 4.1.2 Nombre, función, valor | `MapaLeaflet.tsx` | `tabindex="0"`, `role="button"`, `aria-label` dinámico y apertura con `Enter`/`Espacio` |
| 2 | Controles de zoom y cierre de popup con nombres en inglés (`Zoom in`, `Close popup`) en documento `lang="es"` | 3.1.1 Idioma de la página; 4.1.2 | Leaflet within `MapaLeaflet.tsx` | `aria-label`/`title` en español: `Acercar mapa`, `Alejar mapa`, `Cerrar ventana de información` |
| 3 | El destino del enlace «Saltar al contenido principal» no era enfocable de forma fiable | 2.4.1 Saltar bloques | `App.tsx` | `tabIndex={-1}` en `<main id="contenido">` |
| 4 | El mapa y el polígono no tenían indicador de foco explícito | 2.4.7 Foco visible; 2.4.11 Apariencia del foco | `index.css` | `outline: 3px solid #0f766e` en `:focus-visible` de `.leaflet-container` y `.leaflet-interactive` |
| 5 | `<dl>` contenía un `<p>` dentro del grupo `dt`/`dd`, modelo de contenidos inválido | 4.1.1 Análisis | `DatoFicha.tsx` | El detalle pasa a un segundo `<dd>` válido |
| 6 | Enlaces `target="_blank"` sin aviso para lectores de pantalla | 3.2.5 Cambio a petición (AAA, adoptado como mejora) | `FuenteDato.tsx`, `MapaBarrio.tsx` | Texto `sr-only` «(abre en una pestaña nueva)» |
| 7 | Texto auxiliar con contraste límite (`text-slate-500`) | 1.4.3 Contraste mínimo (AA) | `DatoFicha.tsx`, `BarrioFicha.tsx` | Cambio a `text-slate-600` |
| 8 | Atribución del mapa a 10 px | Legibilidad (no exigencia mínima WCAG) | `index.css` | Aumento a 12 px |
| 9 | La región del mapa no estaba asociada a su explicación visible | 1.3.1 Información y relaciones | `MapaBarrio.tsx` | `aria-describedby="mapa-caption"` en la región |
| 10 | Los anillos de foco usaban solo `:focus` | 2.4.7 / 2.4.11 | Componentes compartidos | Se conserva `:focus` y se añade `:focus-visible` con color reforzado |

## 2. Pruebas automatizadas ejecutadas

Archivo: `tests/acceptance/accesibilidad.spec.ts`.

| Prueba | Selectores analizados por axe | Resultado |
|---|---|---|
| «la ficha y el mapa sin errores de axe» | `section[aria-labelledby="ficha-title"]` y `section[aria-labelledby="mapa-title"]` | **0 violaciones** en cada análisis |
| «el estado de carga es accesible» | `[role="status"]` (con respuesta de `/api/v1/barrio` retardada) | **0 violaciones** |
| «el estado de error es accesible» | `[role="alert"]` (respuestas 500 simuladas en barrio y geometría) | **0 violaciones** |

Etiquetas axe solicitadas: `wcag2a`, `wcag2aa`, `wcag21a`, `wcag21aa`, `wcag22aa`.

Resultado agregado: **4 análisis axe, 0 violaciones**. La ejecución completa de Playwright terminó **36/36**.

## 3. Comprobaciones manuales de teclado y foco

Archivo: `tests/acceptance/accesibilidad.spec.ts`, cuarta prueba. Todas pasaron.

1. Primer `Tab` → el enlace «Saltar al contenido principal» recibe el foco.
2. `Enter` en el enlace → el foco se mueve a `main#contenido` (verificado con `toBeFocused`).
3. Enlace de fuente (`…datosabiertos…`) → `boxShadow` distinto de `none`, es decir, indicador de foco visible.
4. El polígono expone `role="button"` y `aria-label` «Abrir información de URBANIZACION CIUDAD GRANADA».
5. `Enter` con el polígono enfocado → se abre el popup con el nombre oficial.
6. El botón «Cerrar ventana de información» recibe el foco automáticamente al abrirse el popup.
7. `Enter` en ese botón → el popup se cierra y el mapa sigue visible.

## 4. Estados evaluados

| Estado | Evidencia | Resultado |
|---|---|---|
| Carga | `EstadoCarga` con `role="status"` y `aria-live="polite"`, analizado con axe | Accesible, 0 violaciones |
| Éxito | Ficha y mapa reales con datos oficiales, analizados con axe | Accesible, 0 violaciones |
| Error | `ErrorPanel` con `role="alert"` y botón «Reintentar», analizado con axe | Accesible, 0 violaciones |
| Ausencia de dato | Texto visible «Información no disponible» en la ficha, incluido en el análisis de éxito | Accesible, 0 violaciones |

## 5. Limitaciones

- Una ejecución de axe sin violaciones **no demuestra conformidad WCAG 2.2 completa**; cubre reglas automatizables sobre los selectores indicados.
- No se realizó prueba con lector de pantalla real (NVDA/VoiceOver).
- No se auditaron los formularios de administración (HU-13) ni secciones HU-03 a HU-12 más allá de la regresión funcional.
- No se midió el contraste del texto sobre mosaicos del mapa en todos los niveles de zoom; se verificó el contraste del texto de la aplicación.
- Se mantiene la recomendación de una auditoría WCAG formal externa antes de declarar conformidad global del producto.

**Conclusión para CA-HU01-04:** existe evidencia automatizada y manual directa, reproducible y específica para HU-01/HU-02. El criterio se marca **Aprobado** en el alcance de esta fase, sin extender la afirmación a una certificación WCAG completa.
