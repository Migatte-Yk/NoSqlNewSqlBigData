-- =====================================================================
-- 03_carga_datos.sql  (A3. Inserción y carga)  -- GENERADO por datos/generar_datos.py
-- DATOS 100% SINTÉTICOS: personas y correos ficticios (dominio .invalid).
-- Reinicialización controlada: SOLO vacía las 3 tablas del proyecto en la base
-- practica_matriculas (hijas primero). Úsese únicamente para recargar el estado inicial.
-- =====================================================================
USE practica_matriculas;

-- Reinicio acotado a las tablas del proyecto (respeta el orden de las FK)
DELETE FROM matriculas WHERE true;
DELETE FROM estudiantes WHERE true;
DELETE FROM programas WHERE true;

-- 1) Programas académicos
INSERT INTO programas (programa_id, codigo, nombre, facultad, duracion_semestres) VALUES
  (1, 'ISIS', 'Ingeniería de Sistemas', 'Ingeniería', 10),
  (2, 'ADEM', 'Administración de Empresas', 'Ciencias Administrativas', 9),
  (3, 'CONT', 'Contaduría Pública', 'Ciencias Administrativas', 9),
  (4, 'ZOOT', 'Zootecnia', 'Ciencias Agropecuarias', 10),
  (5, 'ENFE', 'Enfermería', 'Ciencias de la Salud', 8);

-- 2) Estudiantes (telefono NULL = campo opcional)
INSERT INTO estudiantes (codigo, nombres, apellidos, correo, fecha_nacimiento, ciudad, programa_id, fecha_ingreso, telefono) VALUES
  ('E2024001', 'Ana', 'Ramírez Rojas', 'est01@ejemplo.invalid', '2000-04-18', 'Fusagasugá', 1, '2025-02-03', '3002419955'),
  ('E2024002', 'Luis', 'Gómez Salazar', 'est02@ejemplo.invalid', '1999-06-15', 'Bogotá', 2, '2025-02-03', '3002390784'),
  ('E2024003', 'María', 'Torres Rincón', 'est03@ejemplo.invalid', '2001-04-09', 'Bogotá', 3, '2025-02-03', NULL),
  ('E2024004', 'Carlos', 'Rojas Ramírez', 'est04@ejemplo.invalid', '2004-10-20', 'Soacha', 4, '2024-08-05', '3003207236'),
  ('E2024005', 'Laura', 'Herrera Moreno', 'est05@ejemplo.invalid', '1998-08-30', 'Arbeláez', 5, '2024-02-05', '3005456749'),
  ('E2024006', 'Andrés', 'Castro Quintero', 'est06@ejemplo.invalid', '1999-10-18', 'Silvania', 1, '2024-02-05', NULL),
  ('E2024007', 'Camila', 'Vargas Ríos', 'est07@ejemplo.invalid', '2002-05-27', 'Silvania', 2, '2024-08-05', '3003889683'),
  ('E2024008', 'Jorge', 'Moreno Herrera', 'est08@ejemplo.invalid', '2002-11-21', 'Fusagasugá', 3, '2024-02-05', '3002436948'),
  ('E2024009', 'Valentina', 'Jiménez Ortiz', 'est09@ejemplo.invalid', '2004-06-27', 'Fusagasugá', 4, '2024-08-05', NULL),
  ('E2024010', 'Felipe', 'Pardo Bernal', 'est10@ejemplo.invalid', '2003-11-22', 'Fusagasugá', 5, '2024-08-05', '3007662722'),
  ('E2024011', 'Daniela', 'Salazar Gómez', 'est11@ejemplo.invalid', '2002-05-27', 'Bogotá', 1, '2024-02-05', '3005371980'),
  ('E2024012', 'Sebastián', 'Ortiz Jiménez', 'est12@ejemplo.invalid', '2001-11-06', 'Fusagasugá', 2, '2024-08-05', NULL),
  ('E2024013', 'Paula', 'Mejía Parra', 'est13@ejemplo.invalid', '1999-12-23', 'Soacha', 3, '2025-02-03', '3007454243'),
  ('E2024014', 'Mateo', 'Cárdenas Cortés', 'est14@ejemplo.invalid', '2002-01-24', 'Bogotá', 4, '2025-02-03', '3001768147'),
  ('E2024015', 'Sofía', 'Quintero Castro', 'est15@ejemplo.invalid', '2000-11-19', 'Arbeláez', 5, '2024-08-05', NULL),
  ('E2024016', 'Diego', 'Parra Mejía', 'est16@ejemplo.invalid', '1998-09-14', 'Girardot', 1, '2024-08-05', '3009855607'),
  ('E2024017', 'Natalia', 'Suárez Acosta', 'est17@ejemplo.invalid', '2004-12-12', 'Silvania', 2, '2025-02-03', '3006638611'),
  ('E2024018', 'Santiago', 'Rincón Torres', 'est18@ejemplo.invalid', '2000-09-28', 'Bogotá', 3, '2024-08-05', NULL),
  ('E2024019', 'Isabela', 'Bernal Pardo', 'est19@ejemplo.invalid', '1998-06-09', 'Silvania', 4, '2025-02-03', '3001386408'),
  ('E2024020', 'Julián', 'Acosta Suárez', 'est20@ejemplo.invalid', '2000-10-09', 'Bogotá', 5, '2024-02-05', '3002773055'),
  ('E2024021', 'Lucía', 'Peña Lozano', 'est21@ejemplo.invalid', '1998-12-19', 'Soacha', 1, '2024-02-05', NULL),
  ('E2024022', 'Nicolás', 'Ríos Vargas', 'est22@ejemplo.invalid', '1998-12-09', 'Silvania', 2, '2024-02-05', '3002131875'),
  ('E2024023', 'Juliana', 'Cortés Cárdenas', 'est23@ejemplo.invalid', '2002-10-19', 'Fusagasugá', 3, '2025-02-03', '3005403280'),
  ('E2024024', 'Tomás', 'Lozano Peña', 'est24@ejemplo.invalid', '2004-11-16', 'Fusagasugá', 4, '2025-02-03', NULL);

-- 3) Matrículas (matricula_id generado por la secuencia de identidad de la tabla)
INSERT INTO matriculas (codigo_estudiante, semestre, fecha_matricula, estado, creditos, valor) VALUES
  ('E2024001', '2025-1', '2025-02-12', 'FINALIZADA', 20, 3600000),
  ('E2024001', '2025-2', '2025-08-13', 'FINALIZADA', 14, 2520000),
  ('E2024002', '2025-1', '2025-02-04', 'FINALIZADA', 16, 2880000),
  ('E2024002', '2025-2', '2025-08-08', 'FINALIZADA', 18, 3240000),
  ('E2024003', '2025-1', '2025-02-04', 'FINALIZADA', 16, 2880000),
  ('E2024003', '2025-2', '2025-08-10', 'APLAZADA', 14, 2520000),
  ('E2024004', '2024-2', '2024-08-11', 'FINALIZADA', 16, 2880000),
  ('E2024004', '2025-1', '2025-02-05', 'FINALIZADA', 18, 3240000),
  ('E2024005', '2024-1', '2024-02-07', 'FINALIZADA', 18, 3240000),
  ('E2024005', '2024-2', '2024-08-05', 'ACTIVA', 18, 3240000),
  ('E2024006', '2024-1', '2024-02-11', 'ACTIVA', 18, 3240000),
  ('E2024006', '2024-2', '2024-08-11', 'FINALIZADA', 20, 3600000),
  ('E2024007', '2024-2', '2024-08-07', 'FINALIZADA', 20, 3600000),
  ('E2024007', '2025-1', '2025-02-10', 'ACTIVA', 16, 2880000),
  ('E2024008', '2024-1', '2024-02-11', 'FINALIZADA', 16, 2880000),
  ('E2024008', '2024-2', '2024-08-08', 'FINALIZADA', 16, 2880000),
  ('E2024009', '2024-2', '2024-08-09', 'FINALIZADA', 12, 2160000),
  ('E2024009', '2025-1', '2025-02-10', 'FINALIZADA', 16, 2880000),
  ('E2024010', '2024-2', '2024-08-12', 'ACTIVA', 14, 2520000),
  ('E2024010', '2025-1', '2025-02-06', 'FINALIZADA', 16, 2880000),
  ('E2024011', '2024-1', '2024-02-13', 'FINALIZADA', 18, 3240000),
  ('E2024011', '2024-2', '2024-08-15', 'FINALIZADA', 14, 2520000),
  ('E2024012', '2024-2', '2024-08-12', 'ACTIVA', 14, 2520000),
  ('E2024012', '2025-1', '2025-02-04', 'FINALIZADA', 12, 2160000),
  ('E2024013', '2025-1', '2025-02-06', 'APLAZADA', 12, 2160000),
  ('E2024014', '2025-1', '2025-02-06', 'FINALIZADA', 14, 2520000),
  ('E2024015', '2024-2', '2024-08-08', 'FINALIZADA', 18, 3240000),
  ('E2024016', '2024-2', '2024-08-10', 'FINALIZADA', 20, 3600000),
  ('E2024017', '2025-1', '2025-02-11', 'FINALIZADA', 16, 2880000),
  ('E2024018', '2024-2', '2024-08-13', 'FINALIZADA', 12, 2160000),
  ('E2024019', '2025-1', '2025-02-04', 'FINALIZADA', 18, 3240000),
  ('E2024020', '2024-1', '2024-02-05', 'APLAZADA', 20, 3600000),
  ('E2024021', '2024-1', '2024-02-08', 'FINALIZADA', 16, 2880000),
  ('E2024022', '2024-1', '2024-02-10', 'FINALIZADA', 12, 2160000),
  ('E2024023', '2025-1', '2025-02-04', 'CANCELADA', 14, 2520000),
  ('E2024024', '2025-1', '2025-02-03', 'ACTIVA', 12, 2160000);

-- 4) Comprobación de cantidades cargadas
SELECT 'programas' AS tabla, count(*) AS filas FROM programas
UNION ALL SELECT 'estudiantes', count(*) FROM estudiantes
UNION ALL SELECT 'matriculas', count(*) FROM matriculas;
