Game.title="Shapes Demo";
Game.homepage="http://www.distractionware.com";
Game.background=Col.BLACK;

var currenteffect;    // Current effect we're drawing on the screen
var totaleffects;     // Total number of effects
var currenteffectname;

var counter;          // Count up one every frame: using in this program for animation.

var pulse;            // A variable that counts from 0 to 50 and back.
var pulsedir;      // Controls the direction of the pulse.

// new() is a special function that is called on startup.
function new() {
  currenteffect = 1;
  totaleffects = 4;
  currenteffectname = "1: TRIANGLES";
  
  pulse = 0;
  counter = 0;
  pulsedir = "up";
  
  Text.setfont(Font.PIXEL, 1);
  //Set up the triangle buffer
  Gfx.createimage("triangles", Gfx.screenwidth, Gfx.screenheight);
  drawtriangles(1);
}

function update() {
  if (Mouse.leftclick()) {
    currenteffect = currenteffect + 1;
    if (currenteffect > totaleffects) currenteffect = 1;
  }
  
  counter++;
  if (pulsedir == "up") {
    pulse++;
    if (pulse >= 50) pulsedir = "down";
  }else if (pulsedir == "down") {
    pulse--;
    if (pulse <= 0)	pulsedir = "up";
  }
  
  if (currenteffect == 1) {
    drawtriangles(currenteffect);
  }else if (currenteffect == 2) {
    drawcircles(currenteffect);
  }else if (currenteffect == 3) {
    drawhexagon(currenteffect);
  }else if (currenteffect == 4) {
    drawstripes(currenteffect);
  }
    
  Gfx.fillbox(0,Gfx.screenheight-10,Gfx.screenwidth,10,Col.BLACK);
  Text.display(Gfx.screenwidth-2, Gfx.screenheight - Text.height()-3, "LEFT CLICK MOUSE TO CYCLE EFFECTS", Col.WHITE, {align: Text.RIGHT});
}

function drawtriangles(effectnum) {
  //Draw to a specially made image buffer
  currenteffectname = "1: TRIANGLES";
  Gfx.drawtoimage("triangles");
  
  if (counter % 60 == 0) {
    //Clear the screen every second
    Gfx.fillbox(0, 0, Gfx.screenwidth, Gfx.screenheight, Col.NIGHTBLUE, 0.9);
  }
  
  //Draw a triangle with random vertices, random colour and alpha of 0.6.
  Gfx.filltri(Random.int(0, Gfx.screenwidth), Random.int(0, Gfx.screenheight), Random.int(0, Gfx.screenwidth), Random.int(0, Gfx.screenheight), Random.int(0, Gfx.screenwidth), Random.int(0, Gfx.screenheight), Gfx.hsl(Random.int(0, 360), 0.5, 0.5), 0.6);
  
  //Draw that buffer to the screen
  Gfx.drawtoscreen();
  Gfx.drawimage(0, 0, "triangles");
}

function drawcircles(effectnum) {
  currenteffectname = "2: CIRCLES";
  Gfx.linethickness=3;
  var radius = 0;
  
  radius = (counter % 120);
  Gfx.drawcircle(Gfx.screenwidthmid, Gfx.screenheightmid, radius, Col.RED);
  radius = ((counter+20) % 120);
  Gfx.drawcircle(Gfx.screenwidthmid, Gfx.screenheightmid, radius, Col.YELLOW);
  radius = ((counter+40) % 120);
  Gfx.drawcircle(Gfx.screenwidthmid, Gfx.screenheightmid, radius, Col.ORANGE);
  radius = ((counter+60) % 120);
  Gfx.drawcircle(Gfx.screenwidthmid, Gfx.screenheightmid, radius, Col.YELLOW);
  radius = ((counter+80) % 120);
  Gfx.drawcircle(Gfx.screenwidthmid, Gfx.screenheightmid, radius, Col.WHITE);
  radius = ((counter+100) % 120);
  Gfx.drawcircle(Gfx.screenwidthmid, Gfx.screenheightmid, radius, Col.ORANGE);
}

function drawhexagon(effectnum) {
  currenteffectname = "3: HEXAGON";
  Gfx.linethickness=1;
  
  var shade;
  for (i in 0 ... 13) {
    shade = 255-(27*i);
  	if(shade<0) shade=0;
    Gfx.drawhexagon(Gfx.screenwidthmid, Gfx.screenheightmid, 10 + (i*10) + (pulse / 2), counter / 50, Gfx.rgb(shade, shade, shade));
  }
}

function drawstripes(effectnum) {
  currenteffectname = "4: STRIPES";
  var colour1;
  var colour2;
  
  if (counter % 60 < 20) {
    colour1 = Col.GRAY;
    colour2 = Col.WHITE;
  }else if (counter % 60 < 40) {
    colour1 = Col.RED;
    colour2 = Col.YELLOW;
  }else {
    colour1 = Col.GREEN;
    colour2 = Col.LIGHTBLUE;
  }
  
  if (counter % 120 < 60) {
    //Horizontal stripes
    for (stripe in 0 ... 20) {
      Gfx.fillbox(0, ( -(counter % 20)) + (stripe * 10), Gfx.screenwidth, 5, colour1);
      Gfx.fillbox(0, ( -(counter % 20)) + (stripe * 10) + 5, Gfx.screenwidth, 5, colour2);
    }
  }else {
    //Vertical stripes
    for (stripe in 0 ... 24) {
      Gfx.fillbox(( -(counter % 20)) + (stripe * 10), 0, 5, Gfx.screenheight, colour1);
      Gfx.fillbox(( -(counter % 20)) + (stripe * 10) + 5, 0, 5, Gfx.screenheight, colour2);
    }
  }
}
