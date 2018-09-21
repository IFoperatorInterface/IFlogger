SetInterviewController setInterviewController;

class SetInterviewController {
    private boolean isCompleted = false;
    private final int PD = 8;
    private Textlabel info;
    SetInterviewController() {
        int pd = 20;
        int NUMTEXT = 2;
        int w = 200;
        int h = 28;
        String[] typeTitles = {
            "admin",
            "visitor"
        };

        rType = controlP5_setup.addRadioButton("rType")
            .setPosition(width / 2 - w / 2, height / 2)
            .setSize(w / 2, h)
            .setItemsPerRow(5)
            .setSpacingColumn(PD)
            .addItem(typeTitles[0], 0)
            .addItem(typeTitles[1], 1);
        int indx = 0;
        for (Toggle t: rType.getItems()) {
            t.getCaptionLabel().getStyle().moveMargin(0, 0, 0, int(-1 * (w / 2) / 2 - textWidth(typeTitles[indx]) / 2));
            indx++;
        }

        int NUM_SESSION = 5;
        rSession = controlP5_setup.addRadioButton("rSession")
            .setPosition(width / 2 - w / 2, height / 2 + 1 * (h + PD))
            .setSize((w - PD * (NUM_SESSION - 2)) / NUM_SESSION, h)
            .setItemsPerRow(NUM_SESSION)
            .setSpacingColumn(PD)
            .addItem("MON", 0)
            .addItem("TUE", 1)
            .addItem("WED", 2)
            .addItem("THR", 3)
            .addItem("FRI", 4);
        indx = 0;
        for (Toggle t: rSession.getItems()) {
            t.getCaptionLabel().getStyle().moveMargin(0, 0, 0, int(-(w - PD * (NUM_SESSION - 2)) / NUM_SESSION) / 2 - 12);
            indx++;
        }

        controlP5_setup.addBang("saveSettings")
            .setCaptionLabel("save")
            .setTriggerEvent(Bang.RELEASE)
            .setPosition(width / 2 + (w / 2 - 50 + PD), height / 2 + 2 * (PD + h))
            .setSize(50, 50);
    }

    void draw() {
        int c = 0;
        String txt;

        for (int i = 0; i < settings.titles.length; i++)
            if (settings.titles[i] != null)
                c++;

        if (c == 3)
            txt = "CLICK SAVE TO PROCEED: " + "  [" + settings.titles[0] + "]  [" + settings.titles[1] + "]";

        else
            txt = "PLEASE SELECT OPTIONS: " + "  [" + settings.titles[0] + "]  [" + settings.titles[1] + "]";

        info = new Textlabel(controlP5, txt, width / 2 - (int) textWidth(txt) / 2, height / 2 - PD - 10);

        info.draw(sketch);
        controlP5_setup.draw();
    }
}

public void rType(int a) {
    String theText = "";
    switch (a) {
        case (0):
            theText = "Operator";
            break;
        case (1):
            theText = "Visitor";
            break;
    }
    settings.titles[0] = theText;
}
public void rSession(int a) {
    String theText = "" + a;
    settings.titles[1] = theText;
}

public void saveSettings() {
    if (settings.isCompleted) {
        for (int i = 0; i < settings.titles.length; i++) {
            if (settings.titles[i] == null)
                return;
        }
        audioController = new AudioController();
        videoRecorder = new VideoRecorder();
        setInterviewController.isCompleted = true;
        settings.mode = 1;
    }
}