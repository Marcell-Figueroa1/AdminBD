-- Crear la base de datos
CREATE DATABASE sistema_ventas;
-- Seleccionar la base de datos para trabajar
USE sistema_ventas;

-- Creamos la tabla tipo_usuario
CREATE TABLE tipo_usuarios (
id INT AUTO_INCREMENT PRIMARY KEY,
-- Identificador único
nombre_tipo VARCHAR(50) NOT NULL,
-- Tipo de usuario (Admin, Cliente)

-- Campos de auditoría

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación

updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación

created_by INT,-- Usuario que crea

updated_by INT,-- Usuario que modifica

deleted BOOLEAN DEFAULT FALSE -- Borrado lógico

);

-- Tabla para usuarios

CREATE TABLE usuarios (

id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY, -- Id único

nombre_tipo VARCHAR(100) NOT NULL, -- Nombre de usuario

correo VARCHAR(100) UNIQUE, -- Correo electrónico único

tipo_usuario_id INT, -- Relación a tipo_usuario

-- Campos de auditoría

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación

updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación

created_by INT,-- Usuario que crea

updated_by INT,-- Usuario que modifica

deleted BOOLEAN DEFAULT FALSE -- Borrado lógico

);

ALTER TABLE usuarios -- Modificar tabla
-- Agregar una restricción (FK)

ADD CONSTRAINT fk_usuario_tipo_usuario

-- Añade referencia(FK)

FOREIGN KEY (tipo_usuario_id) REFERENCES
tipo_usuarios(id);
