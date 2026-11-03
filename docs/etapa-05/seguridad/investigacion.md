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

¿Qué es la seguridad en una base de datos?

Es el conjunto de mecanismos que controlan quién puede entrar a la base y qué puede hacer dentro de ella. En FarmaBlue, que maneja datos de farmacias, clínicas, medicamentos y ventas, esto es clave: no todas las personas de la empresa deberían ver o modificar lo mismo.

SQL Server permite administrar los permisos de dos maneras:

Por usuario (individual): se le da permiso directamente a una persona. Por ejemplo, usuario_lector recibe SELECT sobre la tabla venta y EXECUTE sobre sp_RegistrarVentaSimple.
Por rol (grupal): se crea un grupo con ciertos permisos y se agregan usuarios. Por ejemplo, rol_vendedor puede consultar cliente y Producto, y todos los vendedores que se sumen heredan esos permisos.

Con ambas formas se aplica el principio de mínimo privilegio: cada usuario recibe solo los permisos que necesita para su trabajo. Un vendedor no necesita modificar precios ni ver el límite de crédito de los clientes, así que no los tiene.

¿Por qué utilizar permisos y roles?
Protegen la información sensible. En FarmaBlue, datos como limite_credito, CUIT y matricula_habilitacion_sanitaria de los clientes son confidenciales. Con DENY SELECT (limite_credito) el vendedor no puede verlos aunque tenga acceso al resto de la tabla cliente.
Evitan modificaciones accidentales o no autorizadas. Si un vendedor intenta hacer UPDATE sobre precio_unidad_actual de Producto, SQL Server lo rechaza. Así se evita alterar por error el precio de un medicamento o el stock de un lote. Lo mismo pasa con usuario_lector, que no puede hacer INSERT directo en venta.
Permiten asignar responsabilidades según el perfil. El administrador (usuario_admin, en db_owner) controla todo, el vendedor registra ventas y consulta clientes, y el usuario de consulta solo ve el catálogo de productos. Cada perfil tiene su alcance.
Simplifican la administración de accesos mediante roles reutilizables. Si entran cinco vendedores nuevos, no hay que dar permisos uno por uno: se los agrega a rol_vendedor con ALTER ROLE ... ADD MEMBER. Si cambia una regla, se modifica el rol y el cambio alcanza a todos sus miembros.
Mejoran la seguridad y mantenibilidad de la base de datos. Los permisos quedan ordenados y documentados en roles, y los usuarios operan a través de procedimientos almacenados como sp_RegistrarVentaSimple. Eso mantiene centralizadas las reglas de negocio (cálculo de impuesto, estado de la venta) sin dar acceso directo a las tablas.
