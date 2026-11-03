***** Manejo de Transacciones ****
 ¿Qué son?
Una transacción es un conjunto de operaciones SQL que se ejecutan como una única unidad
lógica de trabajo. Si una operación falla, todas las anteriores se deshacen. Esto garantiza las
propiedades ACID: Atomicidad, Consistencia, Aislamiento y Durabilidad.

¿ porque utilizarlas ?
Integridad en el registro de Gastos: Cuando registras un nuevo gasto, es probable que este movimiento afecte o 
dependa de varias tablas simultáneamente (por ejemplo, relacionarse con un edificio, un tipo_gasto, una localidad y una provincia). 
Si ocurre un error a mitad del proceso de inserción, la transacción evita que quede un registro incompleto o "huérfano" en la base de datos. 

Consistencia de datos maestros y dependientes: Tu modelo se basa en jerarquías estrictas (como provincia -->  localidad --> edificio --> gasto).
Si realizas operaciones complejas que actualizan o relacionan múltiples entidades a la vez, 
la transacción garantiza que o se actualiza todo correctamente o no se aplica ningún cambio parcial que rompa la lógica del sistema. 

Propiedad de Atomicidad ("Todo o nada"): Siguiendo el principio ACID, si un procedimiento o bloque de código SQL intenta insertar un gasto y
actualizar los datos asociados y surge un fallo eléctrico, de conexión o de restricciones, la base de datos ejecuta un ROLLBACK automático.
Esto deshace cualquier cambio previo y mantiene la base de datos en un estado consistente y seguro



