# Abra ModelSim/ModelSim-Altera no DIRETORIO RAIZ do projeto e execute:
# do scripts/simular_modelsim.do
if {![file exists work]} {vlib work}
vmap work work
vcom -93 src/clk_div.vhd
vcom -93 src/trava.vhd
vcom -93 src/binto7seg.vhd
vcom -93 src/main.vhd
vcom -93 tb/tb_clk_div.vhd
vcom -93 tb/tb_trava.vhd
vcom -93 tb/tb_binto7seg.vhd
vcom -93 tb/tb_main.vhd
foreach tb {tb_clk_div tb_trava tb_binto7seg tb_main} {
    echo "Executando $tb"
    vsim work.$tb
    run 400 ns
    quit -sim
}
echo "Fim: confira PASS e eventuais erros de assertion no Transcript."
