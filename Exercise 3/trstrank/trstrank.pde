import java.net.URLEncoder;
import javax.xml.bind.*;

void setup() {
  getFollowersList();
  getRankings();
  list();
  size(640, 640);
}

/*
 * Draw the current image centered on
 * a black background.
 */ 
Float globalHigh = 0.0;
void draw() {
  background(255);
  int m = 0;
  for(int i = 0; i < 4; i++) {
    for(int k = 0; k < 4; k++) {
      Float rank = twitterArrayRank[m];
      Float percentage = (rank/globalHigh);
      Float fillVal = 255.0;
      fillVal = fillVal * percentage;
      println(fillVal);
      fill(fillVal);
      rect((150*i+50), (150*k+50), 100, 100);
      m++;
    }
  }
}

Float twitterArrayRank[] = new Float[16];
String twitterArrayUser[] = new String[16];
String twitterArrayIds[] = new String[50];

void getFollowersList() {
  String url =  "https://api.twitter.com/1/followers/ids.xml?cursor=-1&screen_name=torehansharman";
  XMLElement xml = new XMLElement(this, url);
  XMLElement[] ids = xml.getChildren()[0].getChildren();
  println(ids[0]);
  println(ids[1]);
  
  for(int i = 0; i < 36; i++) {
    twitterArrayIds[i] = ids[i].getContent();
  }
}

void getRankings() {
  int k = 0;
  for(int i = 0; i < 50; i++) {
    if(k == 16) {
      println("breaking");
      break;
    }
    String url =  "http://api.infochimps.com/soc/net/tw/trstrank.xml?apikey=torehansharman-jLVFURuAVAyt7wvwLzF2-U3rB69&user_id=" + twitterArrayIds[i];
    try {
      XMLElement xml = new XMLElement(this, url);
      Float rank = new Float(xml.getChild("trstrank").getContent());
      twitterArrayRank[k] = rank;
      twitterArrayUser[k] = xml.getChild("row-key").getContent();
      if(rank > globalHigh) {
        globalHigh = rank;
        println("new global high " +  globalHigh);
      }
      k++;
    } catch(Exception error) {
      continue;
    }
  }
}

