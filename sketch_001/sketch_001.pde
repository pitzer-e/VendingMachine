class CentralControlSystem { //<>//

  //  class variables
  private int[][] itemPrice;
  private int[][] itemQuantity;
  private int[][] currentSelection;

  private boolean operatingMode = false;
  private boolean requestCoinReturn = false;

  private String storedAccessCode = null;
  private String accessCode = null;

  private float totalCredit;

  //  constructor for CentralControl
  CentralControlSystem() {

    //print("test of object creation");
    this.storedAccessCode = "super-secure-pass";
    this.itemPrice = new int[4][4];
    this.itemQuantity = new int[4][4];
    this.currentSelection = new int[3][3];


    itemPrice[1][1] = 60;
    itemPrice[1][2] = 75;
    itemPrice[1][3] = 90;

    itemPrice[2][1] = 50;
    itemPrice[2][2] = 45;
    itemPrice[2][3] = 55;    

    itemPrice[3][1] = 70;
    itemPrice[3][2] = 80;
    itemPrice[3][3] = 95;

    this.totalCredit = 0.0;
  }

  public String addCredit(int credit) {
    totalCredit += credit;
    return ("CREDIT " +  nf(totalCredit/100, 0, 2));
    //print("total credit: ", totalCredit);
  }

  public float getCredit() {
    return totalCredit/100;
    //print("total credit: ", totalCredit);
  }

  public String vendItem(String itemSelected, int ltrSel, int numSel) {
    //print("selection " + ltrSel + " " + numSel);
    int selItemPrice = itemPrice[ltrSel][numSel];
    if (totalCredit == 0.0) {
      return (itemSelected + " PRICE: " +  nf(selItemPrice/100, 0, 2) );
    } else if (totalCredit < selItemPrice) {
      return (itemSelected + " PRICE: " +  nf(selItemPrice/100, 0, 2) + "\nADD ") + (nf(((selItemPrice - totalCredit)/100), 0, 2));
    } else {
      totalCredit -= selItemPrice;
      return ("VENDING: " +  itemSelected + "\nCHANGE " + nf(totalCredit/100, 0, 2));
    }
  }
}

class CoinMechanism {
  private int[] coinsInTube;
  private float totalCoinValue;

  CoinMechanism() {
    this.coinsInTube = new int[4];
    this.coinsInTube[0] = 10; // initial nickel count is 10
    this.coinsInTube[1] = 10; // initial nickel count is 10
    this.coinsInTube[2] = 10; // initial nickel count is 10
    this.coinsInTube[3] = 10; // initial nickel count is 10

    totalCoinValue = 0.0;
  }

  public void insertCoin(int coinValue) {
    totalCoinValue += coinValue;
    //print("coin total = ", totalCoinValue);
  }
}

class BillAcceptor {
  private int billInUnit;
  private float totalBillValue;

  BillAcceptor() {
    this.billInUnit = 0;

    totalBillValue = 0.0;
  }

  public void insertBill(int billValue) {
    totalBillValue += billValue;
    //print("bill total = ", totalBillValue);
  }
}

boolean letterSelected = false;
boolean numberSelected = false;
boolean selectionMade = false;
boolean locked = false;
int numLetterSel = 0;
int numNumberSel = 0;

PImage nickel = null;
PImage dime = null;
PImage quarter = null;
PImage dollar = null;
PImage bill1 = null;
PImage bill5 = null;

PImage fritos = null;
PImage act2 = null;
PImage yogurt = null;
PImage famous = null;
PImage knotts = null;
PImage grandmas = null;
PImage twix = null;
PImage crunch = null;
PImage mints = null;

CentralControlSystem ccs = null;
CoinMechanism coinMech = null;
BillAcceptor billAcpt = null;

PFont fontSmall = null;
PFont fontBig = null;
//float bx;
//float by;

boolean overNickel = false;
boolean overDime = false;
boolean overQuarter = false;
boolean overDollar = false;
boolean over1Bill = false;
boolean over5Bill = false;

float totalMoneyValue;

int coinsIn = 0;
String currentMessage = "INSERT MONEY";
//TODO: remove vars for code that displays mouse pointer coordinates
String str;
PFont fontInfo = null;

void setup() {
  size(680, 720);  

  ccs = new CentralControlSystem();
  coinMech = new CoinMechanism();
  billAcpt = new BillAcceptor();

  fontSmall = createFont("Arial", 12);
  fontBig = createFont("Arial", 30);
  fontInfo = createFont("Arial", 10);

  //load needed images from files
  dime = loadImage("dime3.png");
  dime.resize(0, 40);
  nickel = loadImage("nickel3.png");
  quarter = loadImage("quarter2.png");
  dollar = loadImage("dollar1.png");
  bill1 = loadImage("1_bill.png");
  bill5 = loadImage("5_bill.png");

  fritos = loadImage("Fritos.png");
  act2 = loadImage("ActII.png");
  yogurt = loadImage("MixNYogurt.png");
  famous = loadImage("FamousAmos.png");
  knotts = loadImage("Knotts.png");
  grandmas = loadImage("grandmas.png");
  twix = loadImage("Twix.png");
  crunch = loadImage("Crunch.png");
  mints = loadImage("JrMints.png");

  drawVendingMachine();
  drawMessageDisplay();
}

void drawVendingMachine() {
  //make background black
  stroke(0);
  fill(0);
  rect(0, 0, 680, 720);

  //draw the vending machine box
  stroke(125);
  //fill(184,2,0);
  //fill(228,227,240); // gray
  //fill(69, 139, 198); //blueish
  fill(166, 184, 201); //chromeish

  rect(90, 20, 460, 650);

  //add two legs under the machine
  fill(125);
  rect(140, 670, 20, 18);
  rect(480, 670, 20, 18);

  //draw the door to get the item out
  //fill(168,2,0);
  fill(208, 207, 220);
  rect(150, 540, 240, 80);

  //draw the window to see the item choices
  //fill (182,194,247);  //was just 20
  fill(13, 12, 9);
  rect(120, 50, 300, 460);

  //draw the border where the door would open to put in more cans
  fill(200, 43, 20);
  rect(448, 20, 4, 650);

  //draw the shelves in the machine for the items
  //fill(150, 63, 45);
  fill (36, 40, 38);
  rect(120, 170, 300, 14);
  rect(120, 320, 300, 14);
  rect(120, 470, 300, 14);

  //draw the selection labels for each item
  textFont(fontSmall);
  fill(250, 180, 200);

  text("A1  60¢", 150, 182);
  text("A2  75¢", 245, 182);
  text("A3  90¢", 340, 182);

  text("B1  50¢", 150, 332);
  text("B2  45¢", 245, 332);
  text("B3  55¢", 340, 332);

  text("C1  70¢", 150, 482);
  text("C2  80¢", 245, 482);
  text("C3  95¢", 340, 482);

  image(fritos, 142, 110, 57, 57);
  image(act2, 242, 98, 48, 70);
  image(yogurt, 334, 103, 52, 65);


  image(famous, 146, 264, 54, 54);
  image(knotts, 242, 258, 55, 60);
  image(grandmas, 334, 264, 53, 54);

  image(twix, 160, 412, 26, 55);
  image(crunch, 254, 406, 28, 62);
  image(mints, 350, 412, 26, 55);

  //draw the coin slot
  fill(192, 192, 192);
  rect(494, 175, 12, 35);
  fill(102, 102, 102);
  rect(497, 179, 6, 27);

  textFont(fontSmall);
  //fill(250,180,200);
  fill(180, 120, 120);
  text("$1 OR $5 ONLY", 460, 232);

  //draw the bill acceptor
  fill(192, 192, 192);
  rect(460, 238, 82, 12);
  fill(102, 102, 102);
  rect(463, 242, 76, 5);


  //draw the buttons (A, B, C, D, 1, 2, 3, 4)
  fill(150, 63, 45);
  rect(482, 270, 18, 18);
  rect(504, 270, 18, 18);
  rect(482, 292, 18, 18);
  rect(504, 292, 18, 18);
  rect(482, 314, 18, 18);
  rect(504, 314, 18, 18);

  //add labels to the buttons
  fill(180, 143, 125);
  text("A", 487, 283);
  text("1", 509, 283);
  text("B", 487, 305);
  text("2", 509, 305);
  text("C", 487, 327);
  text("3", 509, 327);

  //draw the coin return handle for the machine
  stroke(122, 122, 122);
  fill(192, 192, 192);
  rect(481, 410, 30, 6);
  ellipse(512, 416, 12, 12);

  //draw the coin return drop for the machine
  fill(25, 10, 10);
  rect(478, 440, 44, 20);

  //display PUSH on the dispenser door
  textFont(fontBig);
  fill(180, 33, 10);
  text("P U S H", 215, 590);
}

boolean checkMousePosition(int x1, int y1, int x2, int y2) {
  return (mouseX > x1 && mouseY > y1 && mouseX < x2 && mouseY < y2);
}

void draw() {
  drawVendingMachine();
  drawMessageDisplay();

  //if(mousePressed==true && mouseX > 558 && mouseY > 50 && mouseX <675 && mouseY < 100)
  // {
  //dollar bill clicked
  //}

  over1Bill = checkMousePosition(558, 50, 675, 100);
  over5Bill = checkMousePosition(558, 109, 675, 160);

  overNickel = checkMousePosition(571, 168, 605, 203);
  overDime = checkMousePosition(628, 171, 659, 200);
  overQuarter = checkMousePosition(567, 229, 603, 267);
  overDollar = checkMousePosition(623, 230, 662, 270);

  drawDime(625, 170); 
  drawNickel(562, 160);
  drawQuarter(562, 224);
  drawDollar(614, 220);

  draw1Bill(558, 50);
  draw5Bill(558, 108);

  //display the current message in the display panel
  textFont(fontSmall);
  fill(187, 140, 195);
  text("Click on a bill or ", 572, 15);
  text("coin to insert it", 574, 30);
  text("into the machine", 572, 45);


  //TODO: remove code that displays mouse pointer coordinates
  textFont(fontInfo);
  fill(250, 250, 250);
  str = mouseX + ", " + mouseY;
  text(str, 460, 120);

  //display the current message in the display panel
  textFont(fontSmall);
  fill(187, 140, 195);
  text("Service Tech functions", 556, 400);

  //draw buttons service tech will use
  fill(218);
  stroke(141);
  rect(560, 420, 114, 25, 10);
  fill(0);
  text("CCS Access Button", 565, 437);
}

void drawNickel(float x, float y) {
  image(nickel, x, y, 55, 55);
}

void drawDime(float x, float y) {
  image(dime, x, y, 40, 40);
}

void drawQuarter(float x, float y) {
  image(quarter, x, y, 51, 52);
}

void drawDollar(float x, float y) {
  image(dollar, x, y, 61, 60);
}

void draw1Bill(float x, float y) {
  image(bill1, x, y);
}

void draw5Bill(float x, float y) {
  image(bill5, x, y);
}

void drawMessageDisplay() {
  //draw the display panel for the machine
  stroke(125);
  fill(25, 10, 10);
  rect(454, 140, 94, 32);

  //display the current message in the display panel
  textFont(fontSmall);
  fill(57, 255, 20);
  text(currentMessage, 456, 154);
}

void updateSelection (int btn2Display) {
  if (selectionMade == true)
    return;

  currentMessage = currentMessage + btn2Display;
  drawMessageDisplay();

  if (letterSelected && numberSelected)
  {
    selectionMade = true;
    currentMessage = ccs.vendItem(currentMessage, numLetterSel, numNumberSel);
    selectionMade = false;
    letterSelected = false;
    numberSelected = false;
  }
}

boolean buttonAOver() {
  return (mouseX >= 482 && mouseX <= 500 && mouseY >= 270 && mouseY <= 288);
}

boolean buttonBOver() {
  return (mouseX >= 482 && mouseX <= 500 && mouseY >= 292 && mouseY <= 310);
}

boolean buttonCOver() {
  return (mouseX >= 482 && mouseX <= 500 && mouseY >= 314 && mouseY <= 332);
}

boolean button1Over() {
  return (mouseX >= 504 && mouseX <= 522 && mouseY >= 270 && mouseY <= 288);
}

boolean button2Over() {
  return (mouseX >= 504 && mouseX <= 522 && mouseY >= 292 && mouseY <= 310);
}

boolean button3Over() {
  return (mouseX >= 504 && mouseX <= 522 && mouseY >= 314 && mouseY <= 332);
}

boolean coinOver() {
  return (mouseX >= 575 && mouseX <= 615 && mouseY >= 170 && mouseY <= 210);
}

void mousePressed() {
  if (!selectionMade) {
    if (buttonAOver()) {
      currentMessage = "A";
      numLetterSel = 1;
      letterSelected = true;
    } else if (buttonBOver()) {
      currentMessage = "B";
      numLetterSel = 2;
      letterSelected = true;
    } else if (buttonCOver()) {
      currentMessage = "C";
      numLetterSel = 3;
      letterSelected = true;
    } 

    if (button1Over() && letterSelected == true && numberSelected == false) {
      numNumberSel = 1;
      numberSelected = true;
      updateSelection(1);
    } else if (button2Over() && letterSelected == true && numberSelected == false) {
      numNumberSel = 2;
      numberSelected = true;
      updateSelection(2);
    } else if (button3Over() && letterSelected == true && numberSelected == false) {
      numNumberSel = 3;
      numberSelected = true;
      updateSelection(3);
    }
  }

  if (overDime || overNickel || overQuarter || overDollar || over1Bill || over5Bill ) {
    locked = true;
  } else {
    locked = false;
  }
}

void mouseReleased() {
  if (overNickel) {
    coinMech.insertCoin(5);
    currentMessage = ccs.addCredit(5);
  }
  if (overDime) {
    coinMech.insertCoin(10);
    currentMessage = ccs.addCredit(10);
  }
  if (overQuarter) {
    coinMech.insertCoin(25);
    currentMessage = ccs.addCredit(25);
  }
  if (overDollar) {
    coinMech.insertCoin(100);
    currentMessage = ccs.addCredit(100);
  }
  if (over1Bill) {
    billAcpt.insertBill(100);
    currentMessage = ccs.addCredit(100);
  }
  if (over5Bill) {
    billAcpt.insertBill(500);
    currentMessage = ccs.addCredit(500);
  }

  locked = false;
}
