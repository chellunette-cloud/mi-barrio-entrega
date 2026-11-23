# Manifiesto de versiones — Mi Barrio, Ciudad Granada

**Estrategia:** opción C — portal independiente, sin submódulos y con manifiesto de versiones.
**Fecha de verificación:** 2026-11-23 (ramas y SHAs desplegados en Render; contratos reverificados).
**Ámbito:** referencia documental de las versiones de código y de los contratos que corresponden a la documentación de este portal. No fija dependencias técnicas, no sustituye a un mecanismo de control de versiones y no implica despliegue.

## 1. Repositorios de código

| Repositorio | URL HTTPS (`origin` configurado) | Rama | SHA completo |
|---|---|---|---|
| `mi-barrio-frontend` | `https://github.com/chellunette-cloud/mi-barrio-frontend.git` | `main` | `11aa254ef826ca20367deb4a689123e4ed8a90b8` |
| `mi-barrio-api` | `https://github.com/chellunette-cloud/mi-barrio-api.git` | `fase-15/p0-trust-proxy` | `39684bce72bda72b3d23ba1d3db0724877a97b88` |
| `mi-barrio-backend` | `https://github.com/chellunette-cloud/mi-barrio-backend.git` | `main` | `a6c912542873665659fff4a38c1efdd5f13483be` |

**Método:** `git rev-parse --abbrev-ref HEAD`, `git rev-parse HEAD` y `git remote get-url origin` ejecutados en los tres clones locales. En la preparación de este manifiesto no se ejecutó `git ls-remote`; la comprobación remota posterior se registra en §4.

## 2. Contratos OpenAPI

| Contrato | Archivo verificado | SHA-256 | Copia coincidente |
|---|---|---|---|
| Público | `mi-barrio-api/contracts/public.openapi.yaml` | `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e` | `mi-barrio-frontend/contracts/public.openapi.yaml` |
| Interno | `mi-barrio-backend/contracts/internal.openapi.yaml` | `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2` | `mi-barrio-api/contracts/internal.openapi.yaml` |

**Método:** `Get-FileHash -Algorithm SHA256` sobre los archivos indicados. Las copias duplicadas producen el mismo valor; los archivos `.sha256` incluidos en los repositorios coinciden con estos resultados. Las rutas son relativas al workspace principal y se registran solo como referencia, sin copiar los contratos a este portal.

## 3. Relación con el portal independiente

- Este repositorio (`mi-barrio-entrega`) es un **portal documental independiente**: no contiene `.gitmodules`, no declara submódulos ni gitlinks y no tiene remoto Git configurado.
- Los tres repositorios de código son independientes entre sí. Cada clon local está en `main` y tiene configurado el remoto HTTPS indicado en la sección 1.
- El manifiesto **asocia documentalmente** la documentación del portal con esas revisiones y esos hashes. No crea una dependencia automática: un cambio de rama, SHA o contrato debe registrarse aquí de manera explícita.
- El despliegue de la aplicación se ejecutó el 2026-11-23 con estos SHAs; `main` de la API sigue en `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd` y el SHA desplegado conserva `b9080ea` como antecesor. El portal ya está publicado en <https://chellunette-cloud.github.io/mi-barrio-entrega/>; siguen pendientes la corrección de P0-01, PT-01, PT-02, la auditoría WCAG formal y la aceptación académica. Véase [`estado-publicacion.md`](estado-publicacion.md), el [README del portal](../README.md) y la [evidencia de despliegue](../docs/despliegue/evidencia-fase-15.2-despliegue-render.md).

## 4. Verificación

Todos los valores de las secciones 1 y 2 fueron comprobados el **2026-11-22** en los clones locales del workspace y coinciden con los valores registrados en [`estado-publicacion.md`](estado-publicacion.md). No se inventó vigencia remota ni resultado de publicación.

**Comprobación remota adicional (2026-11-22):** la comprobación de solo lectura `git ls-remote origin refs/heads/main` confirmó que los SHA remotos de `refs/heads/main` coinciden con los SHA locales registrados en la sección 1 para los tres repositorios. Los SHA no requirieron cambio. No se modificaron remotos y no se publicó el portal.
