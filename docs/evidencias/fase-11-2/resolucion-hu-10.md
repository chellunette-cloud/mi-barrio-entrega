# Resolución HU-10 — Información demográfica

**Fase:** 11.2  
**Fecha:** 2026-11-16  
**Historia:** HU-10  
**Criterios:** CA-HU10-01, CA-HU10-02, CA-HU10-03

## Brecha identificada en Fase 11.1

CA-HU10-02 se registró como **parcial**: el ETL de F-03 publicaba la población, el estrato y la distribución por sexo, pero no los quinquenios de edad por UPZ.

CA-HU10-01 y CA-HU10-03 ya estaban aprobados.

## Corrección aplicada en Fase 11.2

Se implementó la extracción de F-03:

- `scripts/extract-poblacion_upz.py`
- `data/source/poblacion-upz-082-2025.json`
- Carga en `StaticStatsRepository`.
- Visualización de quinquenios en `DemografiaPanel`.

## Resultado del ETL

- F-03 extrajo los quinquenios de edad por UPZ.
- Los paneles se mantuvieron separados: barrio con estimación de 3.807 habitantes y UPZ 082 con proyección de 133.130 habitantes en 2025.

## Verificación final

- Playwright HU-10 ejecutado en la suite final: **2/2 aprobadas**.
- CA-HU10-01, CA-HU10-02 y CA-HU10-03 quedaron **aprobados**.
- No se prorrateó la distribución por edad/sexo del UPZ al barrio.

## Estado final

HU-10 quedó **Validada** en Fase 11.2, porque la brecha técnica fue resuelta y la prueba de aceptación final pasó sin inventar datos.
