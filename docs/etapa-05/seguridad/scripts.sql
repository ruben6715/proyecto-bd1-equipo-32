-- ============================================================
-- ETAPA V - TEMA 4: SEGURIDAD (usuarios y roles) - FarmaBlue
-- Ejecutar como administrador (sysadmin)
-- ============================================================

USE FarmaBlue;
GO

-- ------------------------------------------------------------
-- PROCEDIMIENTO: registra una venta simple
-- ------------------------------------------------------------
CREATE PROCEDURE dbo.sp_RegistrarVentaSimple
    @Codigo_Cliente INT,
    @id_metodoPago  INT,
    @subtotal       DECIMAL(10,2)
AS
BEGIN
    DECLARE @nro      INT = (SELECT MAX(numero_comprobante) FROM venta) + 1;
    DECLARE @impuesto DECIMAL(10,2) = @subtotal * 0.21;

    INSERT INTO venta (numero_comprobante, monto_subtotal, monto_Impuesto,
                       monto_total, estado_venta, id_metodoPago, Codigo_Cliente)
    VALUES (@nro, @subtotal, @impuesto, @subtotal + @impuesto,
            'Pendiente', @id_metodoPago, @Codigo_Cliente);
END;
GO

-- ============================================================
-- PARTE 1: PERMISOS A NIVEL DE USUARIOS
-- ============================================================

-- Logins (servidor)
CREATE LOGIN usuario_admin  WITH PASSWORD = 'Admin#2026', CHECK_POLICY = OFF;
CREATE LOGIN usuario_lector WITH PASSWORD = 'Lector#2026', CHECK_POLICY = OFF;
GO

-- Usuarios (base de datos)
CREATE USER usuario_admin  FOR LOGIN usuario_admin;
CREATE USER usuario_lector FOR LOGIN usuario_lector;
GO

-- Permisos
ALTER ROLE db_owner ADD MEMBER usuario_admin;                    -- administrador
GRANT SELECT  ON dbo.venta TO usuario_lector;                    -- solo lectura
GRANT EXECUTE ON dbo.sp_RegistrarVentaSimple TO usuario_lector;  -- puede usar el SP
GO

-- Prueba 1: INSERT directo con admin (CORRECTO)
EXECUTE AS USER = 'usuario_admin';
INSERT INTO venta (numero_comprobante, monto_subtotal, monto_Impuesto,
                   monto_total, estado_venta, id_metodoPago, Codigo_Cliente)
VALUES (9001, 15000, 3150, 18150, 'Pendiente', 3, 1);
REVERT;
GO

-- Prueba 2: INSERT directo con lector (ACCESO DENEGADO)
EXECUTE AS USER = 'usuario_lector';
INSERT INTO venta (numero_comprobante, monto_subtotal, monto_Impuesto,
                   monto_total, estado_venta, id_metodoPago, Codigo_Cliente)
VALUES (9002, 15000, 3150, 18150, 'Pendiente', 3, 1);
REVERT;
GO

-- Prueba 3: lector usa el procedimiento (CORRECTO)
EXECUTE AS USER = 'usuario_lector';
EXEC dbo.sp_RegistrarVentaSimple @Codigo_Cliente = 1, @id_metodoPago = 3, @subtotal = 15000;
REVERT;
GO

-- Ver la venta registrada
SELECT TOP 3 numero_comprobante, monto_subtotal, monto_total, estado_venta
FROM venta ORDER BY id_venta DESC;
GO

-- ============================================================
-- PARTE 2: PERMISOS A NIVEL DE ROLES
-- ============================================================

CREATE LOGIN usuario_con_rol WITH PASSWORD = 'ConRol#2026', CHECK_POLICY = OFF;
CREATE LOGIN usuario_sin_rol WITH PASSWORD = 'SinRol#2026', CHECK_POLICY = OFF;
GO

CREATE USER usuario_con_rol FOR LOGIN usuario_con_rol;
CREATE USER usuario_sin_rol FOR LOGIN usuario_sin_rol;
GO

-- Rol para consultar productos
CREATE ROLE rol_consulta_productos;
GRANT SELECT ON dbo.Producto TO rol_consulta_productos;
ALTER ROLE rol_consulta_productos ADD MEMBER usuario_con_rol;
GO

-- Prueba 4: usuario con rol (CORRECTO)
EXECUTE AS USER = 'usuario_con_rol';
SELECT TOP 5 nombre_comercial, precio_unidad_actual FROM Producto;
REVERT;
GO

-- Prueba 5: usuario sin rol (ACCESO DENEGADO)
EXECUTE AS USER = 'usuario_sin_rol';
SELECT TOP 5 nombre_comercial, precio_unidad_actual FROM Producto;
REVERT;
GO

-- ============================================================
-- PARTE 3: CASO FARMABLUE - ROL VENDEDOR
-- Ve clientes pero NO el límite de crédito
-- ============================================================

CREATE LOGIN usuario_vendedor WITH PASSWORD = 'Vend#2026', CHECK_POLICY = OFF;
GO
CREATE USER usuario_vendedor FOR LOGIN usuario_vendedor;
CREATE ROLE rol_vendedor;
GO

GRANT SELECT ON dbo.cliente TO rol_vendedor;
DENY  SELECT (limite_credito) ON dbo.cliente TO rol_vendedor;   -- columna protegida
ALTER ROLE rol_vendedor ADD MEMBER usuario_vendedor;
GO

-- Prueba 6: columnas permitidas (CORRECTO)
EXECUTE AS USER = 'usuario_vendedor';
SELECT Razon_social, telefono, correo FROM cliente;
REVERT;
GO

-- Prueba 7: columna denegada (ACCESO DENEGADO)
EXECUTE AS USER = 'usuario_vendedor';
SELECT Razon_social, limite_credito FROM cliente;
REVERT;
GO


DELETE FROM venta WHERE numero_comprobante >= 1011;

ALTER ROLE db_owner DROP MEMBER usuario_admin;
ALTER ROLE rol_consulta_productos DROP MEMBER usuario_con_rol;
ALTER ROLE rol_vendedor DROP MEMBER usuario_vendedor;
DROP ROLE rol_consulta_productos;
DROP ROLE rol_vendedor;
DROP USER usuario_admin, usuario_lector, usuario_con_rol, usuario_sin_rol, usuario_vendedor;
DROP PROCEDURE dbo.sp_RegistrarVentaSimple;
USE master;
DROP LOGIN usuario_admin;  DROP LOGIN usuario_lector;
DROP LOGIN usuario_con_rol; DROP LOGIN usuario_sin_rol;
DROP LOGIN usuario_vendedor;
*/
