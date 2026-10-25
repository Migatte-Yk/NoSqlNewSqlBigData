# Evidencias de la práctica

Las salidas de texto de `salidas/` fueron producidas ejecutando realmente los scripts (ver comandos en el README raíz).
**Las capturas de pantalla las debe tomar el estudiante** (no se generan imágenes artificiales). Guardar cada una en esta carpeta con el nombre indicado.

## Capturas requeridas

| # | Archivo | Ventana a abrir | Qué ejecutar / mostrar |
|---|---|---|---|
| 1 | `01_cockroach_version_conexion.png` | Terminal de VS Code | `C:\bigdata\cockroach\cockroach.exe sql --insecure --host=localhost:26257 -f cockroachdb\01_verificacion.sql` (versión + conexión) |
| 2 | `02_cockroach_esquema.png` | Terminal | `... -f cockroachdb\02_esquema.sql` (tablas, constraints) o `SHOW TABLES;` dentro de `practica_matriculas` |
| 3 | `03_cockroach_carga_conteos.png` | Terminal | `... -f cockroachdb\03_carga_datos.sql` (conteos 5 / 24 / 36) |
| 4 | `04_cockroach_consultas.png` | Terminal | `... -f cockroachdb\04_consultas.sql` (consultas 1–3, 5, 10) |
| 5 | `05_cockroach_join_agregaciones.png` | Terminal | Consultas 4, 6, 7, 8 y 9 del mismo script |
| 6 | `06_cockroach_update_validacion.png` | Terminal | `... --set errexit=false -f cockroachdb\05_manipulacion.sql` y `06_transacciones.sql` |
| 7 | `07_compass_conexion.png` | MongoDB Compass | Conexión `mongodb://localhost:27017` en estado conectado |
| 8 | `08_compass_coleccion.png` | Compass → `practica_matriculas.estudiantes` | Pestaña Documents con los 24 documentos |
| 9 | `09_compass_filtros_proyeccion.png` | Compass → Documents | Filter `{ programa_id: 1 }`, Project `{ nombres: 1, apellidos: 1 }`, Sort `{ apellidos: 1 }` |
| 10 | `10_mongo_actualizaciones_agregaciones.png` | Compass → Aggregations o terminal | `mongosh --file mongodb\04_actualizaciones.js` y `05_agregaciones.js` |
| 11 | `11_github_repositorio.png` | Navegador | Página del repositorio GitHub publicado (cuando exista) |
| 12 | `12_cockroach_ui.png` (opcional) | Navegador http://localhost:8080 | Panel de CockroachDB (nodo en vivo) |

## Estado de los ejercicios

Se actualiza conforme se ejecuta. Ver tabla en el README raíz.
