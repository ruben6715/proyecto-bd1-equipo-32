Primera Forma Normal (1FN)Regla: Eliminación de grupos repetitivos y garantía de atomicidad en cada atributo.
Transformación: Atributos como fechas, precios, razones sociales y códigos se definen en campos indivisibles.
Por ejemplo, en la tabla cliente los campos teléfono y correo contienen valores únicos por registro.
Se separan las líneas compuestas de artículos/productos en entidades independientes; así surgieron las tablas de relación explícita detalle_venta y detalle_compra.   

Segunda Forma Normal (2FN)Regla: Cumplir 1FN y eliminar dependencias funcionales parciales en claves compuestas (cada atributo no clave debe depender 
de la totalidad de la clave primaria).
Transformación: En tablas transaccionales de detalle como detalle_venta y detalle_compra, se definen claves 
primarias propias (id_detalle_Venta e id_detalle_compra).
Atributos como cantidad y precio_unitario_histórico dependen únicamente del ítem de detalle 
individual y no parcialmente de la cabecera de la venta ni del lote/producto de forma aislada. 

Tercera Forma Normal (3FN)Regla: Cumplir 2FN y eliminar dependencias transitivas en atributos no clave (ningún atributo no clave debe depender de 
otro atributo no clave).
Transformación:Métodos de Pago: Los detalles del método de pago (nombre_método, descripción) se extraen a la entidad Método_de_Pago, 
dejando solo id_metodopago (FK) en la tabla venta.  
Domicilios: Se separan los datos de dirección (Calle, Barrio, Provincia, Altura) a la entidad Domicilio, dejando únicamente id_domicilio (FK) en la tabla cliente para evitar que datos atómicos del domicilio dependan directamente del código del cliente. 
