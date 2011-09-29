import java.net.URLEncoder;
import javax.xml.bind.*;

//twitter only pulls 20 latest tweets
int numImages = 20;
PImage[] PImageArray = new PImage[numImages];
String[] twitterArray = new String[numImages];
String query = "people";
PImage img;
int curIndex = 0;

void setup() {
  getTwitterFeed();
  getPhotosFromQuery(query);
  img = getPhotoFromIndex(curIndex);
  size(640, 640);
}

/*
 * Draw the current image centered on
 * a black background.
 */ 
void draw() {
  background(0);
  //image(img, (640 - img.width) / 2, (640 - img.height) / 2);
  image(img, 0, 0, 640, 640);
  PFont font;
  font = loadFont("Helvetica-Bold-48.vlw"); 
  textFont(font, 30);
  text(twitterArray[curIndex], 50, 100, 400, 600);
  img = getPhotoFromIndex(curIndex);
}

/*
 * Call this method to populate
 * the array of photos.
 */
void getPhotosFromQuery(String searchTerm) {
  try {
    searchTerm = URLEncoder.encode(searchTerm, "UTF-8");
  } catch (Exception e) {
    e.printStackTrace();
    exit();
    return;
  }
  String url =  "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=bfaa37fbd00c1291ced65b903fb15fda&text=" 
                  + searchTerm + "&format=rest&sort=relevance&user_id=36587311@N08";
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

void getTwitterFeed() {
  String url =  "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=VeryShortStory";
  XMLElement xml = new XMLElement(this, url);
  XMLElement[] tweets = xml.getChildren();
  for(int i = 0; i < numImages; i++) {
    twitterArray[i] = tweets[i].getChild("text").getContent();
  }
}

/*
 * You must call getPhotosFromQuery() to seed the photo array
 * before calling this method.
 */
PImage getPhotoFromIndex(int i) {
  return PImageArray[i];
}

void keyPressed() {
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
