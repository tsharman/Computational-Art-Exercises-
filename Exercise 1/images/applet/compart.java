import processing.core.*; 
import processing.xml.*; 

import java.net.URLEncoder; 
import javax.xml.bind.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class compart extends PApplet {





//twitter only pulls 20 latest tweets
int numImages = 20;
PImage[] PImageArray = new PImage[numImages];
String[] twitterArray = new String[numImages];
String query = "vintage";
PImage img;
int curIndex = 0;

public void setup() {
  getTwitterFeed();
  list();
  getPhotosFromQuery(query);
  img = getPhotoFromIndex(curIndex);
  size(640, 640);
}

/*
 * Draw the current image centered on
 * a black background.
 */ 
public void draw() {
  background(0);
  image(img, (640 - img.width) / 2, (640 - img.height) / 2);
  PFont font;
  font = loadFont("Helvetica-Bold-48.vlw"); 
  textFont(font, 30);
  text(twitterArray[curIndex], 50, 100, 500, 600);
  img = getPhotoFromIndex(curIndex);
}

/*
 * Call this method to populate
 * the array of photos.
 */
public void getPhotosFromQuery(String searchTerm) {
  try {
    searchTerm = URLEncoder.encode(searchTerm, "UTF-8");
  } catch (Exception e) {
    e.printStackTrace();
    exit();
    return;
  }
  String url =  "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=bfaa37fbd00c1291ced65b903fb15fda&text=" 
                  + searchTerm + "&format=rest&sort=relevance";
  XMLElement xml = new XMLElement(this, url);
  xml = xml.getChild(0);
  XMLElement[] photos = xml.getChildren();
  int maximum = min(numImages, photos.length - 1);
  for(int i=0; i < maximum; i++) {
    XMLElement photo = photos[i];
    String imgURL = "http://farm" + photo.getString("farm") 
              + ".static.flickr.com/" 
              + photo.getString("server") + "/" 
              + photo.getString("id") + "_" 
              + photo.getString("secret") + "_z.jpg";
    PImageArray[i] = loadImage(imgURL);
    println(i+1 + "/" + maximum);
  }
  
}

public void getTwitterFeed() {
  String url =  "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=VeryShortStory";
  XMLElement xml = new XMLElement(this, url);
  XMLElement[] tweets = xml.getChildren();
  for(int i = 0; i < numImages; i++) {
    println(i);
    twitterArray[i] = tweets[i].getChild("text").getContent();
  }
}

/*
 * You must call getPhotosFromQuery() to seed the photo array
 * before calling this method.
 */
public PImage getPhotoFromIndex(int i) {
  return PImageArray[i];
}

public void keyPressed() {
  if(key == CODED) {
    if(keyCode == LEFT) {
      curIndex = max(0, curIndex - 1);
      println(curIndex+1);
    } else if (keyCode == RIGHT) {
      curIndex = min(PImageArray.length - 1, curIndex + 1);  
      println(curIndex+1);
    }
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "compart" });
  }
}
