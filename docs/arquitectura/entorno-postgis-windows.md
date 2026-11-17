# Entorno PostgreSQL 16 + PostGIS 3.7.0 en Windows

**Versión:** 1.0 · **Fecha:** 2026-11-15
**Estado:** entorno local verificado. Ajuste **específico de Windows**, no una receta portable.
**Alcance:** documentar el diagnóstico y la reproducibilidad del runtime local verificado como base técnica de la Fase 1. No describe código de la aplicación ni pruebas de historias.

---

## 1. Entorno verificado

| Componente | Versión / valor |
|------------|-----------------|
| Sistema | Windows, PostgreSQL portátil (binarios x64) |
| PostgreSQL | **16.13** (`Visual C++ build 1944, 64-bit`) |
| PostGIS | **3.7.0** |
| GEOS | **3.15.0-CAPI-1.21.0** |
| PROJ | **9.8.1**, `NETWORK_ENABLED=OFF` |
| Puerto local | `55432` |
| Base de datos | `mi_barrio` |
| Directorio de datos | `%TEMP%\opencode\pg16\data` (temporal) |
| Binarios | `%TEMP%\opencode\pg16\extract\pgsql` (temporal) |

El runtime es temporal y no se versiona. Los artefactos territoriales que sí se conservan están en [`../evidencias/fase-0/`](../evidencias/fase-0/).

---

## 2. Error exacto

Al ejecutar `CREATE EXTENSION postgis`:

```text
could not load library C:/.../pg16/extract/pgsql/lib/postgis-3.dll:
The specified module could not be found.
```

Windows no indicó la dependencia faltante. El mensaje genérico corresponde al fallo de carga de `postgis-3.dll`, no a que el archivo no existiera.

---

## 3. Diagnóstico de dependencias

Cadena verificada con inspección PE:

```text
postgis-3.dll (pgsql\lib)
  -> libproj_9.dll (pgsql\bin)
    -> libcurl.dll (versión incluida en el bundle PostGIS)
      -> libnghttp2-14.dll   (faltante)
      -> libbrotlidec.dll    (faltante en pgsql\bin; presente en pgsql\bin\postgisgui)
```

| DLL | Estado inicial | Observación |
|-----|----------------|-------------|
| `libnghttp2-14.dll` | Ausente | No venía en el bundle |
| `libbrotlidec.dll` | Ausente en `pgsql\bin` | Presente en `pgsql\bin\postgisgui` |
| `libbrotlicommon.dll` | Ausente en `pgsql\bin` | Presente en `pgsql\bin\postgisgui` |
| `libidn2-0.dll`, `libpsl-5.dll`, `libssh2-1.dll`, `libzstd.dll`, `zlib1.dll` | Presentes | No bloqueaban la carga |

El `libcurl.dll` del bundle importa `libnghttp2-14.dll` y `libbrotlidec.dll`; el `libcurl.dll` original de PostgreSQL 16 solo importa DLL del sistema.

---

## 4. Corrección aplicada

1. Se copiaron `libbrotlidec.dll` y `libbrotlicommon.dll` desde `pgsql\bin\postgisgui` a `pgsql\bin`.
2. Se sustituyó el `libcurl.dll` del bundle por el `libcurl.dll` original de PostgreSQL 16.

| DLL | Bytes | SHA-256 | Dependencias relevantes |
|-----|-------|---------|-------------------------|
| Bundle PostGIS | 953.344 | `AB26BEA91823E3D549AAE3DE5D5D81F3A3251F5B9F6904ECC8B1A7E0F06222F9` | `libnghttp2-14.dll`, `libbrotlidec.dll` |
| PostgreSQL 16 actual | 673.280 | `B5CCC9E0930366AAABCCE2AE728F4E6C79591DBA300547A0B7AB8325B9D9288E` | Solo DLL del sistema |

**Consecuencia:** este ajuste resuelve el entorno local, pero **no debe repetirse a ciegas** en otro equipo. Si se restaura el `libcurl.dll` del bundle, hay que aportar `libnghttp2-14.dll` y `libbrotlidec.dll` en `pgsql\bin`.

Para CI o contenedores se debe usar una imagen oficial de PostGIS compatible con PostgreSQL 16 y verificar que incluya PostGIS **3.7.0**; no se debe usar este runtime portátil como imagen de CI.

---

## 5. Comprobación de reproducibilidad

Se reinició el servicio y se repitieron las consultas. Los comandos usan `%TEMP%\opencode\pg16` como marcador; no se publican rutas de usuario.

### 5.1 Reinicio

```powershell
$pg = "$env:TEMP\opencode\pg16\extract\pgsql"
& "$pg\bin\pg_ctl.exe" -D "$env:TEMP\opencode\pg16\data" `
  restart -o "-p 55432" -l "$env:TEMP\opencode\pg16\pg.log" -w -t 30
```

Resultado:

```text
esperando que el servidor se detenga.... listo
servidor detenido
esperando que el servidor se inicie.... listo
servidor iniciado
exit_code=0
```

**Incidencia observada:** un primer `restart` sin `-w` devolvió `código de error 6`; el servidor se detuvo pero no arrancó. El log no registró un intento de arranque y no había `postmaster.pid` ni proceso escuchando. Se diagnosticó como carrera entre apagado y arranque (sin espera). No se cambió ninguna DLL ni configuración: se arrancó con `pg_ctl start` y después se repitió `restart` con `-w -t 30`, que completó correctamente.

### 5.2 Versiones

```sql
SELECT version();
SELECT postgis_full_version();
SELECT postgis_lib_version(), postgis_geos_version(), postgis_proj_version();
```

Resultados:

```text
PostgreSQL 16.13, compiled by Visual C++ build 1944, 64-bit

POSTGIS="3.7.0 3.7.0" [EXTENSION] PGSQL="160" GEOS="3.15.0-CAPI-1.21.0"
PROJ="9.8.1 NETWORK_ENABLED=OFF ..." LIBXML="2.12.5" LIBJSON="0.16"
LIBPROTOBUF="1.2.1" WAGYU="0.5.0 (Internal)"

postgis = 3.7.0
geos    = 3.15.0-CAPI-1.21.0
proj    = 9.8.1 NETWORK_ENABLED=OFF ...
```

### 5.3 Consultas espaciales básicas

```sql
SELECT ST_IsValid(ST_GeomFromText('POLYGON((0 0,0 1,1 1,1 0,0 0))',4326));
SELECT ST_Contains(
  ST_GeomFromText('POLYGON((0 0,0 2,2 2,2 0,0 0))',4326),
  ST_SetSRID(ST_MakePoint(1,1),4326)
);
SELECT ST_Distance(
  ST_SetSRID(ST_MakePoint(-74.171758,4.641833),4326)::geography,
  ST_SetSRID(ST_MakePoint(-74.171701,4.641641),4326)::geography
);
SELECT ST_AsText(ST_Transform(ST_SetSRID(ST_MakePoint(-74.171758,4.641833),4326),3116));
SELECT ST_AsGeoJSON(ST_SetSRID(ST_MakePoint(-74.171758,4.641833),4326));
```

Resultados:

| Consulta | Resultado |
|----------|-----------|
| `ST_IsValid` | `t` |
| `ST_Contains` | `t` |
| Distancia centroide nuevo vs. anterior | `22,15 m` |
| `ST_Transform(...,3116)` | `POINT(989542.3075158416 1005046.814534589)` |
| `ST_AsGeoJSON` | `{"type":"Point","coordinates":[-74.171758,4.641833]}` |

---

## 6. Limitaciones y decisiones del entorno

- **PROJ sin red:** `NETWORK_ENABLED=OFF`. Es suficiente para las transformaciones usadas (WGS84 ↔ EPSG:3116), pero no para transformaciones que requieran descargar rejillas. No se deben usar en este entorno transformaciones que dependan de red.
- **Ajuste no portable:** la sustitución de `libcurl.dll` es una decisión del entorno Windows. No se debe documentar como paso automático del proyecto ni copiar a Linux/CI.
- **Archivos temporales:** el runtime y los binarios viven en `%TEMP%` y no se versionan. Los GeoJSON verificados sí se conservan en `docs/evidencias/fase-0/`.
- **Sin secretos:** no se registran contraseñas, tokens ni rutas de usuario. La conexión local usa autenticación `trust` solo en el entorno temporal; no es una configuración de producción.

---

## 7. Evidencia y estado

- Comandos y resultados de esta comprobación: este documento.
- Artefactos territoriales y hashes: [`../evidencias/fase-0/README.md`](../evidencias/fase-0/README.md).
- Fuentes y método de estratificación: [`../investigacion/fuentes-territoriales.md`](../investigacion/fuentes-territoriales.md) §6.1 y §12.
- **Ninguna HU se marca implementada o validada** por esta comprobación.
