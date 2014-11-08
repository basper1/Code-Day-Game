class Room {
  String[][] tiles;
  Room(String type) {
    tiles = new String[(int)(random(20, 30))][(int)(random(20, 30))];
    for (int y=0; y<tiles[0].length; y++) {
      for (int x=0; x<tiles.length; x++) {
        tiles[x][y] = "Normal";
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
    if (type.equals("Normal")) {
      tiles[tiles.length/2][0] = "Exit";
      tiles[tiles.length/2][tiles[0].length-1] = "Exit";
      tiles[0][tiles[0].length/2] = "Exit";
      tiles[tiles.length-1][tiles[0].length/2] = "Exit";
    }
    if (type.equals("Prison")) {
      int cellsHeight = (int)(random(3, 6));
      int cellsWidth = (int)(random(3, 6));
    }
  }
  void display() {
    pushMatrix();
    translate((width-tiles.length*tileSize)/2, (height-tiles[0].length*tileSize)/2);
    for (int y=0; y<tiles[0].length; y++) {
      for (int x=0; x<tiles.length; x++) {
        if (tiles[x][y].equals("Normal")) {
          fill(255);
        } else if (tiles[x][y].equals("Wall")) {
          fill(128);
        } else if (tiles[x][y].equals("Exit")) {
          fill(64);
        }
        rect(x*tileSize, y*tileSize, tileSize, tileSize);
      }
    }
  }
}

int tileSize;
Room test;

void setup() {
  noStroke();
  tileSize = 20;
  size(800, 700);
  test = new Room("Prison");
  background(0);
  test.display();
}

