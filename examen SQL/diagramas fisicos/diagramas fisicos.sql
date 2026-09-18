USE examen_sql;

CREATE TABLE medicos (
    id_medico       INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(50)  NOT NULL,
    apellido        VARCHAR(50)  NOT NULL,
    tipo            ENUM('titular','interino','sustituto') NOT NULL,
    especialidad    VARCHAR(50)  NOT NULL,
    dni             VARCHAR(15)  NOT NULL UNIQUE,
    fecha_alta      DATE         NOT NULL
);


CREATE TABLE horarios_consulta (
    id_horario      INT AUTO_INCREMENT PRIMARY KEY,
    id_medico       INT NOT NULL,
    dia_semana      ENUM('Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo') NOT NULL,
    hora_inicio     TIME NOT NULL,
    hora_fin        TIME NOT NULL,
    CONSTRAINT fk_horario_medico
        FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
        ON DELETE CASCADE
);


CREATE TABLE sustituciones (
    id_sustitucion      INT AUTO_INCREMENT PRIMARY KEY,
    id_medico_titular   INT NOT NULL,
    id_medico_sustituto INT NOT NULL,
    fecha_inicio        DATE NOT NULL,
    fecha_fin            DATE NOT NULL,
    motivo               VARCHAR(150),
    CONSTRAINT fk_sustitucion_titular
        FOREIGN KEY (id_medico_titular) REFERENCES medicos(id_medico),
    CONSTRAINT fk_sustitucion_sustituto
        FOREIGN KEY (id_medico_sustituto) REFERENCES medicos(id_medico),
    CONSTRAINT chk_fechas_sustitucion CHECK (fecha_fin >= fecha_inicio)
);


CREATE TABLE empleados (
    id_empleado     INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL,
    apellido        VARCHAR(50) NOT NULL,
    puesto ENUM('ATS','Auxiliar de Enfermeria','Celador','Administrativo') NOT NULL,
    dni             VARCHAR(15) NOT NULL UNIQUE,
    fecha_alta      DATE NOT NULL
);

CREATE TABLE vacaciones_medico (
    id_vacacion         INT AUTO_INCREMENT PRIMARY KEY,
    id_medico           INT NOT NULL,
    fecha_inicio        DATE NOT NULL,
    fecha_fin            DATE NOT NULL,
    dias_planificados   INT NOT NULL,
    dias_disfrutados     INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_vacacion_medico
        FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
        ON DELETE CASCADE,
    CONSTRAINT chk_dias_medico CHECK (dias_disfrutados <= dias_planificados)
);

CREATE TABLE vacaciones_empleado (
    id_vacacion         INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado         INT NOT NULL,
    fecha_inicio        DATE NOT NULL,
    fecha_fin            DATE NOT NULL,
    dias_planificados   INT NOT NULL,
    dias_disfrutados     INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_vacacion_empleado
        FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
        ON DELETE CASCADE,
    CONSTRAINT chk_dias_empleado CHECK (dias_disfrutados <= dias_planificados)
);

CREATE TABLE pacientes (
    id_paciente         INT AUTO_INCREMENT PRIMARY KEY,
    nombre              VARCHAR(50) NOT NULL,
    apellido            VARCHAR(50) NOT NULL,
    fecha_nacimiento    DATE NOT NULL,
    dni                 VARCHAR(15) NOT NULL UNIQUE,
    id_medico_asignado  INT NOT NULL,
    CONSTRAINT fk_paciente_medico
        FOREIGN KEY (id_medico_asignado) REFERENCES medicos(id_medico)
);

-- medicos
INSERT INTO medicos (nombre, apellido, tipo, especialidad, dni, fecha_alta) VALUES
('Laura',   'Gómez',    'titular',   'Medicina General', '11111111A', '2018-03-01'),
('Carlos',  'Ruiz',     'titular',   'Pediatría',         '22222222B', '2019-06-15'),
('Marta',   'Fernández','titular',   'Ginecología',       '33333333C', '2017-01-10'),
('Javier',  'López',    'interino',  'Medicina General', '44444444D', '2023-09-01'),
('Ana',     'Martín',   'interino',  'Traumatología',     '55555555E', '2024-02-01'),
('Pedro',   'Sánchez',  'sustituto', 'Medicina General', '66666666F', '2025-01-15'),
('Sofía',   'Torres',   'sustituto', 'Pediatría',         '77777777G', '2025-05-01'),
('Diego',   'Romero',   'sustituto', 'Ginecología',       '88888888H', '2026-01-10');

-- horarios_consulta
INSERT INTO horarios_consulta (id_medico, dia_semana, hora_inicio, hora_fin) VALUES
(1, 'Lunes',     '08:00:00', '14:00:00'),
(1, 'Miercoles', '08:00:00', '14:00:00'),
(1, 'Viernes',   '08:00:00', '12:00:00'),
(2, 'Lunes',     '09:00:00', '13:00:00'),
(2, 'Martes',    '09:00:00', '13:00:00'),
(2, 'Jueves',    '09:00:00', '13:00:00'),
(3, 'Martes',    '10:00:00', '15:00:00'),
(3, 'Jueves',    '10:00:00', '15:00:00'),
(4, 'Lunes',     '15:00:00', '20:00:00'),
(4, 'Martes',    '15:00:00', '20:00:00'),
(5, 'Miercoles', '09:00:00', '14:00:00'),
(5, 'Viernes',   '09:00:00', '14:00:00'),
(6, 'Lunes',     '08:00:00', '12:00:00'),
(7, 'Miercoles', '09:00:00', '13:00:00'),
(8, 'Jueves',    '10:00:00', '14:00:00');

-- sustituciones

INSERT INTO sustituciones (id_medico_titular, id_medico_sustituto, fecha_inicio, fecha_fin, motivo) VALUES
(1, 6, '2026-08-01', '2026-08-31', 'Vacaciones del titular'),
(2, 7, '2026-09-01', '2026-09-30', 'Vacaciones del titular'),
(3, 8, '2026-09-10', '2026-09-25', 'Baja médica'),
(1, 6, '2025-12-01', '2025-12-15', 'Baja médica'),
(2, 7, '2025-07-01', '2025-07-20', 'Vacaciones del titular');

-- empleados
INSERT INTO empleados (nombre, apellido, puesto, dni, fecha_alta) VALUES
('Elena',    'Navarro', 'ATS','10101010A', '2019-04-01'),
('Miguel',   'Ortega',  'Auxiliar de Enfermeria','20202020B', '2020-05-12'),
('Rosa',     'Delgado', 'Celador','30303030C', '2021-02-20'),
('Antonio',  'Vega',    'Administrativo','40404040D', '2018-11-05'),
('Cristina', 'Molina',  'ATS','50505050E', '2022-07-18');

-- vacaciones_medico
INSERT INTO vacaciones_medico (id_medico, fecha_inicio, fecha_fin, dias_planificados, dias_disfrutados) VALUES
(1, '2026-08-01', '2026-08-31', 22, 22),
(2, '2026-09-01', '2026-09-30', 22, 10),
(3, '2026-09-10', '2026-09-25', 15, 15),
(4, '2026-07-01', '2026-07-15', 15, 15),
(5, '2026-08-10', '2026-08-24', 15, 0);

-- vacaciones_empleado
INSERT INTO vacaciones_empleado (id_empleado, fecha_inicio, fecha_fin, dias_planificados, dias_disfrutados) VALUES
(1, '2026-07-01', '2026-07-22', 22, 22),
(2, '2026-08-01', '2026-08-15', 15, 15),
(3, '2026-09-01', '2026-09-10', 10, 5),
(4, '2026-06-01', '2026-06-20', 20, 20),
(5, '2026-09-15', '2026-09-30', 15, 0);

-- pacientes
INSERT INTO pacientes (nombre, apellido, fecha_nacimiento, dni, id_medico_asignado) VALUES
('Lucía',    'Herrera',  '1990-05-12', '90000001Z', 1),
('Pablo',    'Iglesias', '1985-11-23', '90000002Y', 1),
('María',    'Castro',   '2015-02-14', '90000003X', 2),
('Hugo',     'Serrano',  '2018-09-30', '90000004W', 2),
('Nuria',    'Ramos',    '1978-06-01', '90000005V', 3),
('Alba',     'Moreno',   '1995-03-19', '90000006U', 3),
('Sergio',   'Gil',      '2000-12-05', '90000007T', 1),
('Beatriz',  'Cano',     '1988-08-08', '90000008S', 4),
('Raúl',     'Santos',   '1972-04-27', '90000009R', 2),
('Marina',   'Suárez',   '1999-10-17', '90000010Q', 1);

