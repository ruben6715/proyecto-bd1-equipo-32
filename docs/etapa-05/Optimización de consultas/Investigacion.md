##  Investigación y Aplicación: Optimización de Consultas

## 1¿Que es?
La optimización de consultas a través de índices es el conjunto de técnicas y mecanismos que permite a SQL Server localizar e intermediar datos de la manera más rápida y eficiente posible.
Existen dos tipos principales de índices en SQL Server Express:
Índice Agrupado (Clustered Index): Determina el orden físico en el que se almacenan los datos dentro de la tabla. Solo puede existir uno por tabla (por lo general, asociado a la clave primaria).
Índice No Agrupado (Non-Clustered Index): Se almacena en una estructura separada de los datos reales y contiene punteros a las filas correspondientes. Puede enriquecerse mediante la cláusula INCLUDE para almacenar columnas adicionales y crear índices de cobertura, los cuales responden a la consulta por completo sin acudir a la tabla principal (Key Lookup)

## 2 ¿Porque utilizarlo en un sistema?
La inclusión de índices y la optimización de consultas en un sistema de base de datos relacional ofrece beneficios críticos:
Mejora sustancial del rendimiento: Reduce radicalmente los tiempos de respuesta al evitar lecturas innecesarias en disco y memoria. 
Disminución de lecturas de I/O y CPU: Convierte operaciones de escaneo masivo de tabla (Table Scan) en búsquedas puntuales o por rangos (Index Seek).   
Soporte para escalabilidad: Garantiza que el rendimiento del sistema no colapse a medida que el volumen de transacciones y registros aumenta exponencialmente.  
Optimización de filtros y reglas complejas: Agiliza las búsquedas filtradas por campos clave como fechas, rangos de vencimiento, números de CUIT, lotes o códigos.   

## 3. Caso de Aplicación en el Proyecto FarmaBlue: 
Contexto del Negocio y Problema de AnálisisEn Distribuidora FarmaBlue, el módulo de Logística y Control Sanitarios procesa diariamente grandes volúmenes de movimientos de inventario por lote y vencimiento bajo la modalidad FEFO (First Expired, First Out - Regla RN.03).   Para auditar y garantizar que no existan medicamentos próximos a vencer ni lotes sin despacho prioritario, el departamento de Logística ejecuta frecuentemente consultas por rangos de fecha de expiración. Sin una indexación adecuada sobre la fecha de vencimiento, la búsqueda en tablas volumétricas fuerza al motor a escanear toda la estructura de lotes (Table Scan), afectando el rendimiento del sistema.
