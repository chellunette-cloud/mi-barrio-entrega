# Manual de operación y mantenimiento — Mi Barrio, Ciudad Granada

**Versión 1.0 — 2026-11-22**

Este manual describe las tareas operativas del sistema en ejecución local o en una instalación propia. El proyecto **no está desplegado públicamente** y no cuenta con supervisión, rotación de logs ni procedimientos de respaldo automatizados. Las tareas aquí descritas son reproducibles con los scripts existentes.

---

## 1. Alcance y responsabilidades

| Proceso | Responsabilidad operativa |
|---|---|
| Backend | Dominio, base de datos, ETL, autenticación y contrato interno. |
| API | Frontera pública, CORS, caché, límite de solicitudes y traducción de errores. |
| Frontend | Interfaz estática o servida por Vite; no genera logs propios. |
| Base de datos | Persistencia de geometrías, lugares, vías, usuarios y auditoría. |

Antes de cualquier intervención, registre el commit o HEAD de los tres repositorios y el hash del contrato correspondiente. Los HEADs vigentes están en el [manual técnico](manual-tecnico.md).

---

## 2. Health checks

No hay scripts npm de healthcheck. La comprobación real son las peticiones HTTP documentadas en el workflow E2E:

```bash
curl -fsS --max-time 3 -H "X-Service-Token: $SERVICE_TOKEN" http://127.0.0.1:3001/internal/v1/health
curl -fsS --max-time 3 http://127.0.0.1:3000/api/v1/health
```

Respuestas esperadas:

```json
{"status":"ok","service":"mi-barrio-backend"}
{"status":"ok","service":"mi-barrio-api"}
```

Comprobaciones adicionales:

- la petición al backend sin `X-Service-Token` debe devolver `401 NO_AUTORIZADO`;
- el frontend no expone health check propio; verifique su carga en `http://127.0.0.1:5173`;
- el workflow E2E realiza hasta 60 intentos con `sleep 2` y falla con “Los servicios no respondieron a tiempo” si no hay respuesta.

---

## 3. Logs y trazabilidad

API y backend usan `console.log`/`console.error`; no hay librería de logging ni archivos de log creados por el código.

Registros reales:

- arranque de la API: `mi-barrio-api escuchando en ${HOST}:${PORT} -> ${BACKEND_URL}`;
- arranque del backend: `mi-barrio-backend escuchando en …`;
- errores no controlados: JSON con `level: "error"`, `requestId` y mensaje o detalle del backend;
- el `requestId` se devuelve en la cabecera `X-Request-Id` y aparece en el cuerpo de error.

En el workflow E2E, los procesos se redirigen a `backend.log` y `api.log` dentro del runner. Esos archivos no se versionan: `.gitignore` excluye `*.log`. Para operación local, redirija la salida estándar a un destino controlado por el operador.

No existe agregación, rotación ni retención definida de logs.

---

## 4. Actualización de dependencias

No hay un script propio de actualización. Procedimiento recomendado:

1. Revise `package.json` y `package-lock.json` del repositorio afectado.
2. Aplique la actualización aprobada por el equipo con el flujo habitual de npm.
3. Reinstale de forma reproducible:

   ```bash
   npm ci
   ```

4. Verifique calidad y contratos:

   ```bash
   npm run lint
   npm run typecheck
   npm run check:lines
   npm run contracts:verify   # solo en mi-barrio-api y mi-barrio-frontend
   npm run ci
   npm run build
   ```

5. Repita la verificación en los tres repositorios, aunque el cambio haya sido local.
6. Registre la fecha, el repositorio, el cambio aplicado y los resultados.

No actualice dependencias directamente en un entorno sin la posibilidad de revertir el cambio.

---

## 5. Migraciones

Las migraciones del backend están en `mi-barrio-backend/migrations/`, numeradas de `001` a `009`. El migrador:

- crea `schema_migrations(version, applied_at)`;
- ejecuta cada archivo en una transacción;
- registra la versión aplicada;
- muestra `migrada: <archivo>`;
- es idempotente.

Comando:

```bash
cd mi-barrio-backend
npm run migrate
```

Buenas prácticas:

- aplicar migraciones antes de `npm run etl`;
- no editar una migración ya aplicada;
- crear un archivo nuevo con el siguiente número secuencial;
- verificar `npm run test:contract` y `npm run ci` después de cambiar el esquema;
- recordar que las migraciones no crean la extensión PostGIS.

---

## 6. Respaldo y restauración

**No existe un procedimiento de respaldo o restauración en los repositorios.** No hay scripts con `pg_dump`, `pg_restore` ni definiciones de volúmenes o jobs de base de datos. Por tanto, este apartado es un pendiente de infraestructura y no debe interpretarse como una capacidad implementada.

Lo único reproducible hoy es una **reconstrucción controlada** de la base desde los snapshots inmutables:

```bash
cd mi-barrio-backend
npm run verify:data
npm run migrate
npm run etl
```

Esta reconstrucción:

- restaura los datos territoriales de los 10 snapshots verificados;
- **no** conserva cambios administrativos en `admin_usuario` ni entradas de `auditoria`;
- **no** sustituye un respaldo de base de datos.

Antes de cualquier intervención destructiva, documente manualmente el estado de usuarios y auditoría que deba conservarse y defina un procedimiento de respaldo aprobado por el responsable de infraestructura.

---

## 7. Gestión de errores

### 7.1 Errores de la API

| Situación | HTTP | Código |
|---|---:|---|
| Falta de autorización | 401 | `NO_AUTORIZADO` |
| Identificador inválido | 400 | `ID_INVALIDO` |
| Filtro inválido | 400 | `FILTRO_INVALIDO` |
| Datos inválidos | 400 | `DATOS_INVALIDOS` |
| No encontrado | 404 | `NO_ENCONTRADO` |
| Ruta inexistente | 404 | `RUTA_NO_ENCONTRADA` |
| Exceso de solicitudes | 429 | `DEMASIADAS_SOLICITUDES` |
| Contrato interno inválido | 502 | `CONTRATO_INTERNO_INVALIDO` |
| Dependencia no disponible | 502 | `DEPENDENCIA_NO_DISPONIBLE` |
| Tiempo agotado | 504 | `TIEMPO_AGOTADO` |
| Error no controlado | 500 | `ERROR_INTERNO` |

Toda respuesta de error incluye `code`, `message` y `requestId`. Use el `requestId` para localizar el registro correspondiente.

### 7.2 Errores visibles para el usuario

La interfaz muestra “No pudimos cargar esta sección” con botón “Reintentar”. Los estados sin fuente muestran “Información no disponible”, “Dirección no disponible” o “No disponible”. No deben sustituirse por valores estimados.

### 7.3 Errores de contrato

Si `npm run contracts:verify` falla, detenga la actualización. Compruebe que el archivo de origen del contrato no cambió sin sincronización y que el consumidor usa la copia correcta. No edite manualmente los archivos `.sha256`.

---

## 8. Recomendaciones de seguridad

- Mantener `SERVICE_TOKEN`, `JWT_SECRET`, `JWT_REFRESH_SECRET`, `ADMIN_PASSWORD` y cualquier credencial solo en variables de entorno.
- No versionar `.env`; verificar que `.gitignore` lo excluye.
- Usar tokens y secretos de al menos 16 caracteres; la contraseña administrativa, al menos 8.
- Rotar secretos ante cambio de personal, exposición sospechosa o actualización de entorno.
- Mantener el backend en red privada, sin puerto público y sin CORS.
- Exponer CORS solo en la API, con un único `FRONTEND_ORIGIN` aprobado.
- No superar `RATE_LIMIT_MAX=120` en producción.
- Conservar Helmet, `x-powered-by` desactivado y el límite de cuerpo JSON de 8 kb.
- No publicar URLs, hashes o credenciales que no estén verificadas.
- No declarar cerrados PT-01, PT-02 ni la auditoría formal de accesibilidad sin evidencia explícita.

---

## 9. Procedimiento básico de recuperación

Ante fallo de arranque o de datos:

1. Detener los tres procesos y conservar los mensajes de error con su `requestId`.
2. Verificar que PostgreSQL y PostGIS están disponibles y que `DATABASE_URL` es correcta.
3. En el backend, ejecutar `npm run verify:data`.
4. Aplicar migraciones pendientes con `npm run migrate`.
5. Si los datos territoriales están inconsistentes, repetir `npm run etl` en una ventana controlada.
6. Verificar contratos en API y frontend con `npm run contracts:verify`.
7. Reiniciar backend, API y frontend en ese orden.
8. Repetir los health checks y una carga básica de la interfaz.
9. Ejecutar `npm run ci` en los tres repositorios y, si procede, `npm run test:acceptance`.
10. Registrar la causa, las acciones y los resultados. Si hubo pérdida de datos administrativos, escalar al responsable de infraestructura: no existe respaldo automático.

---

## 10. Pendientes operativos

- Definir e implementar respaldo y restauración de PostgreSQL.
- Definir el origen CORS definitivo de producción.
- Contratar o configurar alojamiento HTTPS y staging HTTPS.
- Definir agregación, rotación y retención de logs.
- Cerrar PT-01 y PT-02 con evidencia formal.
- Realizar la auditoría formal de accesibilidad.
- Ejecutar el despliegue y las verificaciones finales.

Consulte la [guía de despliegue](manual-despliegue.md) para la arquitectura propuesta y la [guía de pruebas](manual-pruebas.md) para la verificación posterior.
