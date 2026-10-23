library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_trava is
end entity;

architecture teste of tb_trava is
    constant SENHA_TESTE: natural := 42;
    constant TEMPO_TESTE: natural := 5;
    signal clock   : std_logic := '0';
    signal reset   : std_logic := '0';
    signal input   : std_logic_vector(7 downto 0) := (others => '0');
    signal segundos: std_logic_vector(7 downto 0);
    signal trava   : std_logic;
begin
    -- 10 ns de periodo para acelerar teste; cada borda significa 1 segundo.
    clock <= not clock after 5 ns;

    dut: entity work.trava
        generic map (
            senha => SENHA_TESTE,
            tempo_para_desarme => TEMPO_TESTE
        )
        port map (
            clock => clock, reset => reset, input => input,
            segundos => segundos, trava => trava
        );

    estimulos: process
    begin
        wait for 1 ns;
        assert segundos = x"05" and trava = '1'
            report "Falha na inicializacao automatica" severity error;

        reset <= '1';
        wait for 2 ns;
        assert segundos = x"05" and trava = '1'
            report "Falha no reset" severity error;

        reset <= '0';
        -- Borda em 5 ns: senha errada, contador decrementa 5->4.
        wait until rising_edge(clock);
        wait for 1 ns;
        assert segundos = x"04" and trava = '1'
            report "Decremento inicial incorreto" severity error;

        -- Senha correta, antes do tempo chegar a zero.
        input <= std_logic_vector(to_unsigned(SENHA_TESTE, 8));
        wait for 1 ns;
        assert trava = '0' and segundos = x"04"
            report "Nao destravou com a senha correta" severity error;

        wait until rising_edge(clock);
        wait for 1 ns;
        assert segundos = x"04" and trava = '0'
            report "Contagem nao parou com senha correta" severity error;

        -- Retorna a senha errada; trava e retoma contagem.
        input <= x"00";
        wait for 1 ns;
        assert trava = '1'
            report "Nao travou com entrada errada" severity error;
        wait until rising_edge(clock);
        wait for 1 ns;
        assert segundos = x"03"
            report "Contagem nao retomou" severity error;

        -- Deixa tempo acabar: nao deve haver underflow.
        for i in 1 to 3 loop
            wait until rising_edge(clock);
            wait for 1 ns;
        end loop;
        assert segundos = x"00" and trava = '1'
            report "Falha no timeout" severity error;

        input <= std_logic_vector(to_unsigned(SENHA_TESTE, 8));
        wait for 1 ns;
        assert trava = '1' and segundos = x"00"
            report "Destravou indevidamente apos timeout" severity error;
        wait until rising_edge(clock);
        wait for 1 ns;
        assert segundos = x"00"
            report "Underflow do contador" severity error;

        -- Reset assincrono deve restaurar tempo e estado.
        reset <= '1';
        wait for 1 ns;
        assert segundos = x"05" and trava = '1'
            report "Reset final incorreto" severity error;
        report "PASS: tb_trava (reset, senha, congelamento, retomada, timeout)"
            severity note;
        wait;
    end process;
end architecture;
