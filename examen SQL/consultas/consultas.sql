USE examen_sql;

-- 1. Listado de médicos activos actualmente y su tipo
--  titular, interino o sustituto
SELECT
    id_medico,
    CONCAT(nombre, ' ', apellido) AS medico,
    tipo,
    especialidad
FROM medicos
ORDER BY tipo, apellido;

-- 2. Total de días de vacaciones planificadas y disfrutadas
--    por cada empleado
SELECT
    e.id_empleado,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    e.puesto,
    COALESCE(SUM(v.dias_planificados), 0) AS total_dias_planificados,
    COALESCE(SUM(v.dias_disfrutados), 0)   AS total_dias_disfrutados
FROM empleados e
LEFT JOIN vacaciones_empleado v ON v.id_empleado = e.id_empleado
GROUP BY e.id_empleado, empleado, e.puesto
ORDER BY empleado;

-- 3. Médicos con mayor cantidad de horas de consulta en la semana
SELECT
    m.id_medico,
    CONCAT(m.nombre, ' ', m.apellido) AS medico,
    SUM(TIMESTAMPDIFF(MINUTE, h.hora_inicio, h.hora_fin)) / 60 AS horas_semanales
FROM medicos m
JOIN horarios_consulta h ON h.id_medico = m.id_medico
GROUP BY m.id_medico, medico
ORDER BY horas_semanales DESC;

-- 4. Número de sustituciones realizadas por cada médico sustituto
SELECT
    m.id_medico,
    CONCAT(m.nombre, ' ', m.apellido) AS medico_sustituto,
    COUNT(s.id_sustitucion) AS numero_sustituciones
FROM medicos m
JOIN sustituciones s ON s.id_medico_sustituto = m.id_medico
GROUP BY m.id_medico, medico_sustituto
ORDER BY numero_sustituciones DESC;

-- 5. Número de médicos que están actualmente en sustitución
SELECT
    COUNT(DISTINCT id_medico_titular) AS medicos_actualmente_en_sustitucion
FROM sustituciones
WHERE CURDATE() BETWEEN fecha_inicio AND fecha_fin;

-- 6. Horas totales de consulta por médico por día de la semana
SELECT
    m.id_medico,
    CONCAT(m.nombre, ' ', m.apellido) AS medico,
    h.dia_semana,
    SUM(TIMESTAMPDIFF(MINUTE, h.hora_inicio, h.hora_fin)) / 60 AS horas
FROM medicos m
JOIN horarios_consulta h ON h.id_medico = m.id_medico
GROUP BY m.id_medico, medico, h.dia_semana
ORDER BY m.id_medico,
    FIELD(h.dia_semana, 'Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo');

-- 7. Médico con mayor cantidad de pacientes asignados
SELECT
    m.id_medico,
    CONCAT(m.nombre, ' ', m.apellido) AS medico,
    COUNT(p.id_paciente) AS numero_pacientes
FROM medicos m
JOIN pacientes p ON p.id_medico_asignado = m.id_medico
GROUP BY m.id_medico, medico
ORDER BY numero_pacientes DESC
LIMIT 1;
