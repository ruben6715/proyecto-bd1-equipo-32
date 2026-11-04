USE FarmaBlue;
GO

--CREACIÓN DE LA TABLA auditoría_producto para mostrar todos los datos si hay algún cambio:
CREATE TABLE auditoria_producto (
    id_auditoria      INT IDENTITY(1,1) NOT NULL,
    fecha_hora        DATETIME      NOT NULL DEFAULT GETDATE(),
    usuario           VARCHAR(128)  NOT NULL DEFAULT SUSER_SNAME(),
    id_producto       INT           NOT NULL,
    nombre_comercial  VARCHAR(150)  NOT NULL,
    precio_anterior   DECIMAL(10,2) NULL,
    precio_nuevo      DECIMAL(10,2) NULL,
    operacion         VARCHAR(10)   NOT NULL,
    CONSTRAINT pk_auditoria_producto PRIMARY KEY (id_auditoria)
);
GO

--CREACIÓN DEL TRIGGER:

IF OBJECT_ID('dbo.trg_auditoria_producto', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_auditoria_producto;
GO

CREATE TRIGGER dbo.trg_auditoria_producto
ON Producto
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT: existe en inserted pero no en deleted
    INSERT INTO auditoria_producto (id_producto, nombre_comercial, precio_anterior, precio_nuevo, operacion)
    SELECT i.id_producto, i.nombre_comercial, NULL, i.precio_unidad_actual, 'INSERT'
    FROM inserted i
    WHERE NOT EXISTS (SELECT 1 FROM deleted d WHERE d.id_producto = i.id_producto);

    -- UPDATE: existe en ambas y cambió el precio
    INSERT INTO auditoria_producto (id_producto, nombre_comercial, precio_anterior, precio_nuevo, operacion)
    SELECT i.id_producto, i.nombre_comercial, d.precio_unidad_actual, i.precio_unidad_actual, 'UPDATE'
    FROM inserted i
    JOIN deleted d ON d.id_producto = i.id_producto
    WHERE d.precio_unidad_actual <> i.precio_unidad_actual;

    -- DELETE: existe en deleted pero no en inserted
    INSERT INTO auditoria_producto (id_producto, nombre_comercial, precio_anterior, precio_nuevo, operacion)
    SELECT d.id_producto, d.nombre_comercial, d.precio_unidad_actual, NULL, 'DELETE'
    FROM deleted d
    WHERE NOT EXISTS (SELECT 1 FROM inserted i WHERE i.id_producto = d.id_producto);
END;
GO
