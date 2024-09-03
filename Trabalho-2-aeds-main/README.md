# Trabalho-2-aeds

Objetivo
# O objetivo deste trabalho é implementar um player que se movimenta pelo caminho mais rápido no mapa, utilizando o algoritmo de Dijkstra. O player deve ser capaz de se mover por diferentes tipos de terreno (grama, areia, água) e evitar obstáculos (pedras, cactus, corais). Um barco será colocado aleatoriamente no mapa, permitindo que o player navegue na água com velocidade dobrada. Adicionalmente, a implementação do algoritmo A* para a movimentação do player será recompensada com pontos extras.

Estrutura do Trabalho
O trabalho será realizado em grupos de 4 alunos e será avaliado em três aspectos: código, apresentação e relatório. A distribuição de pontos é a seguinte:

Código: 5 pontos
Apresentação: 5 pontos
Relatório: 5 pontos
Implementação do Algoritmo A*: 1 ponto extra
Implementação de um objetivo para o jogo: 1 ponto extra

Requisitos do Trabalho
Implementação do Player

Crie uma classe `Player` que inclua atributos para posição, velocidade e um indicador de posse do barco.
Inicialize o player em uma posição padrão no mapa (por exemplo, no centro).
O player deve se mover do ponto inicial até o ponto clicado no mapa, utilizando o algoritmo de Dijkstra.
O player pode andar na grama e na areia, mas a velocidade na areia é reduzida pela metade. O player pode viajar na água apenas quando está de posse de um barco, viajando na água com o dobro da velocidade de quando anda na grama.
O player não pode atravessar obstáculos (pedras, cactus, corais).

Para a implementação da velocidade, considere que o movimento do player é de 1 bloco do grid por segundo quando na grama, 0,5 blocos no grid por segundo quando na areia e 2 blocos do grid por segundo quando na água com barco.
Implementação do Algoritmo de Dijkstra
Implemente o algoritmo de Dijkstra para calcular o caminho mais curto.
Utilize pesos para os diferentes tipos de terreno, o peso de uma aresta é dada pela média do peso do dois vértices que formam a aresta, O pedo do vértice é dado pelo tipo de terreno:
Água: 1 com barco e infinito sem barco
Grama: 2
Areia: 3
Adicionar um Barco
Coloque um barco em uma posição aleatória do mapa, mas não mais distante do que 100 blocos do ponto inicial do player.
Se o player pegar o barco, ele pode se mover na água.
Ações no Mapa
Ao apertar a tecla 'P', o mapa deve ser centralizado no player.
Relatório
O relatório deve incluir:

Introdução ao problema e descrição das funcionalidades implementadas.
Descrição detalhada da implementação do algoritmo de Dijkstra e suas adaptações.
Explicação de como a centralização foi implementada.
Explicação de trechos relevantes do código
Capturas de tela mostrando o funcionamento do código.
Reflexão sobre os desafios encontrados e como foram superados.
Apresentação
A apresentação deve ser feita por todos os membros do grupo, deverá ter duração de 10 minutos e deve incluir:

Visão geral do projeto e funcionalidades implementadas.
Demonstração do código funcionando.
Explicação do algoritmo de Dijkstra e, se implementado, explicação do algoritmo A*.
Discussão sobre o processo de desenvolvimento e lições aprendidas.
