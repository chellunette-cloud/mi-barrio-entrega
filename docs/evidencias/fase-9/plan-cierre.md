# Plan de cierre — Fase 9

## Bloque A — Funcionalidades y validación

1. Revisar HU-01 a HU-13 individualmente.
2. Ejecutar sus criterios de aceptación.
3. Completar pruebas de aceptación faltantes.
4. Registrar evidencias reales.
5. Actualizar la matriz de trazabilidad.

Salida esperada: estado real de cada historia y evidencia enlazable.

## Bloque B — Seguridad y calidad

1. Evaluar vulnerabilidades de desarrollo.
2. Identificar actualizaciones compatibles.
3. Ejecutar auditorías posteriores.
4. Repetir pruebas de regresión.
5. Documentar vulnerabilidades no corregibles sin riesgo.

Salida esperada: informe de seguridad y dependencias.

## Bloque C — Documentación

1. Crear manual técnico.
2. Crear manual de usuario.
3. Documentar instalación, configuración, ejecución y limitaciones.
4. Verificar coherencia con la aplicación real.

Salida esperada: manuales completos y verificables.

## Bloque D — Despliegue

1. Preparar configuración de staging HTTPS.
2. Documentar variables de entorno.
3. Documentar migraciones y persistencia.
4. Documentar health checks y recuperación.
5. Solicitar autorización antes de ejecutar despliegue.

Salida esperada: procedimiento de despliegue documentado y listo para ejecución.

## Dependencias

- Bloque A depende de las implementaciones existentes.
- Bloque B depende de los repositorios y sus dependencias.
- Bloque C depende de Bloque A.
- Bloque D depende de Bloque C y de autorización externa.

## Primer bloque recomendado

Ejecutar primero el Bloque A para completar la validación de HU-01 a HU-13 antes de realizar cambios de dependencias o despliegue.