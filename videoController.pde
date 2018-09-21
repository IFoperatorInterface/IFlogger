class VideoController {
    float soundDuration = 10.03; // in seconds
    final Movie view;
    final int targetWindow;
    String targetSubject;
    private final float w, h, x, y;
    static final int DELAY = 5;
    int syncValue;
    int reservedJump;
    int reservedSync;
    private final float VOLUME_INIT = 0.2;
    static final int UPDATE_RATE = 10;
    static final int NONE = -10000;


    VideoController(String videoName, String targetSubject, int targetWindow) {
        this.view = new Movie(sketch, videoName);
        this.targetWindow = targetWindow;
        this.targetSubject = targetSubject;
        this.syncValue = 0;
        this.reservedJump = NONE;
        this.reservedSync = NONE;

        view.play();

        x = windows[targetWindow].xy.x;
        y = windows[targetWindow].xy.y;
        while (!view.available()) delay(DELAY);
        view.read();
        if (view.width > view.height) {
            w = windows[targetWindow].size.x;
            h = (view.height * windows[targetWindow].size.x) / view.width;
        } else {
            h = windows[targetWindow].size.y;
            w = (view.width * windows[targetWindow].size.y) / view.height;
        }

        view.pause();
        view.jump(0);
        view.volume(VOLUME_INIT);
    }
    void display() {

        if (!SHOW_OPERATOR && targetSubject == "Operator")
            return;

        if (view.available()) {
            view.read();
        }
        
        image(view, x, y, w, h);

        pushStyle();
        textSize(11);
        float time = view.time();
        String text = String.format("%02d:%05.2f (+%.2f)", int(time) / 60, time, syncValue / FRAMERATE);
        text(text, x, y + (int) h + (playController.sliderW + settings.PD) * 2);
        popStyle();

        if ((frameCount % UPDATE_RATE == 0) && (reservedJump != NONE)) {
            view.play();
            view.jump((reservedJump + syncValue) / FRAMERATE);
            view.pause();
            reservedJump = NONE;
        }

        if ((frameCount % UPDATE_RATE == 0) && (reservedSync != NONE)) {
            view.play();
            view.jump(view.time() + (reservedSync - this.syncValue) / FRAMERATE);
            for (int i = 0; i < 100; i++) {
                delay(3);
                if (view.available()) {
                    view.read();
                    break;
                }
            }
            view.pause();
            this.syncValue = reservedSync;
            reservedSync = NONE;
        }
    }
    void volume(float theValue) {
        view.volume(theValue);
    }

    void play() {
        if (!SHOW_OPERATOR && targetSubject == "Operator")
            return;
        view.play();
    }


    void pause() {
        if (!SHOW_OPERATOR && targetSubject == "Operator")
            return;
        view.pause();
    }


    void jump(int frame) {
        if (!SHOW_OPERATOR && targetSubject == "Operator")
            return;
        reservedJump = frame;
    }


    void sync(int syncValue) {
        if (!SHOW_OPERATOR && targetSubject == "Operator")
            return;
        reservedSync = syncValue;
    }


    void refresh() {
        view.jump(view.time());
    }


    public int getDuration() {
        return int(view.duration() * FRAMERATE);
    }
}