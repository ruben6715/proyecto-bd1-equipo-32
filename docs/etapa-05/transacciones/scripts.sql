USE FarmaBlue;
GO

-- Declaración de variables
DECLARE @id_lote_objetivo INT = 1;          
DECLARE @cantidad_a_comprar INT = 5;        
DECLARE @codigo_cliente_venta INT = 1;      
DECLARE @id_metodo_pago_venta INT = 1;      

-- Generamos un número de comprobante único automáticamente (el último + 1)
DECLARE @nro_comprobante INT;
SELECT @nro_comprobante = ISNULL(MAX(numero_comprobante), 1000) + 1 FROM venta;

-- Variables auxiliares de control
DECLARE @stock_actual INT;
DECLARE @precio_actual DECIMAL(10,2);

BEGIN TRANSACTION;

-- 1. Consultar el stock disponible y el precio actual del producto a través de su lote
SELECT 
    @stock_actual = l.stock_disponible,
    @precio_actual = p.precio_unidad_actual
FROM lote l
INNER JOIN Producto p ON l.id_producto = p.id_producto
WHERE l.id_lote = @id_lote_objetivo;

-- 2. Validar si existe stock suficiente en el lote
IF @stock_actual < @cantidad_a_comprar
BEGIN
    PRINT 'Error: Stock insuficiente en el lote. Ejecutando ROLLBACK: No se registra la venta ni se modifica el stock.';
    ROLLBACK TRANSACTION;
END
ELSE
BEGIN
    DECLARE @subtotal DECIMAL(10,2) = @cantidad_a_comprar * @precio_actual;
    DECLARE @descuento DECIMAL(10,2) = 0.00;
    DECLARE @impuesto DECIMAL(10,2) = @subtotal * 0.21; 
    DECLARE @total DECIMAL(10,2) = @subtotal - @descuento + @impuesto;

    -- A. Crear la venta (Cabecera)
    INSERT INTO venta (
        numero_comprobante, 
        fecha_Hora, 
        monto_subtotal, 
        monto_Descuento, 
        monto_Impuesto, 
        monto_total, 
        estado_venta, 
        id_metodoPago, 
        Codigo_Cliente
    ) 
    VALUES (
        @nro_comprobante, 
        GETDATE(), 
        @subtotal, 
        @descuento, 
        @impuesto, 
        @total, 
        'Entregado', 
        @id_metodo_pago_venta, 
        @codigo_cliente_venta
    );

    -- Obtenemos el ID de la venta recién insertada de manera automática
    DECLARE @id_venta_generada INT = SCOPE_IDENTITY();

    -- B. Crear el detalle de la venta
    INSERT INTO detalle_venta (
        cantidad, 
        precio_unitario_historico, 
        id_lote, 
        id_venta
    ) 
    VALUES (
        @cantidad_a_comprar, 
        @precio_actual, 
        @id_lote_objetivo, 
        @id_venta_generada
    );

    -- C. Descontar el stock disponible del lote correspondiente
    UPDATE lote 
    SET stock_disponible = stock_disponible - @cantidad_a_comprar 
    WHERE id_lote = @id_lote_objetivo;

    -- Confirmamos la transacción
    COMMIT TRANSACTION;
    PRINT 'Éxito: Venta registrada, detalle creado y stock actualizado correctamente.';
END
GO


========================================================================
                        CASO INCORRECTO    
=======================================================================

USE FarmaBlue;
GO

-- Variables para simular el caso INCORRECTO
DECLARE @id_lote_objetivo INT = 1;          -- El mismo lote 1
DECLARE @cantidad_a_comprar INT = 999999;   -- Cantidad imposible (mayor al stock)
DECLARE @codigo_cliente_venta INT = 1;      
DECLARE @id_metodo_pago_venta INT = 1;      
DECLARE @nro_comprobante INT = 2002;        

DECLARE @stock_actual INT;
DECLARE @precio_actual DECIMAL(10,2);

BEGIN TRANSACTION;

-- Consultamos el stock actual del lote
SELECT 
    @stock_actual = l.stock_disponible,
    @precio_actual = p.precio_unidad_actual
FROM lote l
INNER JOIN Producto p ON l.id_producto = p.id_producto
WHERE l.id_lote = @id_lote_objetivo;

-- Validamos
IF @stock_actual < @cantidad_a_comprar
BEGIN
    -- Como no hay stock, cancelamos todo de forma atómica
    PRINT 'PRUEBA INCORRECTA: Stock insuficiente. Se ejecuta ROLLBACK y no queda ningún registro parcial.';
    ROLLBACK TRANSACTION;
END
ELSE
BEGIN
    -- Este bloque no se ejecutará en este escenario
    DECLARE @subtotal DECIMAL(10,2) = @cantidad_a_comprar * @precio_actual;
    
    INSERT INTO venta (numero_comprobante, fecha_Hora, monto_subtotal, monto_Descuento, monto_Impuesto, monto_total, estado_venta, id_metodoPago, Codigo_Cliente) 
    VALUES (@nro_comprobante, GETDATE(), @subtotal, 0, 0, @subtotal, 'Entregado', @id_metodo_pago_venta, @codigo_cliente_venta);

    COMMIT TRANSACTION;
END
GO
