
select *, (cantidad * precio_unitario_historico  )as subTotales 
from detalle_venta ;

select f.id_venta ,SUM(f.cantidad * f.precio_unitario_historico) as total
from detalle_venta AS f
group by f.id_venta;

select f.id_venta,f.fecha_Hora,sum (f.monto_total) AS TOTAL_VENTA
from venta AS f
WHERE fecha_Hora BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59'
group by f.id_venta,f.fecha_Hora;

select 
cl.Razon_social,
    COUNT(v.id_venta) AS cantidad_compras,
    SUM(dv.cantidad * dv.precio_unitario_historico) AS total_gastado
from venta as v
inner join cliente as cl on cl.Codigo_cliente = v.Codigo_Cliente
inner join detalle_venta as dv on dv.id_venta = v.id_venta
where v.fecha_Hora BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59'
group by  cl.Razon_social 
having SUM(dv.cantidad * dv.precio_unitario_historico) > 200000;



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
