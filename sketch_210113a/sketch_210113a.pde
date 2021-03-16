import processing.sound.*; //<>//

//Team D - Vending Machine Prototype 
//Ethan Pitzer, Kayla Serrano, Casey Henderson and Vince Nowell
//CS-361 - Software Engineering I
//Winter 2021 Term, Professor Harrison

// **************************************************************
// Ethan Pitzer - Central Control System class
class CentralControlSystem {

  //  class variables
  private int[][] itemPrice;
  private boolean operatingMode = true;
  private boolean priceChangeMode = false;
  private boolean priceSetMode = false;
  private String storedAccessCode = null;
  private String accessCode = null;
  private float totalCredit;

  //  constructor for CentralControl
  CentralControlSystem() {
    this.storedAccessCode = "CAB213";
    this.accessCode = "";
    this.totalCredit = 0.0;
    this.itemPrice = new int[4][4];
    itemPrice[1][1] = 60;
    itemPrice[1][2] = 75;
    itemPrice[1][3] = 105;
    itemPrice[2][1] = 50;
    itemPrice[2][2] = 45;
    itemPrice[2][3] = 55;    
    itemPrice[3][1] = 70;
    itemPrice[3][2] = 80;
    itemPrice[3][3] = 95;
  }
  
  public String getItemPrice(int letter, int num) {
     int itmPrice = itemPrice[letter][num];
     if (itmPrice > 99)
      return("$" + nf(float(itmPrice)/100,0,2));
     else
       return(itmPrice + "¢");
    
  }

  public String addCredit(int credit) {
    totalCredit += credit;
    return ("CREDIT " +  nf(totalCredit/100,0,2));
  }

  public float getCredit() {
    return totalCredit/100;
  }

  public String vendItem(String itemSelected, int ltrSel, int numSel) {
    float selItemPrice = itemPrice[ltrSel][numSel];
    if(totalCredit == 0.0) {
      return (itemSelected + "\nPRICE: " +  nf(selItemPrice/100,0,2) );
    } else if(totalCredit < selItemPrice) {
      return (itemSelected + " PRICE: " +  nf(selItemPrice/100,0,2) + "\nADD ") + (nf(((selItemPrice - totalCredit)/100),0,2));
    } else {
      float change = totalCredit - selItemPrice;
      totalCredit = 0;
      venditem.play();
      if(change > 0)
        changereturned.play();
      return ("VENDING: " +  itemSelected + "\nCHANGE " + nf(change/100,0,2));
    }
  }

  public String setItemPrice(String itemSelected, int ltrSel, int numSel, int changeAmount) {
    priceSetMode = true;
    if (itemPrice[ltrSel][numSel] + changeAmount > 0) {
      itemPrice[ltrSel][numSel] += changeAmount;
    }
    float selItemPrice = itemPrice[ltrSel][numSel];
    return(itemSelected + " PRICE: " +  nf(selItemPrice/100,0,2) + "\nA-↑  B-↓  C-SET");
  }
  
  public String coinReturnPushed() {
    if (totalCredit >0){
      float change = totalCredit;
      totalCredit = 0;
      changereturned2.play();
      return("RETURNING\n" + nf(change/100,0,2));
    } else {
      return("INSERT MONEY");
    }
  }
  
  public String accessKeyPushed() {
    this.accessCode = "";
    if(operatingMode == true) {
      this.operatingMode = false;
      return("ENTER ACCESS\nCODE  ");
    } else {
      this.operatingMode = true;
      this.priceChangeMode = false;
      this.priceSetMode = false;
      return("INSERT MONEY");
    }
  }
  
  public String validateCode() {
    if(storedAccessCode.equals(accessCode)) {
      priceChangeMode = true;
      return("ENTER ITEM");
    } else {
      operatingMode = true;
      priceChangeMode = false;
      priceSetMode = false;
      return("INCORRECT \nCODE");
    }
  }
  
  public boolean isPriceChangeMode() {
    return priceChangeMode;
  }
  
  public boolean isPriceSetMode() {
    return priceSetMode;
  }
  
  public void setPriceSetMode(boolean flag) {
    priceSetMode = flag;
  }
}

// **************************************************************
// Kayla Serrano - Coin Mechanism class
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
  }
}

// **************************************************************
// Casey Henderson - Bill Acceptor class
class BillAcceptor {
  private int billInUnit;
  private float totalBillValue;

  BillAcceptor() {
    this.billInUnit = 0;
  
    totalBillValue = 0.0;
  }
 
  public void insertBill(int billValue) {
    totalBillValue += billValue;
  }
}

// **************************************************************
// main index.java code
CentralControlSystem ccs;
CoinMechanism coinMech;
BillAcceptor billAcpt;

boolean overNickel = false;
boolean overDime = false;
boolean overQuarter = false;
boolean overDollar = false;
boolean over1Bill = false;
boolean over5Bill = false;
boolean overCoinReturn = false;
boolean overAccessBtn = false;
boolean letterSelected = false;
boolean numberSelected = false;
boolean selectionMade = false;
boolean locked = false;

int numLetterSel = 0;
int numNumberSel = 0;

PImage nickel;
PImage dime;
PImage quarter;
PImage dollar;
PImage bill1;
PImage bill5;
PImage fritos;
PImage act2;
PImage yogurt;
PImage famous;
PImage knotts;
PImage grandmas;
PImage twix;
PImage crunch;
PImage mints;
PImage snacks;

SoundFile coindrop;
SoundFile venditem;
SoundFile changereturned;
SoundFile changereturned2;
SoundFile billaccepted;
SoundFile keypress;
SoundFile btnbeep;

PFont fontSmall;
PFont fontBig;
PFont fontInfo;

String currentMessage = "INSERT MONEY";

// **************************************************************
// Vince Nowell - User Interface design
void drawVendingMachine() {
  //make background black
  stroke(0);
  fill(0);
  rect(0, 0, 680, 720);
  
  //draw the vending machine box
  stroke(125);
  fill(166,184,201); //chromeish
  rect(90, 20, 460, 650);
  
  //add two legs under the machine
  fill(125);
  rect(140, 670, 20, 18);
  rect(480, 670, 20, 18);
  
  //draw the door to get the item out
  fill(208,207,220);
  rect(150, 540, 240, 80);
  
  //draw the window to see the item choices
  //fill (182,194,247);  //was just 20
  fill(13,12,9);
  rect(120, 50, 300, 460);
  
  //draw the border where the door would open to put in more cans
  fill(200, 43,20);
  rect(448, 20, 4, 650);
  
  //draw the shelves in the machine for the items
  //fill(150, 63, 45);
  fill (36, 40, 38);
  rect(120, 170, 300, 14);
  rect(120, 320, 300, 14);
  rect(120, 470, 300, 14);
  
  //draw the selection labels for each item
  textFont(fontSmall);
  fill(250,180,200);
  
  text("A1  " + ccs.getItemPrice(1,1),150,182);
  text("A2  " + ccs.getItemPrice(1,2),245,182);
  text("A3  " + ccs.getItemPrice(1,3),340,182);
  text("B1  " + ccs.getItemPrice(2,1),150,332);
  text("B2  " + ccs.getItemPrice(2,2),245,332);
  text("B3  " + ccs.getItemPrice(2,3),340,332);
  text("C1  " + ccs.getItemPrice(3,1),150,482);
  text("C2  " + ccs.getItemPrice(3,2),245,482);
  text("C3  " + ccs.getItemPrice(3,3),340,482);
  
  image(snacks,202,21,134,29);
  image(fritos,142,110,57,57);
  image(act2,242,98,48,70);
  image(yogurt,334,103,52,65);
  image(famous,146,264,54,54);
  image(knotts,242,258,55,60);
  image(grandmas,334,264,53,54);
  image(twix,160,412,26,55);
  image(crunch,254,406,28,62);
  image(mints,350,412,26,55);

  //draw the coin slot
  fill(192, 192, 192);
  rect(494, 178, 12, 35);
  fill(102, 102, 102);
  rect(497, 182, 6, 27);
  
  textFont(fontSmall);
  fill(180,120,120);
  text("$1 OR $5 ONLY",460,232);
  
  //draw the bill acceptor
  fill(192, 192, 192);
  rect(460, 238, 82, 12);
  fill(102, 102, 102);
  rect(463, 242, 76, 5);
  
  //draw the buttons (A, B, C, 1, 2, 3)
  fill(150, 63, 45);
  rect(482, 270, 18, 18);
  rect(504, 270, 18, 18);
  rect(482, 292, 18, 18);
  rect(504, 292, 18, 18);
  rect(482, 314, 18, 18);
  rect(504, 314, 18, 18);
  
  //add labels to the buttons
  fill(180,143,125);
  text("A",487,283);
  text("1",509,283);
  text("B",487,305);
  text("2",509,305);
  text("C",487,327);
  text("3",509,327);
  
  //draw the coin return handle for the machine
  stroke(122,122,122);
  fill(192,192,192);
  rect(481,410,30,6);
  ellipse(512,416,12,12);
  
  //draw the coin return drop for the machine
  fill(25, 10, 10);
  rect(478, 440, 44, 20);
  
  //display PUSH on the dispenser door
  textFont(fontBig);
  fill(180, 33,10);
  text("P U S H",215,590);
}

void drawMessageDisplay() {
  //draw the display panel for the machine
  stroke(125);
  fill(25, 10, 10);
  rect(454, 140, 94, 32);
  
  //display the current message in the display panel
  textFont(fontSmall);
  fill(57,255,20);
  text(currentMessage,456,151);
}

void setup() {
  size(680, 720);  

  ccs = new CentralControlSystem();
  coinMech = new CoinMechanism();
  billAcpt = new BillAcceptor();

  fontSmall = createFont("Arial", 12);
  fontBig = createFont("Arial", 30);
  fontInfo = createFont("Arial", 10);
  
  dime = loadImage("dime3.png");
  dime.resize(0,40);
  nickel = loadImage("nickel3.png");
  quarter = loadImage("quarter2.png");
  dollar = loadImage("dollar1.png");
  bill1 = loadImage("1_bill.png");
  bill5 = loadImage("5_bill.png");
  snacks = loadImage("Snacks.png");
  fritos = loadImage("Fritos.png");
  act2 = loadImage("ActII.png");
  yogurt = loadImage("MixNYogurt.png");
  famous = loadImage("FamousAmos.png");
  knotts = loadImage("Knotts.png");
  grandmas = loadImage("grandmas.png");
  twix = loadImage("Twix.png");
  crunch = loadImage("Crunch.png");
  mints = loadImage("JrMints.png");

  billaccepted = new SoundFile(this, "billaccepted.mp3");
  coindrop = new SoundFile(this, "coindrop.mp3");
  venditem = new SoundFile(this, "venditem.mp3");
  changereturned = new SoundFile(this, "changereturned.mp3");
  changereturned2 = new SoundFile(this, "changereturned2.mp3");
  keypress = new SoundFile(this, "keypress2.mp3");
  btnbeep = new SoundFile(this, "beep.mp3");
  
  drawVendingMachine();
  drawMessageDisplay();
}

void draw() {
  drawVendingMachine();
  drawMessageDisplay();

  over1Bill = checkMousePosition(558, 50, 675, 100);
  over5Bill = checkMousePosition(558, 109, 675, 160);
  overNickel = checkMousePosition(571, 168, 605, 203);
  overDime = checkMousePosition(628, 171, 659, 200);
  overQuarter = checkMousePosition(567, 229, 603, 267);
  overDollar = checkMousePosition(623, 230, 662, 270);
  overCoinReturn = checkMousePosition(480, 406, 518, 424);
  overAccessBtn  = checkMousePosition(562, 421, 671, 441);
     
  //display the instructions to the right of the vending machine
  textFont(fontSmall);
  fill(187,140,195);
  text("Click on a bill or ",572,15);
  text("coin to insert it",574,30);
  text("into the machine",572,45);
  
  //draw the coins and currency images the user can click to insert money
  image(nickel, 562, 160, 55, 55);
  image(dime, 625, 170, 40, 40);
  image(quarter, 562, 224, 51, 52);
  image(dollar, 614, 220, 61, 60);
  image(bill1, 558, 50);
  image(bill5, 558, 108);
  
  textFont(fontSmall);
  fill(187,140,195);
  text("Service Tech functions",556,400);

  fill(218);
  stroke(141);
  rect(560, 420, 114, 25, 10);
  fill(0);
  text("CCS Access Button", 565, 437);
}

// **************************************************************
// Team D - miscellaneus functions

boolean checkMousePosition(int x1, int y1, int x2, int y2) {
  return (mouseX > x1 && mouseY > y1 && mouseX < x2 && mouseY < y2);
}

boolean buttonAOver() {
  return checkMousePosition(481,269,501,289);
}

boolean buttonBOver() {
  return checkMousePosition(481,291,501,311);
}

boolean buttonCOver() {
  return checkMousePosition(481,313,501,333);
}

boolean button1Over() {
  return checkMousePosition(503,269,523,289);
}

boolean button2Over() {
  return checkMousePosition(503,291,523,311);
}

boolean button3Over() {
  return checkMousePosition(503,313,523,333);
}

void handleKey(String keyIn) {
  keypress.play();
  ccs.accessCode += keyIn;
  currentMessage += "*";
}

void updateSelection (int btn2Display) {
  if (selectionMade == true)
    return;
    
  currentMessage = currentMessage + btn2Display;
  drawMessageDisplay();
  
  if (letterSelected && numberSelected)
  {
    selectionMade = true;
    if(ccs.priceChangeMode) {
     currentMessage = ccs.setItemPrice(currentMessage, numLetterSel, numNumberSel, 0);
    } else {
     currentMessage = ccs.vendItem(currentMessage, numLetterSel, numNumberSel);
    }
    selectionMade = false;
    letterSelected = false;
    numberSelected = false;
  }
}

void inputSelection(boolean priceChgMode) {
    if(!selectionMade) {
      if (buttonAOver()) {
        keypress.play();
        currentMessage = "A";
        numLetterSel = 1;
        letterSelected = true;
      } else if(buttonBOver()) {
        keypress.play();
        currentMessage = "B";
        numLetterSel = 2;
        letterSelected = true;
      } else if(buttonCOver()) {
        keypress.play();
        currentMessage = "C";
        numLetterSel = 3;
        letterSelected = true;
      } 
    
      if (button1Over() && letterSelected == true && numberSelected == false) {
        keypress.play();
        numNumberSel = 1;
        numberSelected = true;
        updateSelection(1);
      } else if(button2Over() && letterSelected == true && numberSelected == false) {
        keypress.play();
        numNumberSel = 2;
        numberSelected = true;
        updateSelection(2);
      } else if(button3Over() && letterSelected == true && numberSelected == false) {
        keypress.play();
        numNumberSel = 3;
        numberSelected = true;
        updateSelection(3);
      } 
    }
}

void mousePressed() {
  if(ccs.isPriceSetMode() == true && (buttonAOver() || buttonBOver() || buttonCOver())) {
    if (buttonAOver()) {
      keypress.play();
      currentMessage = ccs.setItemPrice(currentMessage.substring(0,2), numLetterSel, numNumberSel, 5);
    } else if(buttonBOver()) {
      keypress.play();
      currentMessage = ccs.setItemPrice(currentMessage.substring(0,2), numLetterSel, numNumberSel, -5);
    } else {
      keypress.play();
      ccs.setPriceSetMode(false);     
      currentMessage = "ENTER ITEM";
    }
    return;
  }
  
  if(ccs.operatingMode == false && ccs.isPriceChangeMode()==false && ccs.isPriceSetMode()==false) 
  {
    if       (buttonAOver()) { handleKey("A");
    } else if(buttonBOver()) { handleKey("B");
    } else if(buttonCOver()) { handleKey("C");
    } else if(button1Over()) { handleKey("1");
    } else if(button2Over()) { handleKey("2");
    } else if(button3Over()) { handleKey("3");
    }
    if(ccs.accessCode.length() == 6) {
      currentMessage = ccs.validateCode(); 
    }
  } else {  
    inputSelection(ccs.isPriceChangeMode());
    if(overDime || overNickel || overQuarter || overDollar || over1Bill || over5Bill || overCoinReturn || overAccessBtn ) {
      locked = true;
    } else {
      locked = false;
    }
  }
}

void mouseReleased() {
  if(overNickel) {
    coinMech.insertCoin(5);
    coindrop.play();
    currentMessage = ccs.addCredit(5);
  }
  if(overDime) {
    coinMech.insertCoin(10);
    coindrop.play();
    currentMessage = ccs.addCredit(10);
  }
  if(overQuarter) {
    coinMech.insertCoin(25);
    coindrop.play();
    currentMessage = ccs.addCredit(25);
  }
  if(overDollar) {
    coinMech.insertCoin(100);
    coindrop.play();
    currentMessage = ccs.addCredit(100);
  }
  if(over1Bill) {
    billAcpt.insertBill(100);
    billaccepted.play();
    currentMessage = ccs.addCredit(100);
  }
  if(over5Bill) {
    billAcpt.insertBill(500);
    billaccepted.play();
    currentMessage = ccs.addCredit(500);
   }
   if(overCoinReturn) {
     currentMessage = ccs.coinReturnPushed();
   }
   if(overAccessBtn) {
     btnbeep.play();
     currentMessage = ccs.accessKeyPushed();
   }
   locked = false;
}
