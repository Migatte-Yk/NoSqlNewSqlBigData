-- =====================================================================
-- 05_manipulacion.sql  (A5. Manipulación de datos)
-- Las operaciones destructivas usan SOLO el registro de prueba E9999999.
-- Ejecutar con:  --set errexit=false   para que los errores esperados (apartado 4)
-- no detengan el script.
-- =====================================================================
USE practica_matriculas;

-- 1) UPDATE de un registro real: cambio de ciudad de un estudiante (valor previo -> nuevo)
SELECT codigo, ciudad FROM estudiantes WHERE codigo = 'E2024001';
UPDATE estudiantes SET ciudad = 'Cajicá' WHERE codigo = 'E2024001';
SELECT codigo, ciudad FROM estudiantes WHERE codigo = 'E2024001';   -- validación

-- 2) Registro de prueba: INSERT -> DELETE
INSERT INTO estudiantes (codigo, nombres, apellidos, correo, fecha_nacimiento, ciudad, programa_id, fecha_ingreso)
VALUES ('E9999999', 'Prueba', 'Borrable', 'prueba@ejemplo.invalid', '2000-01-01', 'Bogotá', 1, '2026-02-02');
SELECT count(*) AS existe_antes FROM estudiantes WHERE codigo = 'E9999999';
DELETE FROM estudiantes WHERE codigo = 'E9999999';
SELECT count(*) AS existe_despues FROM estudiantes WHERE codigo = 'E9999999';   -- debe ser 0

-- 3) Restaurar el valor original del UPDATE (mantiene reproducible el estado inicial)
UPDATE estudiantes SET ciudad = 'Fusagasugá' WHERE codigo = 'E2024001';

-- 4) Restricciones de integridad: cada sentencia DEBE FALLAR (error esperado)
-- 4a) FK: matrícula de un estudiante inexistente
INSERT INTO matriculas (codigo_estudiante, semestre, fecha_matricula, estado, creditos, valor)
VALUES ('NOEXISTE', '2026-1', '2026-02-02', 'ACTIVA', 12, 2160000);
-- 4b) CHECK: estado fuera del dominio permitido
INSERT INTO matriculas (codigo_estudiante, semestre, fecha_matricula, estado, creditos, valor)
VALUES ('E2024001', '2030-1', '2030-02-02', 'INVALIDO', 12, 2160000);
-- 4c) FK al eliminar: no se puede borrar un programa con estudiantes
DELETE FROM programas WHERE programa_id = 1;
-- 4d) UNIQUE: segunda matrícula del mismo estudiante en el mismo semestre
INSERT INTO matriculas (codigo_estudiante, semestre, fecha_matricula, estado, creditos, valor)
SELECT codigo_estudiante, semestre, fecha_matricula, estado, creditos, valor FROM matriculas LIMIT 1;

-- Estado final: los conteos no cambiaron
SELECT (SELECT count(*) FROM estudiantes) AS estudiantes, (SELECT count(*) FROM matriculas) AS matriculas, (SELECT count(*) FROM programas) AS programas;
