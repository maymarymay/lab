# Restricao basica do oscilador CLOCK_50 = 50 MHz (periodo 20 ns).
# O clock de 1 Hz e gerado internamente pelo codigo VHDL do clk_div.
create_clock -name CLOCK_50 -period 20.000 [get_ports {CLOCK_50}]
derive_clock_uncertainty
