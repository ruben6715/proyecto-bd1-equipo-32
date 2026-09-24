Primera Forma Normal (1FN)Regla: Eliminación de grupos repetitivos y garantía de atomicidad en cada atributo. 
Transformación: Atributos como fechas, precios, razones sociales y códigos se definen en campos indivisibles. Por ejemplo, en la tabla cliente los campos teléfono y correo se mantienen individuales por registro. 
 Se separan las líneas compuestas de productos en entidades independientes vinculadas por claves primarias . Surgieron tablas de relación explícita como detalle_venta y detalle_compra, .   
