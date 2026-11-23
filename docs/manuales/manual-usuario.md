# Manual de usuario — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**  
**Público objetivo:** ciudadanía, evaluadores académicos y operadores autorizados.

Este manual describe el uso de la interfaz pública y del panel administrativo con base en el comportamiento implementado en `mi-barrio-frontend`. No describe un sistema desplegado: la ejecución local se realiza según el [manual de instalación](manual-instalacion.md) y el estado vigente se resume en el [índice general](../README.md).

---

## 1. Propósito y alcance

Mi Barrio — Ciudad Granada permite consultar información territorial verificable del barrio **Ciudad Granada**, localidad 08 Kennedy, UPZ 82 Patio Bonito, UPL14, en Bogotá D.C. La interfaz pública ofrece:

- ficha del barrio con localidad, UPZ, UPL, área, lotes, población y estrato;
- mapa del polígono oficial en WGS84 sobre teselas de OpenStreetMap;
- lugares de interés con búsqueda, filtros y detalle;
- vías con cobertura parcial;
- indicadores de demografía y seguridad con el nivel territorial adecuado;
- panel administrativo para el rol autorizado.

El sistema cubre 13 historias de usuario, descritas en [`requerimientos/historias-usuario.md`](../requerimientos/historias-usuario.md). Los 46 criterios de aceptación aprobados se registran en la [matriz canónica](../evidencias/fase-13/matriz-global-46-criterios.md), físicamente presente en este portal e incorporada a Git. Esa aprobación no significa que el E2E haya ejecutado individualmente los 46 criterios.

---

## 2. Requisitos para acceder

Para la interfaz pública:

- navegador moderno con JavaScript y soporte para `fetch`;
- acceso al servicio frontend, en local `http://127.0.0.1:5173` después de iniciar los componentes;
- conexión con la API pública. En desarrollo, el proxy de Vite redirige `/api` hacia `http://127.0.0.1:3000`.

Para el panel administrativo:

- usuario y contraseña emitidos por el administrador del sistema;
- no existen credenciales por defecto en los repositorios;
- el acceso se realiza únicamente mediante la ruta `#admin` de la aplicación.

---

## 3. Navegación e interfaz

La aplicación no usa un enrutador externo. La página pública se muestra por defecto y el panel administrativo se selecciona cuando la URL termina en `#admin`.

La página pública contiene, en este orden:

1. **Ficha del barrio** con datos generales y fuentes.
2. **Mapa del barrio** con el polígono oficial.
3. **Lugares de interés** con categorías, búsqueda, filtros, lista y detalle.
4. **Vías** con representación por tipo.
5. **Demografía y seguridad** con paneles separados por nivel territorial.

El encabezado identifica el proyecto y el territorio: “Ciudad Granada / Localidad de Kennedy · Bogotá D.C. · Información territorial oficial”. Existe un enlace “Saltar al contenido principal” para navegación por teclado.

Para volver a la vista pública desde el panel administrativo, elimine `#admin` de la URL o navegue a la raíz del frontend.

---

## 4. Uso del mapa

El mapa usa teselas de OpenStreetMap y dibuja el polígono oficial del barrio sin simplificación manual. El centroide y la geometría provienen de la API pública; el polígono se ajusta automáticamente al área visible.

Controles disponibles:

- botones “Acercar mapa” y “Alejar mapa”;
- desplazamiento con el ratón sin zoom por rueda, para evitar movimientos accidentales;
- selección del polígono para abrir una ventana con nombre, área, centroide y fuente;
- cierre accesible de la ventana mediante “Cerrar ventana de información”;
- activación por teclado con **Enter** o **Espacio** cuando el control tiene el foco;
- atribución visible de la fuente cartográfica.

En la sección de lugares hay un segundo mapa sincronizado con la lista: al seleccionar un lugar se acerca a su posición. En la sección de vías, las vías terciarias se muestran en azul y las residenciales en gris. No se calculan rutas.

---

## 5. Búsqueda, filtros y consulta de información

En **Lugares de interés**:

1. Seleccione una categoría entre las devueltas por `GET /api/v1/categorias`, o pulse “Limpiar filtros”.
2. Escriba un texto en “Buscar por nombre o dirección”. El campo admite hasta 60 caracteres y se envía al parámetro `q`.
3. Si selecciona “Comercio”, puede filtrar por “Subcategoría comercial (etiqueta shop de OSM)”. El valor se envía como `tipo`; no se inventan clasificaciones.
4. Para educación, la lista considera solo lugares con distancia menor o igual a 800 m del centroide.
5. Al seleccionar parques y zonas verdes, el título cambia a “Parques y zonas verdes cercanas”.
6. El contador “N lugares visibles” se actualiza con cada filtro.
7. Seleccione un elemento de la lista o un marcador para ver “Detalle de <nombre>”.

El detalle puede mostrar sede o naturaleza, descripción, dirección, coordenadas WGS84, distancia, código SITP, identificador interno y fuentes. La ficha de salud muestra el número de prestadores y la distancia mínima; la de transporte muestra paraderos SITP y la estación o portal más cercanos.

En **Demografía** puede desplegar los quinquenios por sexo. En **Seguridad** se muestra el cuadrante de policía, teléfono, UPZ, indicadores y capas ambientales.

---

## 6. Administración (solo rol autorizado)

El panel administrativo se abre en `#admin`. Sin sesión se muestra el formulario “Usuario”, “Contraseña” y “Ingresar”.

El token JWT obtenido en `/api/v1/auth/login` se conserva solo en memoria de la aplicación; no se guarda en `localStorage` ni `sessionStorage`. Todas las llamadas administrativas envían `Authorization: Bearer <token>` y son validadas por la API y el backend. El frontend no decodifica el token para decidir el rol.

Con sesión válida es posible:

- crear, editar, eliminar, publicar y despublicar lugares;
- crear, editar y eliminar categorías;
- consultar la auditoría con “Actualizar auditoría”.

Si se intenta eliminar una categoría con lugares asociados, la interfaz muestra: “La categoría tiene lugares asociados. Elija una categoría destino para reasignarlos antes de eliminarla.” Debe elegir una categoría destino antes de confirmar.

No comparta sus credenciales. Cierre la sesión cerrando la pestaña o recargando la vista pública; el token en memoria desaparece al recargar.

---

## 7. Mensajes de error y recomendaciones

| Situación | Mensaje visible | Recomendación |
|---|---|---|
| Fallo de carga de una sección | “No pudimos cargar esta sección” y botón “Reintentar” | Pulse “Reintentar”; si persiste, verifique API y backend. |
| Carga en curso | “Cargando información…”, “Cargando mapa…”, “Cargando lugares…”, etc. | Espere a que termine la petición. |
| Sin resultados | “No se encontraron lugares con los filtros seleccionados.” | Limpie filtros o amplíe la búsqueda. |
| Campo sin fuente | “Información no disponible”, “Dirección no disponible”, “No disponible” | No deduce el valor; consulte la fuente citada. |
| Credenciales incorrectas | “Credenciales inválidas” | Verifique usuario y contraseña con el administrador. |
| Sin autorización | La interfaz no muestra acciones administrativas; el API responde 401 | Inicie sesión con un usuario autorizado. |
| Exceso de solicitudes | Código `DEMASIADAS_SOLICITUDES` (HTTP 429) | Espere antes de reintentar. |

Si el mapa no muestra el polígono, compruebe que el backend y la API estén activos y que el contrato interno y público estén verificados.

---

## 8. Limitaciones conocidas de los datos

Estas limitaciones son deliberadas y se conservan en [`investigacion/fuentes-territoriales.md`](../investigacion/fuentes-territoriales.md):

- **Comercio:** cobertura parcial. La fuente OSM solo aporta la ventana estudiada y no representa todo el comercio del barrio.
- **Educación:** se listan sedes dentro de 800 m del centroide, no todas las del área amplia.
- **Salud:** se muestran prestadores cercanos; si no hay ninguno dentro del polígono, la interfaz lo indica.
- **Demografía:** los quinquenios por edad y sexo corresponden a la **UPZ 082**, no al barrio; no se prorratean.
- **Seguridad:** los delitos de alto impacto corresponden a la **localidad 08 Kennedy**, no al barrio Ciudad Granada.
- **Transporte:** se publican paraderos, estaciones y portales, pero **no** rutas, horarios, frecuencias ni tiempos de llegada.
- **Vías:** cobertura parcial; no se presentan rutas calculadas ni indicaciones paso a paso.
- **Direcciones:** cuando la fuente oficial no aporta una dirección verificable, se muestra “Dirección no disponible”; no se infiere.
- **Historia del barrio:** no se publica texto sin fuente documental verificada.
- **Geometría:** se usa el polígono oficial en WGS84; no se dibuja ni simplifica manualmente.

---

## 9. Fuentes y trazabilidad

Cada tarjeta de fuente muestra URL, fecha de consulta y licencia cuando la fuente la declara. La lista completa de fuentes está en [`investigacion/fuentes-territoriales.md`](../investigacion/fuentes-territoriales.md) y la trazabilidad criterio por criterio en [`requerimientos/matriz-trazabilidad.md`](../requerimientos/matriz-trazabilidad.md).

Para detalles operativos consulte el [manual técnico](manual-tecnico.md), la [guía de pruebas](manual-pruebas.md) y el [manual de operación y mantenimiento](manual-operacion.md).
