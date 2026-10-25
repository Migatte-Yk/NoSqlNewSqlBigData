"""Convierte informe_tecnico.md en informe_tecnico.pdf.

Requisitos: Python 3, `pip install markdown` y Microsoft Edge (se usa su modo headless).
Uso (desde la raíz del proyecto):  python informe/generar_pdf.py
"""
import re
import subprocess
import sys
from pathlib import Path

import markdown

AQUI = Path(__file__).resolve().parent
MD = AQUI / "informe_tecnico.md"
HTML = AQUI / "_informe_temp.html"
PDF = AQUI / "informe_tecnico.pdf"
EDGE = [
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Microsoft\Edge\Application\msedge.exe",
]

CSS = """
@page { size: A4; margin: 2.2cm 2cm 2.2cm 2cm;
  @top-center { content: "Práctica R2-A2-S12 — NewSQL y NoSQL · Big Data (604025)"; font: 9pt Georgia, serif; color: #555; }
  @bottom-center { content: "Página " counter(page); font: 9pt Georgia, serif; color: #555; } }
@page :first { @top-center { content: none; } @bottom-center { content: none; } }
body { font-family: Georgia, 'Times New Roman', serif; font-size: 11pt; line-height: 1.45; color: #111; }
h1 { font-size: 22pt; margin: 0.4em 0; } h2 { font-size: 15pt; border-bottom: 1px solid #999; padding-bottom: 2px; margin-top: 1.4em; page-break-after: avoid; }
h3 { font-size: 12.5pt; margin-top: 1.1em; page-break-after: avoid; }
.portada { text-align: center; padding-top: 4cm; line-height: 2; } .portada p { text-align: center; } .portada h1 { font-size: 26pt; margin-bottom: 0; } .portada h2 { border: none; font-size: 15pt; font-weight: normal; }
.salto { page-break-after: always; }
table { border-collapse: collapse; width: 100%; font-size: 9.5pt; margin: 0.6em 0; page-break-inside: auto; }
th, td { border: 1px solid #888; padding: 4px 6px; vertical-align: top; text-align: left; } th { background: #e8e8e8; } tr { page-break-inside: avoid; }
pre { background: #f4f4f4; border: 1px solid #ccc; padding: 6px 8px; font-size: 8.5pt; white-space: pre-wrap; word-break: break-word; page-break-inside: avoid; }
code { font-family: Consolas, 'Courier New', monospace; font-size: 9pt; word-break: break-word; }
p { margin: 0.5em 0; text-align: justify; word-break: break-word; }
img { max-width: 100%; max-height: 17cm; display: block; margin: 0.6em auto 0.2em; border: 1px solid #bbb; }
p:has(> img) { page-break-inside: avoid; page-break-after: avoid; text-align: center; margin-bottom: 0; }
figure { margin: 0; }
"""

texto = MD.read_text(encoding="utf-8")
texto = re.sub(r"\A---\n.*?\n---\n", "", texto, flags=re.S)
texto = texto.replace('<div class="portada">', '<div class="portada" markdown="1">')
cuerpo = markdown.markdown(texto, extensions=["tables", "fenced_code", "md_in_html"])
# El título de la figura (texto alternativo) se muestra debajo de cada imagen
cuerpo = re.sub(r'<img alt="([^"]*)" src="([^"]*)" ?/?>',
                r'<img alt="\1" src="\2"><br><em style="font-size:9.5pt">\1</em>', cuerpo)
# Enlaces desnudos visibles y clicables
cuerpo = re.sub(r'(?<![">])(https?://[^\s<]+)', r'<a href="\1">\1</a>', cuerpo)
HTML.write_text(f'<!doctype html><html lang="es"><head><meta charset="utf-8"><style>{CSS}</style></head><body>{cuerpo}</body></html>',
                encoding="utf-8")

edge = next((e for e in EDGE if Path(e).exists()), None)
if not edge:
    sys.exit("No se encontró Microsoft Edge.")
subprocess.run([edge, "--headless", "--disable-gpu", "--no-pdf-header-footer",
                f"--print-to-pdf={PDF}", HTML.as_uri()], check=True)
HTML.unlink()
print("PDF generado:", PDF)
