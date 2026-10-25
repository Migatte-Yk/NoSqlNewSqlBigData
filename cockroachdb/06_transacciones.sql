-- =====================================================================
-- 06_transacciones.sql  (A6. Transacciones)
-- Escenario: dar de alta un estudiante y su matrícula como una unidad atómica.
-- Se usan estudiantes de prueba (E9999998 / E9999997) y se limpian al final.
-- =====================================================================
USE practica_matriculas;

SELECT count(*) AS matriculas_inicio FROM matriculas;

-- 1) Transacción con COMMIT: los dos cambios se conservan
BEGIN;
INSERT INTO estudiantes (codigo, nombres, apellidos, correo, fecha_nacimiento, ciudad, programa_id, fecha_ingreso)
VALUES ('E9999998', 'Tx', 'Commit', 'tx-commit@ejemplo.invalid', '2001-05-05', 'Bogotá', 2, '2026-02-02');
INSERT INTO matriculas (codigo_estudiante, semestre, fecha_matricula, estado, creditos, valor)
VALUES ('E9999998', '2026-1', '2026-02-03', 'ACTIVA', 12, 2160000);
COMMIT;
SELECT 'tras COMMIT' AS momento,
       (SELECT count(*) FROM estudiantes WHERE codigo = 'E9999998') AS estudiante,
       (SELECT count(*) FROM matriculas WHERE codigo_estudiante = 'E9999998') AS matriculas;

-- 2) Transacción con ROLLBACK: los dos cambios se revierten
BEGIN;
INSERT INTO estudiantes (codigo, nombres, apellidos, correo, fecha_nacimiento, ciudad, programa_id, fecha_ingreso)
VALUES ('E9999997', 'Tx', 'Rollback', 'tx-rollback@ejemplo.invalid', '2001-06-06', 'Bogotá', 2, '2026-02-02');
INSERT INTO matriculas (codigo_estudiante, semestre, fecha_matricula, estado, creditos, valor)
VALUES ('E9999997', '2026-1', '2026-02-03', 'ACTIVA', 12, 2160000);
SELECT 'dentro de la tx' AS momento, (SELECT count(*) FROM estudiantes WHERE codigo = 'E9999997') AS estudiante;
ROLLBACK;
SELECT 'tras ROLLBACK' AS momento,
       (SELECT count(*) FROM estudiantes WHERE codigo = 'E9999997') AS estudiante,
       (SELECT count(*) FROM matriculas WHERE codigo_estudiante = 'E9999997') AS matriculas;

-- 3) Limpieza de los registros de prueba (hijas primero)
DELETE FROM matriculas WHERE codigo_estudiante = 'E9999998';
DELETE FROM estudiantes WHERE codigo = 'E9999998';
SELECT count(*) AS matriculas_fin FROM matriculas;   -- igual a matriculas_inicio
