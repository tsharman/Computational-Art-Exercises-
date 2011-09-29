import org.json.*;
String baseURL = "http://words.bighugelabs.com/api/2/bdfafecf0b170ed8c56d2210377724ad/love/xml";

String antonym;
float antonymSize;
String word;

String request = baseURL;
void setup() {
  word = "down";
  getAntonym(word);
  antonymSize = textWidth(antonym);
  size(960, 640);
  background(255, 255, 255);
};
void draw() {
  PFont font;
  font = loadFont("Helvetica-Bold-48.vlw"); 
  textFont(font);
  textSize(20);
  float lineWidth = 0;
  int yOffset = 0;
  float xOffset = 0;
  while(true) {
    println(textWidth(antonym));
    fill(255, 255, 255);
    text(antonym, (15 + xOffset), (70 + yOffset));
    
    xOffset = xOffset + textWidth(antonym);
    if(xOffset > 900) {
      xOffset = 0;
      yOffset = yOffset + 20;
    }
    if(yOffset > 500) {
      break;
    }
  }
  fill(0, 102, 153, 150);
  textSize(300);
  text(word, 15, (500));
  
};


void getAntonym(String word) {
  String baseURL = "http://words.bighugelabs.com/api/2/bdfafecf0b170ed8c56d2210377724ad/"+ word + "/xml";
  XMLElement xml = new XMLElement(this, baseURL);
  for(int i = 0; i < xml.getChildCount(); i++) {
    XMLElement currentChild = new XMLElement();
    currentChild = xml.getChild(i);
    String out = currentChild.getString("r");
    if(out.equals("ant")) {
      antonym = currentChild.getContent();
      break;
    }
  }
  
  
}