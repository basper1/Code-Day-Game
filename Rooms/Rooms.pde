class Room {
  String[][] tiles;
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
    }
    else if (type.equals("Prison")) {
      int cellsWidth = tiles.length/(int)(random(3, 6));
      int cellsHeight = (int)(random(3, 6));
      for(int y=0; y<tiles[0].length; y++){
        tiles[cellsWidth][y] = "Wall";
        tiles[tiles.length-cellsWidth-1][y] = "Wall";
      }
      for(int y=0; y<cellsHeight; y++){
        for(int x=0; x<cellsWidth; x++){
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
    }
    else if(type.equals("Courtyard")){
      int border = (int)(random(3, 6));
      for(int x=border; x<tiles.length-border; x++){
        tiles[x][border] = "Wall";
        tiles[x][tiles[0].length-border-1] = "Wall";
      }
      for(int y=border; y<tiles[0].length-border; y++){
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
    else if(type.equals("Armory")){
      int hallwayX;
      int hallwayY;
      if(tiles.length % 2 == 0){
        hallwayX = 4;
      }else{
        hallwayX = 5;
      }
      if(tiles[0].length % 2 == 0){
        hallwayY = 4;
      }else{
        hallwayY = 5;
      }
      for(int i = 0; i <tiles.length;i++){
        tiles[i][tiles[0].length / 2 + 2] = "Wall";
        tiles[i][tiles[0].length / 2 - 2] = "Wall";
      }
      for(int i = 0; i <tiles[0].length;i++){
        tiles[tiles.length / 2 + 2][i] = "Wall";
        tiles[tiles.length / 2 - 2][i] = "Wall";
      }
      for(int i = -1;i < 2;i++){
        tiles[tiles.length / 2 + i][tiles[0].length / 2 + 2] = "Floor";
      }
      for(int i = -1;i < 2;i++){
        tiles[tiles.length / 2 + i][tiles[0].length / 2 - 2] = "Floor";
      }
      for(int i = -1;i < 2;i++){
        tiles[tiles.length / 2 + 2][tiles[0].length / 2 + i] = "Floor";
      }
      for(int i = -1;i < 2;i++){
        tiles[tiles.length / 2 - 2][tiles[0].length / 2 + i] = "Floor";
      }
      tiles[tiles.length/4][tiles[0].length / 2 - 2] = "Floor";
      tiles[tiles.length/4][tiles[0].length / 2 + 2] = "Floor";
      tiles[tiles.length/4*3][tiles[0].length / 2 - 2] = "Floor";
      tiles[tiles.length/4*3][tiles[0].length / 2 + 2] = "Floor";
      
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
        } else if (tiles[x][y].equals("Test")){
          fill(255,0,0);
        }
        rect(x*tileSize, y*tileSize, tileSize, tileSize);
      }
    }
  }
}

int tileSize;
Room test;

void setup() {
  //noStroke();
  tileSize = 20;
  size(800, 700);
  test = new Room("Armory");
  background(0);
  test.display();
}

