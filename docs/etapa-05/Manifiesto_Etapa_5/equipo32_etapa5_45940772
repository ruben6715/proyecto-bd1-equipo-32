Contribución individual -- Etapa V

Equipo: [32]
Integrante: [Ariel Gomez]
Fecha: 2026-11-03

1. Aporte realizado
Desarrollé el tema técnico 4 de la guía de la Etapa V: Seguridad (permisos a nivel de usuarios y roles en SQL Server).
Redacté la parte teórica: definición y objetivo, ventajas y aplicaciones, e implementación en SQL Server Express.
Adapté el caso de ejemplo de la guía a la base FarmaBlue y armé el script de demostración FarmaBlue_Seguridad_Simple.sql, que incluye:
El procedimiento almacenado sp_RegistrarVentaSimple sobre la tabla venta.
Logins y usuarios (usuario_admin, usuario_lector, usuario_con_rol, usuario_sin_rol, usuario_vendedor).
Roles rol_consulta_productos y rol_vendedor.
7 pruebas con resultado esperado (permitido o denegado) y un bloque de limpieza para repetir la demostración.
2. Decisiones en las que participé
Definir tres perfiles según el dominio de FarmaBlue: administrador, lector y vendedor, aplicando el principio de mínimo privilegio.
Proteger el dato sensible limite_credito de la tabla cliente, de modo que el rol vendedor pueda consultar clientes pero no ver el límite de crédito.
Que las ventas se registren a través del procedimiento almacenado y no con INSERT directo sobre la tabla, para mantener centralizada la regla de negocio (cálculo del 21% de impuesto, estado inicial “Pendiente”).
Usar EXECUTE AS USER en las pruebas, para demostrar los permisos sin tener que reconectarse con cada login.
3. Problemas o dificultades identificadas
El ejemplo de la guía usa una tabla Venta simplificada, mientras que venta de FarmaBlue tiene más columnas obligatorias (comprobante único, impuesto, total, método de pago, cliente).
Para conectarse con los logins desde SSMS, la instancia de SQL Server Express necesita autenticación mixta.
Diferenciar el error de permiso sobre una tabla (229) del error sobre una columna (230).
Al no tener limpieza automática, el script no se puede ejecutar dos veces seguidas sin errores por objetos ya existentes.
4. Soluciones o propuestas realizadas
Adapté el procedimiento para que reciba solo cliente, método de pago y subtotal, y calcule el resto (número de comprobante, impuesto, total y estado).
Usé EXECUTE AS USER en las pruebas, lo que además evita depender de la autenticación mixta para la demostración.
Documenté cada prueba con su resultado esperado, incluyendo el número de error, para que sirva de evidencia en el informe.
Incluí al final del script un bloque comentado de limpieza (borrado de usuarios, roles, logins, procedimiento y ventas de prueba) para poder repetir la demostración.
5. Evidencias en el repositorio
docs/etapa-05/seguridad/FarmaBlue_Seguridad_Simple.sql (ajustar a la ruta real)
docs/etapa-05/seguridad/informe-seguridad.md (si lo subís)
Issue: #[XX]
Pull Request: #[XX]
6. Reflexión individual
En esta etapa desarrollé la competencia de administrar la seguridad de una base de datos. Aprendí a distinguir logins (servidor) 
de usuarios (base de datos) y a asignar permisos con GRANT y DENY, tanto a usuarios como a roles. Entendí que DENY tiene prioridad sobre GRANT y
que se puede aplicar a una sola columna. También aprendí que un procedimiento almacenado permite que un usuario realice una operación autorizada sin tener permiso
directo sobre la tabla, gracias al encadenamiento de propiedad. Esto me mostró que la seguridad también forma parte del diseño del sistema, junto con las reglas de negocio.
