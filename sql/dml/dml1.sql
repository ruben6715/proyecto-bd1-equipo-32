

USE FarmaBlue;
GO

-- ============================================================================
-- SCRIPT DML
-- ============================================================================

-- 1. Carga de Domicilio (10 registros)
INSERT INTO Domicilio (Calle, Barrio, Provincia, Altura) VALUES 
('Av. 3 de Mayo', 'Centro', 'Corrientes', 1230),
('San Martín', 'Belgrano', 'Corrientes', 450),
('Junín', 'Cambá Cuá', 'Corrientes', 890),
('Córdoba', 'Plácido Martínez', 'Corrientes', 1020),
('Bolívar', 'La Cruz', 'Corrientes', 550),
('Mendoza', 'Centro', 'Corrientes', 1420),
('Salta', 'Aldana', 'Corrientes', 310),
('Santa Fe', 'Bañado Norte', 'Corrientes', 670),
('Av. Italia', 'Resistencia Centro', 'Chaco', 240),
('Pellgrini', 'Centro', 'Chaco', 1150);

-- 2. Carga de cliente (10 registros: Farmacias y Centros de Salud)
-- Nota: id_domicilio asignados de 1 a 10
INSERT INTO cliente (telefono, correo, autorizacion_psicotropico, matricula_habilitacion_sanitaria, fecha_vencimiento_habilitacion, limite_credito, CUIT, Razon_social, id_domicilio) VALUES 
(4411223, 'contacto@farmaciacentral.com', 1, 'MS-34589-COR', '2027-12-31', 1500000.00, '30-71123456-8', 'Farmacia Central S.R.L.', 1),
(4422334, 'pedidos@farmaciasanroque.com', 1, 'MS-45120-COR', '2026-11-15', 2000000.00, '30-71234567-9', 'Farmacia San Roque S.A.', 2),
(4433445, 'compras@farmauno.com.ar', 0, 'MS-12890-COR', '2025-08-20', 800000.00, '30-71345678-0', 'Farmacia Uno S.H.', 3),
(4444556, 'admin@centrodelasalud.org', 1, 'MS-99812-COR', '2028-05-10', 5000000.00, '30-65432109-1', 'Centro Médico Integral S.A.', 4),
(4455667, 'farmacia_camba@gmail.com', 0, 'MS-67234-COR', '2026-10-30', 500000.00, '30-71456789-2', 'Farmacia Cambá Cuá', 5),
(4466778, 'proveeduria@clinicaitaliana.com', 1, 'MS-88123-CHA', '2027-01-15', 3500000.00, '30-68901234-5', 'Sanatorio Italiano Chaco', 9),
(4477889, 'ventas@farmaciadelpueblo.com', 0, 'MS-11223-COR', '2026-06-30', 600000.00, '30-71567890-3', 'Farmacia El Pueblo', 6),
(4488990, 'farmacia_belgrano@hotmail.com', 1, 'MS-33445-COR', '2027-09-01', 1200000.00, '30-71678901-4', 'Farmacia Belgrano Norte', 7),
(4499001, 'contacto@saludplus.com.ar', 1, 'MS-55667-CHA', '2028-02-28', 4000000.00, '30-69012345-6', 'Clínica Salud Plus S.R.L.', 10),
(4400112, 'farmacia_sanmarting@gmail.com', 0, 'MS-77889-COR', '2026-12-01', 750000.00, '30-71789012-5', 'Farmacia San Martín', 8);

-- 3. Carga de Producto (10 medicamentos e insumos)
INSERT INTO Producto (nombre_comercial, monodroga_principio_activo, es_psicotropico, requiere_cadena_frio, precio_unidad_actual) VALUES 
('Ibuprofeno 600mg Pharma', 'Ibuprofeno', 0, 0, 1250.50),
('Paracetamol 1g Farma', 'Paracetamol', 0, 0, 980.00),
('Amoxicilina 500mg Duo', 'Amoxicilina', 0, 0, 2400.00),
('Alprazolam 1mg Sanitas', 'Alprazolam', 1, 0, 3100.00),
('Clonazepam 2mg Sedat', 'Clonazepam', 1, 0, 3450.00),
('Insulina Humana NPH 100UI', 'Insulina NPH', 0, 1, 12800.00),
('Vacuna Antigripal Tetra', 'Vacuna Antigripal', 0, 1, 18500.00),
('Loratadina 10mg Aler', 'Loratadina', 0, 0, 1100.00),
('Alcohol En Gel 500ml', 'Alcohol Etílico 70%', 0, 0, 1600.00),
('Morphina 10mg Ampollas', 'Morfina Clorhidrato', 1, 0, 8900.00);

-- 4. Carga de Provedor (10 laboratorios y distribuidores)
INSERT INTO Provedor (razon_social, cuit, habilitacion) VALUES 
('Laboratorios Roemmers S.A.', '30-50001234-1', 'HAB-ANMAT-0012'),
('Laboratorios Bago S.A.', '30-50002345-2', 'HAB-ANMAT-0034'),
('Elea Phoenix S.A.', '30-50003456-3', 'HAB-ANMAT-0056'),
('Bayer Argentina S.A.', '30-50004567-4', 'HAB-ANMAT-0078'),
('Laboratorios Montpellier S.A.', '30-50005678-5', 'HAB-ANMAT-0090'),
('Gador S.A.', '30-50006789-6', 'HAB-ANMAT-0112'),
('Raffo S.A.I.C.', '30-50007890-7', 'HAB-ANMAT-0134'),
('Novartis Argentina S.A.', '30-50008901-8', 'HAB-ANMAT-0156'),
('Sanofi Aventis S.A.', '30-50009012-9', 'HAB-ANMAT-0178'),
('Droguería Del Sud S.A.', '30-50010123-0', 'HAB-ANMAT-0200');

-- 5. Carga de lote (10 lotes con stock y vencimientos)
INSERT INTO lote (codigo_lote_origen, fecha_vencimiento, stock_disponible, id_producto, id_proveedor) VALUES 
('LOTE-IBU-2026A', '2027-06-30', 1500, 1, 1),
('LOTE-PAR-2026B', '2027-08-15', 2000, 2, 2),
('LOTE-AMO-2026C', '2026-12-31', 800, 3, 3),
('LOTE-ALP-2026D', '2028-01-10', 450, 4, 6),
('LOTE-CLO-2026E', '2027-11-20', 600, 5, 6),
('LOTE-INS-2026F', '2027-04-18', 300, 6, 8),
('LOTE-VAC-2026G', '2027-03-31', 250, 7, 9),
('LOTE-LOR-2026H', '2028-05-15', 1200, 8, 5),
('LOTE-ALG-2026I', '2029-01-01', 3000, 9, 10),
('LOTE-MOR-2026J', '2027-10-10', 150, 10, 7);

-- 6. Carga de Metodo_De_Pago (10 métodos)
INSERT INTO Metodo_De_Pago (nombre_metodo, descripcion) VALUES 
('Cuenta Corriente 30 Días', 'Pago a crédito diferido a 30 días según límite de crédito'),
('Cuenta Corriente 60 Días', 'Pago a crédito diferido a 60 días para grandes clientes'),
('Transferencia Bancaria', 'Transferencia directa CBU/CVU previa a la facturación'),
('Cheque Al Día', 'Cheque físico acreditado al momento del despacho'),
('Cheque Diferido 30 Días', 'Cheque con pago a fecha acordada a 30 días'),
('Cheque Diferido 60 Días', 'Cheque con pago a fecha acordada a 60 días'),
('Efectivo en Entrega', 'Pago en efectivo contra entrega en logística'),
('Tarjeta de Débito', 'Cobro electrónico inmediato en mostrador'),
('Tarjeta de Crédito Corporativa', 'Pago con tarjeta corporativa en 1 pago'),
('E-Cheq', 'Cheque electrónico homologado por Banco Central');

-- 7. Carga de venta (10 ventas registradas)
INSERT INTO venta (numero_comprobante, fecha_Hora, monto_subtotal, monto_Descuento, monto_Impuesto, monto_total, estado_venta, id_metodoPago, Codigo_Cliente) VALUES 
(1001, '2026-09-10 09:30:00', 25000.00, 1000.00, 5040.00, 29040.00, 'Entregado', 1, 1),
(1002, '2026-09-12 11:15:00', 45000.00, 0.00, 9450.00, 54450.00, 'Entregado', 3, 2),
(1003, '2026-09-15 14:20:00', 12000.00, 500.00, 2415.00, 13915.00, 'Facturado', 7, 3),
(1004, '2026-09-18 16:45:00', 150000.00, 5000.00, 30450.00, 175450.00, 'Entregado', 2, 4),
(1005, '2026-09-20 10:00:00', 18000.00, 0.00, 3780.00, 21780.00, 'Entregado', 4, 5),
(1006, '2026-09-22 08:30:00', 85000.00, 2000.00, 17430.00, 100430.00, 'En Despacho', 1, 6),
(1007, '2026-09-25 12:10:00', 9500.00, 0.00, 1995.00, 11495.00, 'Entregado', 8, 7),
(1008, '2026-09-26 15:50:00', 62000.00, 2000.00, 12600.00, 72600.00, 'Pendiente', 5, 8),
(1009, '2026-09-28 17:00:00', 110000.00, 4000.00, 22260.00, 128260.00, 'Entregado', 10, 9),
(1010, '2026-09-30 10:25:00', 21000.00, 0.00, 4410.00, 25410.00, 'Facturado', 3, 10);

-- 8. Carga de compra (10 órdenes de compra a proveedores)
INSERT INTO compra (fecha_emision, fecha_entrega_esperada, condicion_pago, monto_total, observaciones, id_provedor) VALUES 
('2026-08-01', '2026-08-05', 'Cuenta Corriente', 500000.00, 'Pedido mensual de analgésicos', 1),
('2026-08-03', '2026-08-08', 'Transferencia', 350000.00, 'Reposición de antibióticos urgente', 2),
('2026-08-10', '2026-08-15', 'Cuenta Corriente', 420000.00, 'Compra amoxicilina e insumos', 3),
('2026-08-12', '2026-08-18', 'Contado', 280000.00, 'Pedido suplementario', 4),
('2026-08-15', '2026-08-20', 'Cuenta Corriente', 190000.00, 'Loratadina y antialérgicos', 5),
('2026-08-20', '2026-08-25', 'Cuenta Corriente', 650000.00, 'Psicotrópicos controlados', 6),
('2026-08-22', '2026-08-27', 'Cheque 30 Días', 310000.00, 'Morfina y anestésicos', 7),
('2026-09-01', '2026-09-05', 'Transferencia', 980000.00, 'Cadena de frío - Insulina', 8),
('2026-09-05', '2026-09-10', 'Transferencia', 1200000.00, 'Vacunas antigripales stock temporada', 9),
('2026-09-10', '2026-09-12', 'Contado', 150000.00, 'Alcohol y material descartable', 10);

-- 9. Carga de detalle_compra (10 renglones de órdenes de compra)
INSERT INTO detalle_compra (cantidad_pedida, precio_costo_unitario, id_orden_compra, id_producto) VALUES 
(500, 1000.00, 1, 1),
(400, 875.00, 2, 2),
(200, 2100.00, 3, 3),
(100, 2800.00, 4, 4),
(150, 1266.66, 5, 8),
(200, 3250.00, 6, 5),
(50, 6200.00, 7, 10),
(90, 10888.88, 8, 6),
(75, 16000.00, 9, 7),
(100, 1500.00, 10, 9);

-- 10. Carga de detalle_venta (10 renglones de detalle de ventas con precio histórico)
INSERT INTO detalle_venta (cantidad, precio_unitario_historico, id_lote, id_venta) VALUES 
(20, 1250.50, 1, 1), -- Lote Ibuprofeno
(30, 980.00, 2, 2),  -- Lote Paracetamol
(5, 2400.00, 3, 3),  -- Lote Amoxicilina
(40, 3100.00, 4, 4), -- Lote Alprazolam
(10, 3450.00, 5, 5), -- Lote Clonazepam
(5, 12800.00, 6, 6), -- Lote Insulina (Cadena frío)
(10, 950.00, 2, 7),  -- Lote Paracetamol
(20, 3100.00, 4, 8), -- Lote Alprazolam
(5, 18500.00, 7, 9), -- Lote Vacunas
(15, 1400.00, 9, 10); -- Lote Alcohol en Gel
GO
