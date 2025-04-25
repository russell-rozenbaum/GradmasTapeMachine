// OSC Deps and Vars
import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress remoteAddress;

// General Globals
float mousePressOffset;

// Create instances of our main classes
RandomPan randomPan;
Dropout dropout;
Noise noise;
Alter alter;
Master master;


PFont font;

void setup() {
  size(1000, 800);
  font = createFont("Micro5-Regular.ttf", 18);

  // OSC Definitions
  osc = new OscP5(this, 7008);
  remoteAddress = new NetAddress("127.0.0.1", 7009); 
  
  // Initialize our main classes
  randomPan = new RandomPan();
  dropout = new Dropout();
  noise = new Noise();
  alter = new Alter();
  master = new Master();
  drawBG();
}

void drawBG() {
  background(#E4E5E7);
  textFont(font);
  randomPan.draw();
  dropout.draw();
  noise.draw();
  alter.draw();
  master.draw();
}

void mousePressed() {
  randomPan.handleMousePressed();
  noise.handleMousePressed();
  dropout.handleMousePressed();
  alter.handleMousePressed();
  master.handleMousePressed();
}

void mouseClicked() {
  randomPan.handleMouseClicked();
  dropout.handleMouseClicked();
  noise.handleMouseClicked();
  alter.handleMouseClicked();
}

void mouseReleased() {
  noise.handleMouseReleased();
  dropout.handleMouseReleased();
  alter.handleMouseReleased();
  master.handleMouseReleased();
}

void oscEvent(OscMessage incomingMessage) {
  randomPan.handleOSC(incomingMessage);
  dropout.handleOSC(incomingMessage);
  noise.handleOSC(incomingMessage);
  alter.handleOSC(incomingMessage);
  master.handleOSC(incomingMessage);
}

void draw() {
  if (mousePressed) {
    randomPan.handleMouseDragged();
    noise.handleMouseDragged();
    dropout.handleMouseDragged();
    alter.handleMouseDragged();
    master.handleMouseDragged();
  }
  
  noStroke();
  drawBG();
}
