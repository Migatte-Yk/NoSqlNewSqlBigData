"""Genera los datos SINTÉTICOS de la práctica (no hay personas reales).

Salidas (siempre idénticas, el generador es determinista):
  datos/programas.json
  datos/estudiantes.json   (matrículas embebidas)
  cockroachdb/03_carga_datos.sql

Uso:  python datos/generar_datos.py
"""
import json
import random
from datetime import date, timedelta
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
random.seed(604025)

PROGRAMAS = [
    (1, "ISIS", "Ingeniería de Sistemas", "Ingeniería", 10),
    (2, "ADEM", "Administración de Empresas", "Ciencias Administrativas", 9),
    (3, "CONT", "Contaduría Pública", "Ciencias Administrativas", 9),
    (4, "ZOOT", "Zootecnia", "Ciencias Agropecuarias", 10),
    (5, "ENFE", "Enfermería", "Ciencias de la Salud", 8),
]
NOMBRES = ["Ana", "Luis", "María", "Carlos", "Laura", "Andrés", "Camila", "Jorge",
           "Valentina", "Felipe", "Daniela", "Sebastián", "Paula", "Mateo", "Sofía",
           "Diego", "Natalia", "Santiago", "Isabela", "Julián", "Lucía", "Nicolás",
           "Juliana", "Tomás"]
APELLIDOS = ["Ramírez", "Gómez", "Torres", "Rojas", "Herrera", "Castro", "Vargas",
             "Moreno", "Jiménez", "Pardo", "Salazar", "Ortiz", "Mejía", "Cárdenas",
             "Quintero", "Parra", "Suárez", "Rincón", "Bernal", "Acosta", "Peña",
             "Ríos", "Cortés", "Lozano"]
CIUDADES = ["Fusagasugá", "Bogotá", "Soacha", "Girardot", "Silvania", "Arbeláez"]
ESTADOS = ["ACTIVA", "FINALIZADA", "CANCELADA", "APLAZADA"]
SEMESTRES = {"2024-1": date(2024, 2, 5), "2024-2": date(2024, 8, 5),
             "2025-1": date(2025, 2, 3), "2025-2": date(2025, 8, 4),
             "2026-1": date(2026, 2, 2)}
VALOR_CREDITO = 180000

N_EST = 24
estudiantes = []
for i in range(N_EST):
    prog = PROGRAMAS[i % 5][0]
    est = {
        "codigo": f"E{2024000 + i + 1}",
        "nombres": NOMBRES[i],
        "apellidos": f"{APELLIDOS[i]} {APELLIDOS[(i * 7 + 3) % len(APELLIDOS)]}",
        "correo": f"est{i + 1:02d}@ejemplo.invalid",
        "fecha_nacimiento": (date(1998, 1, 1) + timedelta(days=random.randint(0, 2900))).isoformat(),
        "ciudad": random.choice(CIUDADES),
        "programa_id": prog,
        "fecha_ingreso": random.choice(["2024-02-05", "2024-08-05", "2025-02-03"]),
    }
    # Campo opcional: solo ~2/3 de los estudiantes tienen teléfono (NULL en SQL, ausente en Mongo)
    if i % 3 != 2:
        est["telefono"] = f"300{random.randint(1000000, 9999999)}"
    estudiantes.append(est)

# 36 matrículas: todos tienen 1; los 12 primeros tienen una segunda (varias matrículas).
matriculas = []  # (codigo, semestre, fecha, estado, creditos)
semestres = list(SEMESTRES)
for i, est in enumerate(estudiantes):
    ingreso = est["fecha_ingreso"]
    primero = "2024-1" if ingreso == "2024-02-05" else "2024-2" if ingreso == "2024-08-05" else "2025-1"
    cadena = semestres[semestres.index(primero):]
    n = 2 if i < 12 else 1
    for k in range(n):
        sem = cadena[k]
        # El semestre vigente (2026-1) está ACTIVA; los anteriores, mayoritariamente FINALIZADA
        estado = random.choices(ESTADOS, weights=[1, 7, 1, 1])[0] if sem != "2026-1" else "ACTIVA"
        if k == 0 and n == 2 and sem == "2024-1" and i % 4 == 0:
            estado = "FINALIZADA"
        f = SEMESTRES[sem] + timedelta(days=random.randint(0, 10))
        matriculas.append((est["codigo"], sem, f.isoformat(), estado, random.choice([12, 14, 16, 18, 20])))

# Los 12 primeros reciben 2 matrículas; añadimos 2 más a estudiantes 13..14 para llegar a 38 si hace falta
assert len(matriculas) >= 30, len(matriculas)

for est in estudiantes:
    est["matriculas"] = [
        {"semestre": s, "fecha_matricula": f, "estado": e, "creditos": c, "valor": c * VALOR_CREDITO}
        for (cod, s, f, e, c) in matriculas if cod == est["codigo"]
    ]

programas_json = [
    {"programa_id": p, "codigo": c, "nombre": n, "facultad": fac, "duracion_semestres": d}
    for (p, c, n, fac, d) in PROGRAMAS
]

(RAIZ / "datos" / "programas.json").write_text(
    json.dumps(programas_json, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
(RAIZ / "datos" / "estudiantes.json").write_text(
    json.dumps(estudiantes, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def q(v):
    return "NULL" if v is None else "'" + str(v).replace("'", "''") + "'"


sql = [
    "-- =====================================================================",
    "-- 03_carga_datos.sql  (A3. Inserción y carga)  -- GENERADO por datos/generar_datos.py",
    "-- DATOS 100% SINTÉTICOS: personas y correos ficticios (dominio .invalid).",
    "-- Reinicialización controlada: SOLO vacía las 3 tablas del proyecto en la base",
    "-- practica_matriculas (hijas primero). Úsese únicamente para recargar el estado inicial.",
    "-- =====================================================================",
    "USE practica_matriculas;",
    "",
    "-- Reinicio acotado a las tablas del proyecto (respeta el orden de las FK)",
    "DELETE FROM matriculas WHERE true;",
    "DELETE FROM estudiantes WHERE true;",
    "DELETE FROM programas WHERE true;",
    "",
    "-- 1) Programas académicos",
    "INSERT INTO programas (programa_id, codigo, nombre, facultad, duracion_semestres) VALUES",
    ",\n".join(f"  ({p}, {q(c)}, {q(n)}, {q(fac)}, {d})" for (p, c, n, fac, d) in PROGRAMAS) + ";",
    "",
    "-- 2) Estudiantes (telefono NULL = campo opcional)",
    "INSERT INTO estudiantes (codigo, nombres, apellidos, correo, fecha_nacimiento, ciudad, programa_id, fecha_ingreso, telefono) VALUES",
    ",\n".join(
        f"  ({q(e['codigo'])}, {q(e['nombres'])}, {q(e['apellidos'])}, {q(e['correo'])}, "
        f"{q(e['fecha_nacimiento'])}, {q(e['ciudad'])}, {e['programa_id']}, {q(e['fecha_ingreso'])}, {q(e.get('telefono'))})"
        for e in estudiantes) + ";",
    "",
    "-- 3) Matrículas (matricula_id generado por la secuencia de identidad de la tabla)",
    "INSERT INTO matriculas (codigo_estudiante, semestre, fecha_matricula, estado, creditos, valor) VALUES",
    ",\n".join(
        f"  ({q(cod)}, {q(s)}, {q(f)}, {q(e)}, {c}, {c * VALOR_CREDITO})"
        for (cod, s, f, e, c) in matriculas) + ";",
    "",
    "-- 4) Comprobación de cantidades cargadas",
    "SELECT 'programas' AS tabla, count(*) AS filas FROM programas",
    "UNION ALL SELECT 'estudiantes', count(*) FROM estudiantes",
    "UNION ALL SELECT 'matriculas', count(*) FROM matriculas;",
    "",
]
(RAIZ / "cockroachdb" / "03_carga_datos.sql").write_text("\n".join(sql), encoding="utf-8")
print(f"programas={len(PROGRAMAS)} estudiantes={len(estudiantes)} matriculas={len(matriculas)}")
