library ieee;
use ieee.std_logic_1164.all;

entity tb_main is
end entity;

architecture teste of tb_main is
    signal CLOCK_50: std_logic := '0';
    signal SW: std_logic_vector(9 downto 0) := (others => '0');
    signal LEDG: std_logic_vector(9 downto 0);
    signal HEX3: std_logic_vector(7 downto 0);
    signal HEX2: std_logic_vector(7 downto 0);
begin
    -- Para simular: clock-base de 10 ns; divisor com 10 ciclos por periodo.
    -- Isto representa 1 segundo logico em apenas 100 ns de simulacao.
    CLOCK_50 <= not CLOCK_50 after 5 ns;
    dut: entity work.main
        generic map (
            SENHA => 42, TEMPO_PARA_DESARME => 30,
            CLOCK_FREQ_HZ => 10
        )
        port map (
            CLOCK_50 => CLOCK_50, SW => SW,
            LEDG => LEDG, HEX3 => HEX3, HEX2 => HEX2
        );

    estimulos: process
    begin
        SW(9) <= '1'; -- reset
        wait for 4 ns;
        assert LEDG(9) = '1' and HEX3 = x"F9" and HEX2 = x"86"
            report "Inicio esperado: travado, 1E hexadecimal" severity error;
        SW(9) <= '0';
        -- Clock de 1 Hz tem bordas em t~45 ns, 145 ns, ...
        wait for 50 ns;
        assert HEX3 = x"F9" and HEX2 = x"A1"
            report "Display deveria mostrar 1D apos 1 pulso" severity error;
        SW(7 downto 0) <= x"2A"; -- 42 decimal
        wait for 2 ns;
        assert LEDG(9) = '0' and LEDG(7 downto 0) = x"2A"
            report "Senha correta nao apagou LED9 / nao espelhou chaves" severity error;
        wait for 120 ns;
        assert HEX3 = x"F9" and HEX2 = x"A1"
            report "Contagem deveria ficar congelada" severity error;
        SW(7 downto 0) <= x"00";
        wait for 2 ns;
        assert LEDG(9) = '1'
            report "Senha errada deveria travar" severity error;
        wait for 100 ns;
        assert HEX3 = x"F9" and HEX2 = x"C6"
            report "Contagem deveria ser retomada (1C)" severity error;
        SW(9) <= '1';
        wait for 2 ns;
        assert LEDG(9) = '1' and HEX3 = x"F9" and HEX2 = x"86"
            report "Reset deveria restaurar 1E" severity error;
        report "PASS: tb_main (divisor, LEDs, senha, displays, reset)" severity note;
        wait;
    end process;
end architecture;
