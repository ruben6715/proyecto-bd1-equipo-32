-- SCRIPT SQL: OPTIMIZACIÓN DE CONSULTAS E ÍNDICES - FARMABLUE

USE FarmaBlue;
GO

-- =========================================================================
-- PARTE 1: CREACIÓN DE LA TABLA HISTÓRICA PARA EL MÓDULO DE LOGÍSTICA FEFO
-- =========================================================================
-- Tabla destinada a registrar el volumen masivo de lotes de medicamentos 
-- para auditar vencimientos y despachos bajo la modalidad FEFO (RN.03)[cite: 1, 14, 15].
CREATE TABLE LoteInventarioHistorico (
    id_lote BIGINT IDENTITY(1,1),
    codigo_medicamento VARCHAR(20) NOT NULL,
    numero_lote VARCHAR(30) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    stock_disponible INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL
);
GO


-- =========================================================================
-- PARTE 2: CARGA MASIVA DE DATOS SIMULADOS (1.000.000 DE REGISTROS)
-- =========================================================================
-- Generación de un volumen significativo de registros para evaluar 
-- el rendimiento del motor ante consultas de control de vencimientos[cite: 14, 15].
SET NOCOUNT ON;
GO

WITH Numeros AS (
    SELECT TOP (1000000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
INSERT INTO LoteInventarioHistorico (codigo_medicamento, numero_lote, fecha_vencimiento, stock_disponible, precio_unitario)
SELECT 
    'MED-' + CAST((ABS(CHECKSUM(NEWID())) % 500) + 1 AS VARCHAR(10)),
    'LOT-' + CAST((ABS(CHECKSUM(NEWID())) % 10000) + 1 AS VARCHAR(10)),
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1825, '2024-01-01'), -- Fechas en un rango de 5 años
    (ABS(CHECKSUM(NEWID())) % 1000) + 1,
    ROUND((RAND(CHECKSUM(NEWID())) * 15000) + 500, 2)
FROM Numeros;
GO

-- Verificación de la cantidad de registros insertados
SELECT COUNT(*) AS CantidadRegistros 
FROM LoteInventarioHistorico;
GO


-- =========================================================================
-- PARTE 3: CONSULTA SIN ÍNDICES (ESCANEO COMPLETO DE TABLA)
-- =========================================================================
-- Activación de estadísticas para medir tiempo de CPU, ejecución y lecturas I/O[cite: 16].
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

-- Auditoría logística para filtrar lotes próximos a vencer en un período crítico
SELECT 
    id_lote,
    codigo_medicamento,
    numero_lote,
    fecha_vencimiento,
    stock_disponible
FROM LoteInventarioHistorico
WHERE fecha_vencimiento BETWEEN '2026-12-01' AND '2026-12-31';
GO


-- =========================================================================
-- PARTE 4: CREACIÓN DE ÍNDICE AGRUPADO SOBRE LA FECHA DE VENCIMIENTO
-- =========================================================================
-- Mejora el acceso al ordenar físicamente los registros por fecha de expiración[cite: 17].
CREATE CLUSTERED INDEX IX_LoteInventario_FechaVencimiento
ON LoteInventarioHistorico (fecha_vencimiento);
GO

-- Repetición de la consulta para verificar el cambio a 'Clustered Index Seek'[cite: 17, 19]
SELECT 
    id_lote,
    codigo_medicamento,
    numero_lote,
    fecha_vencimiento,
    stock_disponible
FROM LoteInventarioHistorico
WHERE fecha_vencimiento BETWEEN '2026-12-01' AND '2026-12-31';
GO


-- =========================================================================
-- PARTE 5: ELIMINACIÓN DEL ÍNDICE AGRUPADO ANTERIOR
-- =========================================================================
DROP INDEX IX_LoteInventario_FechaVencimiento 
ON LoteInventarioHistorico;
GO


-- =========================================================================
-- PARTE 6: CREACIÓN DE UN ÍNDICE NO AGRUPADO CON COBERTURA (COVERING INDEX)
-- =========================================================================
-- Incluye las columnas proyectadas para resolver la consulta de forma directa 
-- sin acudir a la tabla principal (*Key Lookup*)[cite: 18].
CREATE NONCLUSTERED INDEX IX_LoteInventario_FEFO_Cobertura
ON LoteInventarioHistorico (fecha_vencimiento)
INCLUDE (codigo_medicamento, numero_lote, stock_disponible);
GO

-- Repetición de la consulta para verificar la optimización máxima con 'Index Seek'[cite: 18, 19]
SELECT 
    codigo_medicamento,
    numero_lote,
    fecha_vencimiento,
    stock_disponible
FROM LoteInventarioHistorico
WHERE fecha_vencimiento BETWEEN '2026-12-01' AND '2026-12-31';
GO
