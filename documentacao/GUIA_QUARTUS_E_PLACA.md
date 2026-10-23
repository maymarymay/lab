# Guia de uso: Quartus II 13, simulacao e prototipacao DE0

## Antes de comecar

Este guia acompanha os arquivos entregues. Ele **nao substitui** testes no Quartus II 13 e na placa real. Verifique que a placa disponivel e a **DE0 original com Cyclone III**, nao DE0-Nano ou DE0-CV. O manual anexo referencia o FPGA `EP3C16F484`; o projeto assume a variante `EP3C16F484C6`, que deve ser confirmada na placa/Quartus instalado.

### Passo A — revisar a unidade principal

Abra `src/main.vhd`: no bloco `generic`, ajuste `SENHA` (0..255) e `TEMPO_PARA_DESARME` (0..255). Os valores de exemplo estao em 42 e 30. Para manter a temporizacao real, **deixe `CLOCK_FREQ_HZ=50000000` no FPGA**. Os testbenches usam 10 apenas para a simulacao rapida.

### Passo B — compilar

1. Inicie Quartus II 13 (com Cyclone III habilitado).
2. Use **File > Open Project** e selecione `quartus/fechadura_de0.qpf`.
3. Verifique em **Assignments > Settings > General** que a entidade principal e `main`.
4. Verifique em **Assignments > Device** que o FPGA e compatível. Se o chip da placa tiver outro speed grade, ajuste `DEVICE` no arquivo `.qsf` para o modelo real.
5. Confira o **Pin Planner**. Os pinos foram transcritos do manual:

   - CLOCK_50: G21;
   - SW9: D2; SW7..SW0: E3, H7, J7, G5, G4, H6, H5, J6;
   - LEDG9: B1; LEDG7..LEDG0: C2, C1, E1, F2, H1, J3, J2, J1;
   - HEX2/HEX3: Tabela 4.4 do manual, incluindo DP.

6. Em **Processing > Start Compilation**, aguarde a mensagem de compilacao terminada. Se houver erros, registre a mensagem real, corrija e compile novamente. Capture a evidencia da compilacao final.

### Passo C — simular

Os arquivos testbench sao fontes **somente de simulacao**; **nao adicione testbench como top-level de sintese**. No ModelSim, a partir da pasta raiz, use o console:

```tcl
do scripts/simular_modelsim.do
```

Caso a versao do ModelSim nao encontre os arquivos, abra a ferramenta diretamente na pasta que contem `src/`, `tb/` e `scripts/` (ou ajuste o diretorio de trabalho). Confira no transcript as quatro mensagens `PASS` e a ausencia de `severity error`. Para ondas, use `vsim work.tb_trava`, `add wave -r /*`, `run 100 ns`.

**Testes previstos:** inicializacao, reset assincrono, decremento sem underflow, senha correta antes do limite, congelamento, retorno da contagem apos senha errada, impossibilidade de abrir com tempo zero, 0..F e integração de displays/LEDs.

### Passo D — programar a DE0 real

1. Com a placa desligada, conecte a fonte **7,5 V** indicada pelo manual e o cabo USB na porta USB-Blaster.
2. Instale/verifique o driver USB-Blaster no Windows do laboratorio.
3. Posicione RUN/PROG em **RUN** (programacao JTAG).
4. Ligue a placa. No Quartus abra **Tools > Programmer** e escolha **Hardware Setup > USB-Blaster**.
5. Em **Mode**, selecione **JTAG**.
6. Se preciso, clique **Add File...** e escolha `quartus/output_files/fechadura_de0.sof` criado pela compilacao; marque **Program/Configure** e clique **Start**.
7. Aguarde a taxa atingir 100% sem erro.
8. Mova SW9 para **1**: o display deve mostrar **1E** (30 decimal) e o LED9 permanecer aceso.
9. Mova SW9 para **0** e comece com SW7..SW0 diferente de 42. O tempo deve decrementar hexadecimal a cada segundo (1E, 1D, 1C, ...).
10. Ajuste SW7..SW0 para **00101010**: apenas SW5, SW3 e SW1 ficam na posicao 1. O LED9 deve apagar e a contagem deve parar.
11. Mude uma chave para tornar a entrada diferente de 42: o LED9 deve acender e a contagem retomar.
12. Teste o tempo esgotado, redefina com SW9=1 e capture as etapas em video de ate um minuto.

**Seguranca:** nao force chaves nem conectores; utilize a alimentacao indicada para a placa. A configuracao `.sof` (JTAG) nao e persistente apos desligar. Nao e preciso modificar a EEPROM para o trabalho.

### Passo E — resolver problemas comuns

| Sintoma | Possivel causa | Acao |
|---|---|---|
| FPGA nao detectada | USB-Blaster/driver ou RUN/PROG | Verifique driver, cabo, chave RUN, fonte e Hardware Setup |
| Quartus sem Cyclone III | Pacote de dispositivos nao instalado | Instale componente Cyclone III compativel com Quartus 13 |
| Erro de device | Variante/sufixo do FPGA diverge | Confira a marcacao do chip e altere DEVICE no QSF |
| Displays mostram 1E e nao 30 | Contagem e exibida em hexadecimal | Normal: 30 decimal = 1E hexadecimal |
| LED9 aceso com senha correta | SW9=1, tempo zerado ou posicao das chaves errada | Verifique reset, tempo e SW5/SW3/SW1 |
| Simulador mostra erros | VHDL faltando, ordem errada ou erro real | Compile `clk_div`, `trava`, `binto7seg`, `main`, depois TBs |

### Observacao tecnica importante

O requisito "ao ter `input` alterado" e implementado pela comparacao continua das chaves, nao por uma memoria de transicoes. Isso facilita a sintese e resposta imediata, mas o caso em que a senha ja esta correta **antes de retirar o reset** nao depende de uma transicao de `input`: tambem libera a trava. Se o professor exigir deteccao literal de transicao, esse detalhe necessita alinhamento/alteracao antes da entrega. Consulte o README e registre a decisao no relatorio.
