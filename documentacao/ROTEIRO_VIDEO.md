# Roteiro para o video autentico (duracao maxima: 1 minuto)

Nao crie um video ficticio: grave a FPGA DE0 real do laboratorio funcionando. Sugestao de roteiro:

| Intervalo | Cena/acao | O que evidenciar |
|---|---|---|
| 0–7 s | Mostrar a placa DE0 e SW9 em 1 | LED9 ligado e HEX3/HEX2 exibindo 1E (30 decimal) |
| 7–17 s | Mover SW9 para 0 com senha errada | Contagem decrescente a cada segundo |
| 17–30 s | Ajustar SW7..SW0 para 00101010 | LEDG5, LEDG3 e LEDG1 acesos; LEDG9 apaga |
| 30–40 s | Manter a senha correta | Displays congelados |
| 40–49 s | Mudar um bit da senha | LED9 acende e tempo volta a decrescer |
| 49–57 s | Acionar reset | Tempo volta a 1E e fechadura bloqueada |
| 57–60 s | Encerrar com imagem da placa | Encerrar antes de ultrapassar 1 minuto |

**Publicacao:** hospede no YouTube conforme pedido pelo professor e inclua a URL real no relatorio e no AVA. Verifique se o video esta acessivel ao avaliador. Nao invente URL.
