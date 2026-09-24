Parte I: Requerimientos
La Droguería "Distribuidora FarmaBlue" se dedica a la venta y distribución al por mayor de medicamentos, insumos médicos y perfumería a farmacias y centros de salud .
El alcance del sistema comprende el control de inventario por lote y vencimiento, el control de stock disponible, la gestión sanitaria y normativa, la logística de despacho, la administración de la relación comercial con los clientes, el registro de ventas mayoristas con sus respectivos métodos de pago y el almacenamiento del historial de precios unitarios por transacción para garantizar la auditoría y evitar cambios retroactivos.

Reglas del negocio:

	RN.01: Registro de cliente: Toda farmacia o centro de salud debe 	registrarse de manera obligatoria con su número de CUIT (único) y su 	Número de Habilitación Sanitaria.

	RN.02: reglas sanitarias y legales: El sistema no permitirá emitir pedidos 	a clientes con habilitación vencida ni procesar medicamentos de tipo 	Psicotrópicos y Estupefacientes si la farmacia no cuenta con la 	autorización correspondiente.

	RN.03: Despacho por FEFO y Cadena de Frío: La salida del inventario 	debe realizarse bajo la modalidad FEFO (First Expired, First Out - Primero 	en Vencer, Primero en Salir). Se rechazará la venta si el lote no cumple 	con el Margen Mínimo de Vencimiento requerido por la normativa o si 	rompe los parámetros de Cadena de Frío.

	RN.04: Control de Stock por Lote: Cada lote ingresado registra un stock 	disponible y una fecha de expiración. Al confirmarse un pedido, el sistema 	descontará las unidades automáticamente del lote seleccionado; no se 	podrá vender un lote vencido ni sin stock.

	RN.05: Métodos de Pago y Condición de Venta: Toda venta debe 	asociarse a un método de pago válido (Cuenta Corriente, Transferencia 	Bancaria, Cheque a Fecha). Para los pedidos a cuenta corriente, el monto 	total no podrá superar el límite de crédito asignado a la farmacia.

	RN:06: Monto o Cantidad Mínima de Facturación: Los pedidos 	realizados por los clientes minoristas deben alcanzar un monto mínimo de 	facturación establecido o una cantidad mínima de unidades por lote para 	poder ser procesados por el departamento de logística.

	RN:07: Registro Histórico de Precios Unitarios en Ventas: Cuando se 	hace una venta, el precio de cada producto se tiene que guardar tal cual 	en ese momento dentro del detalle del pedido. Si mañana la droguería 	aumenta los precios en el catálogo general, las ventas viejas no se 	modifican y mantienen el p

