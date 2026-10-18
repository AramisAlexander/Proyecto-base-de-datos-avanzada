--=========================================================
-- DATAWAREHOUSE 2: PEDIDOS 
--=========================================================
CREATE DATABASE DW_Polleria_Pedidos;
GO

USE DW_Polleria_Pedidos;
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

CREATE TABLE Dim_Sucursal (
    id_sucursal INT PRIMARY KEY,        
    nombre_sucursal VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    distrito VARCHAR(50) NOT NULL
);

CREATE TABLE Dim_TipoPedido (
    id_tipo_pedido INT IDENTITY(1,1) PRIMARY KEY,
    tipo_pedido VARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE Dim_EstadoPedido (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    estado_pedido VARCHAR(20) NOT NULL UNIQUE  
);

--=========================================================
-- TABLA DE HECHOS
--=========================================================
CREATE TABLE Hechos_Pedidos (
    id_pedido INT PRIMARY KEY,           
    id_tiempo INT NOT NULL,
    id_cliente INT NOT NULL,
    id_sucursal INT NOT NULL,
    id_tipo_pedido INT NOT NULL,
    id_estado INT NOT NULL,
    cantidad_pedidos INT NOT NULL,
    monto_pedidos DECIMAL(10,2) NOT NULL,
    cantidad_productos INT NOT NULL,     
    FOREIGN KEY (id_tiempo) REFERENCES Dim_Tiempo(id_tiempo),
    FOREIGN KEY (id_cliente) REFERENCES Dim_Cliente(id_cliente),
    FOREIGN KEY (id_sucursal) REFERENCES Dim_Sucursal(id_sucursal),
    FOREIGN KEY (id_tipo_pedido) REFERENCES Dim_TipoPedido(id_tipo_pedido),
    FOREIGN KEY (id_estado) REFERENCES Dim_EstadoPedido(id_estado)
);
GO

