Range navi;
class Window {
    private Indicator[] indicators = new Indicator[2];
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
        for (int i = 0; i < indicators.length; i++)
            indicators[i] = new Indicator(indx, i);
    }

    void display() {
        if (indx == 0) {
            pushStyle();

            int textArea = 200;
            int pd = windows[3].PD;
            float _x = windows[3].xy.x + windows[3].size.x - textArea;
            float _y = windows[3].xy.y + pd;

            int d = day();
            int m = month();
            int y = year();
            int h = hour();
            int min = minute();
            int s = second();

            String[] days = {
                "MON",
                "TUE",
                "WED",
                "THU",
                "FRI"
            };

            String sec = "" + ((millis() - settings.initialTime) / 1000) % 60;
            String minute = "" + ((millis() - settings.initialTime) / (1000 * 60)) % 60;
            String duration = "DURATION: ";

            String date = "DATE: " + String.valueOf(m) + ". " + String.valueOf(d) + ". " + String.valueOf(y);
            text(date, _x, _y);
            String time = "TIME: " + String.valueOf(h) + ":" + String.valueOf(min) + ":" + String.valueOf(s);
            text(time, _x, _y + 2 * pd);
            String info = "INFO: " + settings.titles[0] + "    " + days[int(settings.titles[1])];
            text(info, _x, _y + 4 * pd);
            if (settings.initialTime != 0)
                duration = (settings.initialTime != 0) ? duration + minute + ":" + sec : duration + "NOT STARTED";
            text(duration, _x, _y + 6 * pd);
            popStyle();
        }
        // stroke(80);
        // noFill();
        // rect(xy.x, xy.y, size.x, size.y);
        // fill(250, 0, 0);
        // text(indx, xy.x, xy.y);
    }
}