-- =====================================================================
-- 01_verificacion.sql  (A1. Verificación del motor)
-- Ejecutar:  cockroach sql --insecure --host=localhost:26257 -f cockroachdb/01_verificacion.sql
-- No crea ni modifica nada: solo consultas de lectura.
-- =====================================================================

-- Versión del motor
SELECT version();

-- Contexto de la sesión: usuario, base de datos actual y zona horaria
SELECT current_user() AS usuario, current_database() AS base_actual, current_setting('TIMEZONE') AS zona_horaria;

-- Versión del clúster (SHOW server_version muestra la versión de compatibilidad PostgreSQL, no la de CockroachDB)
SHOW CLUSTER SETTING version;
SHOW server_version;

-- Bases de datos existentes (la del proyecto se crea en 02_esquema.sql)
SHOW DATABASES;

-- Comprobación sencilla de ejecución
SELECT 1 + 1 AS resultado_prueba;
