-- Trabajo Práctico Integrados - Bases de Datos II.
-- Geronimo Mercante
-- Gianfranco Andreachi
-- Axel Ian Berger

-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Creación de la base de datos y tablas usando MySQL Workbench Forward Engineering
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `TechStore` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `TechStore` ;

-- -----------------------------------------------------
-- Tabla `TechStore`.`categoria_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`categoria_producto` (
  `id_categoria_producto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_categoria_producto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabla `TechStore`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`producto` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `id_categoria_producto` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  PRIMARY KEY (`id_producto`),
  INDEX `fk_producto_categoria1_idx` (`id_categoria_producto` ASC) VISIBLE,
  CONSTRAINT `fk_producto_categoria1`
    FOREIGN KEY (`id_categoria_producto`)
    REFERENCES `TechStore`.`categoria_producto` (`id_categoria_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabla `TechStore`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre_cliente` VARCHAR(100) NOT NULL,
  `direccion` VARCHAR(255) NOT NULL,
  `correo_electronico` VARCHAR(100) NOT NULL,
  `numero_telefono` VARCHAR(25) NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE INDEX `correo_electronico_UNIQUE` (`correo_electronico` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabla `TechStore`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`proveedor` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre_proveedor` VARCHAR(100) NOT NULL,
  `contacto` VARCHAR(100) NOT NULL,
  `direccion` VARCHAR(255) NOT NULL,
  `correo_electronico` VARCHAR(100) NOT NULL,
  `numbero_telefono` VARCHAR(25) NULL,
  PRIMARY KEY (`id_proveedor`),
  UNIQUE INDEX `correo_electronico_UNIQUE` (`correo_electronico` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabla `TechStore`.`venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`venta` (
  `id_venta` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `fecha_pedido` DATE NOT NULL,
  `estado_pedido` VARCHAR(45) NOT NULL,
  `metodo_pago` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_venta`),
  INDEX `fk_pedido_cliente_idx` (`id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `TechStore`.`cliente` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabla `TechStore`.`stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`stock` (
  `id_stock` INT NOT NULL AUTO_INCREMENT COMMENT 'Esta entidad, se podria haber resumido y absorverse con movimiento_stock, la idea de esta tabla \"stock\" es por la escalabilidad de la base de datos, porque el dia de mañana podriamos tener exito, y tener una sucursual con que maneje distintos stocks, simplemente agregando una tabla \"sucursales o deposito\".',
  `id_producto` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`id_stock`),
  INDEX `fk_inventario_producto1_idx` (`id_producto` ASC) VISIBLE,
  CONSTRAINT `fk_inventario_producto1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `TechStore`.`producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabla `TechStore`.`movimiento_stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`movimiento_stock` (
  `id_movimiento_stock` INT NOT NULL AUTO_INCREMENT,
  `id_stock` INT NOT NULL,
  `cantidad` INT NOT NULL COMMENT 'la cantidad puede ser negativa o positiva\n',
  INDEX `fk_stock_movement_stock1_idx` (`id_stock` ASC) VISIBLE,
  PRIMARY KEY (`id_movimiento_stock`),
  CONSTRAINT `fk_stock_movement_stock1`
    FOREIGN KEY (`id_stock`)
    REFERENCES `TechStore`.`stock` (`id_stock`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabla `TechStore`.`venta_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`venta_producto` (
  `id_venta_producto` INT NOT NULL AUTO_INCREMENT,
  `id_venta` INT NOT NULL,
  `id_producto` INT NOT NULL,
  `id_movimiento_stock` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `nombre_producto` VARCHAR(100) NOT NULL,
  INDEX `fk_producto_pedido_pedido1_idx` (`id_venta` ASC) VISIBLE,
  INDEX `fk_producto_pedido_producto1_idx` (`id_producto` ASC) VISIBLE,
  INDEX `fk_venta_item_stock_movement1_idx` (`id_movimiento_stock` ASC) VISIBLE,
  PRIMARY KEY (`id_venta_producto`),
  CONSTRAINT `fk_producto_pedido_pedido1`
    FOREIGN KEY (`id_venta`)
    REFERENCES `TechStore`.`venta` (`id_venta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_producto_pedido_producto1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `TechStore`.`producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venta_item_stock_movement1`
    FOREIGN KEY (`id_movimiento_stock`)
    REFERENCES `TechStore`.`movimiento_stock` (`id_movimiento_stock`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabla `TechStore`.`compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`compra` (
  `id_compra` INT NOT NULL AUTO_INCREMENT,
  `id_proveedor` INT NOT NULL,
  `fecha_compra` DATE NOT NULL,
  PRIMARY KEY (`id_compra`),
  INDEX `fk_compra_proveedor_proveedor1_idx` (`id_proveedor` ASC) VISIBLE,
  CONSTRAINT `fk_compra_proveedor_proveedor1`
    FOREIGN KEY (`id_proveedor`)
    REFERENCES `TechStore`.`proveedor` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabla `TechStore`.`compra_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TechStore`.`compra_producto` (
  `id_compra_producto` INT NOT NULL AUTO_INCREMENT,
  `id_compra` INT NOT NULL,
  `id_producto` INT NOT NULL,
  `id_movimiento_stock` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_compra_producto`),
  INDEX `fk_compra_item_compra1_idx` (`id_compra` ASC) VISIBLE,
  INDEX `fk_compra_item_producto1_idx` (`id_producto` ASC) VISIBLE,
  INDEX `fk_compra_item_stock_movement1_idx` (`id_movimiento_stock` ASC) VISIBLE,
  CONSTRAINT `fk_compra_item_compra1`
    FOREIGN KEY (`id_compra`)
    REFERENCES `TechStore`.`compra` (`id_compra`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_item_producto1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `TechStore`.`producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_item_stock_movement1`
    FOREIGN KEY (`id_movimiento_stock`)
    REFERENCES `TechStore`.`movimiento_stock` (`id_movimiento_stock`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Inserción de datos - usando MySQL Workbench Forward Engineering
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

-- -----------------------------------------------------
-- Datos para la tabla `TechStore`.`categoria_producto`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`categoria_producto` (`id_categoria_producto`, `nombre`) VALUES (1, 'Smartphones');
INSERT INTO `TechStore`.`categoria_producto` (`id_categoria_producto`, `nombre`) VALUES (2, 'Laptops');
INSERT INTO `TechStore`.`categoria_producto` (`id_categoria_producto`, `nombre`) VALUES (3, 'Tablets');
INSERT INTO `TechStore`.`categoria_producto` (`id_categoria_producto`, `nombre`) VALUES (4, 'Accesorios');
INSERT INTO `TechStore`.`categoria_producto` (`id_categoria_producto`, `nombre`) VALUES (5, 'Monitores');

COMMIT;


-- -----------------------------------------------------
-- Datos para la tabla  `TechStore`.`producto`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`producto` (`id_producto`, `id_categoria_producto`, `nombre`, `precio`, `descripcion`) VALUES (1, 1, 'iPhone 15 Pro Max', 850000, 'Último modelo de iPhone');
INSERT INTO `TechStore`.`producto` (`id_producto`, `id_categoria_producto`, `nombre`, `precio`, `descripcion`) VALUES (2, 1, 'Samsung Galaxy S23 Ultra', 999999, 'Potente celular de Samsung');
INSERT INTO `TechStore`.`producto` (`id_producto`, `id_categoria_producto`, `nombre`, `precio`, `descripcion`) VALUES (3, 2, 'MacBook Pro 16', 650000, 'Portátil de alto rendimiento');
INSERT INTO `TechStore`.`producto` (`id_producto`, `id_categoria_producto`, `nombre`, `precio`, `descripcion`) VALUES (4, 3, 'iPad Air', 779999, 'Tablet ligera y potente');
INSERT INTO `TechStore`.`producto` (`id_producto`, `id_categoria_producto`, `nombre`, `precio`, `descripcion`) VALUES (5, 4, 'AirPods Pro', 450000, 'Auriculares inalambricos con cancelación de ruido');
INSERT INTO `TechStore`.`producto` (`id_producto`, `id_categoria_producto`, `nombre`, `precio`, `descripcion`) VALUES (6, 5, 'LG 19\" 144Hz', 110000, 'Monitor gamer con alta taza de refrigeración y fluida imagen.');

COMMIT;


-- -----------------------------------------------------
-- Datos para la tabla  `TechStore`.`cliente`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`cliente` (`id_cliente`, `nombre_cliente`, `direccion`, `correo_electronico`, `numero_telefono`) VALUES (1, 'Geronimo Mercante', 'Paseo del Bosque 234', 'mercantegero@gmail.com', '2345653853');
INSERT INTO `TechStore`.`cliente` (`id_cliente`, `nombre_cliente`, `direccion`, `correo_electronico`, `numero_telefono`) VALUES (2, 'Gianfranco Andreachi', 'Avenida Las Heras 6499', 'giania@gmail.com', '1154545454');
INSERT INTO `TechStore`.`cliente` (`id_cliente`, `nombre_cliente`, `direccion`, `correo_electronico`, `numero_telefono`) VALUES (3, 'Axel Ian Berger', 'Plaza Mayor', 'axelberger@gmail.com', '1156656565');
INSERT INTO `TechStore`.`cliente` (`id_cliente`, `nombre_cliente`, `direccion`, `correo_electronico`, `numero_telefono`) VALUES (4, 'Sofia Leonardelli', 'Paseo Colón', 'sofi_sofi@gmail.com', '1156562222');

COMMIT;


-- -----------------------------------------------------
-- Datos para la tabla `TechStore`.`proveedor`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`proveedor` (`id_proveedor`, `nombre_proveedor`, `contacto`, `direccion`, `correo_electronico`, `numbero_telefono`) VALUES (1, 'ElectroParts Ltd.', 'Jane Smith', 'Av. Santa Fe 5434', 'sales@electroparts.com', '111-222-333');
INSERT INTO `TechStore`.`proveedor` (`id_proveedor`, `nombre_proveedor`, `contacto`, `direccion`, `correo_electronico`, `numbero_telefono`) VALUES (2, 'TechSupplier Inc.', 'John Doe', 'Paseo Colón 4491', 'sales@techsuppliear.com', '444-555-666');
INSERT INTO `TechStore`.`proveedor` (`id_proveedor`, `nombre_proveedor`, `contacto`, `direccion`, `correo_electronico`, `numbero_telefono`) VALUES (3, 'SonicArg SA.', 'Lucio Ariel Jorge', 'Av. Rivadavia 143', 'sales@sonicarg.com.ar', '777-888-999');

COMMIT;


-- -----------------------------------------------------
-- Datos para la tabla `TechStore`.`venta`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (1, 1, '2024-06-26', 'entregado', 'Tarjeta de crédito');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (2, 2, '2024-06-28', 'pendiente', 'Transferencia bancaria');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (3, 3, '2024-06-27', 'pendiente', 'Efectivo');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (4, 2, '2024-08-02', 'pendiente', 'Mercado Pago');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (5, 3, '2024-06-25', 'entregado', 'Ualá');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (6, 3, '2024-01-18', 'pendiente', 'Efectivo');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (7, 3, '2023-12-30', 'entregado', 'Mercado Pago');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (8, 1, '2023-12-30', 'entregado', 'Transferencia bancaria');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (9, 2, '2024-06-28', 'cancelado', 'PayPal');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (10, 4, '2024-06-24', 'enviado', 'Tarjeta de crédito');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (11, 1, '2024-05-01', 'entregado', 'Mercado Pago');
INSERT INTO `TechStore`.`venta` (`id_venta`, `id_cliente`, `fecha_pedido`, `estado_pedido`, `metodo_pago`) VALUES (12, 2, '2024-06-25', 'entregado', 'Transferencia bancaria');

COMMIT;


-- -----------------------------------------------------
-- Datos para la tabla  `TechStore`.`stock`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`stock` (`id_stock`, `id_producto`, `cantidad`) VALUES (1, 1, 50);
INSERT INTO `TechStore`.`stock` (`id_stock`, `id_producto`, `cantidad`) VALUES (2, 2, 30);
INSERT INTO `TechStore`.`stock` (`id_stock`, `id_producto`, `cantidad`) VALUES (3, 3, 100);
INSERT INTO `TechStore`.`stock` (`id_stock`, `id_producto`, `cantidad`) VALUES (4, 4, 5);
INSERT INTO `TechStore`.`stock` (`id_stock`, `id_producto`, `cantidad`) VALUES (5, 5, 33);
INSERT INTO `TechStore`.`stock` (`id_stock`, `id_producto`, `cantidad`) VALUES (6, 6, 3);

COMMIT;


-- -----------------------------------------------------
-- Datos para la tabla `TechStore`.`movimiento_stock`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (1, 1, -10);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (2, 2, -5);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (3, 3, -2);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (4, 5, 30);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (5, 1, 10);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (6, 2, 20);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (7, 3, 30);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (8, 4, -5);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (9, 5, -1);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (10, 2, -3);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (11, 3, -2);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (12, 1, -1);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (13, 1, -2);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (14, 4, -2);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (15, 4, -1);
INSERT INTO `TechStore`.`movimiento_stock` (`id_movimiento_stock`, `id_stock`, `cantidad`) VALUES (16, 6, -2);

COMMIT;


-- -----------------------------------------------------
-- Datos para la tabla `TechStore`.`venta_producto`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (1, 1, 1, 1, 10, 850000, 'iPhone 15 Pro Max');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (2, 2, 2, 2, 5, 999999, 'Samsung Galaxy S23 Ultra');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (3, 3, 3, 3, 2, 650000, 'MacBook Pro 16');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (4, 4, 4, 8, 5, 779999, 'iPad Air');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (5, 5, 5, 9, 1, 450000, 'AirPods Pro');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (6, 6, 2, 10, 3, 999999, 'Samsung Galaxy S23 Ultra');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (7, 7, 3, 11, 2, 650000, 'MacBook Pro 16');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (8, 8, 1, 12, 1, 850000, 'iPhone 14 Pro Max');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (9, 9, 1, 13, 2, 850000, 'iPhone 15 Pro Max');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (10, 10, 4, 14, 2, 779999, 'iPad Air');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (11, 11, 4, 15, 1, 450000, 'AirPods Pro');
INSERT INTO `TechStore`.`venta_producto` (`id_venta_producto`, `id_venta`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`, `nombre_producto`) VALUES (12, 12, 6, 16, 2, 110000, 'LG 19\" 144hz');

COMMIT;


-- -----------------------------------------------------
-- Datos para la tabla `TechStore`.`compra`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`compra` (`id_compra`, `id_proveedor`, `fecha_compra`) VALUES (1, 1, '2024-06-10');
INSERT INTO `TechStore`.`compra` (`id_compra`, `id_proveedor`, `fecha_compra`) VALUES (2, 2, '2024-06-27');
INSERT INTO `TechStore`.`compra` (`id_compra`, `id_proveedor`, `fecha_compra`) VALUES (3, 3, '2024-06-27');
INSERT INTO `TechStore`.`compra` (`id_compra`, `id_proveedor`, `fecha_compra`) VALUES (4, 1, '2024-06-30');

COMMIT;


-- -----------------------------------------------------
-- Datos para la tabla `TechStore`.`compra_producto`
-- -----------------------------------------------------
START TRANSACTION;
USE `TechStore`;
INSERT INTO `TechStore`.`compra_producto` (`id_compra_producto`, `id_compra`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`) VALUES (1, 1, 5, 4, 30, 350000);
INSERT INTO `TechStore`.`compra_producto` (`id_compra_producto`, `id_compra`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`) VALUES (2, 2, 1, 5, 10, 750000);
INSERT INTO `TechStore`.`compra_producto` (`id_compra_producto`, `id_compra`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`) VALUES (3, 3, 2, 6, 20, 800000);
INSERT INTO `TechStore`.`compra_producto` (`id_compra_producto`, `id_compra`, `id_producto`, `id_movimiento_stock`, `cantidad`, `precio_unitario`) VALUES (4, 4, 3, 7, 30, 650999);

COMMIT;






-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Consultas SQL Específicas
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
use techstore;

-- -----------------------------------------------------------------
-- 1) Cantidad de pedidos mensuales
-- -----------------------------------------------------------------
SELECT 
	YEAR(fecha_pedido) AS "Año",
    MONTH(fecha_pedido) AS "Mes",
    COUNT(*) AS "Cantidad de pedidos"
FROM venta
GROUP BY YEAR(fecha_pedido), MONTH(fecha_pedido)
ORDER BY YEAR(fecha_pedido) DESC;


-- -----------------------------------------------------------------
-- 2) Cantidad mensual pedida de cada artículo
-- -----------------------------------------------------------------
SELECT 
	p.nombre AS "Artículo",
	YEAR(v.fecha_pedido) AS "Año", 
    MONTH(v.fecha_pedido) AS "Mes",  
    SUM(vp.cantidad) AS "Cantidad Pedida"
FROM venta_producto vp
	JOIN venta v ON vp.id_venta = v.id_venta
	JOIN producto p ON vp.id_producto = p.id_producto
GROUP BY YEAR(v.fecha_pedido), MONTH(v.fecha_pedido), p.nombre
ORDER BY vp.cantidad DESC;


-- -----------------------------------------------------------------
-- 3) Ranking de artículos
-- -----------------------------------------------------------------
SELECT 
	p.nombre AS "Artículo", 
    YEAR(v.fecha_pedido) AS "Año", 
    MONTH(v.fecha_pedido) AS "Mes", 
    SUM(vp.cantidad) AS "Cantidad pedida"
FROM venta_producto vp
	JOIN venta v ON vp.id_venta = v.id_venta
	JOIN producto p ON vp.id_producto = p.id_producto
GROUP BY p.nombre, YEAR(v.fecha_pedido), MONTH(v.fecha_pedido)
ORDER BY SUM(vp.cantidad) DESC;


-- -----------------------------------------------------------------
-- 4) Clientes con más pedidos realizados
-- -----------------------------------------------------------------
SELECT 
	c.nombre_cliente AS "Cliente", 
    COUNT(v.id_venta) AS "Cantidad de pedidos"
FROM venta v
	JOIN cliente c ON v.id_cliente = c.id_cliente
GROUP BY c.nombre_cliente
ORDER BY COUNT(v.id_venta) DESC;


-- -----------------------------------------------------------------
-- 5) Ingreso mensual total por ventas
-- -----------------------------------------------------------------
SELECT 
	YEAR(v.fecha_pedido) AS "Año", 
    MONTH(v.fecha_pedido) AS "Mes", 
    SUM(vp.cantidad * vp.precio_unitario) AS "Ingreso total"
FROM venta_producto vp
	JOIN venta v ON vp.id_venta = v.id_venta
GROUP BY YEAR(v.fecha_pedido), MONTH(v.fecha_pedido);


-- -----------------------------------------------------------------
-- 6) Productos con stock bajo
-- -----------------------------------------------------------------
SELECT 
	p.nombre AS "Producto",
    s.cantidad AS "Stock Disponible"
FROM stock s
	JOIN producto p ON s.id_producto = p.id_producto
WHERE s.cantidad <= 5;


-- -----------------------------------------------------------------
-- 7) Pedidos pendientes de entrega
-- -----------------------------------------------------------------
SELECT 
	v.id_venta AS "Pedido", 
    c.nombre_cliente AS "Cliente", 
    v.fecha_pedido AS "Fecha del Pedido",
    v.estado_pedido AS "Estado"
FROM venta v
	JOIN cliente c ON v.id_cliente = c.id_cliente
WHERE v.estado_pedido LIKE 'pendiente';


-- -----------------------------------------------------------------
-- 8) Productos más vendidos por categoría
-- -----------------------------------------------------------------
SELECT 
	cp.nombre AS "Categoría", 
    SUM(vp.cantidad) AS "Cantidad vendida"
FROM venta_producto vp
	JOIN producto p ON vp.id_producto = p.id_producto
	JOIN categoria_producto cp ON p.id_categoria_producto = cp.id_categoria_producto
GROUP BY cp.nombre
ORDER BY SUM(vp.cantidad) DESC;



-- -----------------------------------------------------------------
-- 9) Proveedores con más productos suministrados
-- -----------------------------------------------------------------
SELECT 
    pr.nombre_proveedor AS "Nombre del proveedor",
    pr.correo_electronico AS "Correo",
    c.fecha_compra as "Fecha de la compra",
    cp.cantidad as "Cantidad adquirida",
    p.nombre as "Articulo adquirido"
FROM proveedor pr
    JOIN compra c ON pr.id_proveedor = c.id_proveedor
    JOIN compra_producto cp ON c.id_compra = cp.id_compra
    JOIN producto p ON p.id_producto = cp.id_producto
ORDER BY cp.cantidad DESC;


-- -----------------------------------------------------------------
-- 10) Historial de compras de un cliente específico
-- -----------------------------------------------------------------
SELECT
    c.nombre_cliente AS "Nombre del cliente", 
	vp.precio_unitario AS "Precio unitario",
    vp.cantidad AS "Cantidad",
    vp.nombre_producto AS "Articulo comprado",
    v.fecha_pedido AS "Fecha del pedido",
    v.estado_pedido AS "Estado",
	v.metodo_pago AS "Metodo de pago"
 FROM venta_producto vp 
	JOIN venta v ON vp.id_venta = v.id_venta
    JOIN cliente c ON c.id_cliente = v.id_cliente
WHERE c.id_cliente = 3;

