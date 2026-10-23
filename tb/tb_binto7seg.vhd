library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_binto7seg is
end entity;

architecture teste of tb_binto7seg is
    type tabela_t is array (0 to 15) of std_logic_vector(7 downto 0);
    -- Padrões de referencia, na ordem 0,1,...,9,A,b,C,d,E,F.
    constant esperado: tabela_t := (
        x"C0", x"F9", x"A4", x"B0", x"99", x"92", x"82", x"F8",
        x"80", x"90", x"88", x"83", x"C6", x"A1", x"86", x"8E"
    );
    signal valor: std_logic_vector(3 downto 0) := (others => '0');
    signal display: std_logic_vector(7 downto 0);
begin
    dut: entity work.binto7seg
        port map (input => valor, display => display);

    estimulos: process
    begin
        for i in 0 to 15 loop
            valor <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
            assert display = esperado(i)
                report "Falha no simbolo hexadecimal " & integer'image(i)
                severity error;
        end loop;
        valor <= "XXXX";
        wait for 10 ns;
        assert display = x"FF"
            report "Entrada indeterminada deveria apagar display" severity error;
        report "PASS: tb_binto7seg (0 a F + X)" severity note;
        wait;
    end process;
end architecture;
