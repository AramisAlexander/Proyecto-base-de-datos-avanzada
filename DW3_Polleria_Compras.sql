--=========================================================
-- DATAWAREHOUSE 3: COMPRAS 
--=========================================================
CREATE DATABASE DW_Polleria_Compras;
GO

USE DW_Polleria_Compras;
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

CREATE TABLE Dim_Producto (
    id_producto INT PRIMARY KEY,        
    nombre_producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(80) NOT NULL,     
    descripcion VARCHAR(200) NULL
);

CREATE TABLE Dim_Proveedor (
    id_proveedor INT PRIMARY KEY,       
    ruc VARCHAR(11) NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    telefono VARCHAR(15) NULL
);

CREATE TABLE Dim_Empleado (
    id_empleado INT PRIMARY KEY,         
    dni VARCHAR(8) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL           
);

CREATE TABLE Dim_EstadoCompra (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    estado VARCHAR(20) NOT NULL UNIQUE   
);

--=========================================================
-- TABLA DE HECHOS
--=========================================================
CREATE TABLE Hechos_Compras (
    id_hecho_compra INT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo INT NOT NULL,
    id_producto INT NOT NULL,
    id_proveedor INT NOT NULL,
    id_empleado INT NOT NULL,
    id_estado INT NOT NULL,
    id_compra INT NOT NULL,              
    cantidad_comprada INT NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,     
    subtotal_compra DECIMAL(10,2) NOT NULL,
    total_compra DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_tiempo) REFERENCES Dim_Tiempo(id_tiempo),
    FOREIGN KEY (id_producto) REFERENCES Dim_Producto(id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES Dim_Proveedor(id_proveedor),
    FOREIGN KEY (id_empleado) REFERENCES Dim_Empleado(id_empleado),
    FOREIGN KEY (id_estado) REFERENCES Dim_EstadoCompra(id_estado)
);
GO

