/**
 * Import stuff
 */
import processing.serial.*;     // import the Processing serial library
Serial myPort; // instance of the setial object

/**
 * We must set the screen dimensions to something
 */
final int BLOCK = 16,
          screenWidth = 32*BLOCK,
          screenHeight = 27*BLOCK;

/**
 * Gravity consists of a uniform downforce,
 * and a gravitational acceleration
 */
float DOWN_FORCE = 2;
float ACCELERATION = 1.3;
float DAMPENING = 0.75;

void setup() {
  size(512, 432);
  noLoop();

  screenSet = new HashMap<String, Screen>();
  SpriteMapHandler.init(this);
  SoundManager.init(this);
  CollisionDetection.init(this);
  initialize();
}

/**
 * initializing means building an "empty"
 * level, which we'll 
 */
void initialize() {
  SoundManager.mute(true);
  SoundManager.setDrawPosition(screenWidth-10, 10);
  frameRate(30);
  reset();
  
  println(Serial.list()); // print out serial ports
  myPort = new Serial(this, "/dev/cu.AdafruitEZ-Link79d7-SPP", 115200); // create an object
  myPort.bufferUntil('\n'); // wait until we receive a newline character
}

void reset() {
  clearScreens();
  addScreen("Bonus Level", new BonusLevel(width, height));
  addScreen("Dark Level", new DarkLevel(width, height));
  addScreen("Main Level", new MainLevel(4*width, height));  
  if(javascript != null) { javascript.reset(); }
  setActiveScreen("Main Level");
}

String lastCommand = "9";

/**
 * Serial handling
 * 
 * Triggers on receiving new line
 * w => 87, d => 68, a => 65, s => 83
 */
void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  myString = trim(myString);
  
  if (myString != lastCommand) {
    if (lastCommand.equals("0")) {
      activeScreen.keyReleased('s', 83);
    }
    if (lastCommand.equals("1")) {
      activeScreen.keyReleased('a', 65);
    }
    if (lastCommand.equals("2")) {
      activeScreen.keyReleased('d', 68);
    }
    if (lastCommand.equals("3")) {
      activeScreen.keyReleased('w', 87);
    }
    if (myString.equals("0")) {
      activeScreen.keyPressed('s', 83);
    }
    if (myString.equals("1")) {
      activeScreen.keyPressed('a', 65);
    }
    if (myString.equals("2")) {
      activeScreen.keyPressed('d', 68);
    }
    if (myString.equals("3")) {
      activeScreen.keyPressed('w', 87);
    }
    lastCommand = myString;
  }
  println(myString);
}