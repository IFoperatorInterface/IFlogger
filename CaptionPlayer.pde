class CaptionPlayer {
  Caption[] captions;
  List<Caption> displayingCaptions;
  final int DISPLAYING_TIME = 2000;
  final int TIME_PADDING = 5000;
  final Date startRealTime;
  final int duration;
  int targetWindow;
  String targetSubject;
  int nextCaptionIdx;

  CaptionPlayer(String fileName, String targetSubject, int targetWindow) {
    String[] lines = loadStrings(fileName);

    this.captions = new Caption[lines.length - 1];
    for (int i=0; i<captions.length; i++)
      captions[i] = new Caption(lines[i+1]);

    this.startRealTime = captions[0].realTime;

    this.duration = int(captions[captions.length-1].realTime.getTime() - captions[0].realTime.getTime()) + TIME_PADDING;

    this.displayingCaptions = new ArrayList<Caption>();

    this.targetSubject = targetSubject;

    this.targetWindow = targetWindow;

    jump(0);
  }


  void draw() {
    if (playController.isPlaying)
      update();

    float x = windows[targetWindow].xy.x + windows[targetWindow].PD;
    float y = windows[targetWindow].xy.y + windows[targetWindow].PD;
    for (Caption c : displayingCaptions) {
      if (!c.isFromSubject(targetSubject))
        continue;

      c.display(x, y);
      y += c.captionFontSize;
    }
  }


  void update() {
    long currentTime = playController.getTime() + startRealTime.getTime();

    while(!displayingCaptions.isEmpty()) {
      Caption c = displayingCaptions.get(0);

      if (c.realTime.getTime() <= currentTime - DISPLAYING_TIME)
        displayingCaptions.remove(0);
      else
        break;
    }

    for (int i=nextCaptionIdx; i<captions.length; i++) {
      Caption c = captions[i];

      if (c.realTime.getTime() <= currentTime) {
        displayingCaptions.add(c);
        nextCaptionIdx = i+1;
      }
      else
        break;
    }
  }


  void jump(int time) {
    time = constrain(time, 0, duration);

    long currentTime = time + startRealTime.getTime();

    displayingCaptions.clear();
    nextCaptionIdx = 0;
    for (int i=0; i<captions.length; i++) {
      Caption c = captions[i];
      if (c.realTime.getTime() <= currentTime - DISPLAYING_TIME) {
        nextCaptionIdx = i+1;
      }
      else if ((c.realTime.getTime() > currentTime - DISPLAYING_TIME) && (c.realTime.getTime() <= currentTime)) {
        displayingCaptions.add(c);
        nextCaptionIdx = i+1;
      }
    }
  }


  int getDuration() {
    return duration;
  }


  public Date getRealTime() {
    return new Date(startRealTime.getTime() + int(playController.getTime()));
  }
}


class Caption {
  Date realTime;
  String subject;
  String content;
  private final int captionFontSize = 9;

  Caption(String s) {
    int commaIdx = s.indexOf(",");
    int commaIdx2 = s.indexOf(",", commaIdx+1);

    String timeString = s.substring(0, commaIdx)+"0";
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss.SSS");
    try {
      realTime = sdf.parse(timeString);
    }
    catch (ParseException e) {}
    
    this.subject = s.substring(commaIdx+1, commaIdx2);
    this.content = s;
  }


  void display(float x, float y) {
    pushStyle();
    fill(150);
    textSize(captionFontSize);
    text(content, x, y);
    popStyle();
  }


  public boolean isFromSubject(String targetSubject) {
    String[] words = this.subject.split(" ");
    return words[0].equals(targetSubject);
  }
}
