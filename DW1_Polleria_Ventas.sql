--=========================================================
-- DATAWAREHOUSE 1: VENTAS 
--=========================================================
CREATE DATABASE DW_Polleria_Ventas;
GO

USE DW_Polleria_Ventas;
GO

--=========================================================
-- DIMENSIONES
--=========================================================
CREATE TABLE Dim_Tiempo (
    id_tiempo INT PRIMARY KEY,           
    fecha DATE NOT NULL UNIQUE,
    dia INT NOT NULL,
    mes INT NOT NULL,
    trimestre INT NOT NULL,
    anio INT NOT NULL
);

CREATE TABLE Dim_Cliente (
    id_cliente INT PRIMARY KEY,          
    dni VARCHAR(8) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NULL
);

CREATE TABLE Dim_Producto (
    id_producto INT PRIMARY KEY,        
    nombre_producto VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200) NULL,
    precio DECIMAL(6,2) NOT NULL,
    categoria VARCHAR(80) NOT NULL       
);

CREATE TABLE Dim_Sucursal (
    id_sucursal INT PRIMARY KEY,        
    nombre_sucursal VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    distrito VARCHAR(50) NOT NULL
);

CREATE TABLE Dim_Empleado (
    id_empleado INT PRIMARY KEY,        
    dni VARCHAR(8) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL          
);

CREATE TABLE Dim_Metodo_Pago (
    id_metodo_pago INT PRIMARY KEY,      
    nombre_metodo VARCHAR(50) NOT NULL,
    estado VARCHAR(20) NOT NULL
);

--=========================================================
-- TABLA DE HECHOS
--=========================================================
CREATE TABLE Hechos_Ventas (
    id_hecho_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo INT NOT NULL,
    id_producto INT NOT NULL,
    id_cliente INT NOT NULL,
    id_sucursal INT NOT NULL,
    id_empleado INT NOT NULL,
    id_pedido INT NOT NULL,              
    id_metodo_pago INT NOT NULL,        
    cantidad_vendida INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,   
    subtotal DECIMAL(10,2) NOT NULL,
    cantidad_pedidos INT NOT NULL,
    FOREIGN KEY (id_tiempo) REFERENCES Dim_Tiempo(id_tiempo),
    FOREIGN KEY (id_producto) REFERENCES Dim_Producto(id_producto),
    FOREIGN KEY (id_cliente) REFERENCES Dim_Cliente(id_cliente),
    FOREIGN KEY (id_sucursal) REFERENCES Dim_Sucursal(id_sucursal),
    FOREIGN KEY (id_empleado) REFERENCES Dim_Empleado(id_empleado),
    FOREIGN KEY (id_metodo_pago) REFERENCES Dim_Metodo_Pago(id_metodo_pago),

);
GO

