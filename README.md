# Práctica R2-A2-S12: NewSQL (CockroachDB) y NoSQL (MongoDB)

Asignatura Big Data (604025), Universidad de Cundinamarca. Caso de estudio: estudiantes, programas y matrículas.
**Todos los datos son sintéticos** (nombres ficticios, correos `@ejemplo.invalid`); fueron generados en el propio entorno con `datos/generar_datos.py` como proceso de preparación, no provienen de una fuente externa.
Los ejercicios son de diseño propio: el docente solo entregó la guía de instalación de NewSQL, no una batería de ejercicios.

## Tecnologías
CockroachDB v26.3.2 (un nodo local, modo `--insecure`, desarrollo), MongoDB Community Server 9.0.2, mongosh 2.14.0, MongoDB Compass 1.53.1, Git, Python 3 (generador de datos).

## Limitaciones del entorno
Ambos motores corren en **un solo nodo local**. No se probó distribución, alta disponibilidad, escalabilidad ni rendimiento. No hay medición comparativa de velocidad.

## Requisitos (Windows)
- CockroachDB descargado (en este equipo: `C:\bigdata\cockroach\cockroach.exe`; ajustar la variable `CRDB` si la ruta cambia).
- MongoDB Server, mongosh y Compass: `winget install MongoDB.Server`, `winget install MongoDB.Shell`, `winget install MongoDB.Compass.Full` (servidor y Compass son paquetes separados).

## CockroachDB
Iniciar (si no está corriendo; reutiliza el almacén existente):
```powershell
C:\bigdata\cockroach\cockroach.exe start-single-node --insecure --store=C:\bigdata\cockroach\data --listen-addr=localhost:26257 --http-addr=localhost:8080
```
Ejecutar desde la raíz del proyecto, en este orden:
```powershell
$CRDB = "C:\bigdata\cockroach\cockroach.exe"
& $CRDB sql --insecure --host=localhost:26257 -f cockroachdb\01_verificacion.sql
& $CRDB sql --insecure --host=localhost:26257 -f cockroachdb\02_esquema.sql
& $CRDB sql --insecure --host=localhost:26257 -f cockroachdb\03_carga_datos.sql
& $CRDB sql --insecure --host=localhost:26257 -f cockroachdb\04_consultas.sql
& $CRDB sql --insecure --host=localhost:26257 --set errexit=false -f cockroachdb\05_manipulacion.sql
& $CRDB sql --insecure --host=localhost:26257 -f cockroachdb\06_transacciones.sql
```
`02_esquema.sql` y `03_carga_datos.sql` reinician **solo** las tablas de la base `practica_matriculas`; úselos únicamente para volver al estado inicial. En `05` los 4 errores de restricción son esperados.
Resultados esperados: 5 programas, 24 estudiantes, 36 matrículas; matrículas por estado FINALIZADA 26 / ACTIVA 6 / APLAZADA 3 / CANCELADA 1; tras la transacción con ROLLBACK el conteo vuelve a 36.

## MongoDB
El servicio `MongoDB` se inicia automáticamente (puerto 27017). Ejecutar desde la **raíz** del proyecto:
```powershell
mongosh --quiet --file mongodb\01_verificacion.js
mongosh --quiet --file mongodb\02_carga_datos.js
mongosh --quiet --file mongodb\03_consultas.js
mongosh --quiet --file mongodb\04_actualizaciones.js
mongosh --quiet --file mongodb\05_agregaciones.js
```
`02_carga_datos.js` elimina y recrea solo las colecciones `programas` y `estudiantes` de `practica_matriculas`.
Resultados esperados: 5 / 24 / 36 (matrículas embebidas); mismas agregaciones que en SQL.

### Equivalente en Compass
1. Abrir Compass, **New connection**, URI `mongodb://localhost:27017`, **Connect**.
2. Cargar datos: base `practica_matriculas` → colección `estudiantes` → **Add Data → Import JSON file** → `datos\estudiantes.json` (las fechas quedarán como texto; para tipo Date, usar el script `02_carga_datos.js`). Repetir con `programas.json`.
3. Consultas: pestaña **Documents**, campos Filter / Project / Sort (p. ej. Filter `{ programa_id: 1 }`, Project `{ nombres: 1, apellidos: 1 }`, Sort `{ apellidos: 1 }`).
4. Agregaciones: pestaña **Aggregations**, añadir etapas ($group, $lookup, $unwind, $sort) del archivo `05_agregaciones.js`.
5. Exportar: pestaña Documents → **Export Data → Export the full collection** o **Export query results**, formato JSON o CSV.

## Modelo de datos
| SQL (CockroachDB) | MongoDB |
|---|---|
| `programas`, `estudiantes`, `matriculas` (3 tablas, FK) | `programas`, `estudiantes` (matrículas embebidas en el array `matriculas`) |
| `telefono NULL` | campo `telefono` ausente en algunos documentos |
| CHECK/FK/UNIQUE impuestos por el motor | solo índice único en `correo`; la integridad referencial la gestiona la aplicación (ver `04_actualizaciones.js`, apartado 5) |

## Contenido
`datos/` datos sintéticos y generador · `cockroachdb/` scripts SQL · `mongodb/` scripts mongosh · `evidencias/` salidas reales y lista de capturas · `informe/` informe técnico · `referencias/` fuentes.

## Estado de los ejercicios
| Ejercicio | Estado |
|---|---|
| A1–A6 (CockroachDB) | Ejecutados correctamente (salidas en `evidencias/salidas/crdb_*.txt`) |
| B1 | Servidor, mongosh y Compass instalados; servicio activo; Compass conectado a `localhost:27017` |
| B2–B5 | Ejecutados correctamente con mongosh y Compass (`evidencias/salidas/mongo_*.txt`) |
| B6 (exportación desde Compass) | Documentada; **no ejecutada** |
| Capturas de pantalla | 16 imágenes en `evidencias/` (ver índice en `evidencias/README.md`) |

Autor: Nikolas Krejci · Especialización en Analítica y Ciencia de Datos, Universidad de Cundinamarca.
Informe técnico: [`informe/informe_tecnico.pdf`](informe/informe_tecnico.pdf).
Repositorio: https://github.com/Migatte-Yk/NoSqlNewSqlBigData
