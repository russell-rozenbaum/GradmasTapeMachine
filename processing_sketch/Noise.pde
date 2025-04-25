enum SwitchState {
    PEAK,
    DUCK
}

enum NoiseSwitchState {
    DC,
    VINYL
}

class Noise {
    PImage noisePanel;
    PImage noisePanelSubtracted;
    PImage gainKnob;
    PImage toneDial;
    PImage fluxDial;
    PImage tailDial;
    PImage switch_Peak;
    PImage switch_Duck;
    PImage switch_DC;
    PImage switch_VINYL;

    float noisePanel_x = 447;
    float noisePanel_y = 385;

    float gainKnob_min = 688;
    float gainKnob_max = 452;
    float gainKnob_x = 477.5;
    float gainKnob_y = gainKnob_min;
    boolean gainKnob_pressed = false;

    float dialKnobSize = 37;

    float min_angle = -15;
    float max_angle = 270;

    float toneDial_angle = (max_angle + min_angle) / 2;
    float init_toneDial_angle = min_angle;
    float toneDial_x = 590.5;
    float toneDial_y = 726;
    boolean toneDial_pressed = false;

    float fluxDial_angle = min_angle;
    float init_fluxDial_angle = min_angle;
    float fluxDial_x = 677.5;
    float fluxDial_y = 727;
    boolean fluxDial_pressed = false;

    float tailDial_angle = min_angle;
    float init_tailDial_angle = min_angle;
    float tailDial_x = 682.5;
    float tailDial_y = 464;
    boolean tailDial_pressed = false;

    float switch_x = 578;
    float switch_y = 434;
    SwitchState switch_state = SwitchState.DUCK;

    float noise_switch_x = 520;
    float noise_switch_y = 574;
    NoiseSwitchState noise_switch_state = NoiseSwitchState.DC;

    float waveDisplay_x = 550.5;
    float waveDisplay_length = 145;
    float waveDisplay_center = 581.5;
    NoiseWave noiseWave;
    float noiseAmp = 0.0;
    
    Noise() {
        noisePanel = loadImage("visuals/NoisePanel.png");
        noisePanelSubtracted = loadImage("visuals/NoisePanelSubtracted.png");

        gainKnob = loadImage("visuals/SliderKnobWooden.png");

        toneDial = loadImage("visuals/DialKnobWooden.png");
        fluxDial = loadImage("visuals/DialKnobWooden.png");
        tailDial = loadImage("visuals/DialKnobWooden.png");

        switch_Peak = loadImage("visuals/SwitchWooden_(Up).png"); 
        switch_Duck = loadImage("visuals/SwitchWooden_(Down).png");

        switch_DC = loadImage("visuals/SwitchWooden_(Up).png");
        switch_VINYL = loadImage("visuals/SwitchWooden_(Down).png");

        noiseWave = new NoiseWave(waveDisplay_x, waveDisplay_length, waveDisplay_center);
    }
    
    void draw() {
        fill(255, 0, 0);
        //rect(switch_x, switch_y, 24, 24);

        image(noisePanel, noisePanel_x, noisePanel_y);

        noiseWave.update(noiseAmp);

        stroke(#9CA4FF);
        strokeWeight(1);
        for (int i = 0; i < noiseWave.points.length - 1; i++) {
            line(noiseWave.points[i].x, noiseWave.points[i].y, noiseWave.points[i+1].x, noiseWave.points[i+1].y);
        }
        noStroke();
        image(noisePanelSubtracted, noisePanel_x, noisePanel_y);

        image(gainKnob, gainKnob_x, gainKnob_y);

        if (switch_state == SwitchState.DUCK) {
            image(switch_Duck, switch_x, switch_y);
        } else {
            image(switch_Peak, switch_x, switch_y-5);
        }

        if (noise_switch_state == NoiseSwitchState.DC) {
            image(switch_DC, noise_switch_x, noise_switch_y-5);
        } else {
            image(switch_VINYL, noise_switch_x, noise_switch_y);
        }

        //----- BEGIN: Knob Drawing -----//
        imageMode(CENTER);
        
        // Tone knob
        pushMatrix();
        translate(toneDial_x - 15.5, toneDial_y - 18);
        rotate(radians(toneDial_angle));
        image(toneDial, 0, 0, dialKnobSize, dialKnobSize);
        popMatrix();

        // Flux knob
        pushMatrix();
        translate(fluxDial_x - 15.5, fluxDial_y - 18);
        rotate(radians(fluxDial_angle));
        image(fluxDial, 0, 0, dialKnobSize, dialKnobSize);
        popMatrix();

        // Tail knob
        pushMatrix();
        translate(tailDial_x - 15.5, tailDial_y - 18);
        rotate(radians(tailDial_angle));
        image(tailDial, 0, 0, dialKnobSize, dialKnobSize);
        popMatrix();

        imageMode(CORNER);

        //----- END: Knob Drawing -----//

        textSize(18);
        fill(#DAE1E6);
        textAlign(CENTER);
        float text_offset_x = 31;
        float text_offset_y = 12.25;
        text(nf(map(toneDial_angle, min_angle, max_angle, 0, 100), 0, 1), 543.5 + text_offset_x, 740 + text_offset_y);
        text(nf(map(fluxDial_angle, min_angle, max_angle, 0, 100), 0, 1), 630.5 + text_offset_x, 740 + text_offset_y);
        text(nf(map(tailDial_angle, min_angle, max_angle, 0, 100), 0, 1), 635.5 + text_offset_x, 477 + text_offset_y);
        text(nf(map(gainKnob_y, gainKnob_min, gainKnob_max, -60, 6), 0, 1), 461 + text_offset_x, 740 + text_offset_y);

    }

    void handleMousePressed() {
        if (mouseX > gainKnob_x && mouseX < gainKnob_x + 26
            && mouseY > gainKnob_y && mouseY < gainKnob_y + 49) {
            mousePressOffset = mouseY - gainKnob_y;
            gainKnob_pressed = true;
        }
        if (mouseX > toneDial_x - dialKnobSize + 3 && mouseX < toneDial_x + 3
            && mouseY > toneDial_y - dialKnobSize && mouseY < toneDial_y) {
            mousePressOffset = mouseY;
            toneDial_pressed = true;
            init_toneDial_angle = toneDial_angle;
        }
        if (mouseX > fluxDial_x - dialKnobSize + 3 && mouseX < fluxDial_x + 3
            && mouseY > fluxDial_y - dialKnobSize && mouseY < fluxDial_y) {
            mousePressOffset = mouseY;
            fluxDial_pressed = true;
            init_fluxDial_angle = fluxDial_angle;
        }
        if (mouseX > tailDial_x - dialKnobSize + 3 && mouseX < tailDial_x + 3
            && mouseY > tailDial_y - dialKnobSize && mouseY < tailDial_y) {
            mousePressOffset = mouseY;
            tailDial_pressed = true;
            init_tailDial_angle = tailDial_angle;
        }
    }

    void handleMouseDragged() {
        if (gainKnob_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            gainKnob_y = mouseYPos;
            gainKnob_y = constrain(gainKnob_y, gainKnob_max, gainKnob_min);
            OscMessage gain = new OscMessage("/noise_gain");
            gain.add(map(gainKnob_y, gainKnob_min, gainKnob_max, 0, 158));
            osc.send(gain, remoteAddress);
        }
        else if (toneDial_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            toneDial_angle = map(mouseYPos, 0, -100, min_angle, max_angle) + init_toneDial_angle - min_angle;
            toneDial_angle = constrain(toneDial_angle, min_angle, max_angle);
            OscMessage tone = new OscMessage("/noise_tone");
            tone.add(map(toneDial_angle, min_angle, max_angle, 0, 1));
            osc.send(tone, remoteAddress);
        }
        else if (fluxDial_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            fluxDial_angle = map(mouseYPos, 0, -100, min_angle, max_angle) + init_fluxDial_angle - min_angle;
            fluxDial_angle = constrain(fluxDial_angle, min_angle, max_angle);
            OscMessage flux = new OscMessage("/noise_flux");
            flux.add(map(fluxDial_angle, min_angle, max_angle, 0, 5000));
            osc.send(flux, remoteAddress);
        }
        else if (tailDial_pressed) { 
            float mouseYPos = mouseY - mousePressOffset;
            tailDial_angle = map(mouseYPos, 0, -100, min_angle, max_angle) + init_tailDial_angle - min_angle;
            tailDial_angle = constrain(tailDial_angle, min_angle, max_angle);
            OscMessage tail = new OscMessage("/noise_tail");
            tail.add(map(tailDial_angle, min_angle, max_angle, 0, 1));
            osc.send(tail, remoteAddress);
        }
    }

    void handleMouseReleased() {
        toneDial_pressed = false;
        fluxDial_pressed = false;
        tailDial_pressed = false;
        gainKnob_pressed = false;
    }

    void handleMouseClicked() {
        if (mouseX > switch_x - 4 && mouseX < switch_x + 20
            && mouseY > switch_y - 4 && mouseY < switch_y + 20) {
            switch_state = (switch_state == SwitchState.DUCK) ? SwitchState.PEAK : SwitchState.DUCK;
            OscMessage peak_duck = new OscMessage("/peak_duck");
            peak_duck.add(switch_state == SwitchState.DUCK ? 0 : 1);
            osc.send(peak_duck, remoteAddress);
        }
        if (mouseX > noise_switch_x - 4 && mouseX < noise_switch_x + 20
            && mouseY > noise_switch_y - 4 && mouseY < noise_switch_y + 20) {
            noise_switch_state = (noise_switch_state == NoiseSwitchState.DC) ? NoiseSwitchState.VINYL : NoiseSwitchState.DC;
            OscMessage dc_vinyl = new OscMessage("/dc_vinyl");
            dc_vinyl.add(noise_switch_state == NoiseSwitchState.DC ? 0 : 1);
            osc.send(dc_vinyl, remoteAddress);
        }
    }

    void handleOSC(OscMessage incomingMessage) {
        if (incomingMessage.checkAddrPattern("/noise_amp")) {
            noiseAmp = incomingMessage.get(0).floatValue();
        }
    }

    class NoiseWavePoint {
    float x;
    float y;
    NoiseWavePoint(float x_in, float y_in) {
      x = x_in;
      y = y_in;
    }
  }

    class NoiseWave {
    NoiseWavePoint[] points;
    float displayRight_x;
    float displayLeft_x;
    float displayCenter_y;
    
    NoiseWave(float displayRight_x, float displayLeft_x, float displayCenter_y) {
      this.displayRight_x = waveDisplay_x + waveDisplay_length;
      this.displayLeft_x = waveDisplay_x;
      this.displayCenter_y = displayCenter_y;
      
      points = new NoiseWavePoint[150];
      for (int i = 0; i < points.length; i++) {
        points[i] = new NoiseWavePoint(displayLeft_x + map(i, 0, points.length, 0, (displayRight_x - displayLeft_x)), displayCenter_y);
      }
    }

    void update(float currAmplitude) {
      float x_diff = (displayRight_x - displayLeft_x) / points.length;
      for (int i = 0; i < points.length - 1; i++) {
        points[i] = points[i + 1];
        points[i].x -= x_diff;
      }
      points[points.length - 1] = new NoiseWavePoint(displayRight_x, displayCenter_y + map(currAmplitude, -.2, 0.2, -141, 141));
    }
  }
}