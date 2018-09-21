 public class PlayController {
   private int duration;
   private boolean isPlaying;
   private int playStartTime;

   private Toggle playToggle;
   private Slider timeSlider;
   private Slider syncBigSlider1, syncBigSlider2;
   private Slider syncSlider1, syncSlider2;
   private Slider volume1, volume2;

   private final Textlabel[] playAnnotation = new Textlabel[2];
   private final String[] playText = {
     "PAUSE: Press the [SPACEBAR] to stop playing.",
     "PLAY: Press the [SPACEBAR] to start playing."
   };

   private final int sliderW = 10;


   PlayController() {

     this.isPlaying = false;
     this.duration = max(max(captionPlayer1.getDuration(),
         captionPlayer2.getDuration()),
       max(videoController1.getDuration(),
         videoController2.getDuration()));
     this.playStartTime = 0;

     this.playToggle = controlP5.addToggle("playToggle")
       .setPosition(windows[3].xy.x + windows[2].PD, windows[3].xy.y + windows[3].PD)
       .setSize(int(windows[3].size.y - windows[2].PD * 2), int(windows[3].size.y - windows[3].PD * 2))
       .setCaptionLabel("play/stop")
       //  .setLabelVisible(false)
       .plugTo(this);

     this.timeSlider = controlP5.addSlider("timeSlider")
       .setBroadcast(false)
       .setPosition(windows[2].xy.x, windows[2].xy.y)
       .setSize(width - windows[2].PD * 2, int(sliderW * 2.5))
       .setRange(0, duration)
       .setColorForeground(color(255, 180))
       .setColorBackground(color(255, 80))
       .setLabelVisible(false)
       .plugTo(this)
       .setBroadcast(true);

     int btSize = (int) windows[3].size.y - windows[2].PD * 2;
     int _x = (int) windows[3].xy.x + btSize + windows[2].PD * 2;
     int _y = (int) windows[3].xy.y + windows[2].PD;
     controlP5.addToggle("record")
       .setPosition(_x, _y)
       .setSize(btSize, btSize);

     int movieSize = 398;
     int PD = 8;
     float[] x = {
       videoController1.x,
       videoController2.x
     };
     float[] y = {
       videoController1.y + videoController1.h + PD / 2,
       videoController2.y + videoController2.h + PD / 2,
       videoController1.y + videoController2.h + (PD + sliderW),
       videoController2.y + videoController2.h + (PD + sliderW)
     };

     if (SHOW_OPERATOR)
       this.syncBigSlider1 = controlP5.addSlider("syncBigSlider1")
       .setBroadcast(false)
       .setPosition(x[0], y[0])
       .setSize(int(windows[1].size.x), sliderW)
       .setRange(0, 120)
       .setColorForeground(color(255, 180))
       .setColorBackground(color(255, 80))
       .setLabelVisible(false)
       .plugTo(this)
       .setBroadcast(true);

     this.syncBigSlider2 = controlP5.addSlider("syncBigSlider2")
       .setBroadcast(false)
       .setPosition(x[1], y[1])
       .setSize(int(windows[5].size.x), sliderW)
       .setRange(0, 120)
       .setColorForeground(color(255, 180))
       .setColorBackground(color(255, 80))
       .setLabelVisible(false)
       .plugTo(this)
       .setBroadcast(true);

     if (SHOW_OPERATOR)
       this.syncSlider1 = controlP5.addSlider("syncSlider1")
       .setBroadcast(false)
       .setPosition(x[0], y[2])
       .setSize(int(windows[1].size.x), sliderW)
       .setRange(-120, 120)
       .setColorForeground(color(255, 180))
       .setColorBackground(color(255, 80))
       .setLabelVisible(false)
       .plugTo(this)
       .setBroadcast(true);

     this.syncSlider2 = controlP5.addSlider("syncSlider2")
       .setBroadcast(false)
       .setPosition(x[1], y[3])
       .setSize(int(windows[5].size.x), sliderW)
       .setRange(-120, 120)
       .setColorForeground(color(255, 180))
       .setColorBackground(color(255, 80))
       .setLabelVisible(false)
       .plugTo(this)
       .setBroadcast(true);
     for (int i = 0; i < playAnnotation.length; i++)
       playAnnotation[i] = new Textlabel(controlP5, playText[i], int(windows[3].xy.x + (windows[3].size.y + windows[3].PD) * 2), int(windows[3].xy.y + windows[3].PD * 4));

     this.volume1 = controlP5.addSlider("volume1")
       .setPosition(videoController1.x, videoController1.y)
       .setSize(sliderW, (int) videoController1.h)
       .setRange(0, 1)
       .setValue(0.3)
       .setNumberOfTickMarks(20)
       .setLabelVisible(false)
       .setColorForeground(color(255, 180))
       .setColorBackground(color(255, 80))
       .plugTo(this)
       .setBroadcast(true);

     this.volume2 = controlP5.addSlider("volume2")
       .setPosition(videoController2.x, videoController2.y)
       .setSize(sliderW, (int) videoController2.h)
       .setRange(0, 1)
       .setValue(0.3)
       .setNumberOfTickMarks(20)
       .setLabelVisible(false)
       .setColorForeground(color(255, 180))
       .setColorBackground(color(255, 80))
       .plugTo(this)
       .setBroadcast(true);
   }


   public void draw() {
     if (round(timeSlider.getValue()) == duration) {
       playToggle.setValue(false);
     }

     if (isPlaying) {
       timeSlider
         .setBroadcast(false)
         .setValue((millis() - playStartTime) / 1000.0 * FRAMERATE)
         .setBroadcast(true);

       playAnnotation[0].draw(sketch);
     } else {
       playAnnotation[1].draw(sketch);
     }

     pushStyle();
     textSize(11);
     float time = timeSlider.getValue() / FRAMERATE;
     String text = String.format("%02d:%05.2f", int(time) / 60, time % 60);
     text(text, windows[2].xy.x, windows[2].xy.y + sliderW * 2.5 + 8);
     popStyle();
   }


   public int getTime() {
     return (int) timeSlider.getValue();
   }


   public void playToggle(boolean theValue) {
     this.isPlaying = theValue;

     if (isPlaying) {
       videoController1.play();
       videoController2.play();
       playStartTime = millis() - int(timeSlider.getValue() / FRAMERATE * 1000.0);
     } else {
       videoController1.pause();
       videoController2.pause();

       videoController1.refresh();
       videoController2.refresh();
     }
   }


   public void timeSlider(int theValue) {
     playToggle.setValue(false);

     captionPlayer1.jump(theValue);
     captionPlayer2.jump(theValue);

     videoController1.jump(theValue);
     videoController2.jump(theValue);
   }


   public void syncBigSlider1(int theValue) {
     syncSlider(theValue, int(syncSlider1.getValue()), videoController1);
   }


   public void syncBigSlider2(int theValue) {
     syncSlider(theValue, int(syncSlider2.getValue()), videoController2);
   }


   public void syncSlider1(int theValue) {
     syncSlider(int(syncBigSlider1.getValue()), theValue, videoController1);
   }


   public void syncSlider2(int theValue) {
     syncSlider(int(syncBigSlider2.getValue()), theValue, videoController2);
   }


   public void syncSlider(int bigValue, int theValue, VideoController targetVideoController) {
     playToggle.setValue(false);

     targetVideoController.sync(int(bigValue * FRAMERATE) + theValue);
   }

   public void volume1(float theValue) {
     videoController1.volume(theValue);
   }

   public void volume2(float theValue) {
     videoController2.volume(theValue);
   }
 }