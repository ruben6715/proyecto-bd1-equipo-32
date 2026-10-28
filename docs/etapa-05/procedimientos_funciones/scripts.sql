
-- SCRIPT SQL: PROCEDIMIENTOS Y FUNCIONES - FARMABLUE

USE FarmaBlue;
GO

-- 1. FUNCIÓN: Calcular descuento para clientes frecuentes
-- Lógica: Calcula el acumulado de compras del cliente y retorna el porcentaje de descuento.
CREATE FUNCTION dbo.fn_CalcularDescuentoCliente (@Codigo_Cliente INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @TotalAcumulado DECIMAL(10,2);
    DECLARE @PorcentajeDescuento DECIMAL(5,2);

    -- Sumar el total de las ventas históricas de este cliente
    SELECT @TotalAcumulado = ISNULL(SUM(monto_total), 0)
    FROM venta
    WHERE Codigo_Cliente = @Codigo_Cliente;

    -- Aplicar reglas de negocio según monto acumulado
    IF @TotalAcumulado > 500000.00
        SET @PorcentajeDescuento = 0.10; -- 10% de descuento
    ELSE IF @TotalAcumulado > 200000.00
        SET @PorcentajeDescuento = 0.05; -- 5% de descuento
    ELSE
        SET @PorcentajeDescuento = 0.00; -- Sin descuento

    RETURN @PorcentajeDescuento;
END;
GO

-- 2. PROCEDIMIENTO ALMACENADO: Registrar una venta completa
-- Tareas: Valida stock, calcula subtotales, aplica descuento (usando la función), 
-- registra cabecera, inserta detalle, guarda precio histórico y actualiza stock.
CREATE PROCEDURE dbo.sp_RegistrarVentaCompleta
    @NumeroComprobante INT,
    @IdMetodoPago INT,
    @CodigoCliente INT,
    @IdLote INT,
    @Cantidad INT
AS
BEGIN
    DECLARE @StockActual INT;
    DECLARE @PrecioUnitario DECIMAL(10,2);
    DECLARE @Subtotal DECIMAL(10,2);
    DECLARE @PorcentajeDesc DECIMAL(5,2);
    DECLARE @MontoDescuento DECIMAL(10,2);
    DECLARE @Impuesto DECIMAL(10,2);
    DECLARE @Total DECIMAL(10,2);
    DECLARE @IdVentaNueva INT;

    -- Verificar stock disponible en el lote y obtener el precio actual del producto
    SELECT @StockActual = l.stock_disponible, 
           @PrecioUnitario = p.precio_unidad_actual
    FROM lote l
    INNER JOIN Producto p ON l.id_producto = p.id_producto
    WHERE l.id_lote = @IdLote;

    IF @StockActual < @Cantidad
    BEGIN
        RAISERROR('Error: Stock insuficiente en el lote seleccionado.', 16, 1);
        RETURN;
    END

    -- Calcular montos y aplicar la función de descuento
    SET @Subtotal = @PrecioUnitario * @Cantidad;
    SET @PorcentajeDesc = dbo.fn_CalcularDescuentoCliente(@CodigoCliente);
    SET @MontoDescuento = @Subtotal * @PorcentajeDesc;
    
    -- Calcular impuesto (21% sobre el monto con descuento aplicado)
    SET @Impuesto = (@Subtotal - @MontoDescuento) * 0.21;
    SET @Total = (@Subtotal - @MontoDescuento) + @Impuesto;

    -- 1. Registrar encabezado de venta
    INSERT INTO venta (numero_comprobante, fecha_Hora, monto_subtotal, monto_Descuento, monto_Impuesto, monto_total, estado_venta, id_metodoPago, Codigo_Cliente)
    VALUES (@NumeroComprobante, GETDATE(), @Subtotal, @MontoDescuento, @Impuesto, @Total, 'Entregado', @IdMetodoPago, @CodigoCliente);

    SET @IdVentaNueva = SCOPE_IDENTITY();

    -- 2 y 3. Insertar detalle de venta y guardar precio histórico
    INSERT INTO detalle_venta (cantidad, precio_unitario_historico, id_lote, id_venta)
    VALUES (@Cantidad, @PrecioUnitario, @IdLote, @IdVentaNueva);

    -- 4. Actualizar stock del lote
    UPDATE lote
    SET stock_disponible = stock_disponible - @Cantidad
    WHERE id_lote = @IdLote;

    PRINT 'Operación confirmada: Venta registrada y stock actualizado con éxito.';
END;
GO


-- 3. DEMOSTRACIÓN DE USO 


-- A. Probar la función de descuento para un cliente:
SELECT 
    Razon_social, 
    dbo.fn_CalcularDescuentoCliente(Codigo_Cliente) AS PorcentajeDescuentoAsignado
FROM cliente;
GO

-- B. Probar el procedimiento almacenado de venta completa:
EXEC dbo.sp_RegistrarVentaCompleta 
    @NumeroComprobante = 7777, 
    @IdMetodoPago = 1, 
    @CodigoCliente = 1, 
    @IdLote = 1, 
    @Cantidad = 2;
GO
--c .Probar el stock insuficiente
EXEC dbo.sp_RegistrarVentaCompleta 
    @NumeroComprobante = 5555, 
    @IdMetodoPago = 1, 
    @CodigoCliente = 1, 
    @IdLote = 1,          -- Lote 1
    @Cantidad = 9999;     -- Pides más de lo que hay en stock para forzar el error
