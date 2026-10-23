-- Mostra os numeros de 0 a F no display da DE0.
-- O ultimo bit controla o ponto decimal.
-- Na placa, 0 acende e 1 apaga cada segmento.
library ieee;
use ieee.std_logic_1164.all;

entity binto7seg is
    port (
        input  : in  std_logic_vector(3 downto 0);
        display: out std_logic_vector(7 downto 0)
    );
end entity binto7seg;

architecture combinacional of binto7seg is
begin
    with input select
        display <=
            x"C0" when "0000", -- 0
            x"F9" when "0001", -- 1
            x"A4" when "0010", -- 2
            x"B0" when "0011", -- 3
            x"99" when "0100", -- 4
            x"92" when "0101", -- 5
            x"82" when "0110", -- 6
            x"F8" when "0111", -- 7
            x"80" when "1000", -- 8
            x"90" when "1001", -- 9
            x"88" when "1010", -- A
            x"83" when "1011", -- b
            x"C6" when "1100", -- C
            x"A1" when "1101", -- d
            x"86" when "1110", -- E
            x"8E" when "1111", -- F
            x"FF" when others; -- apaga se a entrada for desconhecida
end architecture combinacional;
