class Enemy {
  String type;
  int health;
  int xPos;
  int yPos;
  int xPixel;
  int counter;
  int yPixel;
  PImage image;
  Enemy(String type, int xPos, int yPos) {
    this.type = type;
    counter = 0;
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
    } else if (type.equals("Dog")) {
      image(dogSprite, xPixel-tileSize, yPixel);
    } else if (type.equals("Robot")) {
      image(robotSprite, xPixel-tileSize, yPixel-tileSize);
    }
  }
  void move() {
    if (type.equals("Robot")) {
      int xPosMem = 0;
      int yPosMem = 0;
      if (counter < 30) {
        counter++;
      }
      if (Math.abs(xPixel - xPos*tileSize) <= robotSpeed) {
        xPixel = xPos*tileSize;
      }
      if (Math.abs(yPixel - yPos*tileSize) <= robotSpeed) {
        yPixel = yPos*tileSize;
      }
      if (xPixel == xPos*tileSize && yPixel == yPos*tileSize && counter == 30) {
        counter = 0;
        xPosMem = xPos;
        yPosMem = yPos;
        if (xPos < playerX) {
          xPos++;
        } else if (xPos > playerX) {
          xPos--;
        }
        if (yPos < playerY) {
          yPos++;
        } else if (yPos > playerY) {
          yPos--;
        }
        for (int i=0; i<enemies.size (); i++) {
          if (xPos == enemies.get(i).xPos && yPos == enemies.get(i).yPos && enemies.get(i) != this) {
            xPos = xPosMem;
            yPos = yPosMem;
          }
        }
      }
      if (xPixel < xPos*tileSize) {
        xPixel += robotSpeed;
      } else if (xPixel > xPos*tileSize) {
        xPixel -= robotSpeed;
      }
      if (yPixel < yPos*tileSize ) {
        yPixel += robotSpeed;
      } else if (yPixel > yPos*tileSize ) {
        yPixel -= robotSpeed;
      }
    } else if (type.equals("Zombie")) {
      String[][] copy = current.tiles;
      int[][] route = new int[copy.length][copy[0].length];
      for (int y=0; y<copy[0].length; y++) {
        for (int x=0; x<copy.length; x++) {
          if (copy[x][y].equals("Wall")) {
            route[x][y] = 0;
          } else if (copy[x][y].equals("Floor")) {
            route[x][y] = 1;
          }
        }
      }
    }
  }
}

void pathFind(int[][] x, int startX, int startY) {
  int current = x[startX][startY];
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
          image(floorSprite, x*tileSize, y*tileSize);
        } else if (tiles[x][y].equals("Wall")) {
          image(wallSprite, x*tileSize, y*tileSize);
        } else if (tiles[x][y].equals("Exit")) {
          if (roomClear == false) {
            image(exitClose, x*tileSize, y*tileSize);
          } else if (roomClear == true) {
            image(exitOpen, x*tileSize, y*tileSize);
          }
        }
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
boolean roomClear;

boolean up;
boolean down;
boolean left;
boolean right;

PImage zombieSprite;
PImage dogSprite;
PImage robotSprite;
String[] enemyTypes;
ArrayList<Enemy> enemies;

int collideRange;

int robotSpeed;

PImage wallSprite;
PImage floorSprite;
PImage exitOpen;
PImage exitClose;

//Setting up variables for the game

void setup() {
  exitOpen = loadImage("ExitOpen.png");
  exitClose = loadImage("ExitClose.png");
  wallSprite = loadImage("Wall.png");
  floorSprite = loadImage("Floor.png");
  roomClear = false;
  frameRate(60);
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
  robotSpeed = 1;

  collideRange = 2;

  moving = false;

  up = false;
  down = false;
  left = false;
  right = false;

  zombieSprite = loadImage("Zombie.png");
  dogSprite = loadImage("Dog.png");
  robotSprite = loadImage("Robot.png");
  enemyTypes = new String[] {
    "Zombie", "Robot", "Dog"
  };
  enemies = new ArrayList<Enemy>();
}

boolean playerCollide(int xChange, int yChange) {
  boolean collide = false;
  int x = playerX+xChange;
  int y = playerY+yChange;
  if (current.tiles[x][y].equals("Wall") || (current.tiles[x][y].equals("Exit") && roomClear == false)) {
    collide = true;
  }
  return collide;
}

void draw() {
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
        if (current.tiles[x][y].equals("Wall")) {
          repeat = true;
        }
        if (enemies.size() > 0) {
          for (int j=0; j<enemies.size (); j++) {
            if (enemies.get(j).xPos == x && enemies.get(j).yPos == y) {
              repeat = true;
              break;
            }
          }
        }
      }
      Enemy b = new Enemy(enemyTypes[(int)(random(0, enemyTypes.length))], x, y);
      enemies.add(b);
    }
    setRoom = false;
    roomClear = false;
  }
  if (enemies.size() == 0) {
    roomClear = true;
  }

  //Drawing segment

  background(0);
  current.display();
  pushMatrix();
  translate((width-current.tiles.length*tileSize)/2, (height-current.tiles[0].length*tileSize)/2);
  image(playerSprite, playerPixelX, playerPixelY);
  for (int i=0; i<enemies.size (); i++) {
    enemies.get(i).display();
    enemies.get(i).move();
  }
  if (Math.abs(playerPixelX-playerX*tileSize) <= playerSpeed) {
    playerPixelX = playerX*tileSize;
  }
  if (Math.abs(playerPixelY-playerY*tileSize) <= playerSpeed) {
    playerPixelY = playerY*tileSize;
  }
  if (playerPixelX == playerX*tileSize && playerPixelY == playerY*tileSize) {
    if (up == true && !playerCollide(0, -1)) {
      playerY--;
    }
    if (down == true && !playerCollide(0, 1)) {
      playerY++;
    }
    if (left == true && !playerCollide(-1, 0)) {
      playerX--;
    }
    if (right == true && !playerCollide(1, 0)) {
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

