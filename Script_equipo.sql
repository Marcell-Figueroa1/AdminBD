CREATE DATABASE GestionTalleres;
USE GestionTalleres;

-- -- 📘 Escenario 2: Plataforma de Gestión de Talleres Culturales
-- El Departamento de Cultura del municipio organiza talleres como pintura,
-- folclore, yoga o cocina. Estos talleres se imparten en centros comunitarios,
-- con monitores especializados. Las inscripciones se hacen en línea y requieren
-- validación de cupo.

-- Roles del sistema:
-- Coordinador cultural: crea talleres y administra sedes y monitores.
-- Monitor: realiza talleres y evalúa a participantes.
-- Participante: persona inscrita en uno o más talleres.

-- Requerimientos:
-- Registro de personas con rol: participante, monitor o coordinador.
-- Talleres: nombre, descripción, sede, días, horario, cupo, monitor responsable.
-- Inscripciones: fecha de inscripción, estado (pendiente, confirmada, rechazada), participante, taller.
-- Evaluaciones por parte del monitor: puntualidad, participación, observaciones.
-- Sedes: nombre, dirección, capacidad.

-- Tabla TIPO DE USUARIOS
CREATE TABLE tipo_Usuario (
    id_tipo_u INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único del tipo de usuario
    nombre_tipo_u VARCHAR(50) NOT NULL UNIQUE, -- Nombre del tipo de usuario (ej. Coordinador, Monitor, Participante)
    descripcion_tipo_u VARCHAR(200) NOT NULL, -- Descripción del tipo de usuario
    -- Campos de auditoría
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- fecha modificación
    created_by INT, -- Usuario que crea
    updated_by INT, -- Usuario que modifica
    deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);
-- Tabla de USUARIOS
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único del usuario
    nombre_usuario VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(nombre_usuario) >= 3 AND nombre REGEXP '^[A-Za-z ]+$'), -- Nombre completo del usuario
    correo_usuario VARCHAR(100) UNIQUE CHECK (correo_usuario LIKE '%@%.%'), -- Correo electrónico único del usuario
    password_usuario VARCHAR(100) NOT NULL CHECK (char_length(password_usuario) >= 8), -- Contraseña del usuario,
    asistencia_id INT, -- Relación a asistencia
    tipo_usuario_id INT, -- Relación a tipo_Usuario
    -- Campos de auditoría
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
    created_by INT, -- Usuario que crea
    updated_by INT, -- Usuario que modifica
    deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);
-- Tabla de TALLERES
CREATE TABLE talleres (
    id_taller INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único del taller
    nombre_taller VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(nombre_taller) >= 3 AND nombre REGEXP '^[A-Za-z ]+$'), -- Nombre del taller
    descripcion_taller VARCHAR(200) NOT NULL CHECK (CHAR_LENGTH(descripcion_taller) >= 3), -- Descripción del taller
    sede_id INT, -- Relación a sedes
    total_Horas TIME NOT NULL, -- Horas totales del taller
    cupo INT NOT NULL, -- Cupo máximo de participantes
    monitor_id INT, -- Relación a monitores (usuarios)
    -- Campos de auditoría
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
    created_by INT, -- Usuario que crea
    updated_by INT, -- Usuario que modifica
    deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);
-- Tabla de INSCRIPCIONES
CREATE TABLE inscripciones (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único de la inscripción
    fecha_inscripcion DATETIME NOT NULL, -- Fecha de inscripción
    estado ENUM('pendiente', 'confirmada', 'rechazada') NOT NULL, -- Estado de la inscripción
    participante_id INT, -- Relación a participantes (usuarios)
    taller_id INT, -- Relación a talleres
    -- Campos de auditoría
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
    created_by INT, -- Usuario que crea
    updated_by INT, -- Usuario que modifica
    deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);
-- Tabla de EVALUACIONES
CREATE TABLE evaluaciones (
    id_evaluacion INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único de la evaluación
    puntualidad INT NOT NULL, -- Puntualidad del participante (1-5)
    participacion INT NOT NULL, -- Participación del participante (1-5)
    observaciones VARCHAR(300), -- Observaciones del monitor sobre el participante
    -- Campos de auditoría
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
    created_by INT, -- Usuario que crea
    updated_by INT, -- Usuario que modifica
    deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

CREATE TABLE sedes(    
    id_sedes INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_lugar VARCHAR(100) NOT NULL UNIQUE,
    dirrecion VARCHAR(50) NOT NULL UNIQUE,
    capacidad VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by INT, -- Usuario que crea
    updated_by INT, -- Usuario que modifica
    deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

-- tabla de calificaciones
CREATE TABLE calificaciones(
	id_calificaciones INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE ,
    nota VARCHAR(20) NOT NULL UNIQUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by INT, -- Usuario que crea
    updated_by INT, -- Usuario que modifica
    deleted BOOLEAN DEFAULT FALSE, -- Borrado lógico
    id_taller INT NOT NULL,
    id_usuario INT,
    id_evaluacion INT
);
-- tabla de asistencia
CREATE TABLE asistencia (
	id_asistencia  INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    asistencia boolean not null unique,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by INT, -- Usuario que crea
    updated_by INT, -- Usuario que modifica
    deleted BOOLEAN DEFAULT FALSE,-- Borrado lógico
    id_taller INT,
    id_usuario INT
);


-- Relación entre usuarios y tipo de usuario
ALTER TABLE usuarios
ADD CONSTRAINT fk_tipo_usuario
FOREIGN KEY (tipo_usuario_id) REFERENCES tipo_Usuario(id_tipo_u); -- ✅
-- Relación entre talleres y sedes
ALTER TABLE talleres
ADD CONSTRAINT fk_sede
FOREIGN KEY (sede_id) REFERENCES sedes(id_sedes); -- ✅
-- Relación entre talleres y monitores
ALTER TABLE talleres
ADD CONSTRAINT fk_monitor
FOREIGN KEY (monitor_id) REFERENCES usuarios(id_usuario); -- ✅
-- Relación entre inscripciones y participantes
ALTER TABLE inscripciones
ADD CONSTRAINT fk_participante
FOREIGN KEY (participante_id) REFERENCES usuarios(id_usuario); -- ✅
-- Relación entre inscripciones y talleres
ALTER TABLE inscripciones
ADD CONSTRAINT fk_taller
FOREIGN KEY (taller_id) REFERENCES talleres(id_taller); -- ✅
-- relaciones de usuarios y calificaciones
ALTER TABLE calificaciones
ADD CONSTRAINT fk_calificaciones_usuarios
foreign key(id_usuario) references usuarios(id_usuario); -- ✅
-- relaciones de asistencia y usuarios
ALTER TABLE asistencia
ADD CONSTRAINT fk_asistencia_id
foreign key (id_usuario) references usuarios(id_usuario); -- ✅
-- relaciones de asistencia y talleres
ALTER TABLE asistencia
ADD CONSTRAINT fk_taller_id
foreign key (id_taller) references talleres(id_taller); -- ✅
-- relaciones de calificaciones y talleres
ALTER TABLE calificaciones
ADD CONSTRAINT fk_id_taller
FOREIGN KEY (id_taller) references talleres(id_taller); -- ✅
