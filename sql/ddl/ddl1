
-- 1. Verifica si la base de datos NO existe
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'FarmaBlue')
BEGIN
    -- Si no existe, la crea
    CREATE DATABASE FarmaBlue;
    PRINT 'La base de datos FarmaBlue fue creada con éxito.';
END
ELSE
BEGIN
    PRINT 'La base de datos FarmaBlue ya existe.';
END
GO

-- 2. Selecciona la base de datos para usarla
USE FarmaBlue;
GO

-- 3. Creación de Tablas (DDL)

CREATE TABLE Domicilio (
    id_domicilio INT IDENTITY(1,1) NOT NULL,
    Calle VARCHAR(100) NOT NULL,
    Barrio VARCHAR(50) NOT NULL,
    Provincia VARCHAR(50) NOT NULL,
    Altura INT NOT NULL,
    CONSTRAINT pk_id_domicilio PRIMARY KEY (id_domicilio)
);

CREATE TABLE cliente (
    Codigo_cliente INT IDENTITY(1,1) NOT NULL,
    telefono VARCHAR(20) NULL,
    correo VARCHAR(100) NOT NULL,
    autorizacion_psicotropico BIT NOT NULL DEFAULT 0, 
    matricula_habilitacion_sanitaria VARCHAR(100) NOT NULL,
    fecha_vencimiento_habilitacion DATE NOT NULL,    
    limite_credito DECIMAL(10, 2) NOT NULL DEFAULT 0,  
    CUIT VARCHAR(20) NOT NULL,
    Razon_social VARCHAR(100) NOT NULL,
    id_domicilio INT NOT NULL,
    CONSTRAINT uq_correo UNIQUE (correo),
    CONSTRAINT uq_matricula_habilitacion UNIQUE (matricula_habilitacion_sanitaria),
    CONSTRAINT uq_cuit_cliente UNIQUE (CUIT),
    CONSTRAINT pk_Codigo_cliente PRIMARY KEY (Codigo_cliente),
    CONSTRAINT fk_cliente_domicilio FOREIGN KEY (id_domicilio) 
        REFERENCES Domicilio(id_domicilio) 
        ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE Producto (
    id_producto INT IDENTITY(1,1) NOT NULL,
    nombre_comercial VARCHAR(150) NOT NULL,
    monodroga_principio_activo VARCHAR(150) NOT NULL,
    es_psicotropico BIT NOT NULL DEFAULT 0,
    requiere_cadena_frio BIT NOT NULL DEFAULT 0,
    precio_unidad_actual DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_IDproducto PRIMARY KEY (id_producto)
);

CREATE TABLE Provedor (
    id_provedor INT IDENTITY(1,1) NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    cuit VARCHAR(20) NOT NULL,
    habilitacion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_IDproveedor PRIMARY KEY (id_provedor), 
    CONSTRAINT uq_cuit_provedor UNIQUE (cuit)
);

CREATE TABLE lote (
    id_lote INT IDENTITY(1,1) NOT NULL,
    codigo_lote_origen VARCHAR(50) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    stock_disponible INT NOT NULL DEFAULT 0,
    id_producto INT NOT NULL,
    id_proveedor INT NOT NULL,
    CONSTRAINT pk_lote PRIMARY KEY (id_lote),
    CONSTRAINT fk_lote_producto FOREIGN KEY (id_producto) 
        REFERENCES Producto(id_producto) 
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_lote_proveedor FOREIGN KEY (id_proveedor) 
        REFERENCES Provedor(id_provedor) 
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT ck_stock_no_negativo CHECK (stock_disponible >= 0)
);

CREATE TABLE Metodo_De_Pago (
    id_metodoPago INT IDENTITY(1,1) NOT NULL,
    nombre_metodo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_id_metodoPago PRIMARY KEY (id_metodoPago)
);

CREATE TABLE venta (
    id_venta INT IDENTITY(1,1) NOT NULL,
    numero_comprobante INT NOT NULL,
    fecha_Hora DATETIME NOT NULL DEFAULT GETDATE(),
    monto_subtotal DECIMAL(10, 2) NOT NULL,
    monto_Descuento DECIMAL(10, 2) NULL DEFAULT 0,
    monto_Impuesto DECIMAL(10, 2) NOT NULL,
    monto_total DECIMAL(10, 2) NOT NULL,
    estado_venta VARCHAR(50) NOT NULL,
    id_metodoPago INT NOT NULL,
    Codigo_Cliente INT NOT NULL,
    CONSTRAINT pk_id_venta PRIMARY KEY (id_venta),
    CONSTRAINT uq_numero_comprobante UNIQUE (numero_comprobante),
    CONSTRAINT fk_venta_metodoPago FOREIGN KEY (id_metodoPago) 
        REFERENCES Metodo_De_Pago(id_metodoPago) 
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_venta_cliente FOREIGN KEY (Codigo_Cliente) 
        REFERENCES cliente(Codigo_Cliente) 
        ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE compra (
    id_orden_compra INT IDENTITY(1,1) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_entrega_esperada DATE NULL,
    condicion_pago VARCHAR(50) NOT NULL,
    monto_total DECIMAL(10,2) NOT NULL,
    observaciones VARCHAR(120) NULL,
    id_provedor INT NOT NULL,
    CONSTRAINT pk_compra PRIMARY KEY (id_orden_compra),
    CONSTRAINT fk_compra_provedor FOREIGN KEY (id_provedor) 
        REFERENCES Provedor(id_provedor) 
        ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE detalle_compra (
    id_detalle_compra INT IDENTITY(1,1) NOT NULL,
    cantidad_pedida INT NOT NULL,
    precio_costo_unitario DECIMAL (10,2) NOT NULL,
    id_orden_compra INT NOT NULL,
    id_producto INT NOT NULL,
    CONSTRAINT pk_detalle_compra PRIMARY KEY (id_detalle_compra),
    CONSTRAINT fk_detalle_compra_orden FOREIGN KEY (id_orden_compra) 
        REFERENCES compra(id_orden_compra) 
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_compra_producto FOREIGN KEY (id_producto) 
        REFERENCES Producto(id_producto) 
        ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE detalle_venta (
    id_detalle_Venta INT IDENTITY(1,1) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario_historico DECIMAL(10, 2) NOT NULL,
    id_lote INT NOT NULL,
    id_venta INT NOT NULL,
    CONSTRAINT PK_IDdetalleventa PRIMARY KEY (id_detalle_Venta),
    CONSTRAINT fk_detalle_venta_lote FOREIGN KEY (id_lote) 
        REFERENCES lote(id_lote) 
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_venta_venta FOREIGN KEY (id_venta) 
        REFERENCES venta(id_venta) 
        ON DELETE NO ACTION ON UPDATE CASCADE
);
