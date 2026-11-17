# Evidencias de la fase 0 — base territorial y entorno PostGIS

**Fecha:** 2026-11-15
**Estado:** evidencia documental. No implica implementación de historias, pruebas de aplicación ni cierre de fase.

Esta carpeta conserva los artefactos verificables que sirven de base para la Fase 1. Los archivos temporales de consulta no se versionan; los artefactos oficiales filtrados sí.

---

## 1. Artefactos conservados

| Archivo | Contenido | Origen | Tamaño | SHA-256 |
|---------|-----------|--------|--------|---------|
| `barrio-ciudad-granada.geojson` | Polígono oficial WGS84, 1 feature, 58 vértices, anillo cerrado | F-01: SDP/UAECD, servicio REST `ordenamientoterritorial/barrioslegalizados/MapServer/0`, `outSR=4326&f=geojson` | 20.998 bytes | `1CDD6D0A63E3AD38393EB8FB37CBF7E2CAD1AD507D97CC2EDCBE2E8CCD5B0F6E` |
| `estrato-ciudad-granada.geojson` | 34 manzanas con centroide dentro del polígono, todas `ESTRATO=2` | F-02: SDP/UAECD, capa `ordenamientoterritorial/estratificacion/MapServer/1`, filtrada | 98.550 bytes | `175E3BA4BAD361863B1731669AD7A9E1EFD7F2B531FA950EE170D5D8619591E9` |

**Datos del polígono oficial (F-01):** `NOMBRE=URBANIZACION CIUDAD GRANADA`, `LLAVE_PLANO=080394B001`, `AREA_TOTAL=9.1` ha, `LOTES_TOTAL=705`, `POBLACION_ESTIMADA=3807`, `CODIGO_UPZ=82`, `CODIGO_LOCALIDAD=08`. El campo `CODIGO_ID` viene vacío en el servicio REST; `LEG00645` se obtiene del archivo descargable del dataset. No se usa el código postal 110881 como límite.

**Datos de estratificación (F-02):** la consulta por bbox devolvió **802 polígonos**; se conservaron solo los **34** cuyo centroide cae dentro del polígono oficial. Las 34 tienen `ESTRATO=2`. Los campos de la capa son `OBJECTID`, `CODIGO_MANZANA`, `ESTRATO` y `CODIGO_ZONA_ESTRATO`.

---

## 2. Archivos temporales (no versionados)

| Archivo temporal | Tamaño | SHA-256 | Por qué no se versiona |
|------------------|--------|---------|------------------------|
| `%TEMP%\opencode\estrato_bbox.geojson` | 1.342.687 bytes | `23871D893F8B9C2CABD65562BD7816E578C414391FEC4C7CD52E79C36C42BDA2` | Es la ventana rectangular completa (802 entidades), no el recorte del barrio; se conserva solo el filtro de 34 |
| `%TEMP%\opencode\barriolegalizado.json` | 8.179.729 bytes | `9F49AA65545A834C1E3F6CD8E675A98E22F17E6FF9FAD768F71B4BF9B569CA38` | Dataset oficial completo (1.775 features); se referencia por URL y el recorte se conserva en el repositorio |
| `%TEMP%\opencode\pg16\` | — | — | Runtime portátil de PostgreSQL/PostGIS específico de Windows; no es un artefacto del proyecto |

Los archivos temporales se pueden regenerar con las consultas de la sección 3. No contienen datos personales; solo geometrías y atributos oficiales.

---

## 3. Reproducción

### 3.1 Polígono oficial

```powershell
$svc = "https://serviciosgis.catastrobogota.gov.co/arcgis/rest/services/ordenamientoterritorial/barrioslegalizados/MapServer/0/query"
$where = "NOMBRE='URBANIZACION CIUDAD GRANADA'"
$url = "$svc?where=$([uri]::EscapeDataString($where))&outFields=*&outSR=4326&f=geojson&returnGeometry=true"
curl.exe -s $url -o "$env:TEMP\opencode\barrio.geojson"
```

### 3.2 Estratificación por manzana

```powershell
$svc = "https://serviciosgis.catastrobogota.gov.co/arcgis/rest/services/ordenamientoterritorial/estratificacion/MapServer/1/query"
$bbox = "-74.179791,4.633412,-74.163695,4.650294"
$fields = "OBJECTID,CODIGO_MANZANA,ESTRATO,CODIGO_ZONA_ESTRATO"
$url = "$svc?where=1%3D1&geometry=$bbox&geometryType=esriGeometryEnvelope&inSR=4326&spatialRel=esriSpatialRelIntersects&outFields=$fields&outSR=4326&f=geojson&returnGeometry=true"
curl.exe -s $url -o "$env:TEMP\opencode\estrato_bbox.geojson"
```

El filtro por centroide está en `filtrar_estrato.py`. Requiere Python 3 y `shapely`:

```powershell
python filtrar_estrato.py `
  "barrio-ciudad-granada.geojson" `
  "$env:TEMP\opencode\estrato_bbox.geojson" `
  "estrato-ciudad-granada.geojson"
```

**Resultado esperado:** `total_bbox=802`, `total_dentro=34`, todos con `ESTRATO=2`. El script conserva esa metadata en el archivo de salida.

**Comprobación ejecutada (2026-11-15):** salida `bbox=802 dentro=34`; SHA-256 reproducido `175E3BA4BAD361863B1731669AD7A9E1EFD7F2B531FA950EE170D5D8619591E9`, idéntico al artefacto conservado (`coincide=True`); conteo de estratos `{2: 34}`. Esto valida que el filtro es reproducible con los archivos de entrada indicados.

---

## 4. Relación con la documentación

- Método y cifras territoriales: [`../../investigacion/fuentes-territoriales.md`](../../investigacion/fuentes-territoriales.md) §6.1 y §12.
- Entorno PostgreSQL/PostGIS en Windows: [`../../arquitectura/entorno-postgis-windows.md`](../../arquitectura/entorno-postgis-windows.md).
- Trazabilidad: [`../../requerimientos/matriz-trazabilidad.md`](../../requerimientos/matriz-trazabilidad.md). Ninguna HU se marca implementada por estos artefactos.
