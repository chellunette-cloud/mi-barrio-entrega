# Entrega — Mi Barrio

Documentos de preparación y publicación del portal de entrega.

| Archivo | Uso |
|---|---|
| [`estado-publicacion.md`](estado-publicacion.md) | Inspección de los tres repositorios, bloqueos y secuencia exacta para publicar |
| [`manifiesto-versiones.md`](manifiesto-versiones.md) | Manifiesto de versiones del portal: repositorios, ramas, SHAs y hashes de contratos verificados |
| [`configurar-submodulos.ps1`](configurar-submodulos.ps1) | Artefacto histórico; no aplicable ni ejecutable en la opción C |
| [`gitmodules.example`](gitmodules.example) | Plantilla histórica de `.gitmodules`; no se usa en la arquitectura aprobada |

> **Opción C (2026-11-22):** el portal es independiente y referencia los repositorios por URL HTTPS y el [manifiesto de versiones](manifiesto-versiones.md). `configurar-submodulos.ps1` y `gitmodules.example` se conservan solo como artefactos históricos/no aplicables; no deben ejecutarse ni crear `.gitmodules`.

## Manuales

Los seis manuales están en [`../docs/manuales/`](../docs/manuales/) como reflejo controlado de la fuente canónica del workspace principal:

- [Manual de usuario](../docs/manuales/manual-usuario.md)
- [Manual técnico](../docs/manuales/manual-tecnico.md)
- [Manual de instalación y configuración local](../docs/manuales/manual-instalacion.md)
- [Manual de operación y mantenimiento](../docs/manuales/manual-operacion.md)
- [Guía de pruebas y verificación](../docs/manuales/manual-pruebas.md)
- [Guía de despliegue y publicación](../docs/manuales/manual-despliegue.md)

> **Estado vigente (2026-11-23):** los tres repositorios tienen remoto verificado; frontend y backend están en `main`, y la API se desplegó desde `fase-15/p0-trust-proxy`. La aplicación está desplegada en Render con planes Free y USD 0, con P0-01 NO APROBADO y P0-02 aprobado para la integridad consultada. El portal es independiente, sin submódulos ni `.gitmodules`, y referencia esas versiones mediante el [manifiesto de versiones](manifiesto-versiones.md). Consulta [`estado-publicacion.md`](estado-publicacion.md) y la [evidencia de despliegue](../docs/despliegue/evidencia-fase-15.2-despliegue-render.md).
>
> **Enlaces públicos:** aplicación <https://mi-barrio-frontend.onrender.com> · portal de documentación <https://chellunette-cloud.github.io/mi-barrio-entrega/>. No son la misma dirección.

> **Registro histórico (2026-11-16):** la configuración de submódulos no se ejecutó porque los tres repositorios todavía no tenían remoto.
