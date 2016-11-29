import processing.video.*;
import ddf.minim.*;

Minim minim;
AudioInput in;

Capture video;
int pixelSize;
int pixelSize2;
int pixelSize3;
XML xml;
int noRotations;
int rangeDefault;

boolean ellip= false;
boolean rect= false;
void setup() {
  size(640, 480);
  frameRate(30);
  xml = loadXML("sizeDetails.xml");
  XML psize = xml.getChild("pixelSize");
  pixelSize = psize.getInt("size");
  pixelSize2 = psize.getInt("size2");
  pixelSize3 = psize.getInt("size3");
  XML range = xml.getChild("defaultRange");
  rangeDefault = range.getInt("range");
  colorMode(RGB, 255, 255, 255, 100);
  
  XML[] rotations = xml.getChildren("rotation");
  noRotations = rotations.length;
  
  minim = new Minim(this);
  in = minim.getLineIn();
  
  video = new Capture(this, width, height);
  video.start();  
  background(0);
}


void draw() { 
  if (video.available()) {
    video.read();
    video.loadPixels();
    image(video,0,0);
    if(key=='r'){
      rect=true;
      ellip=false;
      drawShape();
    }
    if(key=='e'){
      ellip=true;
      rect=false;
      drawShape();
    }
  }

}

void drawShape(){
    for (int x = 0; x < video.width; x+=20) {
      for (int y = 0; y < video.height; y+=20) {
        int loc = x + y*video.width;
      
        float r = red(video.pixels[loc]);
        float g = green(video.pixels[loc]);
        float b = blue(video.pixels[loc]);
        color c = color(r, g, b, 85);
        float range = in.mix.level()*width;
      float dis = dist(x,y,width/2,height/2);
      if(range<rangeDefault){
        range+=rangeDefault;
      }
      if(dis<range){
        
        pushMatrix();
        translate(x, y);
        int rt=int(random(0,noRotations));
        rotate(rt);
        rectMode(CENTER);
        fill(c);
        noStroke();
        if(rect==true){
        rect(0, 0, pixelSize, pixelSize);
        }
        if(ellip==true){
        ellipse(0, 0, pixelSize3, pixelSize2);
        }
        popMatrix();
      }
      }
    }
  
}