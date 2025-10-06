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