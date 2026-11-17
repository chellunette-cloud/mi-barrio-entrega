# Resolución HU-07 — Servicios de salud

**Fase:** 11.2  
**Fecha:** 2026-11-16  
**Historia:** HU-07  
**Criterios:** CA-HU07-01, CA-HU07-02, CA-HU07-03

## Brecha identificada en Fase 11.1

CA-HU07-01 se registró como **parcial**: el listado de servicios de salud mostraba nombre, tipo y distancia, pero una farmacia no tenía dirección, por lo que la interfaz mostraba «Dirección no disponible».

La investigación de Fuentes (F-05) indicó que la fuente oficial de salud contenía campos de dirección (`DIRECCIÓN`, `DIRECCION`, `DIRECCIONC`), pero el mapper ETL no los estaba consumiendo correctamente.

## Corrección aplicada en Fase 11.2

Se corrigió el mapper de salud:

- `mi-barrio-backend/src/infrastructure/etl/healthMapper.ts`
- Se leyeron nombres y tipos desde `NOMBRE_DEL`, `NOMBRE` y `RAZONSOCIA`.
- Si `RAZONSOCIA` estaba vacía o numérica, se usó `${TIPOESTABL} sin razón social`.
- Se leyeron direcciones desde `DIRECCIÓN`, `DIRECCION` y `DIRECCIONC`.
- Se deduplicó por `OBJECTID`.

## Resultado del ETL

Tras la recarga:

- `salud`: 148 registros procesados.
- `salud sinDireccion`: 0.
- Farmacia con dirección encontrada: `TV 21A 20 30 SUR`.
- Place relacionado: `id: 741`.
- Nombre: `DROGUERÍA sin razón social`.
- Tipo: `farmacia`.
- Fuente principal: `F-05`.

## Verificación final

- Playwright HU-07 ejecutado en la suite final: **2/2 aprobadas**.
- La interfaz ya no muestra «Dirección no disponible».
- El detalle de la farmacia muestra dirección, distancia y fuente.
- No se inventó una dirección.

## Estado final

HU-07 quedó **Validada** en Fase 11.2, porque la brecha técnica fue resuelta, la fuente fue verificada y la prueba de aceptación final pasó.
