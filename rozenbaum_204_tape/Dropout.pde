class Dropout {
  PImage dropoutPanel;
  PImage lightOn;
  PImage dialKnob_rate;
  PImage dialKnob_maxDepth;
  PImage dialKnob_stochasticDepth;
  PImage dialKnob_movement;
  
  boolean stereoDropout = false;
  
  float min_knob_angle = -15;
  float max_knob_angle = 270;

  float dialKnobSize = 37;

  float panel_x = 444;
  float panel_y = 91;
  
  float rateDial_angle = min_knob_angle;
  float init_rateDial_angle = min_knob_angle;
  float rateDial_x = 444+82.-(dialKnobSize/2.);
  float rateDial_y = 91.+150.-(dialKnobSize/2.);
  boolean rateDial_pressed = false;

  float maxDepthDial_angle = min_knob_angle;
  float init_maxDepthDial_angle = min_knob_angle;
  float maxDepthDial_x = 444+209.-(dialKnobSize/2.);
  float maxDepthDial_y = 91.+240.-(dialKnobSize/2.);
  boolean maxDepthDial_pressed = false;

  float stochasticDepthDial_angle = min_knob_angle;
  float init_stochasticDepthDial_angle = min_knob_angle;
  float stochasticDepthDial_x = 444+356.-(dialKnobSize/2.);
  float stochasticDepthDial_y = 91.+240.-(dialKnobSize/2.);
  boolean stochasticDepthDial_pressed = false;

  float movementDial_angle = min_knob_angle;
  float init_movementDial_angle = min_knob_angle;
  float movementDial_x = 444+491.-(dialKnobSize/2.);
  float movementDial_y = 91.+150.-(dialKnobSize/2.);
  boolean movementDial_pressed = false;
  
  float displayRight_x = 421 + 444;
  float displayLeft_x = 121 + 444;
  float displayMin_y = 142 + 91; // 162 actual dim
  float displayMax_y = 58 + 91; // 38 actual dim
  
  float lMag = 1.0;
  float rMag = 1.0;
  float avgMag = 1.0;
  float cMag = 1.0;
  
  int strokeWeight = 3;
  
  DropoutLine lineLeft;
  DropoutLine lineRight;
  DropoutLine lineAvg;
  DropoutLine lineCenter;
  
  Dropout() {
    dropoutPanel = loadImage("visuals/DropoutBackground.png");
    lightOn = loadImage("visuals/Light_(On).png");
    dialKnob_rate = loadImage("visuals/DialKnob.png");
    dialKnob_maxDepth = loadImage("visuals/DialKnob.png");
    dialKnob_stochasticDepth = loadImage("visuals/DialKnob.png");
    dialKnob_movement = loadImage("visuals/DialKnob.png");

    lineLeft = new DropoutLine(displayRight_x, displayLeft_x, displayMax_y);
    lineRight = new DropoutLine(displayRight_x, displayLeft_x, displayMax_y);
    lineAvg = new DropoutLine(displayRight_x, displayLeft_x, displayMax_y);
    lineCenter = new DropoutLine(displayRight_x, displayLeft_x, displayMax_y);
  }
  
  void draw() {
    image(dropoutPanel, 444, 91);

    //fill(255, 0, 0);
    //rect(rateDial_x - dialKnobSize/2., rateDial_y - dialKnobSize/2., dialKnobSize, dialKnobSize);
    
    //----- BEGIN: Knob Drawing -----//
    imageMode(CENTER);
    
    // Rate knob
    pushMatrix();
    translate(rateDial_x, rateDial_y);
    rotate(radians(rateDial_angle));
    image(dialKnob_rate, 0, 0, dialKnobSize, dialKnobSize);
    popMatrix();
    
    // Max Depth knob
    pushMatrix();
    translate(maxDepthDial_x, maxDepthDial_y);
    rotate(radians(maxDepthDial_angle));
    image(dialKnob_maxDepth, 0, 0, dialKnobSize, dialKnobSize);
    popMatrix();
    
    // Stochastic Depth knob
    pushMatrix();
    translate(stochasticDepthDial_x, stochasticDepthDial_y);
    rotate(radians(stochasticDepthDial_angle));
    image(dialKnob_stochasticDepth, 0, 0, dialKnobSize, dialKnobSize);
    popMatrix();
    
    // Movement knob
    pushMatrix();
    translate(movementDial_x, movementDial_y);
    rotate(radians(movementDial_angle));
    image(dialKnob_movement, 0, 0, dialKnobSize, dialKnobSize);
    popMatrix();
    
    // Reset image mode to default
    imageMode(CORNER);
    //----- END: Knob Drawing -----//

    float rateDial_value = map(rateDial_angle, min_knob_angle, max_knob_angle, 0, 100);
    float maxDepthDial_value = map(maxDepthDial_angle, min_knob_angle, max_knob_angle, 0, 100);
    float stochasticDepthDial_value = map(stochasticDepthDial_angle, min_knob_angle, max_knob_angle, 0, 100);
    float movementDial_value = map(movementDial_angle, min_knob_angle, max_knob_angle, 0, 100);

    textSize(18);
    fill(#82C0ED);
    textAlign(CENTER);
    float text_offset_x = 28;
    float text_offset_y = 12.25;
    text(nf(rateDial_value, 0, 1), panel_x + 35 + text_offset_x, panel_y + 163 + text_offset_y);
    text(nf(maxDepthDial_value, 0, 1), panel_x + 162 + text_offset_x, panel_y + 253 + text_offset_y);
    text(nf(stochasticDepthDial_value, 0, 1), panel_x + 309 + text_offset_x, panel_y + 253 + text_offset_y);
    text(nf(movementDial_value, 0, 1), panel_x + 444 + text_offset_x, panel_y + 163 + text_offset_y);

    
    // Create and add new dropout magnitudes for each stereo line
    lineLeft.update(map(lMag, 0.0, 1.0, displayMin_y, displayMax_y));
    lineRight.update(map(rMag, 0.0, 1.0, displayMin_y, displayMax_y));
    lineAvg.update(map(avgMag, 0.0, 1.0, displayMin_y, displayMax_y));
    lineCenter.update(map(cMag, 0.0, 1.0, displayMin_y, displayMax_y));
    
    if (stereoDropout) {
      image(lightOn, 444+375-10, 91+18-10);
      
      // Draw left stereo line
      stroke(#FFB752);
      strokeWeight(strokeWeight);
      for (int i = 0; i < lineLeft.points.length - 1; i++) {
        line(lineLeft.points[i].x, lineLeft.points[i].y, lineLeft.points[i+1].x, lineLeft.points[i+1].y);
      }
      noStroke();
      
      // Draw right stereo line
      stroke(#56E4FC);
      strokeWeight(strokeWeight);
      for (int i = 0; i < lineRight.points.length - 1; i++) {
        line(lineRight.points[i].x, lineRight.points[i].y, lineRight.points[i+1].x, lineRight.points[i+1].y);
      }
      noStroke();
      
      // Draw avg stereo line
      stroke(#DAFFDA, 100);
      strokeWeight(strokeWeight - 1);
      for (int i = 0; i < lineAvg.points.length - 1; i++) {
        line(lineAvg.points[i].x, lineAvg.points[i].y, lineAvg.points[i+1].x, lineAvg.points[i+1].y);
      }
      noStroke();
    }
    else {
      // Draw center stereo line
      stroke(#FF69FA);
      strokeWeight(strokeWeight);
      for (int i = 0; i < lineCenter.points.length - 1; i++) {
        line(lineCenter.points[i].x, lineCenter.points[i].y, lineCenter.points[i+1].x, lineCenter.points[i+1].y);
      }
      noStroke();
    }
  }

  void handleMousePressed() {
        if (mouseX > rateDial_x - dialKnobSize/2. && mouseX < rateDial_x + dialKnobSize/2.
            && mouseY > rateDial_y - dialKnobSize/2. && mouseY < rateDial_y + dialKnobSize/2.) {
            mousePressOffset = mouseY;
            rateDial_pressed = true;
            init_rateDial_angle = rateDial_angle;
            }
        else if (mouseX > maxDepthDial_x - dialKnobSize/2. && mouseX < maxDepthDial_x + dialKnobSize/2.
            && mouseY > maxDepthDial_y - dialKnobSize/2. && mouseY < maxDepthDial_y + dialKnobSize/2.) {
            mousePressOffset = mouseY;
            maxDepthDial_pressed = true;
            init_maxDepthDial_angle = maxDepthDial_angle;
        } 
        else if (mouseX > stochasticDepthDial_x - dialKnobSize/2. && mouseX < stochasticDepthDial_x + dialKnobSize/2. 
            && mouseY > stochasticDepthDial_y - dialKnobSize/2. && mouseY < stochasticDepthDial_y + dialKnobSize/2.) {
            mousePressOffset = mouseY;
            stochasticDepthDial_pressed = true;
            init_stochasticDepthDial_angle = stochasticDepthDial_angle;
        }
        else if (mouseX > movementDial_x - dialKnobSize/2. && mouseX < movementDial_x + dialKnobSize/2.
            && mouseY > movementDial_y - dialKnobSize/2. && mouseY < movementDial_y + dialKnobSize/2.) {
            mousePressOffset = mouseY;
            movementDial_pressed = true;
            init_movementDial_angle = movementDial_angle;
        }
    }

  void handleMouseReleased() {
    rateDial_pressed = false;
    maxDepthDial_pressed = false;
    stochasticDepthDial_pressed = false;
    movementDial_pressed = false;
  }

  void handleMouseDragged() {
    if (rateDial_pressed) {
      float mouseYPos = mouseY - mousePressOffset;
      rateDial_angle = map(mouseYPos, 0, -100, min_knob_angle, max_knob_angle) + init_rateDial_angle - min_knob_angle;
      rateDial_angle = constrain(rateDial_angle, min_knob_angle, max_knob_angle);
      OscMessage rate = new OscMessage("/dropout_rate");
      rate.add(map(rateDial_angle, min_knob_angle, max_knob_angle, 0, 9990));
      osc.send(rate, remoteAddress);
    } 
    else if (maxDepthDial_pressed) {
      float mouseYPos = mouseY - mousePressOffset;
      maxDepthDial_angle = map(mouseYPos, 0, -100, min_knob_angle, max_knob_angle) + init_maxDepthDial_angle - min_knob_angle;
      maxDepthDial_angle = constrain(maxDepthDial_angle, min_knob_angle, max_knob_angle);
      OscMessage maxDepth = new OscMessage("/dropout_maxDepth");
      maxDepth.add(map(maxDepthDial_angle, min_knob_angle, max_knob_angle, 0, 1000));
      osc.send(maxDepth, remoteAddress);
    }
    else if (stochasticDepthDial_pressed) {
      float mouseYPos = mouseY - mousePressOffset;
      stochasticDepthDial_angle = map(mouseYPos, 0, -100, min_knob_angle, max_knob_angle) + init_stochasticDepthDial_angle - min_knob_angle;
      stochasticDepthDial_angle = constrain(stochasticDepthDial_angle, min_knob_angle, max_knob_angle);
      OscMessage stochasticDepth = new OscMessage("/dropout_stochasticDepth");
      stochasticDepth.add(map(stochasticDepthDial_angle, min_knob_angle, max_knob_angle, 0, 100));
      osc.send(stochasticDepth, remoteAddress);
    }
    else if (movementDial_pressed) {
      float mouseYPos = mouseY - mousePressOffset;
      movementDial_angle = map(mouseYPos, 0, -100, min_knob_angle, max_knob_angle) + init_movementDial_angle - min_knob_angle;
      movementDial_angle = constrain(movementDial_angle, min_knob_angle, max_knob_angle);
      OscMessage movement = new OscMessage("/dropout_movement");
      movement.add(map(movementDial_angle, min_knob_angle, max_knob_angle, 30, 0));
      osc.send(movement, remoteAddress);
    }
  }
  
  void handleMouseClicked() {
    if (mouseX > 444+375-10 && mouseX < 444+375-10+30 && mouseY > 91+18-10 && mouseY < 91+18-10+30) {
      stereoDropout = !stereoDropout;
      OscMessage stereo_dropout = new OscMessage("/stereo_dropout");
      stereo_dropout.add(stereoDropout);
      osc.send(stereo_dropout, remoteAddress);
    }
  }
  
  void handleOSC(OscMessage incomingMessage) {
    if (incomingMessage.checkAddrPattern("/line_left")) {
      lMag = incomingMessage.get(0).floatValue();
    }
    else if (incomingMessage.checkAddrPattern("/line_right")) {
      rMag = incomingMessage.get(0).floatValue();
    }
    else if (incomingMessage.checkAddrPattern("/line_center")) {
      cMag = incomingMessage.get(0).floatValue();
    }
    else if (incomingMessage.checkAddrPattern("/line_avg")) {
      avgMag = incomingMessage.get(0).floatValue();
    }
  }
  
  // Embedded DropoutPoint class
  class DropoutPoint {
    float x;
    float y;
    DropoutPoint(float x_in, float y_in) {
      x = x_in;
      y = y_in;
    }
  }

  // Embedded DropoutLine class
  class DropoutLine {
    DropoutPoint[] points;
    float displayRight_x;
    float displayLeft_x;
    float displayMax_y;
    
    DropoutLine(float displayRight_x, float displayLeft_x, float displayMax_y) {
      this.displayRight_x = displayRight_x;
      this.displayLeft_x = displayLeft_x;
      this.displayMax_y = displayMax_y;
      
      points = new DropoutPoint[150];
      for (int i = 0; i < points.length; i++) {
        points[i] = new DropoutPoint(displayLeft_x + map(i, 0, points.length, 0, (displayRight_x - displayLeft_x)), displayMax_y);
      }
    }
    
    void update(float currMag) {
      float x_diff = (displayRight_x - displayLeft_x) / points.length;
      for (int i = 0; i < points.length - 1; i++) {
        points[i] = points[i + 1];
        points[i].x -= x_diff;
      }
      points[points.length - 1] = new DropoutPoint(displayRight_x, currMag);
    }
  }
} 