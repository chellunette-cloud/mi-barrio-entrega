# Pruebas de interacción del mapa — CA-HU02-03 (Fase 13)

**Fecha:** 2026-11-19
**Archivo ejecutado:** `tests/acceptance/mapa-interaccion.spec.ts`
**Comando:** `npx playwright test tests/acceptance/accesibilidad.spec.ts tests/acceptance/mapa-interaccion.spec.ts --reporter=list`
**Resultado:** 9/9 (4 de accesibilidad + 5 de interacción). La suite completa de Playwright terminó **36/36**.

## 1. Criterio original

> Dado un visitante con ratón o pantalla táctil, cuando arrastra y hace zoom, entonces el polígono permanece correctamente georreferenciado y se puede cerrar/abrir su ventana de información.

## 2. Casos ejecutados y resultados individuales

| # | Requisito de la Fase 13 | Caso E2E | Resultado observable comprobado | Resultado |
|---|---|---|---|---|
| 1 | El mapa se muestra correctamente | «el mapa se muestra y el arrastre cambia su posición» | `role="region"` visible y exactamente 1 `path` en `.leaflet-overlay-pane` | **Passed** |
| 2 | El usuario puede arrastrar y modificar la posición | «el mapa se muestra y el arrastre cambia su posición» | Tras `mouse.down/move/up`, la coordenada `x` del `path` cambia más de 10 px | **Passed** |
| 3 | Acercar y alejar con los controles disponibles | «acercar y alejar con los controles modifica la escala» | El ancho del `path` aumenta con `Acercar mapa` y disminuye con `Alejar mapa` | **Passed** |
| 4 | Zoom con rueda/gestos según la configuración existente | «la rueda no cambia el zoom porque está deshabilitada» | `scrollWheelZoom={false}` se confirma observacionalmente: el ancho del `path` varía menos de 2 px tras `mouse.wheel` | **Passed** |
| 5 | Los marcadores siguen interactivos tras mover/acercar | «los marcadores siguen interactivos tras mover y acercar» | En el mapa de lugares, `.lugar-marker` sigue visible tras zoom + arrastre y al hacer clic se abre `article[aria-label^="Detalle de"]` | **Passed** |
| 5b | El elemento interactivo de HU-02 sigue interactivo | «el polígono sigue interactivo y el popup se abre y cierra» | Tras acercar y arrastrar, el `path` sigue visible y abre el popup con el nombre oficial | **Passed** |
| 6 | El popup se abre al seleccionar el elemento | Casos 5 y 5b | `.leaflet-popup-content` contiene `URBANIZACION CIUDAD GRANADA`; en accesibilidad, `Enter` sobre el polígono enfocado también lo abre | **Passed** |
| 7 | El popup se cierra mediante el mecanismo disponible | «el polígono sigue interactivo y el popup se abre y cierra» + prueba de accesibilidad | Botón «Cerrar ventana de información» visible, enfocado al abrir y funcional con clic y con `Enter` | **Passed** |
| 8 | El mapa conserva comportamiento funcional tras cerrar el popup | Caso 5b | Tras cerrar, `.leaflet-popup-content` tiene count 0 y el `path` continúa visible | **Passed** |

## 3. Selectores y efectos observados

| Elemento | Selector | Uso |
|---|---|---|
| Región del mapa | `getByRole('region', { name: /Mapa interactivo/ })` | Verificación de presencia y límites |
| Polígono oficial | `.leaflet-overlay-pane path` | Georreferenciación observable mediante `boundingBox()` |
| Control de acercar | `getByRole('button', { name: 'Acercar mapa' })` | Zoom in con nombre accesible en español |
| Control de alejar | `getByRole('button', { name: 'Alejar mapa' })` | Zoom out con nombre accesible en español |
| Popup | `.leaflet-popup-content` | Contenido del polígono |
| Cierre del popup | `getByRole('button', { name: 'Cerrar ventana de información' })` | Cierre con clic y teclado |
| Mapa de lugares | `getByTestId('places-map')` | Verificación de marcadores tras interacción |
| Marcador | `.lugar-marker` | Interactividad después de zoom/arrastre |

## 4. Decisiones sobre el comportamiento de Leaflet

- **No se modificaron** `dragging`, `zoomControl`, `doubleClickZoom`, `touchZoom` ni `boxZoom`; Leaflet los habilita por defecto y las pruebas confirman arrastre y zoom.
- **`scrollWheelZoom` permanece `false`** en los tres mapas de la aplicación. No es un defecto: es la configuración existente y deliberada para evitar desplazamientos accidentales de la página. La prueba documenta el comportamiento observable en lugar de forzar un cambio.
- No se crearon marcadores nuevos en HU-02: el criterio habla del **polígono** y su ventana de información. Para cubrir literalmente el punto 5 se verificó además un marcador real del mapa de lugares (HU-03), sin modificar su lógica.
- El popup del polígono pasó a ser alcanzable por teclado (`Enter`/`Espacio`) porque el requisito de accesibilidad y la prueba manual reproducida mostraron que el clic era el único mecanismo previo. Los controles de ratón/táctil no se alteraron.

## 5. Regresión

Las mismas 36 pruebas de Playwright incluyen la spec original `ficha-mapa.spec.ts`, actualizada solo para usar los nombres accesibles en español y el rol del polígono. No se eliminaron ni debilitaron aserciones previas: se conservan las comprobaciones de escritorio, móvil, encuadre y sin desbordamiento horizontal.

**Conclusión para CA-HU02-03:** los ocho comportamientos exigidos tienen prueba ejecutada y resultado observable. El criterio se marca **Aprobado**.
