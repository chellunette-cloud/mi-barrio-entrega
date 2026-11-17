# Riesgos y limitaciones

1. Las vulnerabilidades actuales se encuentran en dependencias de desarrollo y requieren actualizaciones major.
2. PT-01 no fue ejecutado con una herramienta dedicada de carga.
3. La auditoría formal de accesibilidad manual no se realizó; Lighthouse reporta 100/100.
4. No existe staging HTTPS por falta de infraestructura y credenciales.
5. Los repositorios no tienen remoto configurado.
6. No se crearon manuales técnico ni de usuario.
7. HU-01 y HU-02 permanecen en `En pruebas`.
8. HU-03 a HU-13 permanecen en `En desarrollo`.
9. Ninguna historia está marcada como `Validada`.
10. El administrador inicial requiere configuración mediante variables de entorno.
11. Algunas fuentes tienen cobertura parcial, especialmente comercio.

Acciones que requieren intervención humana:
- Proveedor de hosting.
- Dominio y certificado TLS.
- Credenciales de despliegue.
- Autorización para publicar repositorios.
- Aprobación para actualizar dependencias major.