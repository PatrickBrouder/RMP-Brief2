import processing.video.*;

Capture video;
int pixelSize =25;

void setup() {
  size(640, 480);
  frameRate(30);
  colorMode(RGB, 255, 255, 255, 100);
  video = new Capture(this, width, height);
  video.start();  
  background(0);
}


void draw() { 
  if (video.available()) {
    video.read();
    video.loadPixels();
    image(video,0,0);
    
    for (int x = 0; x < video.width; x+=20) {
      for (int y = 0; y < video.height; y+=20) {
        int loc = x + y*video.width;
      
        float r = red(video.pixels[loc]);
        float g = green(video.pixels[loc]);
        float b = blue(video.pixels[loc]);
        color c = color(r, g, b, 85);
        float range = 150;
      float dis = dist(x,y,width/2,height/2);
      
      if(dis<range){
        
        pushMatrix();
        translate(x, y);
        rectMode(CENTER);
        fill(c);
        noStroke();
        rect(0, 0, pixelSize, pixelSize);
        popMatrix();
      }
      }
    }
  }

}