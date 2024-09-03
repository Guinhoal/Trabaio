Map map; // Mapa do jogo
Player player; // Inicializaï¿½ï¿½o do player
Boat boat; // Inicializaï¿½ï¿½o do barco
Enemy[] inimigo = new Enemy[20]; //inicializando inimigos
boolean dragging = false; // Verifica se o mouse estï¿½ arrastando ou nï¿½o
float lastMouseX, lastMouseY; // ï¿½ltima posiï¿½ï¿½o x e y

// Setup, inicia o grid, o framerate e outros detalhes de inicializaï¿½ï¿½o
void setup() {
  size(1200, 800, P3D);
  background(200, 125, 70);
  frameRate(80);
  map = new Map(200, 25); // chunkSize = 200, tileSize = 25

  for (int i = 0; i < inimigo.length; i++) {
    inimigo[i] = new Enemy(random(200, 600), random(200, 600), random(25, 30), 100, true);
  }

  // Garantir que o jogador nï¿½o nasï¿½a na ï¿½gua ou em um obstï¿½culo
  float playerX, playerY;
  do {
    playerX = random(width); // Gera um lugar aleatï¿½rio x
    playerY = random(height); // Gera um lugar aleatï¿½rio y
  } while (map.getTileValue(map.gridPosX((int)playerX), map.gridPosY((int)playerY)) instanceof Agua || // Verifica para nï¿½o nascer na ï¿½gua
    map.getObstaculo(map.gridPosX((int)playerX), map.gridPosY((int)playerY)) != null);

  player = new Player(playerX, playerY, 20, 100); // Instancia o Player e carrega a espada
  player.loadSword();

  // Adicionar o barco em uma posiï¿½ï¿½o aleatï¿½ria, mas nï¿½o mais distante do que 40 blocos do ponto inicial do player
  float boatX, boatY;
  do {
    boatX = playerX + random(-40, 40) * map.tileSize;
    boatY = playerY + random(-40, 40) * map.tileSize;
  } while (!(map.getTileValue(map.gridPosX((int)boatX), map.gridPosY((int)boatY)) instanceof Agua) || // Verifica para nascer na ï¿½gua
    map.getObstaculo(map.gridPosX((int)boatX), map.gridPosY((int)boatY)) != null);

  println("Barco gerado em: (" + boatX + ", " + boatY + ")");

  boat = new Boat(boatX, boatY); // Instancia o barco
  player.boat = boat; // Associa o barco ao player

  Graph graph = new Graph();
  
  //------------------------------------------------
  List<String> path = graph.dijkstra("BLOCO 1", "BLOCO 19");
  println(path);
  //------------------------------------------------
}

// Funï¿½ï¿½es de atualizaï¿½ï¿½o
void draw() {
  background(200, 125, 70);
  noStroke();
  map.display();
  if (boat != null) {
    boat.display(); // Desenha o barco no mapa
  }
  player_spt();
  inimigo_spt();
}

void inimigo_spt() {
  for (int i = 0; i < inimigo.length; i++) {
    if (inimigo[i].dead) {
      continue;
    }
    inimigo[i].update();
    inimigo[i].setTarget(player.x, player.y);
    if (player.swordhand == 1 && dist(inimigo[i].x, inimigo[i].y, player.x, player.y) < 100) {
      inimigo[i].damage(20);
    }
    if (dist(inimigo[i].x, inimigo[i].y, player.x, player.y) < 40) {
      player.damage(20);
    }
  }
}

// Mï¿½todo que possui chamadas de funï¿½ï¿½o que desenha espada, jogador e os atualiza
void player_spt() {
  player.showItem();
  player.desenha();
  player.move();
  player.CheckInput();
}

// Verifica se o mouse foi pressionado
void mousePressed() {
  if (mouseButton == LEFT) {
    // Define o alvo do jogador para a posição do clique
    player.setTarget(mouseX - map.offsetX, mouseY - map.offsetY); 
  } 
  if (mouseButton == LEFT) { // Caso o botï¿½o esquerdo seja pressionado
    player.setTarget(mouseX - map.offsetX, mouseY - map.offsetY); // Define o "alvo" do player
    for (int i = 0; i < inimigo.length; i++) {
      inimigo[i].setTarget(mouseX - map.offsetX, mouseY - map.offsetY);
    }
  } else if (mouseButton == RIGHT) { // Se o botï¿½o direito for pressionado
    dragging = true; // Status de arrastar fica verdadeiro
    lastMouseX = mouseX; // Atualiza a ï¿½ltima posiï¿½ï¿½o x e y
    lastMouseY = mouseY;
  }
}

// Funï¿½ï¿½o para ver quando o mouse for solto, ela ocorre quando o arrastar for verdadeiro
// Assim ela verifica quando para de arrastar e o torna falso
void mouseReleased() {
  if (mouseButton == RIGHT) {
    dragging = false;
  }
}

// Funï¿½ï¿½o chamada quando o mouse ï¿½ arrastado
void mouseDragged() {
  if (dragging) { // Se o mouse estiver sendo arrastado
    float dx = mouseX - lastMouseX; // Calcula a diferenï¿½a X e Y do movimento do mouse
    float dy = mouseY - lastMouseY;
    map.drag(dx, dy); // Move o mapa de acordo com a diferenï¿½a calculada
    lastMouseX = mouseX; // Atualiza a ï¿½ltima posiï¿½ï¿½o X e Y do mouse
    lastMouseY = mouseY;

    // Em nosso cï¿½digo quando ï¿½ movido o grid o player se mantï¿½m no mesmo lugar
    // Isso ï¿½ feito para manter o player no lugar que ele sempre esteve, mas caso queira que ele acompanhe o movimento do grid estï¿½ abaixo
    // Nï¿½o atualizar a posiï¿½ï¿½o do jogador apï¿½s mover o grid
    // player.setTarget(player.x, player.y);
  }
}

// Funï¿½ï¿½o para verificar quando uma tecla ï¿½ pressionada
void keyPressed()
{
  if (key == CODED) {
    if (keyCode == TAB) {
      player.tab *= -1;
    }
  }
  if (key == 'q' || key == 'Q') {
    player.qDown = true;
  }
  if (key == 'w' || key == 'W') {
    player.wDown = true;
  }
  if (key == 'e' || key == 'E') {
    player.eDown = true;
  }
}

// Funï¿½ï¿½o para verificar se uma tecla deixou de ser pressionada
void keyReleased()
{
  if (key == 'q' || key == 'Q') {
    player.qDown = false;
  }
  if (key == 'w' || key == 'W') {
    player.wDown = false;
  }
  if (key == 'e' || key == 'E') {
    player.eDown = false;
  }
}
