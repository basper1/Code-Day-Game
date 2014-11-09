class Enemy {
  String type;
  int health;
  int xPos;
  int yPos;
  int xPixel;
  int yPixel;
  Enemy(String type, int xPos, int yPos) {
    this.type = type;
    if (type.equals("Zombie")) {
      health = 12;
    } else if (type.equals("Dog")) {
      health = 9;
    } else if (type.equals("Robot")) {
      health = 18;
    }
    this.xPos = xPos;
    this.yPos = yPos;
    xPixel = xPos * tileSize;
    yPixel = yPos * tileSize;
  }
  void display() {
    if (type.equals("Zombie")) {
      image(zombieSprite, xPixel, yPixel);
    }
    else if(type.equals("Dog")){
      image(dogSprite, xPixel, yPixel);
    }
  }
}

//The room class

class Room {
  String[][] tiles;
  Room left;
  Room right;
  Room up;
  Room down;
  Room(String type) {
    tiles = new String[(int)(random(20, 32))][(int)(random(20, 32))];
    for (int y=0; y<tiles[0].length; y++) {
      for (int x=0; x<tiles.length; x++) {
        tiles[x][y] = "Floor";
      }
    }
    for (int y=0; y<tiles[0].length; y+=tiles[0].length-1) {
      for (int x=0; x<tiles.length; x++) {
        tiles[x][y] = "Wall";
      }
    }
    for (int y=0; y<tiles[0].length; y++) {
      for (int x=0; x<tiles.length; x+=tiles.length-1) {
        tiles[x][y] = "Wall";
      }
    }
    if (type.equals("Floor")) {
      tiles[tiles.length/2][0] = "Exit";
      tiles[tiles.length/2][tiles[0].length-1] = "Exit";
      tiles[0][tiles[0].length/2] = "Exit";
      tiles[tiles.length-1][tiles[0].length/2] = "Exit";
    } else if (type.equals("Prison")) {
      int cellsWidth = tiles.length/(int)(random(3, 6));
      int cellsHeight = (int)(random(3, 6));
      for (int y=0; y<tiles[0].length; y++) {
        tiles[cellsWidth][y] = "Wall";
        tiles[tiles.length-cellsWidth-1][y] = "Wall";
      }
      for (int y=0; y<cellsHeight; y++) {
        for (int x=0; x<cellsWidth; x++) {
          tiles[x][tiles[0].length/cellsHeight*y] = "Wall";
          tiles[tiles.length-cellsWidth+x][tiles[0].length/cellsHeight*y] = "Wall";
        }
        tiles[cellsWidth][y*(tiles[0].length/cellsHeight)+tiles[0].length/cellsHeight/2] = "Floor";
        tiles[tiles.length-cellsWidth-1][y*(tiles[0].length/cellsHeight)+tiles[0].length/cellsHeight/2] = "Floor";
      }
      tiles[tiles.length/2][0] = "Exit";
      tiles[tiles.length/2][tiles[0].length-1] = "Exit";
      tiles[0][(int)(random(0, cellsHeight))*(tiles[0].length/cellsHeight)+tiles[0].length/cellsHeight/2] = "Exit";
      tiles[tiles.length-1][(int)(random(0, cellsHeight))*(tiles[0].length/cellsHeight)+tiles[0].length/cellsHeight/2] = "Exit";
    } else if (type.equals("Courtyard")) {
      int border = (int)(random(3, 6));
      for (int x=border; x<tiles.length-border; x++) {
        tiles[x][border] = "Wall";
        tiles[x][tiles[0].length-border-1] = "Wall";
      }
      for (int y=border; y<tiles[0].length-border; y++) {
        tiles[border][y] = "Wall";
        tiles[tiles.length-border-1][y] = "Wall";
      }
      tiles[tiles.length/2][border] = "Floor";
      tiles[tiles.length/2][tiles[0].length-border-1] = "Floor";
      tiles[border][tiles[0].length/2] = "Floor";
      tiles[tiles.length-border-1][tiles[0].length/2] = "Floor";
      tiles[tiles.length/2][0] = "Exit";
      tiles[tiles.length/2][tiles[0].length-1] = "Exit";
      tiles[0][tiles[0].length/2] = "Exit";
      tiles[tiles.length-1][tiles[0].length/2] = "Exit";
    }
  }
  void display() {
    pushMatrix();
    translate((width-tiles.length*tileSize)/2, (height-tiles[0].length*tileSize)/2);
    for (int y=0; y<tiles[0].length; y++) {
      for (int x=0; x<tiles.length; x++) {
        if (tiles[x][y].equals("Floor")) {
          fill(255);
        } else if (tiles[x][y].equals("Wall")) {
          fill(128);
        } else if (tiles[x][y].equals("Exit")) {
          fill(64);
        }
        rect(x*tileSize, y*tileSize, tileSize, tileSize);
      }
    }
    popMatrix();
  }
}

//Global variables

int tileSize;
Room current;
boolean setRoom;
int playerX;
int playerY;
int playerPixelX;
int playerPixelY;
PImage playerSprite;
int playerSpeed;
boolean moving;

boolean up;
boolean down;
boolean left;
boolean right;

PImage zombieSprite;
PImage dogSprite;
String[] enemyTypes;
ArrayList<Enemy> enemies;

//Setting up variables for the game

void setup() {
  playerSpeed = 3;
  setRoom = true;
  tileSize = 20;
  size(800, 700);
  playerSprite = loadImage("Player.png");
  current = new Room("Prison");
  playerX = current.tiles.length/2;
  playerY = current.tiles[0].length/2;
  playerPixelX = playerX*tileSize;
  playerPixelY = playerY*tileSize;

  moving = false;

  up = false;
  down = false;
  left = false;
  right = false;

  zombieSprite = loadImage("Zombie.png");
  dogSprite = loadImage("Dog.png");
  enemyTypes = new String[] {
    "Zombie", "Robot", "Dog"
  };
  enemies = new ArrayList<Enemy>();
}

void draw() {
  background(0);
  current.display();
  pushMatrix();
  translate((width-current.tiles.length*tileSize)/2, (height-current.tiles[0].length*tileSize)/2);
  image(playerSprite, playerPixelX, playerPixelY);
  for (int i=0; i<enemies.size (); i++) {
    enemies.get(i).display();
  }
  if (Math.abs(playerPixelX-playerX*tileSize) <= playerSpeed) {
    playerPixelX = playerX*tileSize;
  }
  if (Math.abs(playerPixelY-playerY*tileSize) <= playerSpeed) {
    playerPixelY = playerY*tileSize;
  }
  if (playerPixelX == playerX*tileSize && playerPixelY == playerY*tileSize) {
    if (up == true && !current.tiles[playerX][playerY-1].equals("Wall")) {
      playerY--;
    }
    if (down == true && !current.tiles[playerX][playerY+1].equals("Wall")) {
      playerY++;
    }
    if (left == true && !current.tiles[playerX-1][playerY].equals("Wall")) {
      playerX--;
    }
    if (right == true && !current.tiles[playerX+1][playerY].equals("Wall")) {
      playerX++;
    }
  }
  if (playerPixelX < playerX*tileSize) {
    playerPixelX += playerSpeed;
  }
  if (playerPixelX > playerX*tileSize) {
    playerPixelX -= playerSpeed;
  }
  if (playerPixelY < playerY*tileSize) {
    playerPixelY += playerSpeed;
  }
  if (playerPixelY > playerY*tileSize) {
    playerPixelY -= playerSpeed;
  }
  popMatrix();
  if (setRoom == true) {
    int a = (int)(random(6, 11));
    for (int i=0; i<a; i++) {
      int x = 0;
      int y = 0;
      boolean repeat = true;
      while (repeat == true) {
        repeat = false;
        x = (int)(random(1, current.tiles.length));
        y = (int)(random(1, current.tiles[0].length));
        if(current.tiles[x][y].equals("Wall")){
          repeat = true;
        }
        if(enemies.size() > 0){
          for(int j=0; j<enemies.size(); j++){
            if(enemies.get(j).xPos == x && enemies.get(j).yPos == y){
              repeat = true;
              break;
            }
          }
        }
      }
      Enemy b = new Enemy("Zombie", x, y);
      enemies.add(b);
    }
    setRoom = false;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      up = true;
    }
    if (keyCode == DOWN) {
      down = true;
    }
    if (keyCode == LEFT) {
      left = true;
    }
    if (keyCode == RIGHT) {
      right = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      up = false;
    }
    if (keyCode == DOWN) {
      down = false;
    }
    if (keyCode == LEFT) {
      left = false;
    }
    if (keyCode == RIGHT) {
      right = false;
    }
  }
}

