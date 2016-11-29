import processing.video.*;
import ddf.minim.*;

Minim minim;
AudioInput in;

String url="http://api.openweathermap.org/data/2.5/weather?q=Clonmel&APPID=f2333ff01aff299c491d2be107b101b1&mode=xml";
int temperature;

Capture video;

//XML variables
XML xml;
XML[] rotations;
int pixelSize;
int pixelSize2;
int pixelSize3;
int noRotations;
int rangeDefault;

//Booleans for telling which shape to draw
boolean ellip= true;
boolean rect= false;

void setup() {
  size(640, 480);
  frameRate(24);
  
  //load and read the xml file to get the data required from it
  xml = loadXML("sizeDetails.xml");
  XML psize = xml.getChild("pixelSize");
  pixelSize = psize.getInt("size");
  pixelSize2 = psize.getInt("size2");
  pixelSize3 = psize.getInt("size3");
  XML range = xml.getChild("defaultRange");
  rangeDefault = range.getInt("range");
  rotations = xml.getChildren("rotation");
  noRotations = rotations.length;
  
  colorMode(RGB, 255, 255, 255, 100);
  
  //Set up the audio in which will be the audio coming fom the microphone
  minim = new Minim(this);
  in = minim.getLineIn();
  //Set the video capture for the same size as the screen
  video = new Capture(this, width, height);
  video.start();  
  background(0);
}


void draw() { 
  //if the video is availble read it, and place it in position
  if (video.available()) {
    video.read();
    image(video,0,0);
    //drawShape is called when either a key or boolean meet the conditions. The boolean values are changed depending on what key was pressed
    if(key=='r' || rect==true){
      rect=true;
      ellip=false;
      drawShape();
    }
    if(key=='e' || ellip ==true){
      ellip=true;
      rect=false;
      drawShape();
    }
  }

}

void drawShape(){
  //Load the openwethermap api from the string url. The temperature value is gooten from the xml and is assigned to temperature
  XML xmlResponse = loadXML(url);
  XML temperatureNode = xmlResponse.getChild("temperature");
  temperature = (int)(temperatureNode.getFloat("value")-273.15);
  
  //loop thorugh the pixels in the video but we are increasing 20 at a time instead of by 1. as the shaped are roighly 20 in size we dont need to draw one at every pixel
    for (int x = 0; x < video.width; x+=20) {
      for (int y = 0; y < video.height; y+=20) {
        //get the location of the pixel
        int loc = x + y*video.width;
        
        float r = red(video.pixels[loc]);
        float g = green(video.pixels[loc]);
        float b = blue(video.pixels[loc]);
        
        //depednig on the temperature value a tint of, blue(for cold), or red(for hot), will be applied to the shapes.
        if(temperature<8){
          b+=temperature+25;
        }
        if(temperature>8){
          r+=temperature+25;
        }
        color c = color(r, g, b, 85);
      
      //the area that gets shapes drawn on it is a circle from the center of the screen. the radius of that circle is deteremined by audio in level.
      //But seeing as that can be quite low there is check to see if the audio in value is lower than the rangeDefault, if it is the rangeDefault is added to the range 
      float range = in.mix.level()*width;
      float dis = dist(x,y,width/2,height/2);
      if(range<rangeDefault){
        range+=rangeDefault;
      }
      
      //if the pixel is within the range we draw a shape
      if(dis<range){  
        //translate i to the correct position
        pushMatrix();
        translate(x, y);
        //each shape will have a rotation, with a value from the XML file. It randomly picks one of the values in the file and applies that rotation
        int rt=int(random(0,noRotations-1));
        int rt2= rotations[rt].getInt("rotate");
        rotate(rt2);
        rectMode(CENTER);
        fill(c);
        noStroke();
        //depending on which variable is true that shape will be drawn. the sizes are got from the XML file and openweathermap
        if(rect==true){
        rect(0, 0, pixelSize+temperature, pixelSize+temperature);
        }
        if(ellip==true){
        ellipse(0, 0, pixelSize3+temperature, pixelSize2+temperature);
        }
        popMatrix();
      }
      }
    }

}