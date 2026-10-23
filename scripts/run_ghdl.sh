#!/usr/bin/env bash
set -euo pipefail
# Rode na raiz do projeto: bash scripts/run_ghdl.sh
# Necessita GHDL (nao e necessario para compilar no Quartus).
cd "$(dirname "$0")/.."
if ! command -v ghdl >/dev/null 2>&1; then
  echo 'ERRO: GHDL nao esta instalado. No laboratorio, use o simulador do Quartus/ModelSim ou instale GHDL.' >&2
  exit 127
fi
mkdir -p build/ghdl
cd build/ghdl
for arq in ../../src/clk_div.vhd ../../src/trava.vhd ../../src/binto7seg.vhd ../../src/main.vhd \
           ../../tb/tb_clk_div.vhd ../../tb/tb_trava.vhd ../../tb/tb_binto7seg.vhd ../../tb/tb_main.vhd; do
  ghdl -a --std=93 "$arq"
done
for tb in tb_clk_div tb_trava tb_binto7seg tb_main; do
  echo "== TESTE: $tb =="
  ghdl -e --std=93 "$tb"
  ghdl -r --std=93 "$tb" --assert-level=error --stop-time=400ns --vcd="${tb}.vcd"
done
echo 'Simulacoes concluídas. Confira todas as linhas PASS e ausencia de errors.'
