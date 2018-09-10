import gab.opencv.*;
import processing.video.*;
import processing.serial.*;
import java.awt.*;

Capture video;
OpenCV opencv;
Serial serial;
Boolean isHazed = false;

//color perlin noise
float t=0;
int addColor = 0xFFFE00;
int currentTime;

void setup() {
  size(1280, 960);

  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();

  String portName = Serial.list()[1];
  serial = new Serial(this, portName, 9600);
  currentTime = millis();
}

void draw() {
  scale(4);
  opencv.loadImage(video);

  Rectangle[] faces = opencv.detect();

  //modify color every 10 seconds
  if (millis() - currentTime > 5000) {
    currentTime = millis();
    float randomValue = random(1);
    if (randomValue < 0.3) {
      addColor=color(random(240, 255), random(240, 255), random(0, 40));
    } else if (randomValue < 0.6) {
      addColor=color(random(240, 255), random(0, 40), random(240, 255));
    } else if (randomValue < 1) {
      addColor=color(random(0, 40), random(240, 255), random(240, 255));
    }
  }
  video.loadPixels();
  for (int i=0; i<video.width*video.height; i++) {
    video.pixels[i] = addColor & video.pixels[i];
  }
  video.updatePixels();
  image(video, 0, 0);

  if (faces.length > 0 && !isHazed) {
    if (serial.active()) {
      serial.write('1');
    }
    isHazed = true;
    fill(0, 80);
    textSize(26);
    text(faces.length, 10, 30);
    //for (int i = 0; i < faces.length; i++) {
    //  println(faces[i].x + "," + faces[i].y);
    //  rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    //}
  } else {
    isHazed = false;
  }
}

void captureEvent(Capture c) {
  c.read();
}
