class CaptionPlayer {
  Caption[] captions;
  List<Caption> displayingCaptions;
  final int DISPLAYING_TIME = int(FRAMERATE * 2);
  final int TIME_PADDING = int(FRAMERATE * 5);
  final int startTime;
  final int duration;
  int targetWindow;
  String targetSubject;
  int nextCaptionIdx;

  CaptionPlayer(String fileName, String targetSubject, int targetWindow) {
    String[] lines = loadStrings(fileName);

    this.captions = new Caption[lines.length - 1];
    for (int i=0; i<captions.length; i++)
      captions[i] = new Caption(lines[i+1]);
      
    this.startTime = captions[0].time;

    this.duration = captions[captions.length-1].time - captions[0].time + TIME_PADDING;

    this.displayingCaptions = new ArrayList<Caption>();

    this.targetSubject = targetSubject;

    this.targetWindow = targetWindow;

    jump(0);
  }


  void draw() {
    if (!SHOW_OPERATOR && targetSubject=="Operator")
      return;
    
    if (playController.isPlaying)
      update();

    float x = windows[targetWindow].xy.x + windows[targetWindow].PD;
    float y = windows[targetWindow].xy.y + windows[targetWindow].PD;
    for (Caption c : displayingCaptions) {
      if (!c.subject.equals(targetSubject))
        continue;

      c.display(x, y);
      y += c.captionFontSize;
    }
  }


  void update() {
    if (!SHOW_OPERATOR && targetSubject=="Operator")
      return;

    int currentTime = playController.getTime() + startTime;

    while(!displayingCaptions.isEmpty()) {
      Caption c = displayingCaptions.get(0);

      if (c.time <= currentTime - DISPLAYING_TIME)
        displayingCaptions.remove(0);
      else
        break;
    }

    for (int i=nextCaptionIdx; i<captions.length; i++) {
      Caption c = captions[i];

      if (c.time <= currentTime) {
        displayingCaptions.add(c);
        nextCaptionIdx = i+1;
      }
      else
        break;
    }
  }


  void jump(int time) {
    if (!SHOW_OPERATOR && targetSubject=="Operator")
      return;

    time = constrain(time, 0, duration);

    int currentTime = time + startTime;

    displayingCaptions.clear();
    nextCaptionIdx = 0;
    for (int i=0; i<captions.length; i++) {
      Caption c = captions[i];
      if (c.time <= currentTime - DISPLAYING_TIME) {
        nextCaptionIdx = i+1;
      }
      else if ((c.time > currentTime - DISPLAYING_TIME) && (c.time <= currentTime)) {
        displayingCaptions.add(c);
        nextCaptionIdx = i+1;
      }
    }
  }


  int getDuration() {
    return duration;
  }
}


class Caption {
  int time;
  String subject;
  String content;
  private final int captionFontSize = 9;

  Caption(String s) {
    int commaIdx = s.indexOf(",");
    int commaIdx2 = s.indexOf(",", commaIdx+1);

    String timeString = s.substring(0, commaIdx);
    String[] timeWords = timeString.split(":");
    time = int(Integer.parseInt(timeWords[0]) * FRAMERATE * 60 * 60
               + Integer.parseInt(timeWords[1]) * FRAMERATE * 60
               + Float.parseFloat(timeWords[2]) * FRAMERATE);
    
    this.subject = s.substring(commaIdx+1, commaIdx2);
    this.content = s.substring(commaIdx2+1, s.length());
  }


  void display(float x, float y) {
    pushStyle();
    fill(150);
    textSize(captionFontSize);
    text(content, x, y);
    popStyle();
  }
}
