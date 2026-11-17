# Análisis de cambios en contratos — Fase 10.1

## Cambio exacto

Backend `contracts/internal.openapi.yaml`:

```diff
- sector: { type: string, nullable: true, enum: [oficial, privado, 'no informado'] }
+ sector: { type: string, nullable: true, enum: [oficial, privado, 'no informado', null] }
```

API sincronizó la misma modificación en `contracts/internal.openapi.yaml` y actualizó `contracts/internal.openapi.sha256`.

## Motivo

El backend devuelve `sector: null` para parques, comercio, salud y transporte. La API valida respuestas internas con Ajv. El esquema OpenAPI declaraba `nullable: true`, pero el `enum` no incluía `null`, por lo que Ajv rechazaba la respuesta con `data/sector must be equal to one of the allowed values`.

El error se manifestó como `CONTRATO_INTERNO_INVALIDO` en endpoints que devolvían lugares con `sector: null`.

## Compatibilidad

- Backend y API tienen el mismo cambio.
- El contrato público no declara `enum` para `sector`; solo `nullable: true`, por lo que no requirió cambio.
- El frontend no declara `enum` para `sector`; solo `nullable: true`.
- La generación de tipos se ejecutó correctamente en API y frontend.

## Decisión

El cambio es **correcto y compatible**. Se conserva porque permite representar la ausencia de sector sin inventar datos.