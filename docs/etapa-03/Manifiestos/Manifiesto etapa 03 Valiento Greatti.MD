Contribución individual – Etapa 03
Equipo: 32

Integrante: Valentino Greatti

DNI: 46.843.191

Fecha: 2026-09-30

Materia: Base de Datos

Aporte realizado
En esta etapa participé en el desarrollo y revisión de los scripts SQL para la creación del esquema DDL (Data Definition Language) e inserción de datos DML (Data Manipulation Language) de la base de datos FarmaBlue. Analicé la coherencia de las claves primarias, claves foráneas, tipos de datos y restricciones (CHECK, UNIQUE, DEFAULT) necesarias para garantizar la integridad referencial del sistema.

Decisiones en las que participé
Participé en la validación de las relaciones entre entidades complejas, en especial la asociación entre proveedores, compras, lotes y ventas. Se resolvió ajustar la consistencia de nombres de atributos clave (como id_proveedor en lugar de variaciones ortográficas) para asegurar la compatibilidad total de los scripts al momento de compilar las claves foráneas con reglas de actualización en cascada (ON UPDATE CASCADE).

Problemas o dificultades identificadas
La principal dificultad radicó en la detección de inconsistencias léxicas en los nombres de las tablas y campos clave (por ejemplo, Provedor vs Proveedor y id_provedor vs id_proveedor), lo cual generaba fallos de referencia al intentar ejecutar el DDL para crear las relaciones entre lote, compra y Proveedor.

Soluciones o propuestas realizadas
Propuse la normalización y estandarización del nombre de la entidad Proveedor y su clave primaria en todo el script SQL. De igual forma, verifiqué que los registros DML para las 10 tablas mantuvieran una correspondencia exacta con las claves generadas autoincrementalmente (IDENTITY), asegurando la inserción fluida de datos de prueba válidos para clientes, productos, proveedores, lotes y transacciones.

Reflexión individual
Durante esta etapa consolidé la comprensión de que la definición DDL no solo requiere una sintaxis correcta, sino una rigurosa consistencia en la nomenclatura y tipado para evitar inconsistencias referenciales. Además, comprendí el valor práctico de poblar la base de datos con scripts DML estructurados para comprobar en la práctica la validez de las reglas de negocio y restricciones aplicadas.
