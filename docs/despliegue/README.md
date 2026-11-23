# Planificación de despliegue — Mi Barrio, Ciudad Granada

**Versión 1.1 — 2026-11-23**

Índice del Bloque C. Los documentos originales registran análisis, arquitectura propuesta, comparación de alternativas y procedimientos planificados. **El despliegue real se ejecutó después, en Fase 15.2**, con recursos Free en Render y USD 0; la evidencia vigente es [`evidencia-fase-15.2-despliegue-render.md`](evidencia-fase-15.2-despliegue-render.md). Los documentos de planificación se conservan como registro histórico.

| Documento | Contenido | Estado |
|---|---|---|
| [`auditoria-estado-despliegue.md`](auditoria-estado-despliegue.md) | HEADs, configuración real, scripts, variables, contratos, dependencias, health checks y auth | **Implementado y verificado** / **Preparado, no desplegado** |
| [`arquitectura-propuesta.md`](arquitectura-propuesta.md) | Componentes públicos y privados, red, secretos, CORS, JWT, health checks y registro de errores | **Propuesto** |
| [`comparacion-alternativas.md`](comparacion-alternativas.md) | Alternativas de alojamiento con fuentes oficiales y límites verificados o pendientes | **Pendiente de decisión externa** |
| [`plan-por-etapas.md`](plan-por-etapas.md) | Once etapas con prerrequisitos, acciones, verificaciones, aceptación y reversión | **Propuesto** / **Pendiente de ejecución** |
| [`respaldo-observabilidad.md`](respaldo-observabilidad.md) | Respaldo, restauración, logs, health checks, alertas y recuperación propuestos | **Propuesto** / **Pendiente de ejecución** |
| [`evidencia-fase-15.2-despliegue-render.md`](evidencia-fase-15.2-despliegue-render.md) | Despliegue real, configuración, migraciones, ETL, P0-01 y P0-02 | **Ejecutado y verificado**; P0-01 NO APROBADO |

## Convención de estados

- **Implementado y verificado:** existe en el código y fue comprobado en esta auditoría.
- **Preparado, no desplegado:** existe como documento, plantilla o workflow local, pero no se ejecutó contra infraestructura externa.
- **Propuesto:** diseño técnico listo para revisión; no implica autorización para ejecutarlo.
- **Pendiente de decisión externa:** requiere elección humana, cuenta, contrato o dato verificable que aún no existe.
- **Pendiente de ejecución:** paso del plan que debe realizarse cuando exista autorización e infraestructura.

Relaciones con documentación existente:

- Guía operativa breve: [`../manuales/manual-despliegue.md`](../manuales/manual-despliegue.md).
- Manual técnico: [`../manuales/manual-tecnico.md`](../manuales/manual-tecnico.md).
- Guía de pruebas: [`../manuales/manual-pruebas.md`](../manuales/manual-pruebas.md).
- Arquitectura de solución: [`../arquitectura/arquitectura-solucion.md`](../arquitectura/arquitectura-solucion.md).

Este índice no duplica el contenido de esos documentos; solo los enlaza.
