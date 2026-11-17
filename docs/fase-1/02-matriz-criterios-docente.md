# Matriz de criterios — control de evidencia

**Estado global:** 🟢 **RESUELTA el 2026-11-15** — los "13/14 criterios" son las **13 historias de usuario HU-01…HU-13**, confirmadas por el usuario. No eran una rúbrica del docente.

> **Corrección documental (no destructiva):** este archivo se conserva como registro histórico de la búsqueda. La sección B (filas `PENDIENTE`) queda **superada** por [`../requerimientos/historias-usuario.md`](../requerimientos/historias-usuario.md). No se eliminó ningún contenido previo.

### Resolución del bloqueo

| Aspecto | Antes (Fase 1) | Ahora (confirmado por el usuario) |
|---------|----------------|-----------------------------------|
| Naturaleza | Se buscaban 13/14 criterios del docente | Son **13 historias de usuario** |
| Fuente | Documento externo inexistente | Enunciado entregado en el chat |
| Identificadores | `CD-01`…`CD-14` (previstos) | **`HU-01`…`HU-13`** (vigentes) |
| Artefacto | Matriz bloqueada | Modelo de requerimientos completo |

La búsqueda de la sección A sigue siendo válida como evidencia: los criterios **no estaban** en el repositorio de referencia porque nunca fueron criterios, sino historias del enunciado.

---

## A. Búsqueda realizada para localizar los criterios

| # | Ubicación revisada | Método | Resultado |
|---|---|---|---|
| A-1 | Árbol completo del repositorio | `git ls-tree -r --name-only HEAD` | 16 archivos; ninguno con criterios |
| A-2 | Historial completo | `git log --all --name-status` | 1 commit; 16 archivos; sin borrados |
| A-3 | Ramas remotas | `git branch -a` | solo `master` |
| A-4 | Tags y releases | `git tag` + API | ninguno |
| A-5 | Issues y Pull Requests | API GitHub | 0 |
| A-6 | Wiki | web | vacía |
| A-7 | README raíz | árbol + API | **no existe** |
| A-8 | `.openspec/README.md` | lectura íntegra | describe módulos, no criterios |
| A-9 | `config.yaml`, `package.json`, `tsconfig.json` | lectura íntegra | configuración, no criterios |
| A-10 | 6 módulos `.ts` | lectura íntegra | contratos de dominio, no criterios |
| A-11 | API `/contents/` (rama `master`) | GET | 5 ítems raíz; mismos del clon |

**Resultado:** 0 coincidencias de una lista de 13 o 14 criterios.

---

## B. Matriz solicitada (SUPERADA — se conserva como registro)

> ⚠️ **Sección superada.** Las filas `PENDIENTE` corresponden a la hipótesis inicial (rúbrica de 13/14 criterios). Esa hipótesis fue descartada: el usuario confirmó que son las 13 historias de usuario. Ver `docs/requerimientos/historias-usuario.md` y `docs/requerimientos/matriz-trazabilidad.md`.

Columnas previstas. Filas marcadas `PENDIENTE` hasta recibir el documento del docente.

| N° | Nombre | Descripción | Importancia | Cómo se aplicará en Mi Barrio | Evidencia necesaria |
|---:|--------|-------------|-------------|-------------------------------|---------------------|
| 01 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 02 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 03 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 04 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 05 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 06 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 07 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 08 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 09 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 10 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 11 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 12 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 13 | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| 14 | PENDIENTE *(solo si la fuente confirma 14)* | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |

> El enunciado indica "13 o 14 criterios"; la cifra exacta se fijará al leer la fuente.

---

## C. Requisitos declarados en el enunciado del proyecto

> Estas tablas **no** son los criterios del docente. Son requisitos explícitos del enunciado entregado por el usuario, y sirven como base de trazabilidad desde ya.
>
> **Nota (2026-11-15):** las tablas C.1–C.5 se conservan como antecedente. El modelo vigente, con identificadores definitivos, está en [`../requerimientos/requisitos.md`](../requerimientos/requisitos.md).

### C.1 Entregables académicos (enunciado §3)

| ID | Entregable | Artefacto previsto | Fase |
|----|-----------|--------------------|------|
| E-01 | Modelo de requerimientos | `docs/02-requerimientos/` | 3 |
| E-02 | Especificaciones del sistema | `docs/03-especificaciones/` | 3 |
| E-03 | Arquitectura de la solución | `docs/04-arquitectura/` | 4 |
| E-04 | Generación del código fuente | 3 repositorios | 6-8 |
| E-05 | Repositorios GitHub | `mi-barrio-frontend`, `-api`, `-backend` | 5 |
| E-06 | Modelo de pruebas | `docs/09-pruebas/` + suites | 10 |
| E-07 | Verificación de calidad | `docs/10-calidad/` | 10 |
| E-08 | Despliegue en Internet | URLs públicas + `docs/11-despliegue/` | 11 |

### C.2 Reglas obligatorias de construcción (enunciado §6, §7)

| ID | Regla | Verificación |
|----|-------|--------------|
| RC-01 | Ningún archivo de código > 100 líneas | Script de conteo en CI |
| RC-02 | SRP | Revisión + estructura de módulos |
| RC-03 | OCP | Extensión por composición, no modificación |
| RC-04 | LSP | Contratos e interfaces respetados |
| RC-05 | ISP | Interfaces pequeñas por caso de uso |
| RC-06 | DIP | Servicios dependen de abstracciones |
| RC-07 | Clean Code + nombres consistentes | Revisión de código |
| RC-08 | Separación de responsabilidades / alta cohesión / bajo acoplamiento | Diagrama de componentes |
| RC-09 | Modularidad y reutilización | Estructura por dominio |
| RC-10 | Manejo centralizado de errores | Middleware único + códigos |
| RC-11 | Validaciones de entrada | Esquemas (Zod) en API |
| RC-12 | Seguridad | Helmet, CORS, rate limit, secrets |
| RC-13 | 3 repositorios independientes, sin mezclar responsabilidades | Auditoría de dependencias |

### C.3 Requisitos por repositorio (enunciado §6)

| ID | Requisito | Se aplica a |
|----|-----------|-------------|
| RP-01 | `README.md` con instalación y ejecución | 3 repos |
| RP-02 | `.gitignore` | 3 repos |
| RP-03 | Configuración de dependencias | 3 repos |
| RP-04 | Estructura modular | 3 repos |
| RP-05 | Variables de entorno documentadas (`.env.example`) | 3 repos |
| RP-06 | Pruebas correspondientes | 3 repos |

### C.4 Funcionalidades a evaluar (enunciado §10)

> **Superada por el modelo de 13 HU.** Esta lista de 12 funcionalidades fue el antecedente; las historias vigentes son HU-01…HU-13 (ver `historias-usuario.md`). Se mantiene para trazabilidad histórica.
> Los identificadores de esta tabla se renombran a **`FA-01`…`FA-12`** para no colisionar con los RF vigentes de `requisitos.md`.

| ID | Funcionalidad | Viabilidad | Prioridad |
|----|---------------|-----------|-----------|
| FA-01 | Página de inicio | por evaluar (Fase 2-3) | — |
| FA-02 | Información general de Ciudad Granada | por evaluar | — |
| FA-03 | Mapa interactivo | por evaluar | — |
| FA-04 | Visualización de límites geográficos | por evaluar | — |
| FA-05 | Consulta de lugares de interés | por evaluar | — |
| FA-06 | Filtros por categorías | por evaluar | — |
| FA-07 | Información de equipamientos | por evaluar | — |
| FA-08 | Consulta de servicios | por evaluar | — |
| FA-09 | Información de movilidad | por evaluar | — |
| FA-10 | Datos territoriales y estadísticos | por evaluar | — |
| FA-11 | Buscador de lugares | por evaluar | — |
| FA-12 | Detalle de cada punto | por evaluar | — |

### C.5 Despliegue (enunciado §15) y documentación final (§16)

| ID | Elemento | Criterio de verificación |
|----|----------|--------------------------|
| RD-01 | Frontend en Internet | URL pública con HTTPS |
| RD-02 | API en Internet | `/health` responde 200 |
| RD-03 | Backend + BD | Conexión PostGIS verificada en producción |
| RD-04 | Variables de entorno | Configuradas en el proveedor, no en el repo |
| RD-05 | CORS | Solo origen del frontend |
| RD-06 | Disponibilidad | Checklist de producción |
| DOC-01 | Manual de usuario | `docs/12-manuales/` |
| DOC-02 | Manual técnico | `docs/12-manuales/` |
| DOC-03 | Matriz de trazabilidad | requisito → prueba → evidencia |
| DOC-04 | Enlaces de despliegue | en README de cada repo |

---

## D. Desbloqueo (resuelto el 2026-11-15)

La información que se solicitaba ya no es necesaria: el usuario entregó las 13 historias de usuario en el enunciado. **No se requiere ningún documento adicional del docente.**

Se conserva el registro de lo que se había pedido, como evidencia de la trazabilidad del bloqueo:

1. ~~Archivo del docente con la lista numerada.~~
2. ~~URL del aula virtual, Drive o repositorio.~~
3. ~~Transcripción del fragmento de clase.~~
4. ~~Captura o texto pegado en el chat.~~

**Estado:** el modelo de requerimientos quedó registrado en `docs/requerimientos/`; la Fase 3 podrá cerrarse cuando el usuario valide el modelo. La Fase 2 (investigación territorial) también quedó documentada.

---

## E. Regla de uso (actualizada)

- El identificador vigente es **`HU-01`…`HU-13`**; `CD-01`…`CD-14` **no se usará**.
- Cada historia se enlaza a: RF/RNF → criterio (`CA-HUxx-nn`) → artefacto → prueba → evidencia.
- Un criterio sin evidencia se marca `NO CUMPLIDO` o `PENDIENTE`, nunca "cumplido" sin prueba.
- La matriz vigente se revisa al cierre de cada fase en `docs/requerimientos/matriz-trazabilidad.md`.
