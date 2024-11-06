Block block;
Dialog dialog;
StandardButton button;

//--------------------------------------------------
void setup(){
  size(800, 450);
  surface.setResizable(true);

    block = new Block(16, 16);
    dialog = new Dialog(16, 16);
    button = new StandardButton(16, 16);
}

void draw() {
    background(255);
    menu();
}

//--------------------------------------------------
void menu(){
  // side bar
  noStroke();
  fill(47, 55, 54);
  block.blockAnker("CORNER");
  block.box(0, 0, 8, 16, "topLeft", "vertical");
  block.box(0, 0, 8, 16, "topRight", "vertical");
  // shape_button
  fill(255, 255, 255);
  stroke(0, 0, 0);
  block.blockAnker("CENTER");
  block.box(4, 4, 3, 3, "topLeft", "vertical");

  
  noFill();
  stroke(255, 0, 0);
  block.blockAnker("CORNER");
  block.debugGrid("topLeft", "vertical");
}
