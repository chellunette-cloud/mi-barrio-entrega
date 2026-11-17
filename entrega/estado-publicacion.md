# Estado de publicación — portal de entrega

**Fecha de preparación:** 2026-11-16  
**Alcance:** Fase A (inspección) y Fase B (preparación local). **No se hizo push, publicación ni despliegue.**

---

## 1. Inspección de los tres repositorios

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

## 2. Bloqueo crítico: los submódulos no incluyen cambios sin commit

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

> **Conclusión:** para publicar la Fase 11.2 es imprescindible autorizar y crear commits en los tres repositorios antes de registrar los submódulos. No se hicieron commits en los tres repositorios porque esta ejecución no tenía esa autorización.

---

## 3. Estado del portal `mi-barrio-entrega`

Preparado localmente, sin remoto:

| Elemento | Estado |
|---|---|
| Repositorio Git local | Inicializado en `main` |
| Commit inicial | `2577ba93edfb2e77f7e8d485310db2d28325c354` |
| HEAD actual | `f67a733` (3 commits locales) |
| Archivos versionados | 78 |
| README principal en español | Sí |
| Copia de documentación y evidencias | Sí: 72 archivos, incluida la Fase 11.2 |
| `.gitignore` | Sí: excluye `.env`, dependencias, builds y secretos |
| Script de configuración de submódulos | Sí: `entrega/configurar-submodulos.ps1` |
| Plantilla de `.gitmodules` | Sí: `entrega/gitmodules.example` (inactiva) |
| `.gitmodules` real | **No creado**: faltan URLs confirmadas |
| Remoto del portal | Ninguno |
| Push o publicación | **No realizado** |

El portal pesa aproximadamente **3,04 MB**, sin `node_modules`, `dist`, `test-results` ni `temp-reference/`.

---

## 4. Qué falta para publicar y obtener el enlace único

### 4.1. Información y decisiones que debe confirmar el usuario

1. **Cuenta u organización de GitHub** que será propietaria de los cuatro repositorios.
2. **URLs definitivas** de `mi-barrio-frontend`, `mi-barrio-api` y `mi-barrio-backend`.
3. **URL definitiva** de `mi-barrio-entrega`.
4. **Visibilidad** de cada repositorio: público o privado. Si son privados, el profesor necesita acceso.
5. **Autorización expresa para crear commits** en los tres repositorios con los cambios de las fases 10.1, 11.1 y 11.2.
6. **Autorización expresa para hacer push** a los remotos.
7. Confirmación de si la copia de `docs/` dentro del portal es aceptable o si se prefiere un cuarto repositorio de documentación.
8. Decisión sobre las credenciales locales de prueba presentes en los `.env.example` antes de una publicación pública.

### 4.2. Secuencia recomendada (no ejecutada)

#### Paso 1 — Revisar y confirmar cada repositorio

```bash
cd mi-barrio-frontend
git status
git diff
npm run ci
```

Repetir en `mi-barrio-api` y `mi-barrio-backend`. Revisar especialmente que no se incorporen `.env`, `node_modules`, `dist`, `test-results` ni archivos locales.

#### Paso 2 — Crear commits en los tres repositorios

Solo después de la revisión y autorización:

```bash
git add -A
git commit -m "<mensaje descriptivo de la fase>"
```

Los tres commits deben incluir los cambios de las fases 10.1, 11.1 y 11.2. No se deben separar ni descartar archivos sin revisar.

#### Paso 3 — Crear los cuatro repositorios remotos

Nombres sugeridos, sin inventar propietario:

- `<USUARIO_O_ORG>/mi-barrio-frontend`
- `<USUARIO_O_ORG>/mi-barrio-api`
- `<USUARIO_O_ORG>/mi-barrio-backend`
- `<USUARIO_O_ORG>/mi-barrio-entrega`

Los tres repositorios de código deben crearse **vacíos** (sin README, sin `.gitignore`, sin licencia) para evitar conflictos, y deben recibir al menos un commit antes de usarse como submódulos.

#### Paso 4 — Publicar los tres repositorios de código

```bash
git remote add origin <URL_REAL_DEL_REPOSITORIO>
git push -u origin main
```

Repetir en los tres repositorios.

#### Paso 5 — Registrar los submódulos desde el portal

```powershell
cd mi-barrio-entrega
powershell -NoProfile -ExecutionPolicy Bypass -File entrega\configurar-submodulos.ps1 `
  -FrontendUrl <URL_REAL_FRONTEND> `
  -ApiUrl <URL_REAL_API> `
  -BackendUrl <URL_REAL_BACKEND>
```

El script:

- valida que las URLs no sean marcadores;
- comprueba acceso con `git ls-remote`;
- exige que los remotos tengan commits;
- añade los tres submódulos;
- no hace commit ni push automáticamente.

Después:

```bash
git add .gitmodules mi-barrio-frontend mi-barrio-api mi-barrio-backend
git commit -m "feat(entrega): registrar submodulos de los tres repositorios"
git remote add origin <URL_REAL_ENTREGA>
git push -u origin main
```

#### Paso 6 — Verificar el clon recursivo real

```bash
git clone --recurse-submodules <URL_REAL_ENTREGA> C:\temp\verificacion-entrega
cd C:\temp\verificacion-entrega
git submodule status
```

Comprobar que:

- los tres submódulos se clonan;
- los commits fijados son los nuevos, no los antiguos;
- existen los artefactos de la Fase 11.2;
- el README y los enlaces a `docs/` se visualizan en GitHub;
- el portal no contiene secretos.

#### Paso 7 — Entregar el enlace único

El enlace único será la URL de `mi-barrio-entrega`. No se debe entregar hasta completar el Paso 6.

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
| Push o despliegue | No realizado |

> Los tres `.env.example` documentan credenciales locales de prueba para el entorno de desarrollo. No son credenciales de producción, pero deben revisarse antes de publicar los repositorios como públicos. No se imprimieron ni copiaron valores secretos en este documento.

---

## 6. Verificación de enlaces y contenido del README

Verificación local ejecutada el 2026-11-16:

- [x] Todos los enlaces relativos del README existen: **19 enlaces, 0 roto**.
- [x] No hay URLs de GitHub sin confirmar: no se encontró ningún `github.com`.
- [x] No hay datos territoriales presentados con el nivel territorial incorrecto: UPZ y localidad están separados del barrio.
- [x] No se afirma que los submódulos ya estén configurados: el README usa un marcador `<URL_DE_ESTE_REPOSITORIO>` y no incluye `.gitmodules`.
- [x] El README no contiene credenciales ni secretos: la búsqueda de patrones no encontró tokens, claves ni contraseñas.
- [x] La documentación de la Fase 11.2 está copiada y enlazada.

---

## 7. Resumen ejecutivo

| Pregunta | Respuesta |
|---|---|
| ¿Los tres repositorios tienen remoto GitHub? | **No** |
| ¿GitHub CLI está instalado y autenticado? | **No instalado; no verificable** |
| ¿Se conservaron los cambios de 10.1, 11.1 y 11.2? | **Sí, en el árbol de trabajo** |
| ¿Los cambios están en commits publicables? | **No** |
| ¿El portal está preparado localmente? | **Sí** |
| ¿Los submódulos están configurados? | **No, a la espera de URLs y commits** |
| ¿Se publicó algo? | **No** |
| ¿Qué falta para el enlace único? | Cuenta/URLs, autorización de commits y push, crear remotos, registrar submódulos y verificar el clon recursivo |
