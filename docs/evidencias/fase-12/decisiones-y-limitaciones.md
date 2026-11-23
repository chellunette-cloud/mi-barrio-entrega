# Decisiones y limitaciones — Fase 12

**Fecha:** 2026-11-19

## Decisiones técnicas

1. **Búsqueda sin tildes sin extensión.** El runtime PostgreSQL local no expone `unaccent` en `pg_available_extensions`. Se descartó una migración dependiente de esa extensión y se implementó normalización con `translate(lower(...))`, incluyendo vocales acentuadas, ñ, ý, ç y sus mayúsculas. Verificado con `q=nino` → `JAIRO ANIBAL NIÑO`.
2. **Sin migración nueva.** El parámetro `tipo` ya tenía columna de soporte (`lugar.tipo`) y el cambio es solo de filtrado; no se crearon esquemas ni campos.
3. **Subcategorías verificables.** El snapshot F-16 contiene etiquetas `shop` reales. El ETL ya las guardaba en `tipo`; el filtro reutiliza ese dato. Las etiquetas en español son traducciones, no clasificaciones nuevas.
4. **Contrato retrocompatible.** `tipo` es opcional y está acotado a 60 caracteres. Se actualizaron ambos contratos, sus hashes y los tipos generados.
5. **Resaltado de parques.** El criterio permite polígono o marcador. Se usa el marcador del centroide calculado por el ETL y se fuerza su remontaje al cambiar la selección para que la clase `seleccionado` sea confiable.
6. **Naturaleza educativa.** Solo se muestra «Pública»/«Privada» cuando `SECTOR` de F-04 es `oficial`/`privado`; de lo contrario se dice explícitamente que no está informada.
7. **Compatibilidad de pruebas heredadas.** Se restauraron `Identificador interno` y `Código SITP` en el detalle para no romper HU-09; las etiquetas nuevas conviven con ellas.

## Limitaciones conocidas

- El inventario comercial es parcial: 25 establecimientos F-16 con etiqueta `shop` dentro del bbox. No hay fuente IDT en los snapshots y no se inventaron negocios ni rubros.
- Algunos comercios no tienen dirección en OSM; la interfaz muestra **Dirección no disponible** en lugar de completarla.
- Los parques se representan como marcadores de centroide, no como polígonos interactivos completos.
- Para educación, `descripcion` permanece nula porque la fuente no provee un campo equivalente; la ficha muestra **No disponible** y no rellena texto.
- La extensión `unaccent` no está disponible localmente; la normalización actual cubre el alfabeto español y algunos caracteres latinos adicionales, no todos los Unicode posibles.
- La matriz histórica de Fase 11.2 conserva la errata «30 (HU-07 a HU-13)»; el total correcto es 24 y el total general 36. No se modificó evidencia histórica; esta fase la sustituye para HU-03 a HU-06.
- Las credenciales E2E se cargaron en memoria desde el `.env` local del backend para la corrida; no se imprimieron ni se versionaron.

## Fuera de alcance (sin cambios)

- HU-01 y HU-02: auditoría de accesibilidad, PT-01 y arrastre de mapa siguen pendientes.
- Pruebas de seguridad, cross-browser y verificación de despliegue: pendientes conforme al informe de auditoría previo.
- Documentación académica no publicada: no hay cuarto repositorio autorizado.
- `temp-reference/`, requisitos originales y fuentes de datos: intactos.

## Estado de publicación

No se crearon commits, no se hizo push y no se desplegó. Los tres repositorios oficiales permanecen independientes y sus HEAD publicados no cambiaron en esta fase.
