Map map; // Mapa do jogo
Player player; // Inicializa��o do player
Boat boat; // Inicializa��o do barco
Enemy[] inimigo = new Enemy[20]; //inicializando inimigos
boolean dragging = false; // Verifica se o mouse est� arrastando ou n�o
float lastMouseX, lastMouseY; // �ltima posi��o x e y

// Setup, inicia o grid, o framerate e outros detalhes de inicializa��o
void setup() {
  size(1200, 800, P3D);
  background(200, 125, 70);
  frameRate(80);
  map = new Map(200, 25); // chunkSize = 200, tileSize = 25

  for (int i = 0; i < inimigo.length; i++) {
    inimigo[i] = new Enemy(random(200, 600), random(200, 600), random(25, 30), 100, true);
  }

  // Garantir que o jogador n�o nas�a na �gua ou em um obst�culo
  float playerX, playerY;
  do {
    playerX = random(width); // Gera um lugar aleat�rio x
    playerY = random(height); // Gera um lugar aleat�rio y
  } while (map.getTileValue(map.gridPosX((int)playerX), map.gridPosY((int)playerY)) instanceof Agua || // Verifica para n�o nascer na �gua
    map.getObstaculo(map.gridPosX((int)playerX), map.gridPosY((int)playerY)) != null);

  player = new Player(playerX, playerY, 20, 100); // Instancia o Player e carrega a espada
  player.loadSword();

  // Adicionar o barco em uma posi��o aleat�ria, mas n�o mais distante do que 40 blocos do ponto inicial do player
  float boatX, boatY;
  do {
    boatX = playerX + random(-40, 40) * map.tileSize;
    boatY = playerY + random(-40, 40) * map.tileSize;
  } while (!(map.getTileValue(map.gridPosX((int)boatX), map.gridPosY((int)boatY)) instanceof Agua) || // Verifica para nascer na �gua
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

// Fun��es de atualiza��o
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

// M�todo que possui chamadas de fun��o que desenha espada, jogador e os atualiza
void player_spt() {
  player.showItem();
  player.desenha();
  player.move();
  player.CheckInput();
}

// Verifica se o mouse foi pressionado
void mousePressed() {
  if (mouseButton == LEFT) {
    // Define o alvo do jogador para a posi��o do clique
    player.setTarget(mouseX - map.offsetX, mouseY - map.offsetY); 
  } 
  if (mouseButton == LEFT) { // Caso o bot�o esquerdo seja pressionado
    player.setTarget(mouseX - map.offsetX, mouseY - map.offsetY); // Define o "alvo" do player
    for (int i = 0; i < inimigo.length; i++) {
      inimigo[i].setTarget(mouseX - map.offsetX, mouseY - map.offsetY);
    }
  } else if (mouseButton == RIGHT) { // Se o bot�o direito for pressionado
    dragging = true; // Status de arrastar fica verdadeiro
    lastMouseX = mouseX; // Atualiza a �ltima posi��o x e y
    lastMouseY = mouseY;
  }
}

// Fun��o para ver quando o mouse for solto, ela ocorre quando o arrastar for verdadeiro
// Assim ela verifica quando para de arrastar e o torna falso
void mouseReleased() {
  if (mouseButton == RIGHT) {
    dragging = false;
  }
}

// Fun��o chamada quando o mouse � arrastado
void mouseDragged() {
  if (dragging) { // Se o mouse estiver sendo arrastado
    float dx = mouseX - lastMouseX; // Calcula a diferen�a X e Y do movimento do mouse
    float dy = mouseY - lastMouseY;
    map.drag(dx, dy); // Move o mapa de acordo com a diferen�a calculada
    lastMouseX = mouseX; // Atualiza a �ltima posi��o X e Y do mouse
    lastMouseY = mouseY;

    // Em nosso c�digo quando � movido o grid o player se mant�m no mesmo lugar
    // Isso � feito para manter o player no lugar que ele sempre esteve, mas caso queira que ele acompanhe o movimento do grid est� abaixo
    // N�o atualizar a posi��o do jogador ap�s mover o grid
    // player.setTarget(player.x, player.y);
  }
}

// Fun��o para verificar quando uma tecla � pressionada
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

// Fun��o para verificar se uma tecla deixou de ser pressionada
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
