# Investigación y Aplicación: Procedimientos Almacenados y Funciones

## 1. ¿Qué son los Procedimientos Almacenados y las Funciones?
* **Procedimiento Almacenado (Stored Procedure):** Es un conjunto de instrucciones SQL precompiladas que se almacenan en el motor de base de datos. Permiten ejecutar lógica de negocio compleja, agrupando múltiples operaciones (como consultas, inserciones, actualizaciones y validaciones de stock) en una sola llamada de manera segura.
* **Función Definida por el Usuario (User-Defined Function):** Es una rutina de código que realiza cálculos específicos y **retorna un valor** o una tabla, permitiendo reutilizar la lógica de forma limpia dentro de las consultas SQL (`SELECT`).

## 2. ¿Por qué utilizarlos en un sistema?
* **Reutilización de código:** Evitan duplicar la lógica de negocio en distintas aplicaciones o consultas.
* **Mantenibilidad:** Si una regla cambia (por ejemplo, el cálculo de un impuesto o un descuento), se modifica en un solo lugar.
* **Seguridad y Control:** Permiten centralizar las operaciones y proteger las tablas de modificaciones directas y erróneas por parte de los usuarios o sistemas externos.

## 3. Caso de Aplicación en el Proyecto FarmaBlue

En el sistema mayorista **FarmaBlue**, implementamos estos componentes para resolver operaciones críticas de negocio:

### A. Función de Impuestos (`dbo.CalcularImpuesto`)
* **Problema de negocio:** Cada venta registrada debe calcular automáticamente el porcentaje correspondiente de impuestos (IVA) sobre el subtotal de los productos farmacéuticos adquiridos por las farmacias clientes.
* **Implementación:** Una función escalar que recibe el monto `@Subtotal` y retorna el valor numérico exacto del impuesto calculado.

### B. Procedimiento Almacenado de Registro de Ventas (`dbo.RegistrarVentaComercial`)
* **Problema de negocio:** Registrar una venta completa implica múltiples pasos que deben suceder en conjunto: validar que exista suficiente stock en el `lote`, calcular subtotales e impuestos, insertar la cabecera en la tabla `venta`, registrar los renglones en `detalle_venta`, y descontar automáticamente la cantidad vendida del stock disponible.
* **Implementación:** Un procedimiento almacenado que centraliza toda esta lógica de control de stock y persistencia, garantizando que la operación se ejecute de forma ordenada y segura con un simple comando (`EXEC`).
