-- =====================================================================
-- 04_consultas.sql  (A4. Consultas SQL)  -- solo lectura
-- =====================================================================
USE practica_matriculas;

-- 1) Consulta general: listado completo de estudiantes
SELECT * FROM estudiantes;

-- 2) Filtrado: estudiantes del programa Ingeniería de Sistemas (programa_id = 1)
SELECT codigo, nombres, apellidos, ciudad FROM estudiantes WHERE programa_id = 1;

-- 3) Ordenamiento: estudiantes por apellido y nombre; fecha de ingreso más reciente primero
SELECT codigo, apellidos, nombres, fecha_ingreso FROM estudiantes ORDER BY apellidos ASC, nombres ASC;
SELECT codigo, apellidos, nombres, fecha_ingreso FROM estudiantes ORDER BY fecha_ingreso DESC, codigo;

-- 4) JOIN: cada estudiante con el nombre de su programa y facultad
SELECT e.codigo, e.nombres, e.apellidos, p.nombre AS programa, p.facultad
FROM estudiantes e
JOIN programas p ON p.programa_id = e.programa_id
ORDER BY p.nombre, e.apellidos;

-- 5) Matrículas de un semestre concreto (2025-1) con datos del estudiante
SELECT m.matricula_id, e.codigo, e.apellidos, m.semestre, m.estado, m.creditos, m.valor
FROM matriculas m JOIN estudiantes e ON e.codigo = m.codigo_estudiante
WHERE m.semestre = '2025-1'
ORDER BY e.apellidos;

-- 6) Conteo de estudiantes por programa (LEFT JOIN para incluir programas sin estudiantes)
SELECT p.nombre AS programa, count(e.codigo) AS total_estudiantes
FROM programas p LEFT JOIN estudiantes e ON e.programa_id = p.programa_id
GROUP BY p.nombre ORDER BY total_estudiantes DESC, p.nombre;

-- 7) Conteo de matrículas por estado
SELECT estado, count(*) AS total FROM matriculas GROUP BY estado ORDER BY total DESC;

-- 8) GROUP BY + ORDER BY: matrículas, créditos y valor total por semestre
SELECT semestre, count(*) AS matriculas, sum(creditos) AS creditos_totales, sum(valor) AS valor_total
FROM matriculas GROUP BY semestre ORDER BY semestre;

-- 9) HAVING: programas que acumulan al menos 8 matrículas (filtro sobre el resultado agregado)
SELECT p.nombre AS programa, count(*) AS total_matriculas
FROM matriculas m
JOIN estudiantes e ON e.codigo = m.codigo_estudiante
JOIN programas p ON p.programa_id = e.programa_id
GROUP BY p.nombre
HAVING count(*) >= 8
ORDER BY total_matriculas DESC;

-- 10) Subconsulta: estudiantes con más matrículas que el promedio por estudiante
SELECT e.codigo, e.apellidos, count(m.matricula_id) AS n_matriculas
FROM estudiantes e JOIN matriculas m ON m.codigo_estudiante = e.codigo
GROUP BY e.codigo, e.apellidos
HAVING count(m.matricula_id) > (SELECT count(*)::DECIMAL / (SELECT count(*) FROM estudiantes) FROM matriculas)
ORDER BY e.codigo;
