class Chunk { // Classe Chunk representa uma se��o do mapa do jogo
  int chunkX, chunkY; // Coordenadas do chunk no mapa
  int chunkSize, tileSize;// Tamanho do chunk e tamanho de cada tile
  Terreno[][] tiles; //Matriz de Tiles terrenos do chunk
  Obstaculo[][] obstaculos; // Matriz de obst�culos do chunk

  // Construtor da classe Chunk
  Chunk(int chunkX, int chunkY, int chunkSize, int tileSize) {
    this.chunkX = chunkX; // Inicializa a coordenada X e Y do chunk
    this.chunkY = chunkY;
    this.chunkSize = chunkSize; //Inicializa o tamanho do chunk
    this.tileSize = tileSize; // Inicializa o tamanho de cada tile
    this.tiles = new Terreno[chunkSize / tileSize][chunkSize / tileSize]; // Inicializa a matriz de tiles
    this.obstaculos = new Obstaculo[chunkSize / tileSize][chunkSize / tileSize]; // Inicializa a matriz de obst�culos
    generateChunk(); //Gera o chunk
  }

  // M�todo para gerar o conte�do do chunk
  void generateChunk() {
    // M�todo para gerar o conte�do do chunk
    for (int x = 0; x < chunkSize / tileSize; x++) {
      for (int y = 0; y < chunkSize / tileSize; y++) {
        // Calcula um valor de ru�do para determinar o tipo de terreno
        float noiseValue = noise((chunkX * chunkSize + x * tileSize) * 0.01, (chunkY * chunkSize + y * tileSize) * 0.01);
        // Define o tipo de terreno com base no valor de ru�do
        if (noiseValue < 0.3) {
          tiles[x][y] = new Agua(); // Define o tile como �gua
        } else if (noiseValue < 0.6) {
          tiles[x][y] = new Grama(); // Define o tile como Grama
        } else {
          tiles[x][y] = new Areia(); // Define o tile como Areia
        }

        // Adicionar obst�culos
        if (random(1) < 0.005) {// 0.5% de chance de adicionar um obst�culo
          if (tiles[x][y] instanceof Agua) obstaculos[x][y] = new Corais(); // Adiciona Corais se o tile for �gua
          else if (tiles[x][y] instanceof Grama) obstaculos[x][y] = new Pedra(); // Adiciona Pedra se o tile for Grama
          else if (tiles[x][y] instanceof Areia) obstaculos[x][y] = new Cactus(); // Adiciona Cactus se o tile for Areia
        }
      }
    }
  }

  // M�todo para obter o terreno em uma posi��o espec�fica dentro do chunk
  Terreno getTile(int localX, int localY) {
    // Verifica se as coordenadas est�o dentro dos limites da matriz de tiles
    if (localX >= 0 && localX < tiles.length && localY >= 0 && localY < tiles[0].length) {
      return tiles[localX][localY]; // Retorna o terreno na posi��o especificada
    } else {
      return null; //Se n existir retona null
    }
  }

  // M�todo para obter o obst�culo em uma posi��o espec�fica dentro do chunk
  Obstaculo getObstaculo(int localX, int localY) {
    if (localX >= 0 && localX < obstaculos.length && localY >= 0 && localY < obstaculos[0].length) {
      return obstaculos[localX][localY];
    } else {
      return null;
    }
  }

  // M�todo para exibir o chunk na tela
  void display(float offsetX, float offsetY) {
    //Itera sobre cada tile no chunk
    for (int x = 0; x < chunkSize / tileSize; x++) {
      for (int y = 0; y < chunkSize / tileSize; y++) {
        // Calcula a posi��o na tela para o tile atual
        float screenX = chunkX * chunkSize + x * tileSize + offsetX;
        float screenY = chunkY * chunkSize + y * tileSize + offsetY;
        
        // Verifica se o tile est� fora da tela e, se estiver, pula para o pr�ximo tile
        if (screenX + tileSize < 0 || screenX > width || screenY + tileSize < 0 || screenY > height) {
          continue;
        }

        fill(tiles[x][y].cor);
        pushMatrix();
        translate(screenX, screenY);
        rect(0, 0, tileSize, tileSize);
        // Se houver um obst�culo no tile, define a cor de preenchimento e desenha o ret�ngulo
        if (obstaculos[x][y] != null) {
          fill(obstaculos[x][y].cor);
          //rect(0, 0, tileSize, tileSize);
        }
        popMatrix();
      }
    }
  }
}
