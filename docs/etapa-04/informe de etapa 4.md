# Etapa IV: Consultas y Casos de Uso

## Introducción

En esta etapa del proyecto FarmaBlue nos dedicamos a desarrollar y probar las consultas SQL que responden a las necesidades de información del negocio. Trabajamos sobre las tablas que ya habíamos creado y cargado en las etapas anteriores (scripts `ddl1` y `dml1`), principalmente `venta`, `detalle_venta`, `cliente`, `lote` y `producto`. La consigna pedía tres tipos de consulta: un comprobante de venta, un reporte agregado y una consulta de negocio avanzada. A continuación contamos cómo resolvimos cada una.

## 1. Factura / Comprobante

Lo primero que hicimos fue obtener el detalle de cada venta con el subtotal de cada renglón. Para eso partimos de la tabla `detalle_venta` y calculamos el subtotal multiplicando la cantidad por el precio unitario histórico:

```sql
SELECT *, (cantidad * precio_unitario_historico) AS subTotales
FROM detalle_venta;
```

Usamos `precio_unitario_historico` y no el precio actual del producto porque queríamos que el comprobante refleje el valor al que realmente se vendió en ese momento, aunque el precio del producto cambie después.

Luego calculamos el total acumulado de cada venta, sumando los subtotales de todos sus renglones y agrupando por número de venta:

```sql
SELECT f.id_venta, SUM(f.cantidad * f.precio_unitario_historico) AS total
FROM detalle_venta AS f
GROUP BY f.id_venta;
```

De esta manera, la primera consulta nos da el detalle renglón por renglón y la segunda el total de cada comprobante.

## 2. Reporte agregado

Para el reporte agregado armamos una consulta sobre la tabla `venta` que suma los montos totales dentro de un rango de fechas, en nuestro caso el mes de septiembre de 2026:

```sql
SELECT f.id_venta, f.fecha_Hora, SUM(f.monto_total) AS TOTAL_VENTA
FROM venta AS f
WHERE fecha_Hora BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59'
GROUP BY f.id_venta, f.fecha_Hora;
```

El filtro `WHERE` con `BETWEEN` limita las ventas al período pedido, y con `GROUP BY` y `SUM` obtenemos el total de cada venta realizada en ese rango.

## 3. Consulta de negocio avanzada

Por último, hicimos una consulta que combina cinco tablas con `INNER JOIN` (`venta`, `cliente`, `detalle_venta`, `lote` y `producto`) y que responde a una pregunta concreta del negocio: qué clientes compraron qué productos durante septiembre y cuánto gastaron en cada uno, mostrando solo los casos en que el gasto superó los $20.000.

```sql
SELECT
    cl.Razon_social AS cliente,
    p.nombre_comercial AS producto,
    SUM(dv.cantidad) AS cantidad_total_comprada,
    SUM(dv.cantidad * dv.precio_unitario_historico) AS total_gastado
FROM venta AS v
INNER JOIN cliente AS cl
    ON cl.Codigo_Cliente = v.Codigo_Cliente
INNER JOIN detalle_venta AS dv
    ON dv.id_venta = v.id_venta
INNER JOIN lote AS l
    ON dv.id_lote = l.id_lote
INNER JOIN producto AS p
    ON l.id_producto = p.id_producto
WHERE v.fecha_Hora BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59'
GROUP BY cl.Razon_social, p.nombre_comercial
HAVING SUM(dv.cantidad * dv.precio_unitario_historico) > 20000;
```

Acá el recorrido de los `JOIN` sigue el modelo: la venta se relaciona con el cliente, el detalle de la venta se relaciona con el lote del que salió la mercadería, y el lote con el producto. El `WHERE` filtra antes de agrupar (por fecha) y el `HAVING` filtra después de agrupar (por el total gastado), que es justamente la diferencia que nos interesaba mostrar.

## Conclusiones

En esta etapa pudimos comprobar que el modelo de FarmaBlue permite sacar la información que necesita el negocio: comprobantes con sus subtotales, totales de ventas por período y análisis de compras por cliente y producto. Guardar el precio histórico en el detalle de la venta resultó clave para que los cálculos sean correctos aunque cambien los precios. Todas las consultas fueron ejecutadas y probadas en SQL Server Management Studio.
