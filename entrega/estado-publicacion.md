# Estado de publicación — portal de entrega

**Fecha de preparación:** 2026-11-16 (registro histórico)  
**Última actualización:** 2026-11-23  
**Vigencia por sección:** §0 estado vigente; §§1–2 registros históricos; §3 información histórica del portal con estado actual diferenciado; §4 decisiones y secuencia de publicación; §5 verificaciones de seguridad vigentes; §6 verificación de enlaces y contenido re-verificada el 2026-11-22; §7 resumen ejecutivo actualizado; §8 despliegue real de Fase 15.2; §9 publicación del portal en GitHub Pages.  
**Alcance original:** Fase A (inspección) y Fase B (preparación local). En ese momento **no se hizo push, publicación ni despliegue**.

---

## 0. Estado vigente (2026-11-23)

Los tres repositorios de código están publicados en `main`. Remotos y HEADs verificados en los repositorios locales y confirmados contra GitHub mediante `git ls-remote --heads origin` el 2026-11-22 (`refs/heads/main` coincide en los tres casos):

| Repositorio | Remoto `origin` verificado | HEAD vigente |
|---|---|---|
| `mi-barrio-frontend` | `https://github.com/chellunette-cloud/mi-barrio-frontend.git` | `main` / `4237608525a8df3cbc033aa11376772564f68294` |
| `mi-barrio-api` | `https://github.com/chellunette-cloud/mi-barrio-api.git` | `fase-15/p0-trust-proxy` / `0661782534b979f2497add5402fc2a3c3f3f4091` |
| `mi-barrio-backend` | `https://github.com/chellunette-cloud/mi-barrio-backend.git` | `main` / `a6c912542873665659fff4a38c1efdd5f13483be` |

**Hashes vigentes de contratos:** interno `ab080fd08eba86aa90d2217ffcc1c3e9bd2e8223a542cc9348c5861e8cb181e2`, público `a2ed68fa2826ef8de7e9ffff9be68f9e8903b2ba5021ed04297ca0848903029e`.  
**Hashes históricos conservados:** Fase 11.2 interno `338f3cbe3a7591d09691c0e05ae43bab8783faac1511d22408eb67e05d0f8ddc`, público `af9cda5b6ae3cdad59593ac5dd4abf9d3ca3c2550ee672484ac952ed88b5232e`; Fase 12 interno `606a25436e23c4964f44153acc545b4dcb947801ffc726aa1aaf0f565c15a84c`, público `c1602756c9eb7edf98695da489856f76387f3d62874e13e5ce89a1ed461aed59`.

`main` de la API permanece en `40c92fb2651ad31f7d33f9c14e0abc0ff976f9dd`; el SHA desplegado conserva `b9080ea` y `39684bc` como antecesores.

**Despliegue real (2026-11-23, Fase 15.2):** cuatro servicios Free en Render, USD 0, sin tarjeta. Frontend `https://mi-barrio-frontend.onrender.com`, API `https://mi-barrio-api-8bn3.onrender.com`, backend `https://mi-barrio-backend-6jp2.onrender.com` y PostgreSQL/PostGIS de 1 GB con expiración el 2026-12-22. Endpoints, mapa, ETL y datos verificados; **P0-02 aprobado para la integridad consultada; P0-01 NO APROBADO en esa fecha**. El 2026-11-23 se ejecutó la Fase 15.3: **P0-01 APROBADO con evidencia desplegada** y secciones públicas verificadas en 200. Detalle en [`docs/despliegue/evidencia-fase-15.3-correccion-p0-01-y-secciones.md`](../docs/despliegue/evidencia-fase-15.3-correccion-p0-01-y-secciones.md) y registro histórico en [`docs/despliegue/evidencia-fase-15.2-despliegue-render.md`](../docs/despliegue/evidencia-fase-15.2-despliegue-render.md).

**Publicación del portal (2026-11-23, §9):** repositorio público independiente `chellunette-cloud/mi-barrio-entrega`, GitHub Pages activo en `main` / raíz. Enlace único del portal: <https://chellunette-cloud.github.io/mi-barrio-entrega/>. La aplicación sigue en <https://mi-barrio-frontend.onrender.com>; son direcciones distintas.

La matriz canónica registra **46/46 criterios aprobados** ([`docs/evidencias/fase-13/matriz-global-46-criterios.md`](../docs/evidencias/fase-13/matriz-global-46-criterios.md)). El E2E remoto `44979541605` terminó en `success` con **36/36 pruebas en 15 archivos** ([`docs/evidencias/fase-14-7/ejecucion-e2e-remota.md`](../docs/evidencias/fase-14-7/ejecucion-e2e-remota.md)). Es regresión remota de los criterios cubiertos, no ejecución individual de los 46 criterios ni despliegue. Ambas rutas están físicamente presentes en este portal y enlazadas desde [`docs/README.md`](../docs/README.md); los archivos figuran como `untracked` en `git status` y su incorporación a Git y revisión siguen pendientes.

Los seis manuales están disponibles en `mi-barrio-entrega/docs/manuales/` y enlazados desde el README raíz y desde `entrega/README.md`. **Publicación del portal resuelta (§4 y §9):** URL definitiva <https://chellunette-cloud.github.io/mi-barrio-entrega/>, repositorio público `chellunette-cloud/mi-barrio-entrega`, Pages desde `main` / raíz, clon y enlaces verificados; enlace único entregado. La copia de `docs/` quedó en el mismo repositorio del portal, sin cuarto repositorio. Las plantillas `.env.example` de los repositorios de código se revisaron sin encontrar secretos reales. No se solicitó autorización ni registro de submódulos: la opción C los excluye y el portal usa el [manifiesto de versiones](manifiesto-versiones.md). **Despliegue de la aplicación (ejecutado el 2026-11-23, §8):** configuración de producción aplicada en Render y servicios verificados; CORS queda definido por `FRONTEND_ORIGIN`, con backends internos protegidos por token. **Pendientes de despliegue:** respaldos/restauración; P0-01 quedó corregido y revalidado en la Fase 15.3 (§10). **Pendientes de verificación final y sustentación:** entrega final, trazabilidad final, verificaciones finales, PT-01, PT-02 y la auditoría formal de accesibilidad (los tres últimos permanecen sin evidencia de cierre). La documentación final de los seis documentos canónicos ya está sincronizada en el portal; queda pendiente su entrega académica. Las secciones 1 y 2 conservan el registro original de preparación de 2026-11-16; §3 distingue ese registro del estado actual del portal; §§4–7 reflejan las decisiones pendientes, las verificaciones vigentes y el resumen actualizado.

---

## 1. Inspección de los tres repositorios (registro histórico de 2026-11-16)

> **Registro histórico:** en ese momento ninguno de los tres repositorios tenía remoto y los cambios estaban sin commitear, según la tabla siguiente. El estado vigente se describe en §0.

| Repositorio | Rama | HEAD | Remoto configurado | Modificados | Sin rastrear |
|---|---|---|---|---|---:|---:|
| `mi-barrio-frontend` | `main` | `755640df89e18c90c650f1f827cbcd3c5d162e62` | Ninguno | 12 | 17 |
| `mi-barrio-api` | `main` | `246bd94c39354a11ff746aefe694b8482020feae` | Ninguno | 14 | 3 |
| `mi-barrio-backend` | `main` | `50dba27cc59220523a330625a8039d7abe9e232e` | Ninguno | 20 | 10 |
| **Total** | | | | **46** | **30** |

- Los tres repositorios son Git independientes y están en la rama `main`.
- **Ninguno tiene remoto** (`git remote -v` vacío).
- **GitHub CLI no está instalado** en el equipo; `gh auth status` no puede ejecutarse. No se pudo verificar ninguna cuenta de GitHub.
- No hay `stash` en ninguno de los tres repositorios.
- No se descartó, movió ni sobrescribió ningún cambio.

### 1.1. Presencia de las fases 10.1, 11.1 y 11.2

Los cambios siguen en el árbol de trabajo. Se verificó la presencia de artefactos clave de la Fase 11.2:

| Artefacto | Repositorio | Presente |
|---|---|---|
| Corrección de direcciones de salud (`DIRECCION`, `DIRECCIONC`) | backend | Sí |
| Código SITP desde `PSICENEFA` | backend | Sí |
| Migración `009_add_lugar_codigo.sql` | backend | Sí |
| Snapshot `poblacion-upz-082-2025.json` | backend | Sí |
| Panel de quinquenios `DemografiaPanel.tsx` | frontend | Sí |
| Administración de categorías (controlador API) | api | Sí |
| Prueba E2E `hu13.categorias.spec.ts` | frontend | Sí |

Verificación de contratos:

| Contrato | Hash calculado | Hash registrado | Resultado |
|---|---|---|---|
| Interno (`mi-barrio-api/contracts/internal.openapi.yaml`) | `338f3cbe…8ddc` | `338f3cbe…8ddc` | Coincide |
| Público (`mi-barrio-frontend/contracts/public.openapi.yaml`) | `af9cda5b…232e` | `af9cda5b…232e` | Coincide |

Los resultados de regresión de la Fase 11.2 están documentados en `docs/evidencias/fase-11-2/resultados-regresion.md`: CI en verde en los tres repositorios, 23/23 pruebas Playwright, 10 snapshots verificados y builds correctos.

---

## 2. Registro histórico del ensayo de submódulos (2026-11-16; no aplicable a la opción C)

Un submódulo Git fija un **commit**, no el árbol de trabajo. Mientras los cambios de las fases 10.1, 11.1 y 11.2 sigan sin commit, cualquier submódulo apuntará a los commits antiguos y la entrega publicada **no mostrará esos cambios**.

Se hizo un ensayo local aislado en `%TEMP%` con clones bare de los commits actuales:

1. Se clonaron los tres repositorios en modo bare.
2. Se clonó el portal `mi-barrio-entrega`.
3. Se añadieron los tres submódulos con rutas locales temporales.
4. Se clonó el portal con `git clone --recurse-submodules`.

Resultado del ensayo:

| Submódulo | Commit fijado | ¿Incluye Fase 11.2? |
|---|---|---|
| `mi-barrio-frontend` | `755640df…` | **No** |
| `mi-barrio-api` | `246bd94c…` | **No** |
| `mi-barrio-backend` | `50dba27c…` | **No** |

Archivos de la Fase 11.2 ausentes en el clon de prueba:

- `mi-barrio-backend/migrations/009_add_lugar_codigo.sql`: **no presente**.
- `mi-barrio-frontend/src/features/stats/components/DemografiaPanel.tsx`: **no presente**.
- `mi-barrio-api/src/http/controllers/adminCategoriasController.ts`: **no presente**.

La mecánica de submódulos y el clon recursivo **sí funcionan**, pero el contenido publicado sería el de los commits antiguos. El ensayo se eliminó después de registrar el resultado.

> **Conclusión histórica:** en 2026-11-16 los cambios de las fases 10.1, 11.1 y 11.2 aún no estaban en commits y un submódulo habría fijado los commits antiguos. Posteriormente se crearon y publicaron los commits vigentes (§0). El mecanismo de submódulos sigue sin aplicarse al portal: no existe `.gitmodules` y no se ha verificado un clon recursivo con las URLs reales. Con la opción C aprobada, ese mecanismo queda descartado para el portal: los repositorios se referencian por URL HTTPS y por el [manifiesto de versiones](manifiesto-versiones.md).

---

## 3. Estado del portal `mi-barrio-entrega`

**Información histórica (2026-11-16):** preparado localmente, sin remoto, con 78 archivos versionados y una copia documental de 72 archivos.  
**Estado en 2026-11-22 (histórico):** en ese momento seguía sin remoto, sin `.gitmodules` y sin publicar; la documentación quedó sincronizada y el HEAD vigente era `399f66f9b7fab2808ada4d62456670ac8aec4704`. **Estado actual (2026-11-23):** con remoto, sin `.gitmodules` y publicado (§9).

| Elemento | Registro histórico (2026-11-16) | Estado actual (2026-11-22) |
|---|---|---|
| Repositorio Git local | Inicializado en `main` | Igual; rama `main` |
| Commit inicial | `2577ba93edfb2e77f7e8d485310db2d28325c354` | Sin cambios; sigue siendo el commit raíz |
| HEAD vigente | — | `399f66f9b7fab2808ada4d62456670ac8aec4704` (7 commits locales) |
| Historial | Commits locales en `main`; consultar `git log` | 7 commits locales en `main` |
| Archivos versionados | 78 | 78 (sin cambios) |
| README principal en español | Sí | Sí |
| Copia de documentación y evidencias | 72 archivos, incluida la Fase 11.2 | 103 archivos presentes en `docs/`: 72 versionados y 31 sin rastrear |
| `.gitignore` | Sí: excluye `.env`, dependencias, builds y secretos | Sin cambios |
| Script de configuración de submódulos | Sí: `entrega/configurar-submodulos.ps1` | Artefacto histórico; no aplicable a la opción C, no ejecutado |
| Plantilla de `.gitmodules` | Sí: `entrega/gitmodules.example` (inactiva) | Artefacto histórico; sigue inactiva y no se usa |
| `.gitmodules` real | **No creado**: faltan URLs confirmadas | **No creado ni previsto**: la opción C excluye submódulos; las versiones se registran en el manifiesto |
| Remoto del portal | Ninguno | Ninguno |
| Push o publicación | **No realizado** | **No realizado** |

El portal pesa aproximadamente **3,27 MB** (medido el 2026-11-22, excluyendo `.git`), sin `node_modules`, `dist`, `test-results` ni `temp-reference/`.

---

## 4. Decisiones y secuencia de publicación del portal y del enlace único (ejecutada)

### 4.1. Decisiones pendientes y confirmaciones registradas

1. **URL definitiva y visibilidad** de `mi-barrio-entrega`: **resueltas**. Repositorio público y URL <https://chellunette-cloud.github.io/mi-barrio-entrega/> (§9).
2. **Visibilidad pública confirmada** de `mi-barrio-frontend`, `mi-barrio-api` y `mi-barrio-backend`: los tres repositorios son públicos, comprobado mediante acceso anónimo y sin credenciales (§0). La única decisión de visibilidad pendiente corresponde a `mi-barrio-entrega` (ítem 1).
3. Copia de `docs/` dentro del portal: **aceptada**; no se creó un cuarto repositorio de documentación.
4. Verificación final de las plantillas `.env.example` de los repositorios de código: revisadas el 2026-11-22 sin encontrar valores secretos reales; conservar la precaución ante cambios futuros y no publicar `.env` (§5).
5. Publicación del portal independiente: **ejecutada** (§9). La cuenta, las URLs y el push de los tres repositorios de código ya están resueltos (§0). No se autoriza ni registra ningún submódulo (opción C).

### 4.2. Secuencia de publicación (estado 2026-11-22)

Los pasos 2–4 se ejecutaron para los tres repositorios de código: commits vigentes, remotos `origin` creados y `git push -u origin main` verificado (§0). Los pasos 5–7 se ejecutaron para el portal el 2026-11-23 (§9); el despliegue de la aplicación no forma parte de esta secuencia.

#### Paso 1 — Revisar y confirmar cada repositorio (revisión histórica)

```bash
cd mi-barrio-frontend
git status
git diff
npm run ci
```

Repetir en `mi-barrio-api` y `mi-barrio-backend`. Revisar especialmente que no se incorporen `.env`, `node_modules`, `dist`, `test-results` ni archivos locales.

#### Paso 2 — Crear commits en los tres repositorios (ya ejecutado)

Solo después de la revisión y autorización:

```bash
git add -A
git commit -m "<mensaje descriptivo de la fase>"
```

Los tres commits deben incluir los cambios de las fases 10.1, 11.1 y 11.2. No se deben separar ni descartar archivos sin revisar.

#### Paso 3 — Crear repositorios remotos (ejecutado para los tres de código; pendiente el portal)

Nombres sugeridos, sin inventar propietario:

- `<USUARIO_O_ORG>/mi-barrio-frontend`
- `<USUARIO_O_ORG>/mi-barrio-api`
- `<USUARIO_O_ORG>/mi-barrio-backend`
- `<USUARIO_O_ORG>/mi-barrio-entrega`

Los tres repositorios de código ya están creados y contienen los commits vigentes (§0); no deben recrearse. El repositorio del portal es `chellunette-cloud/mi-barrio-entrega` (§9); no se registraron submódulos (opción C).

#### Paso 4 — Publicar los tres repositorios de código (ya ejecutado)

```bash
git remote add origin <URL_REAL_DEL_REPOSITORIO>
git push -u origin main
```

Repetir en los tres repositorios.

#### Paso 5 — Publicar el portal independiente (ejecutado)

El portal `mi-barrio-entrega` se publicó como repositorio público independiente. No se ejecutó `configurar-submodulos.ps1`, no se creó `.gitmodules` y no se registraron gitlinks. Las versiones de referencia están en [`manifiesto-versiones.md`](manifiesto-versiones.md).

Antes de publicar se confirmaron la URL definitiva, la visibilidad pública permitida por GitHub Free y la ausencia de secretos y archivos `.env`. La publicación y el push se realizaron con autorización explícita; el detalle está en §9.

#### Paso 6 — Verificar el clon del portal (ejecutado)

```bash
git clone https://github.com/chellunette-cloud/mi-barrio-entrega.git <RUTA_VERIFICACION>
cd <RUTA_VERIFICACION>
```

Comprobar que:

- el README y los enlaces a `docs/` se visualizan en GitHub;
- el [manifiesto de versiones](manifiesto-versiones.md) enlaza los tres repositorios independientes;
- no existe `.gitmodules` ni hay gitlinks;
- el portal no contiene secretos.

#### Paso 7 — Entregar el enlace único (ejecutado)

Enlace único del portal: <https://chellunette-cloud.github.io/mi-barrio-entrega/>. Se entrega después de completar el Paso 6. La aplicación desplegada está en <https://mi-barrio-frontend.onrender.com>; no deben confundirse.

---

## 5. Revisión de seguridad

| Verificación | Resultado |
|---|---|
| `.env` rastreado en Git | No en ninguno de los tres repositorios |
| `.env` local en API y backend | Presente, pero ignorado por `.gitignore` |
| `.env` en el portal | No incluido |
| Tokens, claves privadas o PAT en archivos rastreados | No detectados por búsqueda de patrones |
| `node_modules`, `dist`, `build`, `test-results` | Ignorados y no copiados al portal |
| `temp-reference/` | No copiado |
| URLs de GitHub inventadas | Ninguna |
| Push/publicación de los repositorios de código | Realizado; véase §0 |
| Push/publicación del portal `mi-barrio-entrega` | Realizado el 2026-11-23; repo público y Pages activo (§9) |
| Despliegue de la aplicación | Realizado en Render el 2026-11-23; P0-01 APROBADO en Fase 15.3, P0-02 aprobado para los datos consultados |

> Revisión de las plantillas de los tres repositorios de código (2026-11-22): no se encontraron valores secretos reales; las plantillas contienen marcadores, puertos y ejemplos locales (`localhost`). No se imprimieron ni copiaron valores. Se conserva la precaución de revisar cualquier cambio futuro de `.env.example` y de no publicar archivos `.env`.

---

## 6. Verificación de enlaces y contenido del README

Verificación local ejecutada el 2026-11-16; **reverificada el 2026-11-22** (26 enlaces relativos en el README raíz, 0 rotos; sin `.gitmodules`; seis manuales presentes):

- [x] Todos los enlaces relativos del README raíz existen: **26 enlaces, 0 roto**.
- [x] Los dominios de GitHub presentes corresponden a los tres remotos `origin` verificados en la §0; no se presenta ninguna URL de despliegue como existente. Los dominios `*.example` siguen siendo ejemplos de plantilla.
- [x] No hay datos territoriales presentados con el nivel territorial incorrecto: UPZ y localidad están separados del barrio.
- [x] El portal usa la opción C: sin submódulos ni `.gitmodules`; el README usa la URL real del repositorio y las versiones se registran en el manifiesto.
- [x] El README no contiene credenciales ni secretos: la búsqueda de patrones no encontró tokens, claves ni contraseñas.
- [x] La documentación de la Fase 11.2 está copiada y enlazada.
- [x] Los seis manuales están copiados en `docs/manuales/` y enlazados desde el README raíz y desde `entrega/README.md`.

---

## 7. Resumen ejecutivo

| Pregunta | Respuesta |
|---|---|
| ¿Los tres repositorios tienen remoto GitHub? | **Sí**, `origin` verificado; HEAD remoto confirmado con `git ls-remote` (§0). |
| ¿GitHub CLI está instalado y autenticado? | **No instalado; cuenta no verificable con `gh`** (reverificado el 2026-11-22). |
| ¿Se conservaron los cambios de 10.1, 11.1 y 11.2? | **Sí**, incorporados a los commits vigentes de los tres repositorios (§0). |
| ¿Los cambios están en commits publicables? | **Sí**, publicados en `main` (§0). |
| ¿El portal está preparado y publicado? | **Sí**, con documentación sincronizada, remoto `origin` y GitHub Pages activo (§9). |
| ¿El portal usa submódulos? | **No**; opción C, sin `.gitmodules` ni gitlinks. |
| ¿Se publicó algo? | **Sí**: los tres repositorios de código, la aplicación en Render con planes Free y el portal en GitHub Pages. |
| ¿La aplicación está desplegada? | **Sí**, desde el 2026-11-23, con USD 0; P0-01 APROBADO en la Fase 15.3 y P0-02 aprobado para la integridad de datos consultada. Véanse §8 y §10. |
| ¿Cuál es el enlace único? | <https://chellunette-cloud.github.io/mi-barrio-entrega/>. No se registran submódulos (opción C). |

---

## 8. Despliegue real en Render (2026-11-23)

- Cuatro servicios Free sin tarjeta: PostgreSQL 16/PostGIS, backend, API y Static Site. Facturación USD 0; 4/25 servicios y 0,45/750 horas Free.
- SHAs desplegados en esa fecha: frontend `11aa254`, API `39684bc` en `fase-15/p0-trust-proxy`, backend `a6c9125` en `main`. No se generaron commits nuevos ni force pushes. La Fase 15.3 (§10) publicó posteriormente `4237608` y `0661782` sin force pushes.
- Migraciones y ETL se ejecutaron desde el Build Command del backend porque `Pre-Deploy Command` está bloqueado en Free. Se creó la extensión PostGIS directamente en la BD desplegada, sin cambios de código.
- Verificación real: health, ficha, geometría, categorías, 376 lugares, 463 vías y estadísticas responden `200` a través del rewrite del frontend; el mapa y el catálogo cargan datos reales.
- P0-01 (registro histórico de esa fecha): `/internal/v1/diagnostico-ip` mostró `trustProxy=1` y varios `req.ip` internos para una misma IP sintética. **NO APROBADO** entonces; corregido y aprobado en la Fase 15.3 (§10).
- P0-02: 34/34 manzanas estrato 2 dentro del polígono, 58 vértices, 9,10 ha, 94.551,13 m², 705 lotes, 3.807 habitantes, 5 categorías, 376 lugares, 463 vías y 7 fuentes. **APROBADO para la integridad consultada**.
- Limitaciones: red privada no disponible en Free, backend público protegido por token, instancias que se apagan por inactividad, BD de 1 GB que expira el 2026-12-22 sin backups, y PostGIS 3.6.2 en Render frente a 3.7.0 local.
- Evidencia completa: [`docs/despliegue/evidencia-fase-15.2-despliegue-render.md`](../docs/despliegue/evidencia-fase-15.2-despliegue-render.md).

---

## 9. Publicación del portal en GitHub Pages (2026-11-23)

| Concepto | Valor verificado |
|---|---|
| Cuenta | `chellunette-cloud` (GitHub **Free**, confirmado en Billing; $0,00/mes) |
| Condición Pages | En Free, Pages requiere repositorio **público**; no se contrató plan de pago ni se hizo público el repositorio privado de desarrollo |
| Repositorio del portal | `https://github.com/chellunette-cloud/mi-barrio-entrega` (público, solo documentación) |
| Dirección del portal | `https://chellunette-cloud.github.io/mi-barrio-entrega/` |
| Dirección de la aplicación | `https://mi-barrio-frontend.onrender.com` (distinta del portal) |
| Fuente Pages | `main` / `/ (root)` |
| Contenido publicado | README, `docs/`, `entrega/` e `index.html`; sin `.env`, claves, tokens ni submódulos |
| Repositorios de código | Intactos: `mi-barrio-frontend`, `mi-barrio-api` y `mi-barrio-backend` no se modificaron |

**Comprobaciones previas:** búsqueda de patrones de secretos en todo el árbol (sin coincidencias de valores reales), ausencia de `.env`, `*.pem`, `*.key` y `id_rsa`, y verificación de que el destino GitHub estaba libre antes de crearlo. **Comprobaciones posteriores:** clon fresco del repositorio, resolución de la URL de Pages y enlaces del `index.html` a la documentación y a la aplicación.

> Esta sección registra solo la publicación documental. No cambia P0-02 (aprobado para la integridad consultada) ni la ausencia de aceptación académica; P0-01 fue corregido y aprobado después, en la Fase 15.3 (§10).

---

## 10. Fase 15.3 — corrección final de P0-01 y de las secciones (2026-11-23)

- Causa de P0-01: Render añade `X-Forwarded-For` sin limpiar lo que envía el cliente; con `trust proxy=1`, `req.ip` caía en hops internos y fragmentaba el contador. Corrección: clave del limitador derivada de `CF-Connecting-IP`, cabecera controlada por Cloudflare y validada con `isIP`; `trust proxy` sigue en `1`.
- Evidencia desplegada: `clientIpSource=cf-connecting-ip`, IP efectiva estable ante XFF sintéticos, `CF-Connecting-IP` falsificada rechazada con 403, contador compartido por el mismo cliente (`remaining` 119→118→117) y 404 con `no-store`. Pruebas de integración: 32/32 en API (5 nuevas de IP/proxy).
- Causa de las secciones: 502 del backend durante arranque en frío se cachearon con `public, max-age=300`; el navegador sirvió ese error aunque la API ya respondía 200. Corrección: `no-store` en errores/429/404 y reintentos 1/3/6 s ante 502/503/504 en el frontend.
- Validación pública: diez llamadas iniciales en 200, consola sin errores, mapa con 827 `path`, 463 vías, catálogo y filtros operativos, navegación `#inicio`/`#historia`/`#explorar`/`#buscar`. CI verde en los dos repositorios modificados.
- Versiones definitivas: API `0661782534b979f2497add5402fc2a3c3f3f4091` (`fase-15/p0-trust-proxy`), frontend `4237608525a8df3cbc033aa11376772564f68294` (`main`), backend sin cambios `a6c912542873665659fff4a38c1efdd5f13483be`.
- Detalle completo: [`docs/despliegue/evidencia-fase-15.3-correccion-p0-01-y-secciones.md`](../docs/despliegue/evidencia-fase-15.3-correccion-p0-01-y-secciones.md).
