// =====================================================================
// 04_actualizaciones.js  (B4. Actualizaciones y eliminaciones)
//   mongosh --quiet --file mongodb/04_actualizaciones.js
// Deja la base en su estado inicial: todo cambio se revierte o se hace sobre
// un documento de prueba (_id "E9999999"). No hay borrados masivos.
// =====================================================================
const dbp = db.getSiblingDB("practica_matriculas");
const show = (t, v) => { print("\n--- " + t); printjson(v); };

// 1) updateOne: cambio de ciudad de un estudiante (antes / después)
show("antes", dbp.estudiantes.findOne({ _id: "E2024001" }, { ciudad: 1 }));
show("updateOne", dbp.estudiantes.updateOne({ _id: "E2024001" }, { $set: { ciudad: "Cajicá" } }));
show("después", dbp.estudiantes.findOne({ _id: "E2024001" }, { ciudad: 1 }));
dbp.estudiantes.updateOne({ _id: "E2024001" }, { $set: { ciudad: "Fusagasugá" } }); // restaurar

// 2) updateMany: añadir un campo (etiqueta) a los estudiantes del programa 5 y retirarlo después
show("updateMany $set", dbp.estudiantes.updateMany({ programa_id: 5 }, { $set: { etiqueta: "revisado" } }));
show("verificación (programa 5)", dbp.estudiantes.countDocuments({ etiqueta: "revisado" }));
show("updateMany $unset (limpieza)", dbp.estudiantes.updateMany({ etiqueta: "revisado" }, { $unset: { etiqueta: "" } }));

// 3) Actualización de un elemento de un array embebido con arrayFilters
show("matrícula 2025-1 de E2024002 antes", dbp.estudiantes.findOne({ _id: "E2024002" }, { matriculas: 1 }).matriculas);
dbp.estudiantes.updateOne({ _id: "E2024002" }, { $set: { "matriculas.$[m].estado": "APLAZADA" } }, { arrayFilters: [{ "m.semestre": "2025-1" }] });
show("después", dbp.estudiantes.findOne({ _id: "E2024002" }, { matriculas: 1 }).matriculas);
dbp.estudiantes.updateOne({ _id: "E2024002" }, { $set: { "matriculas.$[m].estado": "FINALIZADA" } }, { arrayFilters: [{ "m.semestre": "2025-1" }] }); // restaurar

// 4) deleteOne sobre un documento de prueba
dbp.estudiantes.insertOne({ _id: "E9999999", codigo: "E9999999", nombres: "Prueba", apellidos: "Borrable",
  correo: "prueba@ejemplo.invalid", programa_id: 1, matriculas: [] });
show("existe antes", dbp.estudiantes.countDocuments({ _id: "E9999999" }));
show("deleteOne", dbp.estudiantes.deleteOne({ _id: "E9999999" }));
show("existe después (debe ser 0)", dbp.estudiantes.countDocuments({ _id: "E9999999" }));

// 5) Sin esquema impuesto: MongoDB acepta un estado inválido (en SQL el CHECK lo rechazó) -> se deja constancia y se limpia
dbp.estudiantes.insertOne({ _id: "E9999998", codigo: "E9999998", programa_id: 999, matriculas: [{ estado: "INVALIDO" }] });
show("insert sin validación (programa_id 999 inexistente)", dbp.estudiantes.countDocuments({ _id: "E9999998" }));
dbp.estudiantes.deleteOne({ _id: "E9999998" });

show("conteo final de estudiantes (debe ser 24)", dbp.estudiantes.countDocuments());
