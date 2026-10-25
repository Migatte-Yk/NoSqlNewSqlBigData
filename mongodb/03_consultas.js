// =====================================================================
// 03_consultas.js  (B3. Consultas)  -- solo lectura
//   mongosh --quiet --file mongodb/03_consultas.js
// =====================================================================
const dbp = db.getSiblingDB("practica_matriculas");
const show = (t, v) => { print("\n--- " + t); printjson(v); };

// 1) Consulta general (primeros 3 documentos para no saturar la salida)
show("1) find() general (3 de N)", dbp.estudiantes.find().limit(3).toArray());

// 2) Filtro por programa académico (programa_id = 1, Ingeniería de Sistemas)
show("2) programa_id = 1", dbp.estudiantes.find({ programa_id: 1 }, { nombres: 1, apellidos: 1 }).toArray());

// 3) Proyección: solo algunos campos, sin _id
show("3) proyección", dbp.estudiantes.find({}, { _id: 0, codigo: 1, nombres: 1, ciudad: 1 }).limit(5).toArray());

// 4) Ordenamiento: por apellidos ascendente
show("4) sort apellidos", dbp.estudiantes.find({}, { _id: 0, codigo: 1, apellidos: 1 }).sort({ apellidos: 1 }).limit(5).toArray());

// 5) Operadores de comparación: ingresados desde 2025-01-01 ($gte)
show("5) fecha_ingreso >= 2025-01-01",
  dbp.estudiantes.find({ fecha_ingreso: { $gte: new Date("2025-01-01") } }, { _id: 0, codigo: 1, fecha_ingreso: 1 }).toArray());

// 6) Condiciones combinadas: programa 1 o 2 Y de Bogotá o Fusagasugá
show("6) $and/$or",
  dbp.estudiantes.find({
    $and: [{ programa_id: { $in: [1, 2] } }, { $or: [{ ciudad: "Bogotá" }, { ciudad: "Fusagasugá" }] }]
  }, { _id: 0, codigo: 1, programa_id: 1, ciudad: 1 }).toArray());

// 7) Campo opcional: estudiantes SIN teléfono (campo ausente)
show("7) telefono inexistente", dbp.estudiantes.find({ telefono: { $exists: false } }, { _id: 0, codigo: 1 }).toArray());

// 8) Conteos
show("8) conteos", {
  total_estudiantes: dbp.estudiantes.countDocuments(),
  programa_1: dbp.estudiantes.countDocuments({ programa_id: 1 }),
  total_programas: dbp.programas.countDocuments()
});

// 9) Estudiantes con varias matrículas (tamaño del array embebido >= 2)
show("9) más de una matrícula ($expr + $size)",
  dbp.estudiantes.find({ $expr: { $gte: [{ $size: "$matriculas" }, 2] } }, { _id: 0, codigo: 1, apellidos: 1 }).toArray());

// 10) Consulta en un array embebido: estudiantes con alguna matrícula CANCELADA ($elemMatch)
show("10) matrícula CANCELADA", dbp.estudiantes.find({ matriculas: { $elemMatch: { estado: "CANCELADA" } } }, { _id: 0, codigo: 1 }).toArray());
