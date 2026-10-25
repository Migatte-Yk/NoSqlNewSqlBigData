# Informe de práctica: Bases de datos NewSQL y NoSQL
**BORRADOR — no definitivo (contiene marcadores [PENDIENTE]).**

**Estudiante:** [PENDIENTE: nombre] · **Docente:** [PENDIENTE] · **Universidad:** Universidad de Cundinamarca · **Asignatura:** Big Data (604025) · **Fecha:** [PENDIENTE]

## 1. Resumen
Se diseñó un caso de estudio de estudiantes y matrículas con datos sintéticos y se implementó en CockroachDB v26.3.2 (nodo único local) y MongoDB 9.0.2. Se ejecutaron scripts SQL y mongosh y se contrastaron los resultados (5 programas, 24 estudiantes, 36 matrículas). [PENDIENTE: ajustar tras las capturas]

## 2. Introducción
Actividad R2-A2-S12. La guía del docente cubre la instalación de NewSQL; los ejercicios fueron diseñados por el estudiante a partir de los requisitos de Moodle.

## 3. Objetivo general
Resolver y documentar ejercicios prácticos con un motor NewSQL y uno NoSQL documental.

## 4. Objetivos específicos
- Verificar y usar CockroachDB (esquema, carga, consultas, manipulación, transacciones).
- Instalar y usar MongoDB y Compass (modelo documental, consultas, actualizaciones, agregaciones).
- Comparar ambos enfoques distinguiendo lo documentado de lo observado.

## 5. Marco conceptual
[PENDIENTE: redactar NewSQL, NoSQL y Big Data con citas APA de fuentes verificadas en `referencias/fuentes.md`.]

## 6. Herramientas y entorno
Windows 11; CockroachDB v26.3.2 (`start-single-node --insecure`, un nodo, desarrollo local); MongoDB Server 9.0.2 standalone; mongosh 2.14.0; Compass 1.53.1; Git; Python 3. Sin pruebas de distribución ni rendimiento.

## 7. Metodología
Datos sintéticos generados de forma determinista (`datos/generar_datos.py`), mismos registros lógicos en ambos motores; scripts ejecutados con `cockroach sql -f` y `mongosh --file`; salidas guardadas en `evidencias/salidas/`.

## 8. Desarrollo CockroachDB
Para cada ejercicio: objetivo, procedimiento (script), resultado observado, evidencia.

| Ej. | Script | Resultado observado (ejecutado) | Evidencia |
|---|---|---|---|
| A1 | `01_verificacion.sql` | Versión CCL v26.3.2; usuario `root`; conexión correcta | [PENDIENTE: captura] |
| A2 | `02_esquema.sql` | 3 tablas con PK, FK, CHECK, UNIQUE | [PENDIENTE: captura] |
| A3 | `03_carga_datos.sql` | 5 / 24 / 36 filas | [PENDIENTE: captura] |
| A4 | `04_consultas.sql` | 10 consultas; p. ej. matrículas por estado: FINALIZADA 26, ACTIVA 6, APLAZADA 3, CANCELADA 1 | [PENDIENTE: captura] |
| A5 | `05_manipulacion.sql` | UPDATE y DELETE verificados; 4 violaciones de restricción rechazadas (FK, CHECK, FK al borrar, UNIQUE) | [PENDIENTE: captura] |
| A6 | `06_transacciones.sql` | COMMIT conservó el alta; ROLLBACK la revirtió; matrículas 36 → 36 | [PENDIENTE: captura] |

Interpretación: el motor impone la integridad declarativamente. Al ser un único nodo, no se observó distribución física.

## 9. Desarrollo MongoDB

| Ej. | Script | Resultado observado (ejecutado) | Evidencia |
|---|---|---|---|
| B1 | `01_verificacion.js` | Servidor 9.0.2 standalone, `ping` ok | [PENDIENTE: captura de Compass conectado] |
| B2/B3.1 | `02_carga_datos.js` | 5 programas, 24 estudiantes, 36 matrículas embebidas | [PENDIENTE] |
| B3 | `03_consultas.js` | 10 consultas (filtro, proyección, orden, comparación, combinadas, conteo, arrays) | [PENDIENTE] |
| B4 | `04_actualizaciones.js` | updateOne, updateMany, arrayFilters, deleteOne verificados; MongoDB aceptó un documento con referencia inválida | [PENDIENTE] |
| B5 | `05_agregaciones.js` | 4 pipelines; coinciden con las agregaciones SQL (5/5/5/5/4 por programa) | [PENDIENTE] |
| B6 | — | Exportación desde Compass: [PENDIENTE: ejecutar y capturar] | [PENDIENTE] |

## 10. Resultados observados
Los resultados de agregación coinciden entre ambos motores. Diferencia práctica observada: SQL rechazó los datos inválidos; MongoDB, sin validación configurada, los aceptó.

## 11. Comparación técnica
Lo siguiente es **documentación del fabricante / teoría** (a citar) salvo donde se indica "observado":
- Modelo: relacional distribuido vs. documental. Observado: 3 tablas vs. 2 colecciones con matrículas embebidas.
- Integridad: observado, ver sección 10.
- Relaciones: JOIN vs. `$lookup` / embebido (observado).
- Transacciones: observadas solo en CockroachDB; en MongoDB no se probaron.
- Escalabilidad/distribución: [teoría, sin prueba]; ambos se usaron en un solo nodo.
- Rendimiento: no medido; no se afirma que un motor sea más rápido.

## 12. Limitaciones
Un nodo por motor; datos pequeños y sintéticos; sin pruebas de rendimiento, alta disponibilidad ni escalabilidad; ejercicios propios, no oficiales.

## 13. Conclusiones
[PENDIENTE: redactar al cerrar evidencias.]

## 14. Referencias (APA 7)
[PENDIENTE: completar solo con fuentes verificadas; ver `referencias/fuentes.md`.]

## 15. Repositorio
[PENDIENTE: URL de GitHub]

---
### Lista de pendientes
1. Capturas 1–11 (ver `evidencias/README.md`).
2. Ejecutar y capturar exportación desde Compass (B6).
3. Verificar fuentes y redactar marco conceptual y referencias APA.
4. Datos de portada, conclusiones, URL del repositorio.
5. Generar PDF y revisar.
