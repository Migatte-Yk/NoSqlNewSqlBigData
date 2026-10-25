// =====================================================================
// 02_carga_datos.js  (B2. Estructura documental + B3.1 Inserción)
// Ejecutar desde la RAÍZ del proyecto (las rutas de datos son relativas):
//   mongosh --quiet --file mongodb/02_carga_datos.js
//
// Modelo: colección "programas" y colección "estudiantes" con las matrículas
// EMBEBIDAS (array "matriculas"). Cada estudiante guarda "programa_id" como
// referencia al programa (equivale a la FK de SQL, pero MongoDB no la impone).
// Datos 100% sintéticos (datos/*.json).
//
// REINICIALIZACIÓN: elimina y recrea SOLO las colecciones "programas" y
// "estudiantes" de la base practica_matriculas. No toca otras bases.
// =====================================================================
const fs = require("fs");
const dbp = db.getSiblingDB("practica_matriculas");

const programas = JSON.parse(fs.readFileSync("datos/programas.json", "utf8"));
const estudiantes = JSON.parse(fs.readFileSync("datos/estudiantes.json", "utf8"));

// Las fechas llegan como texto ISO en el JSON: se convierten al tipo BSON Date.
estudiantes.forEach(e => {
  e.fecha_nacimiento = new Date(e.fecha_nacimiento);
  e.fecha_ingreso = new Date(e.fecha_ingreso);
  e.matriculas.forEach(m => { m.fecha_matricula = new Date(m.fecha_matricula); });
});

dbp.programas.drop();
dbp.estudiantes.drop();

// _id natural: programa_id y código de estudiante
dbp.programas.insertMany(programas.map(p => ({ _id: p.programa_id, ...p })));
dbp.estudiantes.insertMany(estudiantes.map(e => ({ _id: e.codigo, ...e })));

// Índices (equivalentes a UNIQUE / INDEX del esquema SQL)
dbp.estudiantes.createIndex({ correo: 1 }, { unique: true });
dbp.estudiantes.createIndex({ programa_id: 1 });

print("programas:   " + dbp.programas.countDocuments());
print("estudiantes: " + dbp.estudiantes.countDocuments());
print("matrículas embebidas: " +
  dbp.estudiantes.aggregate([{ $unwind: "$matriculas" }, { $count: "n" }]).toArray()[0].n);
