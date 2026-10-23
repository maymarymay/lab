# Trabalho Prático – Fechadura Eletrônica em VHDL

**Disciplina:** Laboratório de Hardware  
**Professor:** Renan Albuquerque Marks  
**Alunos:** [NOME 1] e [NOME 2]  
**Data:** [PREENCHER]

## 1. Introdução

Neste trabalho, o objetivo foi montar o código de uma fechadura eletrônica usando VHDL e a placa Altera DE0. A ideia é colocar uma senha pelas chaves da placa. Quando a senha está certa e o tempo ainda não acabou, o LED que representa a trava apaga. Se a senha estiver errada, a fechadura continua bloqueada.

## 2. Como o projeto foi organizado

Dividimos o código em quatro arquivos principais:

- **trava.vhd:** faz a comparação da senha e controla a contagem de tempo.
- **binto7seg.vhd:** converte números de 0 a F para os displays de sete segmentos.
- **clk_div.vhd:** reduz o clock da placa de 50 MHz para 1 Hz.
- **main.vhd:** conecta as outras partes às chaves, LEDs e displays da DE0.

Também foram preparados testbenches separados para conferir cada parte do circuito e um teste da integração.

## 3. Funcionamento

No exemplo do projeto, a senha usada é **42**, que corresponde a **00101010** em binário. O tempo inicial é **30 segundos**. Esses dois valores podem ser alterados no arquivo main.vhd.

A chave **SW9** serve para resetar. As chaves **SW7 até SW0** são usadas para digitar a senha. Os LEDs **LEDG7 até LEDG0** mostram a posição dessas chaves, e o **LEDG9** indica se a fechadura está bloqueada. O tempo restante aparece em **HEX3 e HEX2**.

O display mostra o tempo em hexadecimal. Por exemplo, 30 segundos aparecem como **1E**. Outra coisa importante é que os displays da placa acendem um segmento com nível lógico 0, então o decodificador foi feito considerando isso.

## 4. Testes previstos

Os testbenches verificam reset, senha correta, senha incorreta, contagem chegando a zero, mudança da senha depois de destravar e os valores do display de 0 a F. Para facilitar a simulação, o divisor de clock aceita uma frequência menor quando usado no teste.

**Situação atual:** os códigos e os testes estão escritos, mas ainda precisamos executar a simulação no ModelSim/GHDL, compilar no Quartus 13 e testar a montagem na DE0. Portanto, não vamos marcar esses testes como aprovados antes de fazê-los.

## 5. Dificuldades e observações

Uma dificuldade do projeto é que o clock da DE0 funciona em 50 MHz, mas a contagem precisa ser feita em segundos. Por isso foi criado o divisor de clock. Também tivemos que considerar que os displays são ativos em nível baixo e que a contagem não pode passar de zero.

**Ponto para confirmar com o professor:** o enunciado menciona verificar a senha quando algum bit das chaves muda. O código compara o valor das chaves continuamente. Assim, se a senha já estiver correta quando o reset for desativado, a fechadura também abre. É importante confirmar se esse comportamento será aceito.

**Problemas encontrados durante a execução no laboratório:** [PREENCHER DEPOIS DOS TESTES].  
**Problemas ainda não resolvidos:** [PREENCHER DEPOIS DOS TESTES].

## 6. Conclusão

Até esta etapa, a estrutura do circuito e os arquivos de teste estão preparados. Ainda falta verificar o funcionamento com simulação e na placa física para poder concluir se tudo funciona como esperado. Depois desses testes, vamos atualizar o relatório com os resultados, os problemas encontrados e as imagens necessárias.

**Vídeo da placa funcionando (até 1 minuto):** [INSERIR LINK DO YOUTUBE].

## Referências

- MARKS, Renan Albuquerque. *Descrição do Trabalho Prático da Disciplina de Laboratório de Hardware*, versão 1.1.
- TERASIC. *Altera DE0 Board – User Manual*.
