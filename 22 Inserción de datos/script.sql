create DATABASE sistema_ventas4E;

USE sistema_ventas4E;

CREATE TABLE tipo_usuarios(
id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único
nombre_tipo_usuario VARCHAR(50) NOT NULL, -- Tipo de usuario (Admin, Cliente)
descripcion_tipo_usuario VARCHAR(200) NOT NULL, -- Descripción del tipo usuario
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT, -- Usuario que crea
updated_by INT, -- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

-- Tabla para usuarios
CREATE TABLE usuarios(
id_usuario INT AUTO_INCREMENT PRIMARY KEY, -- Id único
username VARCHAR(100) NOT NULL, -- Nombre de usuario
correo VARCHAR(100) UNIQUE, -- Correo electrónico único
password VARCHAR(100) NOT NULL, -- Contraseña del usuario
tipo_usuario_id INT, -- Relación a tipo_usuario
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT,-- Usuario que crea
updated_by INT,-- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

CREATE TABLE productos (
id_productos INT AUTO_INCREMENT PRIMARY KEY, -- Id único
nombre_productos VARCHAR(100) NOT NULL, 
precio FLOAT NOT NULL, 
stock INT DEFAULT 0, 
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT,-- Usuario que crea
updated_by INT,-- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

CREATE TABLE ventas(
id_ventas INT AUTO_INCREMENT PRIMARY KEY, -- Id único
usuario_id VARCHAR(50) NOT NULL, 
fecha_venta DATETIME,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT,-- Usuario que crea
updated_by INT,-- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

CREATE TABLE detalle_ventas (
id_detalle_ventas INT AUTO_INCREMENT PRIMARY KEY, -- Id único
venta_id INT NOT NULL, 
producto_id INT NOT NULL,
cantidad_vendida INT,
precio_unitario FLOAT NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT,-- Usuario que crea
updated_by INT,-- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

-- RELACION ENTRETABLE USUARIO Y TIPO USUARIO 
ALTER TABLE usuarios -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_usuario_tipo_usuario
-- Añade referencia(FK)
FOREIGN KEY (tipo_usuario_id) REFERENCES
tipo_usuarios(id_tipo_usuario);

-- crear relacion entre usuario y venta --
ALTER TABLE ventas -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_usuario_ventas5
-- Añade referencia(FK)
FOREIGN KEY (id_ventas) REFERENCES
usuarios(id_usuario);

-- RELACION ENTRE detalle Y VENTA 
ALTER TABLE detalle_ventas  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_usuario_ventas
-- Añade referencia(FK)
FOREIGN KEY (venta_id) REFERENCES
ventas(id_ventas);

-- RELACION ENTRE PRODUCTO Y detalle 
ALTER TABLE detalle_ventas  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_producto_ventas
-- Añade referencia(FK)
FOREIGN KEY (producto_id) REFERENCES
productos(id_productos);


-- Insertamos el usuario principal --
INSERT INTO usuarios (
    username, correo, password, tipo_usuario_id, created_by, updated_by
)
VALUES (
    'sistema',
    'sistema@plataforma.cl', -- Contraseña encriptada (ejemplo realista con bcrypt)
    '$2y$10$2pEjT0G2k9YzHs1oZ',
    NULL,
    NULL,
    NULL
);

INSERT INTO tipo_usuarios (
    nombre_tipo_usuario,
    descripcion_tipo_usuario,
    created_by,
    updated_by
)
VALUES (
    'Administrador',
    'Accede a todas las funciones del sistema, incluida la administración de usuarios.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
);

-- Insertamos los tipos de usuario --

INSERT INTO tipo_usuarios (
    nombre_tipo_usuario,
    descripcion_tipo_usuario,
    created_by,
    updated_by
)
VALUES (
    'Vendedor',
    'Registra ventas, aplica descuentos, genera facturas o tickets.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
),
(
    'Cliente',
    'Puede ver productos, relizar pedidos, realizar pagos y ver su historial de compras.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
),
(
    'Gerente',
    'Accede a reportes de ventas, rendimiento de vendedores, gestión de inventario y autoriza descuentos o devoluciones.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
);

-- Insertar un nuevo usuario real --
INSERT INTO usuarios (
    username, correo, password, tipo_usuario_id, created_by, updated_by
)
VALUES (
    'Mark',
    'MK03', 
    'markorsini@liceovvh.cl',
    1,  -- tipo: Administrador
	1, 1  -- creado por el usuario "sistema"
),
(
    'Marcell',
    'porotoVerde17', 
    'marcellfigueroa@liceovvh.cl',
    2,  -- tipo: Administrador
	1, 1  -- creado por el usuario "sistema"
),
(
    'Benjamin',
    'wuatonTeton',
    'benjaminrios@liceovvh.cl',
    3,  -- tipo: Administrador
	1, 1  -- creado por el usuario "sistema"
),
(
    'Vicente',
    'brawlStar', -- bcrypt hasheado
    'manuelulloa@liceovvh.cl',
    4,  -- tipo: Administrador
	1, 1  -- creado por el usuario "sistema"
);


-- Lista de los usuarios activos --
SELECT username
FROM usuarios
WHERE deleted = 'False';

-- Lista de los usuarios de tipo "Administrador -- 
SELECT username
FROM usuarios
WHERE tipo_usuario_id = 1;

-- Lista de los nombres que empiezan con "M" -- 
SELECT username
FROM usuarios
WHERE username LIKE 'M%'