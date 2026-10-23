library ieee;
use ieee.std_logic_1164.all;

-- Divide o clock da placa para a contagem em segundos.
entity clk_div is
    generic (CLOCK_FREQ_HZ : positive := 50000000);
    port (
        clock_in : in std_logic;
        reset : in std_logic;
        clock_out : out std_logic
    );
end clk_div;

architecture funcionamento of clk_div is
    constant metade : positive := CLOCK_FREQ_HZ / 2;
    signal contador : natural range 0 to metade - 1 := 0;
    signal clk_lento : std_logic := '0';
begin
    -- Para funcionar corretamente, a frequencia precisa ser par.
    assert CLOCK_FREQ_HZ >= 2 and CLOCK_FREQ_HZ mod 2 = 0
        report "Frequencia invalida" severity failure;

    process(clock_in, reset)
    begin
        if reset = '1' then
            contador <= 0;
            clk_lento <= '0';
        elsif rising_edge(clock_in) then
            if contador = metade - 1 then
                contador <= 0;
                clk_lento <= not clk_lento;
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;
    clock_out <= clk_lento;
end funcionamento;
