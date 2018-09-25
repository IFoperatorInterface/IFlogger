Range navi;
class Window {
    PVector size, xy, volumeXY;
    int indx;
    private final Integer PD = 8;
    private final int[] recordColor = {
        100,
        20,
        250
    };
    Window(int indx, PVector xy, int w, int h, int mode) {
        this.xy = xy;
        this.indx = indx;
        volumeXY = xy;
        size = new PVector(w, h);
    }

    void display() {
        // stroke(80);
        // noFill();
        // rect(xy.x, xy.y, size.x, size.y);
        // fill(250, 0, 0);
        // text(indx, xy.x, xy.y);
    }
}