Minim minim;
// for recording
AudioInput in ;
AudioRecorder recorder;
boolean recorded;


class AudioController {
    private final int PD = 8;
    private final Textlabel[] recordingAnnotation = new Textlabel[3];
    private final String[] recordingText = {
        "STOP: Press the [R] key to stop recording.",
        "REC: Press the [R] key to start recording.",
        "SAVE: Press the [S] key to save the recording."
    };
    private boolean isCompleted = false;

    AudioController() {
        minim = new Minim(sketch);

        in = minim.getLineIn();

        recorder = minim.createRecorder( in , "save/" + settings.titles[0] + "/" + settings.titles[1] + "/" + settings.titles[0] + "_" + settings.titles[2] + ".wav");

        for (int i = 0; i < recordingAnnotation.length; i++)
            recordingAnnotation[i] = new Textlabel(controlP5, recordingText[i], int(windows[3].xy.x + (windows[3].size.y + windows[3].PD) * 2), int(windows[3].xy.y + windows[3].PD));

        isCompleted = true;
    }
    void display() {
        drawWaveforms();
        drawText();
    }

    void drawWaveforms() {
        pushStyle();
        stroke(200);
        for (int i = 0; i < windows[7].size.x; i++) {
            int scale = 40;
            int baseY = (int) windows[7].size.y / 2;
            float x1 = windows[7].xy.x + i;
            float x2 = windows[7].xy.x + i + 1;
            float y1 = windows[7].xy.y + baseY + in .left.get(i) * scale;
            float y2 = windows[7].xy.y + baseY + in .left.get(i + 1) * scale;
            line(x1, y1, x2, y2);
        }
        popStyle();
    }

    void drawText() {
        if (recorder.isRecording()) {
            recordingAnnotation[0].draw(sketch);
        } else if (!recorded) {
            recordingAnnotation[1].draw(sketch);
        } else {
            recordingAnnotation[2].draw(sketch);
        }
    }
}