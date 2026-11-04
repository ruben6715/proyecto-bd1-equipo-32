# Investigación y Aplicación: Triggers de auditoría

## 1. ¿Qué son los Triggers de auditoría?
Un trigger (o disparador) es un bloque de código que se guarda en la base de datos y se ejecuta solo cuando ocurre un evento sobre una tabla, que puede ser un INSERT, un UPDATE o un DELETE. Nadie lo llama a mano: el motor lo activa cuando alguien agrega, modifica o borra datos.
Un trigger de auditoría es el que se usa para dejar registro de esos cambios. Cada vez que se toca una tabla importante, el trigger guarda en otra tabla, llamada tabla de auditoría, qué se hizo, quién lo hizo, cuándo y cuáles eran los valores antes y después del cambio. Para eso aprovecha las tablas temporales inserted y deleted, que SQL Server genera dentro del trigger con los datos nuevos y los anteriores.
El objetivo es tener trazabilidad: poder reconstruir la historia de un dato y responder preguntas como quién cambió el precio de un producto, cuándo se borró un registro o qué valor tenía antes de la modificación. En nuestro proyecto FarmaBlue, por ejemplo, el trigger trg_auditoria_producto guarda en auditoria_producto cada cambio de precio de la tabla Producto, con la fecha, el usuario, el precio anterior y el nuevo.

## 2. ¿Por qué utilizarlos en un sistema?
La principal ventaja es que la auditoría es automática. No depende de que el programador o el usuario se acuerden de registrar el cambio, porque el trigger se ejecuta siempre, sin importar desde dónde se haga la modificación, ya sea una aplicación, un script o alguien escribiendo una consulta directo en SSMS. Eso la hace bastante más confiable que registrar los cambios desde el código de la aplicación.
Otra ventaja es que el registro queda guardado dentro de la misma transacción que la operación original. Si el cambio se deshace con un ROLLBACK, la fila de auditoría también se deshace, así que nunca queda un registro de algo que en realidad no pasó. Además, el historial queda en la propia base, centralizado y fácil de consultar con un simple SELECT.
También ayuda al control interno y a la seguridad, porque permite detectar modificaciones sospechosas o no autorizadas y saber quién las hizo. Y sirve para recuperar información: si un dato se cambió o se borró por error, la auditoría guarda el valor anterior.
En cuanto a las aplicaciones, se usan mucho en lugares donde los datos son sensibles o están regulados. En un sistema como el de FarmaBlue sirven para controlar los cambios de precios, los movimientos de stock de los lotes o las modificaciones en los límites de crédito de los clientes. En bancos permiten seguir los movimientos de las cuentas, en sistemas de salud los cambios en las historias clínicas, y en comercios los cambios de precios y las anulaciones de ventas.
Como contra, hay que tener en cuenta que cada trigger agrega trabajo extra a cada operación, así que si se abusa de ellos o se auditan tablas con muchísimos movimientos puede bajar el rendimiento. Por eso conviene usarlos solo en las tablas y columnas donde de verdad hace falta tener trazabilidad.

## 3. Caso de Aplicación en el Proyecto FarmaBlue
En FarmaBlue hay varios lugares donde un trigger de auditoría tiene sentido, sobre todo porque es un negocio de medicamentos, donde la trazabilidad pesa más que en un comercio común.

1. Precios de productos (Producto.precio_unidad_actual):
 Permite saber quién cambió el precio de un medicamento y cuánto valía antes. Se relaciona con precio_unitario_historico de detalle_venta, que guarda el precio al momento de la venta.

2. Stock de los lotes (lote.stock_disponible):
El stock tendría que bajar solo por ventas (como en el procedimiento de transacciones). Un trigger puede registrar cada cambio de stock, con el valor anterior y el nuevo, y así detectar ajustes manuales o diferencias raras, como pérdidas o robos.

3. Clasificación de productos (Producto.es_psicotropico, requiere_cadena_frio):
Si alguien cambia esas marcas por error, un psicotrópico podría venderse sin control o un producto de frío tratarse como común. Auditar esos cambios evita problemas.

