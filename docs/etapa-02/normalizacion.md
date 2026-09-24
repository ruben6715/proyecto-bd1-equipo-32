Primera Forma Normal (1FN)Regla: Eliminación de grupos repetitivos y garantía de atomicidad en cada atributo. 
Transformación: Atributos como fechas, precios, razones sociales y códigos se definen en campos indivisibles. Por ejemplo, en la tabla cliente los campos teléfono y correo se mantienen individuales por registro. 
 Se separan las líneas compuestas de productos en entidades independientes vinculadas por claves primarias . Surgieron tablas de relación explícita como detalle_venta y detalle_compra.

 
 Segunda Forma Normal (2FN)Regla: Cumplir 1FN y eliminar dependencias funcionales parciales en claves compuestas (cada atributo no clave debe depender de la totalidad de la clave primaria).  
 Transformación:En tablas transaccionales compuestas como detalle_venta y detalle_compra, se definen claves primarias propias (id_detalle_Venta e id_detalle_compra).  
 Atributos como cantidad y precio_unitario_histórico dependen de la línea exacta del detalle y no parcialmente de la transacción o del producto de forma aisaldda.   
