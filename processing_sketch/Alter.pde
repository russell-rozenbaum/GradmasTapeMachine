
class Alter {
    PImage alterPanel;
    PImage dialKnob;
    PImage sliderKnob;

    float alterPanel_x = 8;
    float alterPanel_y = 457;

    float min_knob_angle = -15;
    float max_knob_angle = 270;
    float dialKnobSize = 37;

    float sliderRange = 609-538 + 5;

    float rateDial_angle = min_knob_angle;
    float init_rateDial_angle = min_knob_angle;
    float rateDial_x = 69.5-(dialKnobSize/2.);
    float rateDial_y = 590.43-(dialKnobSize/2.);
    boolean rateDial_pressed = false;

    float sliderKnobRateFlux_x = 117.-11/2+2;
    float sliderKnobRateFlux_y = 609.-22/2+10;
    float sliderKnobRateFlux_min = 609.-22/2+10;
    float sliderKnobRateFlux_max = 609.-22/2+10 - sliderRange;
    boolean sliderKnobRateFlux_pressed = false;

    float movementDial_angle = min_knob_angle;
    float init_movementDial_angle = min_knob_angle;
    float movementDial_x = 222.5-(dialKnobSize/2.);
    float movementDial_y = 590.43-(dialKnobSize/2.);
    boolean movementDial_pressed = false;   

    float sliderKnobMovementFlux_x = 272.-11/2+2;
    float sliderKnobMovementFlux_y = 609.-22/2+10;
    float sliderKnobMovementFlux_min = 609.-22/2+10;
    float sliderKnobMovementFlux_max = 609.-22/2+10 - sliderRange;
    boolean sliderKnobMovementFlux_pressed = false;

    float depthDial_angle = min_knob_angle;
    float init_depthDial_angle = min_knob_angle;
    float depthDial_x = 70.5-(dialKnobSize/2.);
    float depthDial_y = 723.06-(dialKnobSize/2.);
    boolean depthDial_pressed = false;  

    float sliderKnobDepthFlux_x = 116.-11/2+2;
    float sliderKnobDepthFlux_y = 745.-22/2+10;
    float sliderKnobDepthFlux_min = 745.-22/2+10;
    float sliderKnobDepthFlux_max = 745.-22/2+10 - sliderRange;
    boolean sliderKnobDepthFlux_pressed = false;

    float amountDial_angle = min_knob_angle;
    float init_amountDial_angle = min_knob_angle;
    float amountDial_x = 223.5-(dialKnobSize/2.);
    float amountDial_y = 723.06-(dialKnobSize/2.);
    boolean amountDial_pressed = false;

    float init_sliderPosition = 0;

    
    Alter() {
        alterPanel = loadImage("visuals/AlterPanel.png");

        dialKnob = loadImage("visuals/DialKnobMetal.png");

        sliderKnob = loadImage("visuals/SliderKnobSmall.png");

    }
    
    void draw() {
        fill(255, 0, 0);
        //rect(switch_x, switch_y, 24, 24);

        image(alterPanel, alterPanel_x, alterPanel_y);

        //----- BEGIN: Knob Drawing -----// 

        imageMode(CENTER);

        // Rate dial
        pushMatrix();
        translate(rateDial_x, rateDial_y);
        rotate(radians(rateDial_angle));
        image(dialKnob, 0, 0, dialKnobSize, dialKnobSize);
        popMatrix();

        // Depth dial
        pushMatrix();
        translate(depthDial_x, depthDial_y);
        rotate(radians(depthDial_angle));
        image(dialKnob, 0, 0, dialKnobSize, dialKnobSize);
        popMatrix();    

        // Movement dial
        pushMatrix();
        translate(movementDial_x, movementDial_y);
        rotate(radians(movementDial_angle));
        image(dialKnob, 0, 0, dialKnobSize, dialKnobSize);
        popMatrix();

        // Amount dial
        pushMatrix();
        translate(amountDial_x, amountDial_y);
        rotate(radians(amountDial_angle));
        image(dialKnob, 0, 0, dialKnobSize, dialKnobSize);
        popMatrix();

        imageMode(CORNER);
        
        //----- END: Knob Drawing -----//

        // Slider knob
        image(sliderKnob, sliderKnobRateFlux_x, sliderKnobRateFlux_y);
        image(sliderKnob, sliderKnobDepthFlux_x, sliderKnobDepthFlux_y);
        image(sliderKnob, sliderKnobMovementFlux_x, sliderKnobMovementFlux_y);

        textSize(18);
        fill(#DAE1E6);
        textAlign(CENTER);
        float text_offset_x = 28;
        float text_offset_y = 12.25;
        text(nf(1000 / map(rateDial_angle, min_knob_angle, max_knob_angle, 20, 2200), 0, 2), 23 + text_offset_x, 604 + text_offset_y);
        text(nf(map(movementDial_angle, min_knob_angle, max_knob_angle, 0.2, 2), 0, 3), 176 + text_offset_x, 604 + text_offset_y);
        text(nf(map(depthDial_angle, min_knob_angle, max_knob_angle, 0, 100), 0, 1), 24 + text_offset_x, 737 + text_offset_y);
        text(nf(map(amountDial_angle, min_knob_angle, max_knob_angle, 0, 100), 0, 1), 177 + text_offset_x, 737 + text_offset_y);

        
    }

    void handleMousePressed() {
        if (mouseX > rateDial_x - dialKnobSize/2. && mouseX < rateDial_x + dialKnobSize/2.
            && mouseY > rateDial_y - dialKnobSize/2. && mouseY < rateDial_y + dialKnobSize/2.) {
                mousePressOffset = mouseY;
                rateDial_pressed = true;
                init_rateDial_angle = rateDial_angle;
            }
        else if (mouseX > depthDial_x - dialKnobSize/2. && mouseX < depthDial_x + dialKnobSize/2.
            && mouseY > depthDial_y - dialKnobSize/2. && mouseY < depthDial_y + dialKnobSize/2.) {
                mousePressOffset = mouseY;
                depthDial_pressed = true;
                init_depthDial_angle = depthDial_angle;
            }   
        else if (mouseX > movementDial_x - dialKnobSize/2. && mouseX < movementDial_x + dialKnobSize/2.
            && mouseY > movementDial_y - dialKnobSize/2. && mouseY < movementDial_y + dialKnobSize/2.) {
                mousePressOffset = mouseY;
                movementDial_pressed = true;
                init_movementDial_angle = movementDial_angle;
            }
        else if (mouseX > amountDial_x - dialKnobSize/2. && mouseX < amountDial_x + dialKnobSize/2.
            && mouseY > amountDial_y - dialKnobSize/2. && mouseY < amountDial_y + dialKnobSize/2.) {
                mousePressOffset = mouseY;
                amountDial_pressed = true;
                init_amountDial_angle = amountDial_angle;
            }   
        else if (mouseX > sliderKnobRateFlux_x && mouseX < sliderKnobRateFlux_x + 26
            && mouseY > sliderKnobRateFlux_y && mouseY < sliderKnobRateFlux_y + 49) {
                mousePressOffset = mouseY - sliderKnobRateFlux_y;
                sliderKnobRateFlux_pressed = true;
            }   
        else if (mouseX > sliderKnobDepthFlux_x && mouseX < sliderKnobDepthFlux_x + 26
            && mouseY > sliderKnobDepthFlux_y && mouseY < sliderKnobDepthFlux_y + 49) {
                mousePressOffset = mouseY - sliderKnobDepthFlux_y;
                sliderKnobDepthFlux_pressed = true;
            }   
        else if (mouseX > sliderKnobMovementFlux_x && mouseX < sliderKnobMovementFlux_x + 26
            && mouseY > sliderKnobMovementFlux_y && mouseY < sliderKnobMovementFlux_y + 49) {
                mousePressOffset = mouseY - sliderKnobMovementFlux_y;
                sliderKnobMovementFlux_pressed = true;
            }     
    }

    void handleMouseDragged() {
        if (rateDial_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            rateDial_angle = map(mouseYPos, 0, -100, min_knob_angle, max_knob_angle) + init_rateDial_angle - min_knob_angle;
            rateDial_angle = constrain(rateDial_angle, min_knob_angle, max_knob_angle);
            OscMessage rate = new OscMessage("/alter_rate");
            rate.add(map(rateDial_angle, min_knob_angle, max_knob_angle, 20, 2000));
            osc.send(rate, remoteAddress);
        } 
        else if (movementDial_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            movementDial_angle = map(mouseYPos, 0, -100, min_knob_angle, max_knob_angle) + init_movementDial_angle - min_knob_angle;
            movementDial_angle = constrain(movementDial_angle, min_knob_angle, max_knob_angle);
            OscMessage movement = new OscMessage("/alter_movement");
            movement.add(map(movementDial_angle, min_knob_angle, max_knob_angle, 20, 2000));
            osc.send(movement, remoteAddress);
        }
        else if (depthDial_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            depthDial_angle = map(mouseYPos, 0, -100, min_knob_angle, max_knob_angle) + init_depthDial_angle - min_knob_angle;
            depthDial_angle = constrain(depthDial_angle, min_knob_angle, max_knob_angle);
            OscMessage depth = new OscMessage("/alter_depth");
            depth.add(map(depthDial_angle, min_knob_angle, max_knob_angle, 0, 200));
            osc.send(depth, remoteAddress);
        }
        else if (amountDial_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            amountDial_angle = map(mouseYPos, 0, -100, min_knob_angle, max_knob_angle) + init_amountDial_angle - min_knob_angle;
            amountDial_angle = constrain(amountDial_angle, min_knob_angle, max_knob_angle);
            OscMessage amount = new OscMessage("/alter_amount");
            amount.add(map(amountDial_angle, min_knob_angle, max_knob_angle, 0, 90));
            osc.send(amount, remoteAddress);
        }
        else if (sliderKnobRateFlux_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            sliderKnobRateFlux_y = mouseYPos;
            sliderKnobRateFlux_y = constrain(sliderKnobRateFlux_y, sliderKnobRateFlux_max, sliderKnobRateFlux_min);
            float rate_flux_value = map(sliderKnobRateFlux_min - sliderKnobRateFlux_y, 0, sliderRange, 0.0, 1.0);
            OscMessage rate_flux = new OscMessage("/alter_rate_flux");
            rate_flux.add(rate_flux_value);
            osc.send(rate_flux, remoteAddress);
        }
        else if (sliderKnobDepthFlux_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            sliderKnobDepthFlux_y = mouseYPos;
            sliderKnobDepthFlux_y = constrain(sliderKnobDepthFlux_y, sliderKnobDepthFlux_max, sliderKnobDepthFlux_min);
            float depth_flux_value = map(sliderKnobDepthFlux_min - sliderKnobDepthFlux_y, 0, sliderRange, 0.0, 1.0);
            OscMessage depth_flux = new OscMessage("/alter_depth_flux");
            depth_flux.add(depth_flux_value);
            osc.send(depth_flux, remoteAddress);
        }
        else if (sliderKnobMovementFlux_pressed) {
            float mouseYPos = mouseY - mousePressOffset;
            sliderKnobMovementFlux_y = mouseYPos;
            sliderKnobMovementFlux_y = constrain(sliderKnobMovementFlux_y, sliderKnobMovementFlux_max, sliderKnobMovementFlux_min);
            float movement_flux_value = map(sliderKnobMovementFlux_min - sliderKnobMovementFlux_y, 0, sliderRange, 0.0, 1.0);
            OscMessage movement_flux = new OscMessage("/alter_movement_flux");
            movement_flux.add(movement_flux_value);
            osc.send(movement_flux, remoteAddress);
        }
    }

    void handleMouseReleased() {
        rateDial_pressed = false;
        depthDial_pressed = false;
        movementDial_pressed = false;
        amountDial_pressed = false;
        sliderKnobRateFlux_pressed = false;
        sliderKnobDepthFlux_pressed = false;
        sliderKnobMovementFlux_pressed = false;
    }

    void handleMouseClicked() {
        return;
    }

    void handleOSC(OscMessage incomingMessage) {
        return;
    }


}