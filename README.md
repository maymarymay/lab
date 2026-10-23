# Fechadura eletronica - Laboratorio de Hardware

Projeto em VHDL para a placa DE0. O codigo foi organizado em partes simples para facilitar a leitura e a apresentacao.

- `src/trava.vhd`: verifica a senha e faz a contagem.
- `src/binto7seg.vhd`: converte os valores para o display.
- `src/clk_div.vhd`: gera 1 Hz a partir do clock de 50 MHz.
- `src/main.vhd`: liga tudo na placa.
- `tb/`: testes de cada parte e do projeto completo.
- `quartus/`: configuracao do projeto e pinos.
- `scripts/`: comandos para checagem e simulacao.
- `documentacao/`: guia, modelo de relatorio e roteiro do video.

Senha de exemplo: **42** (00101010). Tempo inicial: **30 segundos**.

Na DE0: SW9 = reset, SW7..SW0 = senha, LEDG9 = estado da trava, HEX3/HEX2 = tempo hexadecimal.

## Antes de entregar

1. Abrir o projeto do Quartus, compilar e corrigir qualquer erro encontrado.
2. Rodar os testbenches no ModelSim ou GHDL.
3. Testar na placa e gravar o video pedido pelo professor.
4. Preencher nomes e resultados reais no relatorio.

**Observacao:** o enunciado fala em verificar a senha quando algum bit muda. Este codigo faz comparacao continua. Isso deve ser confirmado com o professor. Nenhuma simulacao ou teste fisico foi comprovado neste ambiente.
