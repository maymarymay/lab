-- Junta as partes do projeto e liga com a placa DE0.
library ieee;
use ieee.std_logic_1164.all;

entity main is
    generic (
        SENHA             : natural range 0 to 255 := 42;
        TEMPO_PARA_DESARME: natural range 0 to 255 := 30;
        CLOCK_FREQ_HZ     : positive := 50000000
    );
    port (
        CLOCK_50: in  std_logic;
        SW      : in  std_logic_vector(9 downto 0);
        LEDG    : out std_logic_vector(9 downto 0);
        HEX3    : out std_logic_vector(7 downto 0);
        HEX2    : out std_logic_vector(7 downto 0)
    );
end entity main;

architecture estrutural of main is
    signal clk_1hz      : std_logic;
    signal tempo_restante: std_logic_vector(7 downto 0);
    signal esta_travada  : std_logic;
begin
    divisor: entity work.clk_div
        generic map (CLOCK_FREQ_HZ => CLOCK_FREQ_HZ)
        port map (
            clock_in  => CLOCK_50,
            reset     => SW(9),
            clock_out => clk_1hz
        );

    fechadura: entity work.trava
        generic map (
            senha              => SENHA,
            tempo_para_desarme => TEMPO_PARA_DESARME
        )
        port map (
            clock    => clk_1hz,
            reset    => SW(9),
            input    => SW(7 downto 0),
            segundos => tempo_restante,
            trava    => esta_travada
        );

    display_hex3: entity work.binto7seg
        port map (
            input   => tempo_restante(7 downto 4),
            display => HEX3
        );

    display_hex2: entity work.binto7seg
        port map (
            input   => tempo_restante(3 downto 0),
            display => HEX2
        );

    LEDG(9)          <= esta_travada;
    LEDG(8)          <= '0'; -- sem uso
    LEDG(7 downto 0) <= SW(7 downto 0);
end architecture estrutural;
