enum WidthMode {
    WIDEN,
    PINCH
}

class RandomPan {
  PImage randomPanPanel;
  PImage randomPanScreened;
  PImage sliderKnob;
  PImage switchFlick_down;
  PImage switchFlick_up;
  
  float zoomMultiplier = 1.333;
  
  float sliderKnob_rp_rate_x = 50;
  float sliderKnob_rp_rate_y = 252;
  
  float sliderKnob_rp_movement_x = 340;
  float sliderKnob_rp_movement_y = 252;
  WidthMode widthMode = WidthMode.PINCH;
  
  float switchFlick_x = 203;
  float switchFlick_y = 176;
  
  float circleCenterX = 210;
  float circleCenterY = 383.5;
  int stereoOffset;
  float amplitude;
  circleData[] circleDatas = new circleData[128];
  
  float widthControlX = 50;
  
  RandomPan() {
    for (int i = 0; i < circleDatas.length; i++) {
      circleDatas[i] = new circleData();
    }
  }
  
  void draw() {
    // Load the random pan panel
    randomPanPanel = loadImage("visuals/RandomPanBackground.png");
    randomPanScreened = loadImage("visuals/RandomPanSubtracted.png");
    sliderKnob = loadImage("visuals/SliderKnob.png");
    switchFlick_down = loadImage("visuals/Switch_(Down).png");
    switchFlick_up = loadImage("visuals/Switch_(Up).png");
    
    image(randomPanPanel, 0, 91);
    
    // Create and add new circle based on current amplitude and stereo position
    // Also tick all other circles
    circleData newCircleData = new circleData(stereoOffset, amplitude);
    for (int i = 1; i < circleDatas.length; i++) {
      circleDatas[i - 1] = circleDatas[i];
      circleDatas[i].tick();
    }
    circleDatas[circleDatas.length - 1] = newCircleData;
    
    // Draw all circles
    for (int i = 0; i < circleDatas.length; i++) {
      fill(#D78D77, circleDatas[i].opacity);
      circle(circleDatas[i].stereoOffset, circleCenterY, max(3, 200 * circleDatas[i].amplitude));
    }
    
    if (widthMode == WidthMode.PINCH) {
      fill(#82C0ED);
      rect(209, 195, widthControlX, 100);
      rect(210-widthControlX, 195, widthControlX, 100);
    }
    else if (widthMode == WidthMode.WIDEN) {
      fill(#82C0ED);
      rect(209 + widthControlX, 195, 120 - widthControlX, 100);
      rect(90, 195, 120 - widthControlX, 100);
    }

    image(randomPanScreened, 0, 91);
    image(sliderKnob, sliderKnob_rp_rate_x, sliderKnob_rp_rate_y);
    image(sliderKnob, sliderKnob_rp_movement_x, sliderKnob_rp_movement_y);
    
    if (widthMode == WidthMode.PINCH) image(switchFlick_down, switchFlick_x, switchFlick_y);
    else image(switchFlick_up, switchFlick_x, switchFlick_y - 5);

    textSize(18);
    fill(#82C0ED);
    textAlign(CENTER);
    text(nf(1000 / calculate_RP_rate(sliderKnob_rp_rate_y), 0, 3), 66, 317.25);
    text(nf(calculate_RP_movement(sliderKnob_rp_movement_y) / 1000, 0, 3), 354, 317.25);

  }
  
  void handleMousePressed() {
    if (mouseX > sliderKnob_rp_rate_x && mouseX < sliderKnob_rp_rate_x + 26
        && mouseY > sliderKnob_rp_rate_y && mouseY < sliderKnob_rp_rate_y + 49) {
      mousePressOffset = mouseY - sliderKnob_rp_rate_y;
    }
    else if (mouseX > sliderKnob_rp_movement_x && mouseX < sliderKnob_rp_movement_x + 26
        && mouseY > sliderKnob_rp_movement_y && mouseY < sliderKnob_rp_movement_y + 49) {
      mousePressOffset = mouseY - sliderKnob_rp_movement_y;
    }
    else if (mouseX > 108 && mouseX < 108 + 204
        && mouseY > 195 && mouseY < 295) {
      mousePressOffset = mouseX - widthControlX;
    }
  }
  
  void handleMouseClicked() {
    if (mouseX > switchFlick_x - 4 && mouseX < switchFlick_x + 20
        && mouseY > switchFlick_y - 4 && mouseY < switchFlick_y + 20) {
      widthMode = (widthMode == WidthMode.PINCH) ? WidthMode.WIDEN : WidthMode.PINCH;
      OscMessage switch_flicked = new OscMessage("/switch_flicked");
      switch_flicked.add(widthMode == WidthMode.PINCH);
      osc.send(switch_flicked, remoteAddress);
    }
  }
  
  void handleMouseDragged() {
    if (mouseX > sliderKnob_rp_rate_x && mouseX < sliderKnob_rp_rate_x + 26
        && mouseY > sliderKnob_rp_rate_y && mouseY < sliderKnob_rp_rate_y + 49) {
      sliderKnob_rp_rate_y = mouseY - mousePressOffset;
      sliderKnob_rp_rate_y = max(123, sliderKnob_rp_rate_y);
      sliderKnob_rp_rate_y = min(252, sliderKnob_rp_rate_y);
      OscMessage rp_rate = new OscMessage("/rp_rate");
      rp_rate.add(calculate_RP_rate(sliderKnob_rp_rate_y));
      osc.send(rp_rate, remoteAddress);
    }
    else if (mouseX > sliderKnob_rp_movement_x && mouseX < sliderKnob_rp_movement_x + 26
        && mouseY > sliderKnob_rp_movement_y && mouseY < sliderKnob_rp_movement_y + 49) {
      sliderKnob_rp_movement_y = mouseY - mousePressOffset;
      sliderKnob_rp_movement_y = max(123, sliderKnob_rp_movement_y);
      sliderKnob_rp_movement_y = min(252, sliderKnob_rp_movement_y);
      OscMessage rp_movement = new OscMessage("/rp_movement");
      rp_movement.add(calculate_RP_movement(sliderKnob_rp_movement_y));
      osc.send(rp_movement, remoteAddress);
    }
    else if (mouseX > 108 && mouseX < 108 + 204 && mouseY > 195 && mouseY < 295) {
      widthControlX = mouseX - mousePressOffset;
      widthControlX = max(0, widthControlX);
      widthControlX = min(102, widthControlX);
      OscMessage width_control = new OscMessage("/width_control");
      width_control.add(map(widthControlX, 0, 102, 0, 50));
      osc.send(width_control, remoteAddress);
    }
  }
  
  float calculate_RP_rate(float toMap) {
    return pow(map(toMap, 252, 123, 0.1, 1.0), 2) * 10000;
  }
  
  float calculate_RP_movement(float toMap) {
    return pow(map(toMap, 252, 123, 0.01, 1.0), 2) * 10000;
  }
  
  void handleOSC(OscMessage incomingMessage) {
    if (incomingMessage.checkAddrPattern("/stereo")) {
      stereoOffset = incomingMessage.get(0).intValue();
      stereoOffset = int(map(stereoOffset, 0, 100, 60, 360));
    }
    else if (incomingMessage.checkAddrPattern("/amplitude")) {
      amplitude = incomingMessage.get(0).floatValue();
    }
  }
  
  // Embedded circleData class
  class circleData {
    float amplitude;
    int stereoOffset;
    int opacity; 
    
    circleData() {
      this(0, 0);
    }
    
    circleData(int xPos, float amp) {  
      stereoOffset = xPos; 
      amplitude = amp;
      opacity = 128;
    }
    
    void tick() {
      opacity /= 1.05;
    }
  }
} 