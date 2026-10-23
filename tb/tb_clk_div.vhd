library ieee;
use ieee.std_logic_1164.all;

entity tb_clk_div is
end entity;

architecture teste of tb_clk_div is
    signal clock_in: std_logic := '0';
    signal reset: std_logic := '1';
    signal clock_out: std_logic;
begin
    clock_in <= not clock_in after 5 ns;
    dut: entity work.clk_div
        generic map (CLOCK_FREQ_HZ => 10)
        port map (clock_in => clock_in, reset => reset, clock_out => clock_out);

    estimulos: process
    begin
        wait for 2 ns;
        assert clock_out = '0' report "Saida inicial nao e zero" severity error;
        reset <= '0';
        -- A primeira borda de subida ocorre em 5 ns; apos 5 bordas alterna.
        wait for 44 ns; -- tempo total 46 ns, ja houve 5 subidas (5..45 ns)
        assert clock_out = '1'
            report "Divisor deveria alternar apos 5 ciclos" severity error;
        wait for 50 ns; -- 10 bordas acumuladas, deve estar 0
        assert clock_out = '0'
            report "Divisor nao completou periodo" severity error;
        reset <= '1';
        wait for 1 ns;
        assert clock_out = '0'
            report "Reset do divisor falhou" severity error;
        report "PASS: tb_clk_div (divisao e reset)" severity note;
        wait;
    end process;
end architecture;
