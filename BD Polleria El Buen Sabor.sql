--=========================================================
-- CREACIÓN Y USO DE LA BASE DE DATOS
--=========================================================
CREATE DATABASE PolleriaElBuenSabor;
GO

USE PolleriaElBuenSabor;
GO

--=========================================================
-- 0. TABLA SUCURSAL 
--=========================================================
CREATE TABLE Sucursal (
    id_sucursal INT IDENTITY(1,1) PRIMARY KEY,
    nombre_sucursal VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    distrito VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

--=========================================================
-- 1. TABLA CARGOS
--========================================================= 
CREATE TABLE Cargos (
    id_cargo INT IDENTITY(1,1) PRIMARY KEY,
    nombre_cargo VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);

--=========================================================
-- 2. TABLA CLIENTES
--=========================================================
CREATE TABLE Clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    dni VARCHAR(8) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    correo VARCHAR(100),
    direccion VARCHAR(200)
);

--========================================================= 
-- 3. TABLA EMPLEADOS (MODIFICADA: id_sucursal FK)
--=========================================================
CREATE TABLE Empleados (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    dni VARCHAR(8) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    id_cargo INT NOT NULL,
    id_sucursal INT NOT NULL, -- Relación de sucursal laboral
    FOREIGN KEY (id_cargo) REFERENCES Cargos(id_cargo),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

--=========================================================
-- 4. TABLA CATEGORIAS
--=========================================================
CREATE TABLE Categorias (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);

--=========================================================
-- 5. TABLA PRODUCTOS
--=========================================================
CREATE TABLE Productos (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200),
    precio DECIMAL(6,2) NOT NULL,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

--=========================================================
-- 6. TABLA METODOS PAGO
--=========================================================
CREATE TABLE MetodosPago (
    id_metodo_pago INT IDENTITY(1,1) PRIMARY KEY,
    nombre_metodo VARCHAR(50) NOT NULL UNIQUE,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

--=========================================================
-- 7. TABLA PROVEEDORES
--=========================================================
CREATE TABLE Proveedores (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    ruc VARCHAR(11) NOT NULL UNIQUE,
    razon_social VARCHAR(150) NOT NULL,
    telefono VARCHAR(15),
    direccion VARCHAR(200),
    correo VARCHAR(100)
);

--=========================================================
-- 8. TABLA MESAS (MODIFICADA: id_sucursal FK)
--=========================================================
CREATE TABLE Mesas (
    id_mesa INT IDENTITY(1,1) PRIMARY KEY,
    numero_mesa INT NOT NULL,
    capacidad INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'DISPONIBLE',
    id_sucursal INT NOT NULL, -- Mesas físicas de cada local
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

--=========================================================
-- 9. TABLA REPARTIDORES
--=========================================================
CREATE TABLE Repartidores (
    id_repartidor INT IDENTITY(1,1) PRIMARY KEY,
    dni VARCHAR(8) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    tipo_vehiculo VARCHAR(30) NOT NULL DEFAULT 'Motorizado',
    placa NVARCHAR(10),
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

--=========================================================
-- 10. TABLA PROMOCIONES
--=========================================================
CREATE TABLE Promociones (
    id_promocion INT IDENTITY(1,1) PRIMARY KEY,
    nombre_promocion VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descuento DECIMAL(5,2) NOT NULL DEFAULT 0,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

--=========================================================
-- 11. TABLA PEDIDOS (MODIFICADA: id_sucursal FK)
--=========================================================
CREATE TABLE Pedidos (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    fecha_pedido DATE NOT NULL,
    hora_pedido TIME NOT NULL,
    tipo_pedido VARCHAR(20) NOT NULL,
    estado_pedido VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    total DECIMAL(10,2) NOT NULL,
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    id_mesa INT NULL,
    id_metodo_pago INT NOT NULL,
    id_sucursal INT NOT NULL, -- Identificar de dónde es el ingreso monetario
    CHECK (tipo_pedido IN ('LOCAL', 'RECOJO', 'DELIVERY')),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_mesa) REFERENCES Mesas(id_mesa),
    FOREIGN KEY (id_metodo_pago) REFERENCES MetodosPago(id_metodo_pago),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

--=========================================================
-- 12. TABLA DETALLE PEDIDO
--=========================================================
CREATE TABLE DetallePedido (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    id_promocion INT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_promocion) REFERENCES Promociones(id_promocion)
);

--=========================================================
-- 13. TABLA INVENTARIO
--=========================================================
CREATE TABLE Inventario (
    id_inventario INT IDENTITY(1,1) PRIMARY KEY,
    fecha_movimiento DATE NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL,
    cantidad INT NOT NULL,
    observacion VARCHAR(200),
    id_producto INT NOT NULL,
    CHECK (tipo_movimiento IN ('ENTRADA', 'SALIDA')),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

--=========================================================
-- 14. TABLA RESERVAS
--=========================================================
CREATE TABLE Reservas (
    id_reserva INT IDENTITY(1,1) PRIMARY KEY,
    fecha_reserva DATE NOT NULL,
    hora_reserva TIME NOT NULL,
    cantidad_personas INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    id_cliente INT NOT NULL,
    id_mesa INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_mesa) REFERENCES Mesas(id_mesa)
);

--=========================================================
-- 15. TABLA DELIVERY
--=========================================================
CREATE TABLE Delivery (
    id_delivery INT IDENTITY(1,1) PRIMARY KEY,
    direccion_entrega VARCHAR(200) NOT NULL,
    fecha_entrega DATE,
    hora_entrega TIME,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    id_pedido INT NOT NULL UNIQUE,
    id_repartidor INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_repartidor) REFERENCES Repartidores(id_repartidor)
);

--=========================================================
-- 16. TABLA DETALLE PROMOCION
--=========================================================
CREATE TABLE DetallePromocion (
    id_detalle_promocion INT IDENTITY(1,1) PRIMARY KEY,
    cantidad INT NOT NULL,
    id_promocion INT NOT NULL,
    id_producto INT NOT NULL,
    FOREIGN KEY (id_promocion) REFERENCES Promociones(id_promocion),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

--=========================================================
-- 17. TABLA COMPRAS
--=========================================================
CREATE TABLE Compras (
    id_compra INT IDENTITY(1,1) PRIMARY KEY,
    fecha_compra DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'REGISTRADA',
    id_proveedor INT NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

--=========================================================
-- 18. TABLA DETALLE COMPRA
--=========================================================
CREATE TABLE DetalleCompra (
    id_detalle_compra INT IDENTITY(1,1) PRIMARY KEY,
    cantidad INT NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES Compras(id_compra),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

--=========================================================
-- 19. TABLA GASTOS 
--=========================================================
CREATE TABLE Gastos (
    id_gasto INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(200) NOT NULL,
    tipo_gasto VARCHAR(50) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_gasto DATE NOT NULL,
    id_empleado INT NOT NULL,
    id_sucursal INT NOT NULL, 
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal));

--=========================================================
-- 20. TABLA COMPROBANTES
--=========================================================
CREATE TABLE Comprobantes (
    id_comprobante INT IDENTITY(1,1) PRIMARY KEY,
    tipo_comprobante VARCHAR(20) NOT NULL,
    serie VARCHAR(10) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    fecha_emision DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    id_pedido INT NOT NULL UNIQUE,
    CHECK (tipo_comprobante IN ('BOLETA', 'FACTURA')),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);
GO

