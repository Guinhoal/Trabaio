class PathFinder {
  Map map;
  Player player;

  PathFinder(Map map, Player player) {
    this.map = map;
    this.player = player;
  }

  List<PVector> findPath(int startX, int startY, int endX, int endY) {
    int gridWidth = map.chunks.size() * map.chunkSize / map.tileSize;
    int gridHeight = map.chunks.size() * map.chunkSize / map.tileSize;

    // Cria matrizes para armazenar os custos e os nós pais
    float[][] cost = new float[gridWidth][gridHeight];
    PVector[][] parent = new PVector[gridWidth][gridHeight];

    // Inicializa as matrizes
    for (int x = 0; x < gridWidth; x++) {
      for (int y = 0; y < gridHeight; y++) {
        cost[x][y] = Float.MAX_VALUE;
        parent[x][y] = null;
      }
    }

    cost[startX][startY] = 0;

    // Loop principal do Dijkstra
    while (true) {
      int currentX = -1;
      int currentY = -1;
      float minCost = Float.MAX_VALUE;

      // Encontra o nó com menor custo
      for (int x = 0; x < gridWidth; x++) {
        for (int y = 0; y < gridHeight; y++) {
          if (cost[x][y] < minCost && isValidPosition(x, y)) {
            currentX = x;
            currentY = y;
            minCost = cost[x][y];
          }
        }
      }

      // Se não encontrou nenhum nó válido, não há caminho
      if (currentX == -1 || currentY == -1) {
        return null;
      }

      // Se chegou ao destino, reconstrói o caminho
      if (currentX == endX && currentY == endY) {
        return reconstructPath(parent, endX, endY);
      }

      // Marca o nó atual como visitado (definindo o custo como infinito)
      cost[currentX][currentY] = Float.MAX_VALUE;

      // Explora os vizinhos
      for (int[] dir : new int[][]{{0, 1}, {1, 0}, {0, -1}, {-1, 0}}) {
        int neighborX = currentX + dir[0];
        int neighborY = currentY + dir[1];

        // Verifica se o vizinho é válido
        if (isValidPosition(neighborX, neighborY)) {
          float newCost = cost[currentX][currentY] + getCost(currentX, currentY, neighborX, neighborY);

          // Se o novo custo for menor que o custo atual do vizinho
          if (newCost < cost[neighborX][neighborY]) {
            cost[neighborX][neighborY] = newCost;
            parent[neighborX][neighborY] = new PVector(currentX, currentY);
          }
        }
      }
    }
  }

  // Método para verificar se uma posição é válida
  private boolean isValidPosition(int x, int y) {
    if (x < 0 || x >= map.chunks.size() * map.chunkSize / map.tileSize || y < 0 || y >= map.chunks.size() * map.chunkSize / map.tileSize) {
      return false;
    }

    Terreno terreno = map.getTileValue(x, y);
    Obstaculo obstaculo = map.getObstaculo(x, y);

    if (obstaculo != null) {
      return false;
    }
    if (terreno instanceof Agua && !player.hasBoat) {
      return false;
    }

    return true;
  }

  // Método para calcular o custo de movimento
  private float getCost(int fromX, int fromY, int toX, int toY) {
    Terreno terreno = map.getTileValue(toX, toY);
    float distance = dist(fromX, fromY, toX, toY);

    if (terreno instanceof Agua) {
      return distance / 2.0f;
    } else if (terreno instanceof Areia) {
      return distance / 0.5f;
    } else if (terreno instanceof Grama) {
      return distance / 1.0f;
    }

    return distance;
  }

  // Método para reconstruir o caminho
private List<PVector> reconstructPath(PVector[][] parent, int endX, int endY) {
  List<PVector> path = new ArrayList<>();
  PVector current = new PVector(endX, endY);

  while (current != null) {
    path.add(0, current);

    // -- Início da Seção Corrigida --

    int currentGridX = (int) current.x;
    int currentGridY = (int) current.y;

    // Verificação de limites
    if (currentGridX >= 0 && currentGridX < parent.length && 
        currentGridY >= 0 && currentGridY < parent[0].length) {
      current = parent[currentGridX][currentGridY];
    } else {
      // Lidar com o caso de índice inválido (opcional)
      println("Erro: Índice inválido durante a reconstrução do caminho.");
      current = null; // Interromper o loop
    }

    // -- Fim da Seção Corrigida --
  }

  return path;
}
}
