library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Verifica a senha e controla o tempo para abrir a fechadura.
entity trava is
    generic (
        senha : natural range 0 to 255 := 42;
        tempo_para_desarme : natural range 0 to 255 := 30
    );
    port (
        clock : in std_logic;
        reset : in std_logic;
        input : in std_logic_vector(7 downto 0);
        segundos : out std_logic_vector(7 downto 0);
        trava : out std_logic
    );
end trava;

architecture funcionamento of trava is
    signal tempo : unsigned(7 downto 0) := to_unsigned(tempo_para_desarme, 8);
    signal aberta : std_logic;
begin
    -- So abre quando a senha estiver certa e ainda houver tempo.
    aberta <= '1' when reset = '0' and tempo > 0 and
               unsigned(input) = to_unsigned(senha, 8) else '0';

    trava <= not aberta; -- 1 = travada; 0 = aberta
    segundos <= std_logic_vector(tempo);

    process(clock, reset)
    begin
        if reset = '1' then
            tempo <= to_unsigned(tempo_para_desarme, 8);
        elsif rising_edge(clock) then
            -- Enquanto nao abrir, diminui um segundo por pulso.
            if tempo > 0 and aberta = '0' then
                tempo <= tempo - 1;
            end if;
        end if;
    end process;
end funcionamento;
