import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.video.*;
import com.hamoid.*;
import controlP5.*;

import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

ControlP5 controlP5, controlP5_setup;

PApplet sketch = this;

SETTING settings;
PlayController playController;
VideoController videoController1, videoController2;
CaptionPlayer captionPlayer1, captionPlayer2;

public void settings() {
    fullScreen();
}
void setup() {
    settings = new SETTING();
    videoController1 = new VideoController("operator2.mp4", "Operator", 1);
    videoController2 = new VideoController("visitor2.mp4", "Visitor", 5);

    captionPlayer1 = new CaptionPlayer("log.csv", "Operator", 0);
    captionPlayer2 = new CaptionPlayer("log2.csv", "Visitor", 4);
    playController = new PlayController();
    frameRate(30);
    settings.isCompleted = true;
}

void draw() {
    background(0);
    processInterview();
}

void processInterview() {
    playController.draw();
    captionPlayer1.draw();
    captionPlayer2.draw();
    videoController1.display();
    videoController2.display();
    controlP5.draw();
    for (Window win: windows)
        win.display();
}

@ Override void exit() {
    videoController1.view.stop();
    videoController2.view.stop();
    super.exit();
}