# Resultados de Playwright — Fase 11.1

**Fecha:** 2026-11-15
**Proyecto:** `mi-barrio-frontend`
**Comando:** `npx playwright test --reporter=line`
**Navegador:** Chrome (`channel: chrome`)
**Servicios:** Vite 5173, API 3000, backend 3001, PostgreSQL/PostGIS 55432.
**Configuración local:** `RATE_LIMIT_MAX=600` en `mi-barrio-api/.env` para que la suite completa no choque con el límite de 120 solicitudes/min. El valor por defecto de la API sigue siendo 120.

## Resultado global

| Métrica | Valor |
|---|---:|
| Archivos de prueba ejecutados | 11 |
| Pruebas ejecutadas | 22 |
| Aprobadas | 22 |
| Fallidas | 0 |
| Omitidas | 0 |
| Duración aproximada | 35,0 s |

## Detalle por archivo

| Archivo | Pruebas | Resultado |
|---|---:|---|
| `tests/acceptance/ficha-mapa.spec.ts` | 2 | Aprobadas |
| `tests/acceptance/hu07.salud.spec.ts` | 2 | Aprobadas |
| `tests/acceptance/hu08.vias.spec.ts` | 2 | Aprobadas |
| `tests/acceptance/hu09.transporte.spec.ts` | 3 | Aprobadas |
| `tests/acceptance/hu10.demografia.spec.ts` | 2 | Aprobadas |
| `tests/acceptance/hu11.seguridad.spec.ts` | 3 | Aprobadas |
| `tests/acceptance/hu12.filtros.spec.ts` | 3 | Aprobadas |
| `tests/acceptance/hu13.acceso.spec.ts` | 2 | Aprobadas |
| `tests/acceptance/hu13.admin.spec.ts` | 1 | Aprobada |
| `tests/acceptance/hu13.validacion.spec.ts` | 1 | Aprobada |
| `tests/acceptance/places.spec.ts` | 1 | Aprobada |

## Pruebas de HU-07 a HU-13

1. `HU-07 · CA-HU07-01 y CA-HU07-02 listan nombre, tipo, dirección y distancia`
2. `HU-07 · CA-HU07-03 declara cercanía, ausencia dentro del polígono y distancia mínima`
3. `HU-08 · CA-HU08-01 dibuja la malla vial y declara su jerarquía disponible`
4. `HU-08 · CA-HU08-02 y CA-HU08-03 resaltan accesos y no presentan rutas inventadas`
5. `HU-09 · CA-HU09-01 lista paraderos con nombre, ubicación y distancia`
6. `HU-09 · CA-HU09-02 identifica la estación y el portal más cercanos`
7. `HU-09 · CA-HU09-03 selecciona un elemento y no publica rutas, horarios ni frecuencias`
8. `HU-10 · CA-HU10-01 y CA-HU10-02 separan barrio y UPZ con año y fuente`
9. `HU-10 · CA-HU10-03 no prorratea edad ni sexo de la UPZ al barrio`
10. `HU-11 · CA-HU11-01 muestra CAI, cuadrante, teléfono y UPZ`
11. `HU-11 · CA-HU11-02 etiqueta los delitos como Localidad de Kennedy (08)`
12. `HU-11 · CA-HU11-03 muestra capas ambientales con fuente y escala`
13. `HU-12 · CA-HU12-01 y CA-HU12-03 filtro simple consistente entre contador, lista y mapa`
14. `HU-12 · CA-HU12-02 y CA-HU12-04 combinan categorías y restablecen todos los lugares`
15. `HU-12 · CA-HU12-03 estado vacío y error de carga visibles`
16. `HU-13 · CA-HU13-01 rechaza acceso sin token y no expone datos de gestión`
17. `HU-13 · rechaza credenciales incorrectas sin iniciar sesión`
18. `HU-13 · CA-HU13-02 y CA-HU13-04 persisten, publican, despublican y auditan`
19. `HU-13 · CA-HU13-03 rechaza campos incompletos y coordenadas fuera del área`

## Verificaciones de API incluidas en Playwright

- `GET /api/v1/admin/lugares` sin token → **401**.
- `GET /api/v1/admin/lugares` con token inválido → **401**.
- `POST /api/v1/auth/login` con contraseña incorrecta → **401**.
- `POST /api/v1/admin/lugares` con nombre vacío → **400** `DATOS_INVALIDOS` con mención del campo `nombre`.
- `POST /api/v1/admin/lugares` con coordenadas 0,0 → **400** `COORDENADAS_FUERA_AREA`.
- Lugar creado → aparece en `GET /api/v1/lugares?q=...` con `publicado: true`.
- Lugar despublicado → deja de aparecer en la API pública.
- `GET /api/v1/admin/auditoria` → contiene las acciones `crear` y `editar` del usuario administrador.

## Nota sobre mocks

No se usaron mocks para los recorridos funcionales. Solo el caso de estado de error de HU-12 intercepta la petición de lugares para simular un fallo de red/500 y comprobar que la interfaz muestra `ErrorPanel`; no sustituye ninguna verificación de integración.
