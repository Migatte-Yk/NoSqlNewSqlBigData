// =====================================================================
// 05_agregaciones.js  (B5. Agregaciones)  -- solo lectura
//   mongosh --quiet --file mongodb/05_agregaciones.js
// =====================================================================
const dbp = db.getSiblingDB("practica_matriculas");
const show = (t, v) => { print("\n--- " + t); printjson(v); };

// Pipeline 1: estudiantes por programa
//   $group  agrupa por programa_id y cuenta; $lookup trae el nombre del programa
//   (equivalente al JOIN); $unwind aplana el resultado del lookup;
//   $project da forma a la salida; $sort ordena.
show("P1) estudiantes por programa", dbp.estudiantes.aggregate([
  { $group: { _id: "$programa_id", total_estudiantes: { $sum: 1 } } },
  { $lookup: { from: "programas", localField: "_id", foreignField: "_id", as: "programa" } },
  { $unwind: "$programa" },
  { $project: { _id: 0, programa: "$programa.nombre", total_estudiantes: 1 } },
  { $sort: { total_estudiantes: -1, programa: 1 } }
]).toArray());

// Pipeline 2: matrículas por estado
//   $unwind "desenrolla" el array embebido: un documento por matrícula;
//   $group cuenta por estado; $sort ordena de mayor a menor.
show("P2) matrículas por estado", dbp.estudiantes.aggregate([
  { $unwind: "$matriculas" },
  { $group: { _id: "$matriculas.estado", total: { $sum: 1 } } },
  { $sort: { total: -1 } }
]).toArray());

// Pipeline 3: resumen por semestre (conteo, créditos y valor total)
show("P3) resumen por semestre", dbp.estudiantes.aggregate([
  { $unwind: "$matriculas" },
  { $group: { _id: "$matriculas.semestre", matriculas: { $sum: 1 },
              creditos_totales: { $sum: "$matriculas.creditos" }, valor_total: { $sum: "$matriculas.valor" } } },
  { $sort: { _id: 1 } }
]).toArray());

// Pipeline 4: programas con >= 8 matrículas (equivalente a HAVING en SQL: $match tras $group)
show("P4) programas con al menos 8 matrículas", dbp.estudiantes.aggregate([
  { $unwind: "$matriculas" },
  { $group: { _id: "$programa_id", total_matriculas: { $sum: 1 } } },
  { $match: { total_matriculas: { $gte: 8 } } },
  { $lookup: { from: "programas", localField: "_id", foreignField: "_id", as: "p" } },
  { $unwind: "$p" },
  { $project: { _id: 0, programa: "$p.nombre", total_matriculas: 1 } },
  { $sort: { total_matriculas: -1 } }
]).toArray());
