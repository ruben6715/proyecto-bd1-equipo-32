1. Definición y objetivo

La seguridad en SQL Server controla quién puede acceder a la base y qué operaciones puede hacer. Se administra con logins (nivel servidor), usuarios (nivel base de datos), permisos (GRANT, DENY, REVOKE) y roles (grupos de permisos reutilizables). El objetivo es aplicar el principio de mínimo privilegio: cada perfil accede solo a lo que necesita.

2. Ventajas y aplicaciones
Protege datos sensibles. En FarmaBlue: límite de crédito, habilitaciones sanitarias, CUIT.
Evita modificaciones accidentales o no autorizadas, por ejemplo cambiar precios de medicamentos.
Permite asignar responsabilidades por perfil: administrador, vendedor, consulta.
Simplifica la administración: se asignan permisos al rol una sola vez y se suman usuarios.
Permite exponer operaciones controladas mediante procedimientos almacenados, sin dar acceso directo a las tablas.
3. Implementación en SQL Server Express
Elemento	Sentencia
Login	CREATE LOGIN ... WITH PASSWORD
Usuario	CREATE USER ... FOR LOGIN
Rol	CREATE ROLE / ALTER ROLE ... ADD MEMBER
Permiso	GRANT SELECT/EXECUTE ON ... TO ...
Denegar	DENY SELECT (columna) ON tabla TO ...

Para conectarte con los logins desde SSMS, la instancia debe tener autenticación mixta. El script prueba todo con EXECUTE AS USER, así que no hace falta reconectarse.

4. Caso aplicado a FarmaBlue
usuario_admin: miembro de db_owner.
usuario_lector: solo SELECT sobre venta y EXECUTE sobre sp_RegistrarVentaSimple.
rol_consulta_productos: SELECT sobre Producto. Lo tiene usuario_con_rol, pero no usuario_sin_rol.
rol_vendedor (caso propio): ve clientes, productos y lotes, y registra ventas con el SP. Tiene DENY sobre las columnas limite_credito y matricula_habilitacion_sanitaria, y no puede modificar precios.



