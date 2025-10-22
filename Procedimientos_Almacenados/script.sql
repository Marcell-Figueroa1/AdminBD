CREATE DATABASE IF NOT EXISTS CRONODOSIS;
USE CRONODOSIS;

-- =========================
-- TABLA: TIPO DE GENERO
-- =========================
CREATE TABLE tipo_genero (
    id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre_genero VARCHAR(20) NOT NULL UNIQUE CHECK (CHAR_LENGTH(nombre_genero) >= 2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- =========================
-- TABLA: TIPO DE ALERGIAS
-- =========================
CREATE TABLE tipo_alergias (
    id_alergia INT AUTO_INCREMENT PRIMARY KEY,
    nombre_alergia VARCHAR(100) NOT NULL UNIQUE CHECK (CHAR_LENGTH(nombre_alergia) >= 3),
    descripcion VARCHAR(45) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- =========================
-- TABLA: PERSONAS
-- =========================
CREATE TABLE personas (
    id_persona INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(nombre) >= 3),
    correo VARCHAR(100) UNIQUE CHECK (correo LIKE '%@%.%'),
    rut VARCHAR(20) NOT NULL UNIQUE CHECK (CHAR_LENGTH(rut) >= 8),
    telefono VARCHAR(15) CHECK (CHAR_LENGTH(telefono) >= 8),
    fecha_nacimiento DATE,
    id_genero INT,
    id_alergia INT,
    enfermedades_cronicas VARCHAR(200),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_genero) REFERENCES tipo_genero(id_genero),
    FOREIGN KEY (id_alergia) REFERENCES tipo_alergias(id_alergia)
);

-- =========================
-- TABLA: TIPO DE USUARIO
-- =========================
CREATE TABLE tipo_usuario (
    id_tipo_u INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo_u VARCHAR(50) NOT NULL UNIQUE CHECK (CHAR_LENGTH(nombre_tipo_u) >= 3),
    descripcion_tipo_u VARCHAR(200) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- =========================
-- TABLA: USUARIOS
-- =========================
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(45) NOT NULL CHECK (CHAR_LENGTH(nombre_usuario) >= 3),
    password_usuario VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(password_usuario) >= 8),
    id_persona INT NOT NULL,
    tipo_usuario_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona),
    FOREIGN KEY (tipo_usuario_id) REFERENCES tipo_usuario(id_tipo_u)
);

-- =========================
-- TABLA: TIPO TRATAMIENTOS
-- =========================
CREATE TABLE tipo_tratamientos (
    id_tratamiento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tratamiento VARCHAR(100) NOT NULL UNIQUE CHECK (CHAR_LENGTH(nombre_tratamiento) >= 3),
    descripcion VARCHAR(45) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- =========================
-- TABLA: MEDICAMENTOS
-- =========================
CREATE TABLE medicamentos (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_medicamento VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(nombre_medicamento) >= 3),
    frecuencia_tratamiento VARCHAR(50) NOT NULL CHECK (CHAR_LENGTH(frecuencia_tratamiento) >= 1),
    duracion_tratamiento VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(duracion_tratamiento) >= 1),
    usuario_id INT NOT NULL,
    id_tratamiento INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_tratamiento) REFERENCES tipo_tratamientos(id_tratamiento)
);

-- =========================
-- TABLA: ALARMAS
-- =========================
CREATE TABLE alarmas (
    id_alarma INT AUTO_INCREMENT PRIMARY KEY,
    hora TIME NOT NULL,
    fecha DATE NOT NULL,
    medicamento_id INT NOT NULL,
    usuario_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id_medicamento),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
);

-- =========================
-- TABLA: ESTADO PASTILLERO
-- =========================
CREATE TABLE estado_pastillero (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL UNIQUE CHECK (CHAR_LENGTH(nombre_estado) >= 3),
    descripcion VARCHAR(45) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- =========================
-- TABLA: HISTORIAL MEDICAMENTOS
-- =========================
CREATE TABLE historial_medicamentos (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    medicamento_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    cumplimiento_tratamiento ENUM('TOMADO', 'NO_TOMADO') NOT NULL CHECK (cumplimiento_tratamiento IN ('TOMADO','NO_TOMADO')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id_medicamento),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
);

-- =========================
-- TABLA: PASTILLEROS
-- =========================
CREATE TABLE pastilleros (
    id_pastillero INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pastillero VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(nombre_pastillero) >= 3),
    usuario_id INT NOT NULL UNIQUE,
    id_estado INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_estado) REFERENCES estado_pastillero(id_estado)
);

-- =========================
-- TABLA: RELACION TUTOR-USUARIO
-- =========================
CREATE TABLE tutor_usuario (
    id_tutor_usuario INT AUTO_INCREMENT PRIMARY KEY,
    tutor_id INT NOT NULL CHECK (tutor_id <> usuario_id),
    usuario_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (tutor_id, usuario_id),
    FOREIGN KEY (tutor_id) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
);



-- =========================================================
-- PROCEDIMIENTOS ALMACENADOS PARA BASE DE DATOS CRONODOSIS
-- Sistema de gestión de medicamentos y alarmas
-- =========================================================

USE CRONODOSIS;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: TIPO_GENERO
-- =========================================================

-- Insertar nuevo género
DELIMITER //
CREATE PROCEDURE sp_insertar_tipo_genero(
    IN p_nombre_genero VARCHAR(20),
    IN p_created_by INT
)
BEGIN
    INSERT INTO tipo_genero(nombre_genero, created_by, deleted)
    VALUES (p_nombre_genero, p_created_by, 0);
END//
DELIMITER ;

-- Borrado lógico de género
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_tipo_genero(
    IN p_id_genero INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE tipo_genero
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_genero = p_id_genero;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: TIPO_ALERGIAS
-- =========================================================

-- Insertar nueva alergia
DELIMITER //
CREATE PROCEDURE sp_insertar_tipo_alergias(
    IN p_nombre_alergia VARCHAR(100),
    IN p_descripcion VARCHAR(45),
    IN p_created_by INT
)
BEGIN
    INSERT INTO tipo_alergias(nombre_alergia, descripcion, created_by, deleted)
    VALUES (p_nombre_alergia, p_descripcion, p_created_by, 0);
END//
DELIMITER ;

-- Borrado lógico de alergia
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_tipo_alergias(
    IN p_id_alergia INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE tipo_alergias
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_alergia = p_id_alergia;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: PERSONAS
-- =========================================================

-- Insertar nueva persona
DELIMITER //
CREATE PROCEDURE sp_insertar_personas(
    IN p_nombre VARCHAR(100),
    IN p_correo VARCHAR(100),
    IN p_rut VARCHAR(20),
    IN p_telefono VARCHAR(15),
    IN p_fecha_nacimiento DATE,
    IN p_id_genero INT,
    IN p_id_alergia INT,
    IN p_enfermedades_cronicas VARCHAR(200),
    IN p_created_by INT
)
BEGIN
    INSERT INTO personas(
        nombre, correo, rut, telefono, fecha_nacimiento,
        id_genero, id_alergia, enfermedades_cronicas, created_by, deleted
    )
    VALUES (
        p_nombre, p_correo, p_rut, p_telefono, p_fecha_nacimiento,
        p_id_genero, p_id_alergia, p_enfermedades_cronicas, p_created_by, 0
    );
END//
DELIMITER ;

-- Borrado lógico de persona
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_personas(
    IN p_id_persona INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE personas
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_persona = p_id_persona;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: TIPO_USUARIO
-- =========================================================

-- Insertar nuevo tipo de usuario
DELIMITER //
CREATE PROCEDURE sp_insertar_tipo_usuario(
    IN p_nombre_tipo_u VARCHAR(50),
    IN p_descripcion_tipo_u VARCHAR(200),
    IN p_created_by INT
)
BEGIN
    INSERT INTO tipo_usuario(nombre_tipo_u, descripcion_tipo_u, created_by, deleted)
    VALUES (p_nombre_tipo_u, p_descripcion_tipo_u, p_created_by, 0);
END//
DELIMITER ;

-- Borrado lógico de tipo usuario
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_tipo_usuario(
    IN p_id_tipo_u INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE tipo_usuario
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_tipo_u = p_id_tipo_u;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: USUARIOS
-- =========================================================

-- Insertar nuevo usuario
DELIMITER //
CREATE PROCEDURE sp_insertar_usuarios(
    IN p_nombre_usuario VARCHAR(45),
    IN p_password_usuario VARCHAR(100),
    IN p_id_persona INT,
    IN p_tipo_usuario_id INT,
    IN p_created_by INT
)
BEGIN
    INSERT INTO usuarios(
        nombre_usuario, password_usuario, id_persona,
        tipo_usuario_id, created_by, deleted
    )
    VALUES (
        p_nombre_usuario, p_password_usuario, p_id_persona,
        p_tipo_usuario_id, p_created_by, 0
    );
END//
DELIMITER ;

-- Borrado lógico de usuario
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_usuarios(
    IN p_id_usuario INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE usuarios
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_usuario = p_id_usuario;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: TIPO_TRATAMIENTOS
-- =========================================================

-- Insertar nuevo tipo de tratamiento
DELIMITER //
CREATE PROCEDURE sp_insertar_tipo_tratamientos(
    IN p_nombre_tratamiento VARCHAR(100),
    IN p_descripcion VARCHAR(45),
    IN p_created_by INT
)
BEGIN
    INSERT INTO tipo_tratamientos(nombre_tratamiento, descripcion, created_by, deleted)
    VALUES (p_nombre_tratamiento, p_descripcion, p_created_by, 0);
END//
DELIMITER ;

-- Borrado lógico de tipo tratamiento
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_tipo_tratamientos(
    IN p_id_tratamiento INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE tipo_tratamientos
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_tratamiento = p_id_tratamiento;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: MEDICAMENTOS
-- =========================================================

-- Insertar nuevo medicamento
DELIMITER //
CREATE PROCEDURE sp_insertar_medicamentos(
    IN p_nombre_medicamento VARCHAR(100),
    IN p_frecuencia_tratamiento VARCHAR(50),
    IN p_duracion_tratamiento VARCHAR(100),
    IN p_usuario_id INT,
    IN p_id_tratamiento INT,
    IN p_created_by INT
)
BEGIN
    INSERT INTO medicamentos(
        nombre_medicamento, frecuencia_tratamiento, duracion_tratamiento,
        usuario_id, id_tratamiento, created_by, deleted
    )
    VALUES (
        p_nombre_medicamento, p_frecuencia_tratamiento, p_duracion_tratamiento,
        p_usuario_id, p_id_tratamiento, p_created_by, 0
    );
END//
DELIMITER ;

-- Borrado lógico de medicamento
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_medicamentos(
    IN p_id_medicamento INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE medicamentos
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_medicamento = p_id_medicamento;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: ALARMAS
-- =========================================================

-- Insertar nueva alarma
DELIMITER //
CREATE PROCEDURE sp_insertar_alarmas(
    IN p_hora TIME,
    IN p_fecha DATE,
    IN p_medicamento_id INT,
    IN p_usuario_id INT,
    IN p_created_by INT
)
BEGIN
    INSERT INTO alarmas(
        hora, fecha, medicamento_id, usuario_id, created_by, deleted
    )
    VALUES (
        p_hora, p_fecha, p_medicamento_id, p_usuario_id, p_created_by, 0
    );
END//
DELIMITER ;

-- Borrado lógico de alarma
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_alarmas(
    IN p_id_alarma INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE alarmas
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_alarma = p_id_alarma;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: ESTADO_PASTILLERO
-- =========================================================

-- Insertar nuevo estado de pastillero
DELIMITER //
CREATE PROCEDURE sp_insertar_estado_pastillero(
    IN p_nombre_estado VARCHAR(50),
    IN p_descripcion VARCHAR(45),
    IN p_created_by INT
)
BEGIN
    INSERT INTO estado_pastillero(nombre_estado, descripcion, created_by, deleted)
    VALUES (p_nombre_estado, p_descripcion, p_created_by, 0);
END//
DELIMITER ;

-- Borrado lógico de estado pastillero
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_estado_pastillero(
    IN p_id_estado INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE estado_pastillero
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_estado = p_id_estado;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: HISTORIAL_MEDICAMENTOS
-- =========================================================

-- Insertar nuevo registro en historial
DELIMITER //
CREATE PROCEDURE sp_insertar_historial_medicamentos(
    IN p_medicamento_id INT,
    IN p_usuario_id INT,
    IN p_fecha DATE,
    IN p_hora TIME,
    IN p_cumplimiento_tratamiento ENUM('TOMADO', 'NO_TOMADO'),
    IN p_created_by INT
)
BEGIN
    INSERT INTO historial_medicamentos(
        medicamento_id, usuario_id, fecha, hora,
        cumplimiento_tratamiento, created_by, deleted
    )
    VALUES (
        p_medicamento_id, p_usuario_id, p_fecha, p_hora,
        p_cumplimiento_tratamiento, p_created_by, 0
    );
END//
DELIMITER ;

-- Borrado lógico de historial
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_historial_medicamentos(
    IN p_id_historial INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE historial_medicamentos
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_historial = p_id_historial;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: PASTILLEROS
-- =========================================================

-- Insertar nuevo pastillero
DELIMITER //
CREATE PROCEDURE sp_insertar_pastilleros(
    IN p_nombre_pastillero VARCHAR(100),
    IN p_usuario_id INT,
    IN p_id_estado INT,
    IN p_created_by INT
)
BEGIN
    INSERT INTO pastilleros(
        nombre_pastillero, usuario_id, id_estado, created_by, deleted
    )
    VALUES (
        p_nombre_pastillero, p_usuario_id, p_id_estado, p_created_by, 0
    );
END//
DELIMITER ;

-- Borrado lógico de pastillero
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_pastilleros(
    IN p_id_pastillero INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE pastilleros
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_pastillero = p_id_pastillero;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS PARA TABLA: TUTOR_USUARIO
-- =========================================================

-- Insertar nueva relación tutor-usuario
DELIMITER //
CREATE PROCEDURE sp_insertar_tutor_usuario(
    IN p_tutor_id INT,
    IN p_usuario_id INT,
    IN p_created_by INT
)
BEGIN
    INSERT INTO tutor_usuario(
        tutor_id, usuario_id, created_by, deleted
    )
    VALUES (
        p_tutor_id, p_usuario_id, p_created_by, 0
    );
END//
DELIMITER ;

-- Borrado lógico de relación tutor-usuario
DELIMITER //
CREATE PROCEDURE sp_borrado_logico_tutor_usuario(
    IN p_id_tutor_usuario INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE tutor_usuario
    SET deleted = 1,
        updated_by = p_updated_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_tutor_usuario = p_id_tutor_usuario;
END//
DELIMITER ;

-- =========================================================
-- PROCEDIMIENTOS ADICIONALES: CONSULTAS CON JOIN
-- =========================================================

-- Listar usuarios activos con información de persona
DELIMITER //
CREATE PROCEDURE sp_listar_usuarios_activos()
BEGIN
    SELECT 
        u.id_usuario,
        u.nombre_usuario,
        p.nombre AS nombre_persona,
        p.correo,
        p.telefono,
        tu.nombre_tipo_u AS tipo_usuario
    FROM usuarios u
    INNER JOIN personas p ON u.id_persona = p.id_persona
    INNER JOIN tipo_usuario tu ON u.tipo_usuario_id = tu.id_tipo_u
    WHERE u.deleted = 0 AND p.deleted = 0
    ORDER BY u.nombre_usuario;
END//
DELIMITER ;

-- Listar medicamentos activos con tratamiento y usuario
DELIMITER //
CREATE PROCEDURE sp_listar_medicamentos_activos()
BEGIN
    SELECT 
        m.id_medicamento,
        m.nombre_medicamento,
        m.frecuencia_tratamiento,
        m.duracion_tratamiento,
        tt.nombre_tratamiento,
        u.nombre_usuario,
        p.nombre AS nombre_persona
    FROM medicamentos m
    INNER JOIN tipo_tratamientos tt ON m.id_tratamiento = tt.id_tratamiento
    INNER JOIN usuarios u ON m.usuario_id = u.id_usuario
    INNER JOIN personas p ON u.id_persona = p.id_persona
    WHERE m.deleted = 0
    ORDER BY m.nombre_medicamento;
END//
DELIMITER ;

-- Listar alarmas activas con medicamento y usuario
DELIMITER //
CREATE PROCEDURE sp_listar_alarmas_activas()
BEGIN
    SELECT 
        a.id_alarma,
        a.fecha,
        a.hora,
        m.nombre_medicamento,
        u.nombre_usuario,
        p.nombre AS nombre_persona
    FROM alarmas a
    INNER JOIN medicamentos m ON a.medicamento_id = m.id_medicamento
    INNER JOIN usuarios u ON a.usuario_id = u.id_usuario
    INNER JOIN personas p ON u.id_persona = p.id_persona
    WHERE a.deleted = 0
    ORDER BY a.fecha, a.hora;
END//
DELIMITER ;

-- Listar historial de medicamentos con detalle
DELIMITER //
CREATE PROCEDURE sp_listar_historial_completo()
BEGIN
    SELECT 
        h.id_historial,
        h.fecha,
        h.hora,
        h.cumplimiento_tratamiento,
        m.nombre_medicamento,
        u.nombre_usuario,
        p.nombre AS nombre_persona
    FROM historial_medicamentos h
    INNER JOIN medicamentos m ON h.medicamento_id = m.id_medicamento
    INNER JOIN usuarios u ON h.usuario_id = u.id_usuario
    INNER JOIN personas p ON u.id_persona = p.id_persona
    WHERE h.deleted = 0
    ORDER BY h.fecha DESC, h.hora DESC;
END//
DELIMITER ;

-- =========================================================
-- FIN DE LOS PROCEDIMIENTOS ALMACENADOS
-- =========================================================