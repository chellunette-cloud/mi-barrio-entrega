# Modelo de requisitos — Mi Barrio, Ciudad Granada

**Versión:** 1.2 · **Fecha:** 2026-11-15 · **Estado:** D-2…D-6 aprobadas; D-7 pendiente para la fase administrativa y sin bloqueo para HU-01/HU-02. Fase 1 implementada y en pruebas con HU-01/HU-02; no validada.

Este documento fija los identificadores que usan las 13 historias de usuario, los criterios de aceptación y la matriz de trazabilidad.

---

## 1. Actores

| ID | Actor | Descripción | Permisos |
|----|-------|-------------|----------|
| AC-01 | Visitante | Cualquier persona que accede sin autenticarse (habitante, turista, investigador). | Lectura de toda la información pública |
| AC-02 | Administrador | Responsable de mantener la información del barrio. | CRUD sobre lugares, categorías y textos; lectura de auditoría |

---

## 2. Requisitos funcionales (RF)

Cada RF deriva de una historia de usuario. La historia es la fuente; el RF es su formulación verificable en el sistema.

| ID | Requisito funcional | HU origen | Prioridad |
|----|---------------------|-----------|-----------|
| RF-01 | El sistema debe exponer la ficha territorial del barrio: nombre oficial, localidad, UPZ, UPL, área, número de lotes, población estimada y estrato predominante, con fuente y fecha de cada dato. | HU-01 | Alta |
| RF-02 | El sistema debe mostrar el polígono oficial del barrio sobre un mapa interactivo, con encuadre automático y control de capas base. | HU-02 | Alta |
| RF-03 | El sistema debe permitir consultar un catálogo de lugares de interés georreferenciados, con nombre, categoría, dirección y descripción, y abrir su detalle. | HU-03 | Alta |
| RF-04 | El sistema debe permitir buscar establecimientos comerciales por nombre y filtrarlos por subcategoría, indicando la fuente del dato. | HU-04 | Media |
| RF-05 | El sistema debe listar parques y zonas verdes con tipo, distancia al barrio y ubicación en el mapa. | HU-05 | Media |
| RF-06 | El sistema debe listar instituciones educativas con nombre, sede, sector (oficial/privado), dirección y distancia. | HU-06 | Media |
| RF-07 | El sistema debe listar prestadores de salud y farmacias con nombre, tipo, dirección y distancia. | HU-07 | Media |
| RF-08 | El sistema debe visualizar la malla vial del barrio y las vías de acceso, diferenciando jerarquía vial. | HU-08 | Media |
| RF-09 | El sistema debe mostrar paraderos SITP y estaciones/portales de TransMilenio cercanos, con distancia y ubicación. | HU-09 | Media |
| RF-10 | El sistema debe presentar indicadores demográficos y socioeconómicos, indicando el nivel territorial del dato (barrio o UPZ). | HU-10 | Baja |
| RF-11 | El sistema debe presentar información de seguridad y entorno: cuadrante de policía, indicadores disponibles y capas ambientales, con su nivel de agregación. | HU-11 | Baja |
| RF-12 | El sistema debe permitir filtrar los lugares del mapa por una o varias categorías, reflejando el resultado en el mapa y en el listado. | HU-12 | Alta |
| RF-13 | El sistema debe permitir al administrador autenticado crear, editar, despublicar y eliminar lugares, con validación y registro de auditoría. | HU-13 | Media |

### 2.1 Requisito transversal de búsqueda

| ID | Requisito | Deriva de |
|----|-----------|-----------|
| RF-14 | El sistema debe ofrecer búsqueda por texto sobre nombre y dirección de los lugares publicados, sin distinguir mayúsculas ni tildes. | HU-03, HU-04 (criterios de aceptación) |

---

## 3. Requisitos no funcionales (RNF)

| ID | Categoría | Requisito | Verificación |
|----|-----------|-----------|--------------|
| RNF-01 | Arquitectura | Tres capas separadas: presentación, aplicación (API) y lógica/persistencia (backend). | Diagrama + auditoría de dependencias |
| RNF-02 | Repositorios | Tres repositorios independientes y sin dependencias cruzadas de código. | Revisión de `package.json` y CI |
| RNF-03 | Diseño | Aplicación de SOLID en los tres repositorios. | Revisión de código + informe |
| RNF-04 | Mantenibilidad | Ningún archivo de código fuente supera 100 líneas. | Script de conteo en CI (falla el build) |
| RNF-05 | Seguridad | Validación de entrada, autenticación de administrador, autorización, rate limiting, cabeceras seguras, secretos fuera del repositorio. | Pruebas ST-xx + revisión de configuración |
| RNF-06 | Accesibilidad | WCAG 2.1 nivel AA: contraste, foco visible, navegación por teclado, texto alternativo, etiquetas de formulario. | Auditoría automatizada + manual |
| RNF-07 | Adaptabilidad | Diseño responsive desde 360 px hasta 1920 px. | Pruebas de viewport |
| RNF-08 | Errores | Manejo centralizado de errores con códigos estables y mensajes en español, sin filtrar trazas internas. | Pruebas de API + revisión |
| RNF-09 | Pruebas | Pruebas unitarias, de integración, de API, de base de datos, funcionales y de validación geográfica. | Reporte de ejecución real |
| RNF-10 | Trazabilidad | Toda HU enlazada a RF, criterio, módulo, evidencia y prueba. | Matriz de trazabilidad |
| RNF-11 | Rendimiento | Respuesta de API p95 < 800 ms en consultas del barrio; mapa utilizable en < 3 s en 3G rápida. | Pruebas PT-xx |
| RNF-12 | Disponibilidad | Despliegue con HTTPS accesible desde Internet; endpoint `/health` operativo. | Verificación en producción |
| RNF-13 | Compatibilidad | Últimas dos versiones de Chrome, Edge, Firefox y Safari; sin dependencias de escritorio. | Pruebas cross-browser |
| RNF-14 | Legalidad de datos | Atribución visible de fuentes y cumplimiento de licencias (CC BY 4.0, ODbL). | Revisión de UI + aviso legal |
| RNF-15 | Documentación | README, `.env.example`, manual técnico y manual de usuario en cada entrega. | Revisión de repositorios |
| RNF-16 | Observabilidad | Logs estructurados con identificador de petición y registro de errores. | Revisión de logs |
| RNF-17 | Datos | Base de datos geoespacial con SRID 4326, índices GiST y consultas espaciales verificadas. | Pruebas GT-xx |
| RNF-18 | Idioma | Interfaz en español (es-CO), fechas y números en formato local. | Revisión funcional |
| RNF-19 | SEO | Títulos, descripciones y metadatos por página; contenido principal accesible sin interacción. | Revisión + Lighthouse |
| RNF-20 | Calidad de código | Linter y formateador configurados y aplicados en CI. | Pipeline verde |

---

## 4. Reglas de negocio

| ID | Regla | Consecuencia si se incumple |
|----|-------|-----------------------------|
| RN-01 | Todo dato territorial publicado debe tener fuente, URL y fecha de consulta. | El registro no se publica. |
| RN-02 | El polígono del barrio proviene de la capa oficial de la SDP; no se dibuja a mano. | Se bloquea la carga. |
| RN-03 | Los datos de población por UPZ no se presentan como datos del barrio: se muestran en paneles separados, etiquetados y sin prorrateo. | Se corrige la etiqueta y el nivel territorial. |
| RN-04 | Un lugar sin coordenadas dentro del área de influencia definida (barrio + 1 km) no se publica. | Se rechaza en validación. |
| RN-05 | Solo el administrador autenticado puede crear, editar o eliminar lugares. | 401/403. |
| RN-06 | Toda modificación administrativa queda auditada (quién, qué, cuándo, antes/después). | Se revierte y se registra incidencia. |
| RN-07 | Los datos de terceros conservan su licencia y atribución; no se relicencian como propios. | Se retira la capa. |
| RN-08 | Una categoría eliminada no borra sus lugares: se reasignan o se despublican. | Se bloquea el borrado. |
| RN-09 | Las cifras de seguridad se muestran con su nivel de agregación (**localidad 08 Kennedy**) y periodo, sin inferir datos por barrio ni rotularlas como Ciudad Granada. | Se retira el indicador. |
| RN-10 | Ningún texto histórico o descriptivo se publica sin fuente verificable. | Se marca como no disponible. |
| RN-11 | Todo conteo de proximidad declara ventana y radio; los registros de la ventana no se presentan como si estuvieran a esa distancia. | Se corrige la cifra y se documenta el método. |

---

## 5. Supuestos y restricciones

- **S-01:** Se dispone de conexión a Internet para consultar las fuentes oficiales durante la carga inicial.
- **S-02:** El despliegue usará un proveedor con PostgreSQL 16 + PostGIS (ver arquitectura, D-4).
- **S-03:** Los datos se cargan por proceso ETL reproducible, no por edición manual en la base.
- **R-01:** El barrio se delimita exclusivamente por el polígono oficial (9,1 ha). El código postal 110881 cubre una zona mayor y **no** se usa como límite.
- **R-02:** No existe registro abierto de todos los establecimientos comerciales de Bogotá; HU-04 será **parcial y no representará la totalidad**.
- **R-03:** No existen proyecciones de población a nivel de barrio; HU-10 usará la estimación oficial del barrio y, en un panel separado, la proyección de la UPZ 082.
- **R-04:** Los delitos publicados están agregados por la **localidad 08 Kennedy**; HU-11 no mostrará ni inferirá cifras por barrio.
- **R-05:** El feed GTFS no tiene descarga directa estable; en v1 no se publican rutas, horarios ni frecuencias (HU-09).
- **R-06:** Los conteos de proximidad usan distancia geodésica desde el centroide **4,641833, -74,171758**; cada historia declara su ventana y su radio.

---

## 6. Fuera de alcance (v1)

- Registro de usuarios visitantes, reseñas y comentarios.
- Trámites o pagos en línea.
- Edición colaborativa por parte de la comunidad.
- Historial histórico del barrio sin fuente documental.
- Aplicación móvil nativa.

Cualquier inclusión posterior requiere nueva HU y actualización de esta matriz.
