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

int tileSize;
Room current;
int playerX;
int playerY;
int playerPixelX;
int playerPixelY;
PImage playerSprite;
int playerSpeed;
boolean moving;

void setup() {
  playerSpeed = 5;
  tileSize = 20;
  size(800, 700);
  playerSprite = loadImage("Player.png");
  current = new Room("Prison");
  playerX = current.tiles.length/2;
  playerY = current.tiles[0].length/2;
  playerPixelX = playerX*tileSize;
  playerPixelY = playerY*tileSize;

  moving = false;
}

void draw() {
  background(0);
  current.display();
  pushMatrix();
  translate((width-current.tiles.length*tileSize)/2, (height-current.tiles[0].length*tileSize)/2);
  image(playerSprite, playerPixelX, playerPixelY);
  if(playerPixelX < playerX*tileSize){
    playerPixelX += playerSpeed;
  }
  if(playerPixelX > playerX*tileSize){
    playerPixelX -= playerSpeed;
  }
  if(playerPixelY < playerY*tileSize){
    playerPixelY += playerSpeed;
  }
  if(playerPixelY > playerY*tileSize){
    playerPixelY -= playerSpeed;
  }
  if(Math.abs(playerPixelX-playerX*tileSize) < playerSpeed){
    playerPixelX = playerX*tileSize;
  }
  if(Math.abs(playerPixelY-playerY*tileSize) < playerSpeed){
    playerPixelY = playerY*tileSize;
  }
  if(playerPixelX == playerX*tileSize && playerPixelY == playerY*tileSize){
    moving = false;
  }
  popMatrix();
}

void keyPressed(){
  if(key == CODED){
    if(moving == false && (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT)){
      moving = true;
      if(keyCode == UP && !current.tiles[playerX][playerY-1].equals("Wall")){
        playerY--;
      }
      if(keyCode == DOWN && !current.tiles[playerX][playerY+1].equals("Wall")){
        playerY++;
      }
      if(keyCode == LEFT && !current.tiles[playerX-1][playerY].equals("Wall")){
        playerX--;
      }
      if(keyCode == RIGHT && !current.tiles[playerX+1][playerY].equals("Wall")){
        playerX++;
      }
    }
  }
}
