# Decisiones y limitaciones — Fase 11.2

**Fecha:** 2026-11-16  
**Fase:** 11.2 — resolución de brechas y cierre de validación funcional.

## Decisiones tomadas en Fase 11.2

1. **HU-07:** La falta de dirección en una farmacia se trató como defecto de mapper ETL, no como ausencia definitiva de fuente. Se corrigió el mapeo y se validó con F-05.
2. **HU-09:** El código SITP faltante se trató como omisión del mapper ETL, no como imposibilidad de fuente. Se corrigió el mapeo y se validó con F-15.
3. **HU-10:** La falta de quinquenios se resolvio incorporando la extracción de F-03; no se inventaron datos ni se prorrateó por barrio.
4. **HU-13:** La administración de categorías se consideró dentro del alcance funcional al encuadrar el borrado protegido en AC-02/RF-13/RN-08; se implementó y validó.
5. **HU-08, HU-11, HU-12:** Se mantuvieron estados finales tras re-revisión y regresión final; al cumplir criterios con pruebas, evidencia y regresión verde, quedaron `Validada`.

## Limitaciones fuente y de alcance

- **HU-04:** Cobertura comercial parcial (OSM en bbox; IDT sin registros en entorno). No se declaró `Validada`.
- **HU-09:** El alcance quedó limitado a paraderos, estaciones y portales; no se publicaron rutas, horarios, frecuencias ni tiempos de llegada.
- **HU-10:** Los quinquenios corresponden al nivel UPZ; no se presentaron ni prorratearon como dato del barrio.
- **HU-11:** Los delitos se presentan por localidad 08 Kennedy, no por barrio; no se infieren por barrio.
- **HU-01 y HU-02:** Falta auditoría formal de accesibilidad y PT-01 formal; por tanto permanecen en `En pruebas`.

## Pendientes no resueltos en Fase 11.2

- Auditoría formal de accesibilidad.
- Prueba formal de rendimiento PT-01.
- Pruebas formales PT-02.
- Despliegue en staging con HTTPS.
- Ejecución remota de GitHub Actions.
- Publicación del repositorio.

## Estado final de la fase

Fase 11.2 cerró la resolución de brechas funcionales y de datos técnicamente posible, dejó documentadas las limitaciones fuente y dejó la validación funcional final en verde para las HUs finalizadas.
