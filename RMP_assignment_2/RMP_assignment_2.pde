import processing.video.*;

Capture video;


void setup() {
  size(640, 480);
  frameRate(30);
  video = new Capture(this, width, height);
  video.start();  
  background(0);
}


void draw() { 
  if (video.available()) {
    video.read();
    video.loadPixels();
    image(video,0,0);
  }

}