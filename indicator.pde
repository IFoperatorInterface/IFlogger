class Indicator {
    private final int targetedWindow, indx;
    private final color[] active = {
        color(200, 100, 0),
        color(0, 120, 100)
    };
    private final boolean[] isWorking = {
        false,
        false
    };
    Indicator(int targetedWindow, int indx) {
        this.targetedWindow = targetedWindow;
        this.indx = indx;
    };
    void draw() {
        isWorking[1] = recorder.isRecording();
        isWorking[0] = playController.isPlaying;
        
        pushStyle();
        if (isWorking[indx])
            fill(active[indx]);
        else
            fill(200);

        float w = windows[targetedWindow].size.y - windows[targetedWindow].PD * 2;
        float h = windows[targetedWindow].size.y - windows[targetedWindow].PD * 2;
        float x = windows[targetedWindow].xy.x + windows[targetedWindow].PD + (w + windows[targetedWindow].PD) * indx;
        float y = windows[targetedWindow].xy.y + windows[targetedWindow].PD;

        rect(x, y, w, h);
        popStyle();
    }
}