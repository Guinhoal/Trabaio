class Player {
  // Atributos do player
PathFinder pathFinder; // Inst�ncia do PathFinder
  List<PVector> path; // Lista para armazenar o caminho

  float x, y;
  float xpos, ypos;
  float size;
  float hp, max_hp;
  boolean immune, dead, hasBoat;
  private float targetx, targety;
  boolean qDown, wDown, eDown;
  PImage sword;
  int swordhand, combo;
  float rool, rollx, rolly, startx, starty, rolx, roly;
  float swordx, swordy, swordsize;
  float anim;
  long contador;
  long[] pinador = new long[10];
  float atax, atay;
  Boat boat;
  float tab = 10;

  // Construtor do player
  public Player(float xpos, float ypos, float size, float hp) {
    this.x = xpos;
    this.y = ypos;
    this.size = size;
    this.hp = hp;
    this.max_hp = hp;
    this.targetx = xpos;
    this.targety = ypos;
    this.swordhand = 0;
    this.contador = millis();
     this.pathFinder = new PathFinder(map, this); // Inicializa o PathFinder
    this.path = null; 
  }

  // Adicionar um atributo para indicar a posse do barco
  boolean hasBoatIcon = false;

  // Carrega a imagem da espada
  void loadSword() {
    sword = loadImage("Item/7.png");
  }

  // Desenha o player, a barra de vida e a espada
  void desenha() {
    barraVida();
    pushMatrix();
    xpos = x + map.offsetX;
    ypos = y + map.offsetY;
    translate(xpos, ypos);
    fill(255, 255, 255);
    if (swordhand != 1) {
      atay = mouseY - (ypos);
      atax = mouseX - (xpos);
    }
    rotateZ(atan2(atay, atax) - PI/4);
    ellipse(0, 0, size, size);
    ellipse(size/2 + size/5, 0, size/4, size/4);
    ellipse(0, size/2 + size/5, size/4, size/4);
    popMatrix();
    if (swordhand == 0) {
      drawSword(-size/2, -size/2-5, size, 800);
    }
  }

  // Desenha a barra de vida e o �cone do barco se o player tiver o barco
  void barraVida() {
    stroke(1);
    strokeWeight(5);
    fill(200, 20, 20);
    rect(30, 20, max_hp*7, 20);
    strokeWeight(1);
    fill(20, 200, 100);
    rect(30, 20, hp*7, 20);

    // Desenhar o �cone do barco se o player tiver o barco
    if (hasBoatIcon) {
      fill(0, 0, 255); // Cor azul para o �cone do barco
      rect(30 + max_hp*7 + 10, 10, 30, 30); // Desenha um ret�ngulo representando o �cone do barco
    }
  }

  // Fun��o que verifica se o player est� imune, se ele recebeu dano e atualiza a vida ou se ele se curou e atualiza a vida
  void damage(float damage) {
    if (immune) {
      return;
    }

    hp -= damage;

    pinador[5] = millis() + 300;

    if (hp < 0) {
      dead = true;
      hp = 0;
    }
  }

  void heal(float heal) {
    hp += heal;

    if (hp > max_hp) {
      hp = max_hp;
    }
  }

  // Fun��o que faz o player se mover
  void move() {
    float angle = atan2(targety - y, targetx - x);
    float speed = getSpeed(); // Obt�m a velocidade com base no terreno
    float nextX = x + cos(angle) * speed;
    float nextY = y + sin(angle) * speed;

    // Verifica se a pr�xima posi��o n�o colide com nenhum obst�culo
    if ((targety-y > 5 || targety-y < -5) || (targetx-x > 5 || targetx-x < -5 )) {
      if (!isColliding(nextX, nextY)) {
        x = nextX; // Atualiza posi��o x e y
        y = nextY;
      }
    }

    // Verifica se o player pegou o barco
    if (boat != null && !hasBoat && dist(x, y, boat.x, boat.y) < size) {
      hasBoat = true; // O player pegou o barco
      hasBoatIcon = true; // Exibir o �cone do barco
      boat.visible = false; // Remover o barco da tela
      boat = null; // Remover a refer�ncia ao barco
      println("Player pegou o barco!");
    }

    
    if (path != null && !path.isEmpty()) {
      PVector targetTile = path.get(0);
      float targetX = map.screenPosX((int) targetTile.x);
      float targetY = map.screenPosY((int) targetTile.y);

      // Calcula o �ngulo em dire��o ao alvo
       angle = atan2(targetY - y, targetX - x);

      // Obt�m a velocidade com base no terreno (m�todo existente)
       speed = getSpeed(); 

      // Move em dire��o ao alvo
      x += cos(angle) * speed; 
      y += sin(angle) * speed;

      // Verifica se chegou ao tile atual do caminho
      if (dist(x, y, targetX, targetY) < speed) {
        path.remove(0); // Remove o tile atual do caminho
      }
    }

    // Corre��o aqui: usar x e y em vez de xpos e ypos
    int gridX = map.gridPosX((int) x);
    int gridY = map.gridPosY((int) y);

    Terreno tile = map.getTileValue(gridX, gridY);

    println("Player est� em: (" + gridX + ", " + gridY + "), Terreno: " + tile);
  }

  // Fun��o para obter a velocidade do player com base no terreno
  float getSpeed() {
    int gridX = map.gridPosX((int)xpos);
    int gridY = map.gridPosY((int)ypos);
    Terreno tile = map.getTileValue(gridX, gridY);

    println("Player est� em: (" + gridX + ", " + gridY + "), Terreno: " + tile);

    if (tile instanceof Agua) {
      return hasBoat ? 2.0 : 0.0; // 2 blocos por segundo na �gua com barco, 0 sem barco
    } else if (tile instanceof Areia) {
      return 0.5; // 0.5 blocos por segundo na areia
    } else if (tile instanceof Grama) {
      return 1.0; // 1 bloco por segundo na grama
    }
    return 1.0; // Velocidade padr�o
  }

  // Fun��o que verifica se o player est� colidindo com algo
  boolean isColliding(float nextX, float nextY) {
    int gridX = map.gridPosX((int)(nextX + xpos - x));
    int gridY = map.gridPosY((int)(nextY + ypos - y));
    
    Terreno tile = map.getTileValue(gridX, gridY);
    Obstaculo obstaculo = map.getObstaculo(gridX, gridY);

    // Verifica se o terreno � de livre locomo��o
    if (tile instanceof Grama || tile instanceof Areia) {
      return false; // N�o h� colis�o, jogador pode se locomover
    }

    // Verifica se o terreno � �gua e o jogador n�o est� em um barco
    if (tile instanceof Agua && !hasBoat) {
      return true; // Colis�o detectada, jogador n�o pode andar na �gua sem o barco
    }

    // Verifica se h� um obst�culo na posi��o
    if (obstaculo != null) {
      return true; // Colis�o detectada, h� um obst�culo na posi��o
    }

    return false; // N�o h� colis�o
  }

  void setTarget(float x1, float y1) {
    int startX = map.gridPosX((int) x);
    int startY = map.gridPosY((int) y);
    int endX = map.gridPosX((int) x1);
    int endY = map.gridPosY((int) y1);

    // Calcula o caminho quando o alvo � definido
    path = pathFinder.findPath(startX, startY, endX, endY); 
  }

  // Verifica a entrada do jogador
  void CheckInput() {
    if (pinador[1] < millis()) {
      /*reseta ataque*/
      swordhand = 0;
    }
    if (qDown == true) {
      if (pinador[1] < millis()) {
        pinador[1] = millis() + 300/*recargaAtaque*/;
        anim = 0;
        swordhand++;
        ;
      }
      /* quebrando a cabeça pra fazer o ataque prestar :))))))))))) ;-; socoro
       fiz um broxa ;(((((*/
    }

    //uma Cura quando aperta W
    if (wDown == true) {
      if (pinador[2] < millis() && hp != max_hp) {
        heal(80);
        pinador[2] = millis() + 25000/*recargaCura*/;
      }
    }
    //rolamento
    if (pinador[4] > millis()) {
      float angle = atan2(rolly - roly - map.offsetY, rollx - rolx - map.offsetX);
      rool = 20;
      y += sin(angle)*rool;
      x += cos(angle)*rool;

      setTarget(x, y);
    }
    if (eDown == true) {
      if (pinador[3] < millis()) {
        rool = 0;
        pinador[3] = millis() + 3000; /* recargaAvanço*/

        pinador[4] = millis() + 100; //duracao avanço
        pinador[5] = millis() + 150;
        rollx = mouseX;
        rolly = mouseY;
        rolx = x;
        roly = y;
      }
    }
  }

  // Mostra o item do jogador (espada)
  void showItem() {
    anim++;
    if (swordhand == 1) {
      drawSword(10, 10, 60, 1800 + anim * -200);
    } else {
      swordhand = 0;
    }
  }

  // Desenha a espada
  void drawSword(float xx, float yy, float sizer, float aa) {
    pushMatrix();
    translate(x + map.offsetX, y + map.offsetY);
    rotateZ(atan2(atay, atax));
    translate(xx, yy);
    float t = 0.5;
    rotateZ(PI * (aa) / 3600);
    image(sword, 0, 0, lerp(swordsize, sizer, t), lerp(swordsize, sizer, t));
    swordx = xx;
    swordy = yy;
    swordsize = sizer;
    popMatrix();
  }
}
