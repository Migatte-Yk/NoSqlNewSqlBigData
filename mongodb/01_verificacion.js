// =====================================================================
// 01_verificacion.js  (B1. Instalación y conexión)  -- solo lectura
// Ejecutar desde la raíz del proyecto:
//   mongosh --quiet --file mongodb/01_verificacion.js
// =====================================================================

// Versión del servidor y de la shell
print("Versión del servidor MongoDB: " + db.version());
print("Versión de mongosh:           " + version());

// Comprobación de conexión (debe devolver { ok: 1 })
printjson(db.adminCommand({ ping: 1 }));

// Información del nodo al que se conectó la sesión (instancia standalone local)
const h = db.hello();
print("¿Es primario/standalone? isWritablePrimary=" + h.isWritablePrimary +
      " | setName=" + (h.setName || "(sin conjunto de réplicas: standalone)"));

// Bases de datos existentes
printjson(db.adminCommand({ listDatabases: 1, nameOnly: true }).databases.map(d => d.name));

// Consulta sencilla de verificación
printjson(db.runCommand({ buildInfo: 1 }).version);
