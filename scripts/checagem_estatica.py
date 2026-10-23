"""Confere arquivos, pinagem, tabela dos displays e configuracao principal.
Nao substitui compilacao ou simulacao VHDL.
"""
from pathlib import Path
import re

base = Path(__file__).resolve().parents[1]
qsf = (base / "quartus/fechadura_de0.qsf").read_text()
dec = (base / "src/binto7seg.vhd").read_text()
main = (base / "src/main.vhd").read_text()
expected_pins = {
  'CLOCK_50':'G21', 'SW[9]':'D2', 'SW[8]':'E4', 'SW[7]':'E3',
  'SW[6]':'H7', 'SW[5]':'J7', 'SW[4]':'G5', 'SW[3]':'G4',
  'SW[2]':'H6', 'SW[1]':'H5', 'SW[0]':'J6',
  'LEDG[9]':'B1', 'LEDG[8]':'B2', 'LEDG[7]':'C2', 'LEDG[6]':'C1',
  'LEDG[5]':'E1', 'LEDG[4]':'F2', 'LEDG[3]':'H1',
  'LEDG[2]':'J3', 'LEDG[1]':'J2', 'LEDG[0]':'J1',
  'HEX2[0]':'D15', 'HEX2[1]':'A16', 'HEX2[2]':'B16',
  'HEX2[3]':'E15', 'HEX2[4]':'A17', 'HEX2[5]':'B17',
  'HEX2[6]':'F14', 'HEX2[7]':'A18',
  'HEX3[0]':'B18', 'HEX3[1]':'F15', 'HEX3[2]':'A19',
  'HEX3[3]':'B19', 'HEX3[4]':'C19', 'HEX3[5]':'D19',
  'HEX3[6]':'G15', 'HEX3[7]':'G16'
}
found = dict((dest, pin) for pin, dest in
    re.findall(r'^set_location_assignment PIN_(\w+) -to \{?(\w+(?:\[\d+\])?)\}?$', qsf, re.M))
assert found == expected_pins, f"Pinos divergentes: {set(found.items()) ^ set(expected_pins.items())}"
assert len(set(found.values())) == len(found), 'Pinos duplicados'
hex_patterns = ['C0','F9','A4','B0','99','92','82','F8','80','90','88','83','C6','A1','86','8E']
for value, h in enumerate(hex_patterns):
    assert re.search(r'x"' + h + r'"\s+when\s+"' + format(value, '04b') + r'"', dec), (value, h)
assert 'LEDG(9)          <= esta_travada' in main
assert 'LEDG(7 downto 0) <= SW(7 downto 0)' in main
for f in [*sorted((base/'src').glob('*.vhd')),*sorted((base/'tb').glob('*.vhd'))]:
    assert f.stat().st_size > 0, f
print(f"OK: {len(found)} pinos conforme manual, 16 glifos, fontes VHDL e ligacoes principais.")
print('IMPORTANTE: checagem estatica nao e simulacao no Quartus/GHDL.')
