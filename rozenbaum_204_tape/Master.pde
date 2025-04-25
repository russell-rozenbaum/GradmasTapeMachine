class Master {
    
    PImage masterPanel;

    PImage sliderKnob;

    float masterPanel_x = 754;
    float masterPanel_y = 408;

    float sliderRange = 265 - 40 + 5;

    float sliderKnobMasterMix_x = masterPanel_x+43-4;
    float sliderKnobMasterMix_y = masterPanel_y+265;
    float sliderKnobMasterMix_min = masterPanel_y+265;
    float sliderKnobMasterMix_max = sliderKnobMasterMix_min - sliderRange;
    boolean sliderKnobMasterMix_pressed = false;

    float sliderKnobMasterGain_x = masterPanel_x+150-4;
    float sliderKnobMasterGain_y = masterPanel_y+265;
    float sliderKnobMasterGain_min = masterPanel_y+265;
    float sliderKnobMasterGain_max = sliderKnobMasterGain_min - sliderRange;
    boolean sliderKnobMasterGain_pressed = false;
    
    

    Master() {
        masterPanel = loadImage("visuals/MasterSliders.png");
        sliderKnob = loadImage("visuals/SliderKnob.png");
        
    }

    void draw() {
        image(masterPanel, masterPanel_x, masterPanel_y);

        image(sliderKnob, sliderKnobMasterMix_x, sliderKnobMasterMix_y);
        image(sliderKnob, sliderKnobMasterGain_x, sliderKnobMasterGain_y);

        textSize(18);
        fill(#DAE1E6);
        textAlign(CENTER);
        textFont(font);
        float text_offset_x = 28;
        float text_offset_y = 12.25;
        text(nf(map(sliderKnobMasterMix_min - sliderKnobMasterMix_y, 0, sliderRange, 0.0, 100.0), 0, 1), masterPanel_x + 27 + text_offset_x, masterPanel_y + 336 + text_offset_y);
        text(nf(map(sliderKnobMasterGain_min - sliderKnobMasterGain_y, 0, sliderRange, -60.0, 6.0), 0, 1), masterPanel_x + 134 + text_offset_x, masterPanel_y + 336 + text_offset_y);

        textSize(32);
        fill(#454F57);
        textAlign(CENTER);
        text("Grandma's Tape Machine", width / 2, 45);

    }

    void handleMousePressed() {
        if (mouseX > sliderKnobMasterMix_x && mouseX < sliderKnobMasterMix_x + 26
            && mouseY > sliderKnobMasterMix_y && mouseY < sliderKnobMasterMix_y + 49) {
                mousePressOffset = mouseY - sliderKnobMasterMix_y;
                sliderKnobMasterMix_pressed = true; 
        }
        else if (mouseX > sliderKnobMasterGain_x && mouseX < sliderKnobMasterGain_x + 26
            && mouseY > sliderKnobMasterGain_y && mouseY < sliderKnobMasterGain_y + 49) {
                mousePressOffset = mouseY - sliderKnobMasterGain_y;
                sliderKnobMasterGain_pressed = true; 
        }
    }

    void handleMouseDragged() {
        if (sliderKnobMasterMix_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            sliderKnobMasterMix_y = mouseYPos;
            sliderKnobMasterMix_y = constrain(sliderKnobMasterMix_y, sliderKnobMasterMix_max, sliderKnobMasterMix_min);
            float masterMix_value = map(sliderKnobMasterMix_min - sliderKnobMasterMix_y, 0, sliderRange, 0.0, 100.0);
            OscMessage masterMix = new OscMessage("/master_mix");
            masterMix.add(masterMix_value);
            osc.send(masterMix, remoteAddress);
        }       
        else if (sliderKnobMasterGain_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            sliderKnobMasterGain_y = mouseYPos;
            sliderKnobMasterGain_y = constrain(sliderKnobMasterGain_y, sliderKnobMasterGain_max, sliderKnobMasterGain_min);
            float masterGain_value = map(sliderKnobMasterGain_min - sliderKnobMasterGain_y, 0, sliderRange, 0.0, 158.0);
            OscMessage masterGain = new OscMessage("/master_gain");
            masterGain.add(masterGain_value);
            osc.send(masterGain, remoteAddress);
        }
    }

    void handleMouseReleased() {
        sliderKnobMasterMix_pressed = false;
        sliderKnobMasterGain_pressed = false;
    }

    void handleOSC(OscMessage incomingMessage) {    

    }
    
}

