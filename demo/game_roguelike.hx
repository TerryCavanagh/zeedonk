Game.title = "Fancy Roguelike Example";

var sfx = [];
sfx.hitwall = 68417307;
sfx.opendoor = 32259507;
sfx.hitghost = 81923904;
sfx.killenemy = 88552902;
sfx.collect = 72329307;
sfx.collectscroll = 84140903;
sfx.playerhit = 14229104;
sfx.menunudge = 87758904;
sfx.select = 25955707;
sfx.closemenu = 13221904;
sfx.rest = 72272107;

sfx.music = {};
sfx.music.dead = "qckYcOeyIåKeMUsVfb3agJEvéacdåaãaæa3eagm3j4acäaRa2i2c2j4a";

//Entity creation function. Most of the game logic is in here, if 
//you want to hack it!

var entity = [];
var numentity = 0;

var player = [];
var dogamefade;

var item = {};
item.cannedfood = {
  name: "Canned Food", 
  description: "Delicious tin + meats yum",
  type: "use"
};

var inventory = [];
var numitems;

var menu = {};
menu.list = [];
menu.x = 0;
menu.y = 0;
menu.w = 0;
menu.h = 0;
menu.selection = 0;

var currentmenu = "";

function changemenu(t){
  currentmenu = t;
  if(t == "init"){
    menu.selection = 0;
    menu.list = ["MAGIC", "ITEM"];
    menu.x = 1;
    menu.y = 2;
    menu.w = 8;
    menu.h = menu.list.length + 2;  
  }
}

function giveitem(t){
  if(inventory.length < numitems){
    inventory.push(t);
    numitems++;
  }else{
    inventory[numitems] = t;
    numitems++;
  }
}

function resetplayer(){
  player.x = 0;
  player.y = 0;
  player.tile = 93;
  player.health = 5;
  player.maxhealth = 5;
  player.sp = 5;
  player.maxsp = 5;
  player.hunger = 1000;
  player.hungerspeed = 2;
  player.restclock = 0;
  player.restrate = 4; //How many turns you need to rest before you get something.  
  player.starveclock = 0;
  player.starvepoint = 100;
}

animation = [];
animation.hp = 0;
animation.hplost = 0;
animation.mp = 0;
animation.hunger = 0;
animation.full = 0;
animation.menu = 0;

hungerstat = [
  "Starving", "Starving", "Hungry", "Hungry", 
  "OK", "OK", "OK", 
  "Full", "Full", "Full", "Full"
];


Gfx.createimage("screen", 240,150);

function grabscreen(){
  Gfx.grabimagefromscreen("screen", 0, 0);
}

function redrawscreen(){
  Gfx.drawimage(0, 0, "screen");
}


function create(_x, _y, t) {
  var i = getfreeentityindex();
  resetentity(i);

  entity[i].x = _x;
  entity[i].y = _y;
  entity[i].active = true;
  entity[i].type = t;
  if(t == "food"){
    entity[i].tile = 73;
    entity[i].col = 0x8f8f8f;
    
    entity[i].onplayerhit = function(j){
      Music.playsound(sfx.collect);
      giveitem(item.cannedfood);
      setmessage("FOUND CANNED FOOD", Col.WHITE);
      killentity(j);
    };
    
  }else if(t == "enemy"){
    entity[i].solid = true;
    entity[i].tile = 88;
    entity[i].col = Col.WHITE;
    entity[i].health = 3;
    entity[i].alertsound = 42911908;
    
    entity[i].onplayerhit = function(j){
      entity[j].health--;
      Music.playsound(sfx.hitghost);
    };
    
    entity[i].update = function(j){
      if(entity[j].health <= 0){
        Music.playsound(sfx.killenemy);
        killentity(j);
      }else{
      	entity[j].timer++;
      	seekplayer(j, player.x, player.y);
      }
    }
      
    entity[i].attack = function(j){
      hurtplayer();
    }
  }
}

function hurtplayer(?str){
  if(str == null){
  	player.health--;
  }else{
    player.health -= str;
  }
  if(player.health < 0) player.health = 0;
  animation.hplost = 5;
  
  if(player.health > 0){
    Music.playsound(sfx.playerhit);
  }else{
    Music.playmusic(sfx.music.dead);
    Music.musicloop = false;
    setmessage("GAME OVER", Col.RED);
    messagetime = -1;
    dogamefade = true;
  }
}

// ASSETS START HERE
Gfx.loadimagestring("icon0", "Dæ3ap3üæaüOcöVRcâTa"); // Corner, Top left
Gfx.loadimagestring("icon1", "Dæ3ap3üæbüaxáédwàTa"); // Corner, Top right
Gfx.loadimagestring("icon2", "Dæ3ap3üåàTRcöVOdö2a"); // Corner, Bottom left
Gfx.loadimagestring("icon3", "Dæ3ap3üåáTdxáéaxè2a"); // Corner, Bottom right
Gfx.loadimagestring("icon4", "Dæ3ap3üæbüGh2üJgâTa"); // Up
Gfx.loadimagestring("icon5", "Dæ3ap3üåáTJh2üGhö2a"); // Down
Gfx.loadimagestring("icon6", "Dæ3ap3üåàTRcöVRcâTa"); // Left
Gfx.loadimagestring("icon7", "Dæ3ap3üåáTdxáédwàTa"); // Right
Gfx.loadimagestring("icon8", "Dæ3ap3üæbüGh2üGhö2a"); // Horizontal
Gfx.loadimagestring("icon9", "Dæ3ap3üåàTlsàTlsàTa"); // Vertical
Gfx.loadimagestring("icon10", "Dæ3ap3üåáTJh2üJgâTa"); // Cross
Gfx.loadimagestring("icon11", "Dæ3ap3üöäZOuZmOxpTG"); // Mine
Gfx.loadimagestring("icon12", "Dæ3ap5üaWmdaWmdüG"); // Square
Gfx.loadimagestring("icon13", "Dæ3ap3üæaEmYàTmXæ2a"); // Radio button, selected
Gfx.loadimagestring("icon14", "Dæ3ap3üæaEmYeHmXæ2a"); // Radio button, unselected
Gfx.loadimagestring("icon15", "Dæ3ap3üæChbaqèpdWæa"); // Music Note
Gfx.loadimagestring("icon16", "Dæ3ap3üæWEpäöEhHæ2a"); // Up arrow
Gfx.loadimagestring("icon17", "Dæ3ap3üæaEhHãüVXæma"); // Down arrow
Gfx.loadimagestring("icon18", "Dæ3ap3üæGypäéüpXGia"); // Left arrow
Gfx.loadimagestring("icon19", "Dæ3ap3üæqgpZöüVWyea"); // Right arrow
Gfx.loadimagestring("icon20", "Dæ3ap3üøn5üVXæma"); // Heart
Gfx.loadimagestring("icon21", "Dæ3ap3üæWEpä2üVXæma"); // Diamond
Gfx.loadimagestring("icon22", "Dæ3ap3üæWEpä2üV2WEa"); // Spade
Gfx.loadimagestring("icon23", "Dæ3ap3üæWEhMä2üöâma"); // Club
Gfx.loadimagestring("icon24", "Dæ3ap3üèq3abe5a"); // Dither, 1
Gfx.loadimagestring("icon25", "Dæ3ap3üèqaeqbeabe2a"); // Dither, 2
Gfx.loadimagestring("icon26", "Dæ3ap3üéuaeqbvabe2a"); // Dither, 3
Gfx.loadimagestring("icon27", "Dæ3ap3üéuavqbvafu2a"); // Dither, 4
Gfx.loadimagestring("icon28", "Dæ3ap3üéuIvqbviLu2a"); // Dither, 5
Gfx.loadimagestring("icon29", "Dæ3ap3üéuIvqJviLuiG"); // Dither, 6
Gfx.loadimagestring("icon30", "Dæ3ap3üéuQáqJvkTuiG"); // Dither, 7
Gfx.loadimagestring("icon31", "Dæ3ap3üéuQásRvkTuQG"); // Dither, 8
Gfx.loadimagestring("icon32", "Dæ3ap4üCQásRäkTuQG"); // Dither, 9
Gfx.loadimagestring("icon33", "Dæ3ap4üCQäARäkTâQG"); // Dither, 10
Gfx.loadimagestring("icon34", "Dæ3ap4üöQäARüQTâQG"); // Dither, 11
Gfx.loadimagestring("icon35", "Dæ3ap4üöQüåRüQVöQG"); // Dither, 12
Gfx.loadimagestring("icon36", "Dæ3ap5üUüåRüøVöQG"); // Dither, 13
Gfx.loadimagestring("icon37", "Dæ3ap5üUüøVüøVöøG"); // Dither, 14
Gfx.loadimagestring("icon38", "Dæ3ap7üøV3üöøG"); // Dither, 15
Gfx.loadimagestring("icon39", "DW3ap4üaäXFaäXA21Q"); // Full
Gfx.loadimagestring("icon40", "Dæ3ap3üøéüøFüHèüöüa"); // Face, filled
Gfx.loadimagestring("icon41", "Dæ3ap3üøéaàSdEZmcüa"); // Face, outlined
Gfx.loadimagestring("icon42", "Dæ3ap3üøèüadèüadèüa"); // Three, Horizontal
Gfx.loadimagestring("icon43", "Dæ3ap3üæbTøEäTøEâ2a"); // Three, Vertical
Gfx.loadimagestring("icon44", "Dæ3ap3üæaüpW2apZè2a"); // Two, Horizontal
Gfx.loadimagestring("icon45", "Dæ3ap3üæaZmZmZmZm2a"); // Two, Vertical
Gfx.loadimagestring("icon46", "Dæ3ap3üæ3adèü5a"); // One, Horizontal
Gfx.loadimagestring("icon47", "Dæ3ap3üæamdaWmdaW2a"); // One, Vertical
Gfx.loadimagestring("icon48", "Dæ3ap3üægdHWãCEdbya"); // Sword
Gfx.loadimagestring("icon49", "Dæ3ap5üaäSZmæBmEa"); // Shield
Gfx.loadimagestring("icon50", "Dæ3ap3üæCnGyogdbGWa"); // Staff
Gfx.loadimagestring("icon51", "Dæ3ap3ü2æsiNöIiHioa"); // Bow
Gfx.loadimagestring("icon52", "Dæ3ap3üæahbWC2hZè2a"); // Boots
Gfx.loadimagestring("icon53", "Dæ3ap3üænNFJithøMWa"); // Throwing star
Gfx.loadimagestring("icon54", "Dæ3ap3üæaHltèüitè2a"); // Helmet
Gfx.loadimagestring("icon55", "Dæ3ap3üæbZ2üöZhJè2a"); // Armor
Gfx.loadimagestring("icon56", "Dæ3ap3üæaüpZmZmZm2a"); // Trousers
Gfx.loadimagestring("icon57", "Dæ3ap3üãæXjk3QkCGa"); // Whip
Gfx.loadimagestring("icon58", "Dæ3ap3üèdH3üTZiWma"); // Axe
Gfx.loadimagestring("icon59", "Dæ3ap3üæaüpZèmdaW2a"); // Hammer
Gfx.loadimagestring("icon60", "Dæ3ap3üæ2ahsiIiHà2a"); // Alpha
Gfx.loadimagestring("icon61", "Dæ3ap3üãWIiJWIisæ2a"); // Beta
Gfx.loadimagestring("icon62", "Dæ3ap3üæ2aVáiseHi2a"); // Pi
Gfx.loadimagestring("icon63", "Dæ3ap3üøèXgaWymtè2a"); // Sigma
Gfx.loadimagestring("icon64", "Dæ3ap3üæ2ahYiIiHW2a"); // Sigma, lower
Gfx.loadimagestring("icon65", "Dæ3ap3üæaEiseHeJm2a"); // Omega
Gfx.loadimagestring("icon66", "Dæ3ap3üãæZitèüitmEa"); // Theta
Gfx.loadimagestring("icon67", "Dæ3ap3üåeTlsàühGWma"); // Psi
Gfx.loadimagestring("icon68", "Dæ3ap3üæWElsàTlræma"); // Phi
Gfx.loadimagestring("icon69", "Dæ3ap3üãèWgaætitmEa"); // Delta
Gfx.loadimagestring("icon70", "Dæ3ap3üæaWwaWogZg2a"); // Lambda
Gfx.loadimagestring("icon71", "Dæ3ap3üæaZmZmZoZyWa"); // Mu
Gfx.loadimagestring("icon72", "Dæ3ap3üæWEfHisgHæma"); // Crystal 1
Gfx.loadimagestring("icon73", "Dæ3ap3üæGCnMCãMWæea"); // Crystal 2
Gfx.loadimagestring("icon74", "Dæ3ap3üæWHdflsJcema"); // Crystal 3
Gfx.loadimagestring("icon75", "Dæ3ap3üæas2dmZdbi2a"); // Crystal 4
Gfx.loadimagestring("icon76", "Dæ3ap3üæaEnZàVoXæ2a"); // Crystal 5
Gfx.loadimagestring("icon77", "Dæ3ap3üæy2EâmXTãæya"); // Crystal 6
Gfx.loadimagestring("icon78", "Dæ3ap3üãæZmXæehaqCa"); // Key 1
Gfx.loadimagestring("icon79", "Dæ3ap3üåeüpXæehaqCa"); // Key 2
Gfx.loadimagestring("icon80", "Dæ3ap3üãæZiseHjseHa"); // Door 1
Gfx.loadimagestring("icon81", "Dæ3ap3üãæüpZèüptèüa"); // Door 2
Gfx.loadimagestring("icon82", "Dæ3ap3üæaEpWaümZè2a"); // Chest
Gfx.loadimagestring("icon83", "Dæ3ap3üæaEhHæmdaW2a"); // Lock
Gfx.loadimagestring("icon84", "Dæ3ap3üæacaWqimb3a"); // Bone
Gfx.loadimagestring("icon85", "Dæ3ap3üæaEpYSRpHW2a"); // Skull
Gfx.loadimagestring("icon86", "Dæ3ap3üöhZüéømüöäHG"); // Monster
Gfx.loadimagestring("icon87", "Dæ3ap3üæaEpYàümákTa"); // Monster 2
Gfx.loadimagestring("icon88", "Dæ3ap3üãæültèüpZèTa"); // Ghost
Gfx.loadimagestring("icon89", "Dæ3ap3üæaEdaWEpZèEa"); // Potion
Gfx.loadimagestring("icon90", "Dæ3ap3üãæHlsQLlseEa"); // S Token
Gfx.loadimagestring("icon91", "Dæ3ap3üãæüF4üøèEa"); // Circle
Gfx.loadimagestring("icon92", "Dæ3ap3üæWmhHæüpä2üG"); // Triangle
Gfx.loadimagestring("icon93", "Dæ3ap5üaäTlsâSlöG"); // Spiral
Gfx.loadimagestring("icon94", "Dæ3ap3üæbüjtèPpYeüG"); // Scroll
Gfx.loadimagestring("icon95", "Dæ3ap3üæaEiuZmOræ2a"); // Eye
Gfx.loadimagestring("icon96", "Dæ3ap3üéDx3vävfrua"); // HP
Gfx.loadimagestring("icon97", "Dæ3ap4üDäruväfhràa"); // SP
Gfx.loadimagestring("icon98", "Dæ3ap3üæcbGèDUFdGqa"); // Tick
Gfx.loadimagestring("icon99", "Dæ3ap3üøgøNWæFoøg2a"); // X
Gfx.loadimagestring("icon100", "Dæ3ap5üaäTøEäSdüG"); // Block 1
Gfx.loadimagestring("icon101", "Dæ3ap5üHZnlsZohüG"); // Block 2
Gfx.loadimagestring("icon102", "Dæ3ap3üéuaäHlshSaQG"); // Block 3
Gfx.loadimagestring("icon103", "Dæ3ap3üæbFäéöaEüVøG"); // Block 4
Gfx.loadimagestring("icon104", "Dæ3ap3üæbgäéöemFVøG"); // Block 5
Gfx.loadimagestring("icon105", "Dæ3ap3üæaG2ae2ab3a"); // Ground 1
Gfx.loadimagestring("icon106", "Dæ3ap3üæaæ3adGh3a"); // Ground 2
Gfx.loadimagestring("icon107", "Dæ3ap3üæWüiwhHOtèma"); // Target
Gfx.loadimagestring("icon108", "Dæ3ap3üæacdy2aegW2a"); // Water
Gfx.loadimagestring("icon109", "Dæ3ap3üøéüøFüZæFöüa"); // Sad face, filled
Gfx.loadimagestring("icon110", "Dæ3ap3üøéaàSdmäScüa"); // Sad face, outlined
Gfx.loadimagestring("icon111", "Dæ3ap4üöaFæbüGhö2a"); // Grate

var icon = [];
for(i in 0 ... 112) icon.push("icon"+i);
// ASSETS END HERE

var currentmap;
var lightmap;

var mapwidth;
var mapheight;
var bottombar;

var floortile;
var walltile;
var scrolltile;
var potiontile;
var doortile;
var bloodtile;

var steppedon;
var oldtile;

var redrawmap;
var newtile;

var iconcolor = [];

var uselighting = 1;

var message;
var messagecol = Col.GRAY;
var messageflickercol = Col.WHITE;
var messagetime = 0;

var state;

function setmessage(m, col, ?doflicker){
  message = m;
  messagecol = col;
  if(doflicker != null){
    messageflickercol = col; 
  }else{
    messageflickercol = Gfx.rgb(Convert.toint(Gfx.getred(col)*0.75), 
                                Convert.toint(Gfx.getgreen(col)*0.75), 
                                Convert.toint(Gfx.getblue(col)*0.75));
  }
  messagetime=60;
}

var shaketiles = [];
var numshaketiles = 0;

var rooms = [];
var numrooms = 0;

var tx;
var ty;
var tw;
var th;

var turn;

function resetgame(){
  message = "";
  messagecol = Col.GRAY;
  messageflickercol = Col.WHITE;
  messagetime = 0;
  turn = "player";
  numitems = 0;
  state = "game";
  
  dogamefade = false;
  resetplayer(); 
}

function new(){
  Gfx.showfps=true;
  Text.setfont(Font.THIN);
  Gfx.clearscreeneachframe=false;
  currentmap = [];
  lightmap = [];
  
  //setmessage("FANCY ROGUELIKE EXAMPLE", Col.WHITE, true);
  resetgame();
  
  player.x = 20;
  player.y = 9;
  
  mapwidth = 30;
  mapheight = 16;
  bottombar = (mapheight + 1) * 8;
  
  //These numbers corespond to the icons we want to use from the asset pack
  floortile = 105;
  walltile = 103;
  scrolltile = 94;
  potiontile = 89;
  doortile = 81;
  opendoortile = 80;
  bloodtile = 25;
  
  steppedon = floortile;
  
  for(i in 0 ... 100){
    shaketiles.push({x:0, y:0, xoff:0, yoff:0, shake:0});
    rooms.push({x:0, y:0, w:0, h:0, type:0});
  }
  numshaketiles = 0;
  numrooms = 0;
    
  for(i in 0 ... mapwidth) {
    currentmap.push([]);
    lightmap.push([]);
    for(j in 0 ... mapheight){
      currentmap[i].push(-1);
      if(uselighting == 0){
        lightmap[i].push(3);
      }else{
      	lightmap[i].push(0);
      }
    }
  }
  redrawmap = true;
  
  for(i in 0 ... 140) iconcolor.push(Col.RED);
  iconcolor[player.tile] = Col.WHITE;
  iconcolor[floortile] = Col.NIGHTBLUE;
  iconcolor[walltile] = 0x7070e5;
  iconcolor[scrolltile] = Col.WHITE;
  iconcolor[potiontile] = Col.MAGENTA;
  iconcolor[doortile] = Col.BROWN;
  iconcolor[opendoortile] = Col.DARKBROWN;
  iconcolor[bloodtile] = 0x541919;
  
  generate(0);
  
  placeentity("food");
  placeentity("food");
  placeentity("food");
  
  placeentity("enemy");
  placeentity("enemy");
  placeentity("enemy");
  
  player.x = Random.int(1,mapwidth-2);
  player.y = Random.int(1,mapheight-2);
  while(currentmap[player.x][player.y] != floortile){
    player.x = Random.int(1,mapwidth-2);
    player.y = Random.int(1,mapheight-2);
  }
  currentmap[player.x][player.y]=player.tile;
  
}

function placeentity(t){
  tx = Random.int(1,mapwidth-2);
  ty = Random.int(1,mapheight-2);
  while(currentmap[tx][ty] != floortile){
    tx = Random.int(1,mapwidth-2);
    ty = Random.int(1,mapheight-2);
  }
  currentmap[tx][ty]=999;
  create(tx, ty, t);
}

function addroom(x, y, w, h, type){
  rooms[numrooms].x = x;
  rooms[numrooms].y = y;
  rooms[numrooms].w = w;
  rooms[numrooms].h = h;
  rooms[numrooms].type = type;
  
  numrooms++;
}

function inbox(xp, yp, x, y, w, h){
  if(xp >= x){
    if(yp >= y){
      if(xp < x + w){
        if(yp < y + h){
          return true;
        }
      }
    }
  }
  return false;
}

function checkroomcollision(){
  for(i in 0 ... numrooms){
    if(inbox(tx, ty, rooms[i].x-1, rooms[i].y-1, rooms[i].w+2, rooms[i].h+2)) return true;
    if(inbox(tx + tw, ty, rooms[i].x-1, rooms[i].y-1, rooms[i].w+2, rooms[i].h+2)) return true;
    if(inbox(tx, ty + th, rooms[i].x-1, rooms[i].y-1, rooms[i].w+2, rooms[i].h+2)) return true;
    if(inbox(tx + tw, ty + th, rooms[i].x-1, rooms[i].y-1, rooms[i].w+2, rooms[i].h+2)) return true;
  }
  return false;
}

function generate(type){
  var roomsleft = 0;
  var roomscreated = 0;
  
	if(type == 0){
  	//Basic room type
    //Generate between 5 - 10 non intersecting rooms
    while (roomsleft == 0 && roomscreated < 7){
      roomsleft = 10;
      roomscreated = 0;
      numrooms = 0;

      while(roomsleft > 0){
        //Random room coordinates
        tw = Random.int(2,6);
        th = Random.int(2,5);
        tx = Random.int(1, mapwidth-2-tw);
        ty = Random.int(1, mapheight-2-th);

        //Ok, Check if this collides with any existing rooms
        if(checkroomcollision()){
          roomsleft--;
        }else{
          roomscreated++;
          roomsleft--;
          addroom(tx, ty, tw, th, 0);
        }
      }
    }
    
    //Now find the bounds of the map, so we can center it a bit
    tx = mapwidth; ty = mapheight;
    tw = 0; th = 0; 
    for(i in 0 ... numrooms){
      if(rooms[i].x < tx) tx = rooms[i].x;
      if(rooms[i].y < ty) ty = rooms[i].y;
      if(rooms[i].x + rooms[i].w > tw) tw = rooms[i].x + rooms[i].w;
      if(rooms[i].y + rooms[i].h > th) th = rooms[i].y + rooms[i].h;
    }
    
    tx = Convert.toint((tx + mapwidth - tw)/2) - tx;
    ty = Convert.toint((ty + mapheight - th)/2) - ty;
    //Ok, now we nudge the rooms around before finally drawing them:
    for(i in 0 ... numrooms){
      rooms[i].x += tx;
      rooms[i].y += ty;
      drawroom(rooms[i].x, rooms[i].y, rooms[i].w, rooms[i].h);
    }
    
    //Ok! Now we connect the rooms with passageways.
    for(i in 0 ... numrooms - 1){
      tx = Random.int(rooms[i].x + 1, rooms[i].x + rooms[i].w - 2);
      ty = Random.int(rooms[i].y + 1, rooms[i].y + rooms[i].h - 2);
      tw = Random.int(rooms[i + 1].x + 1, rooms[i + 1].x + rooms[i + 1].w - 2);
      th = Random.int(rooms[i + 1].y + 1, rooms[i + 1].y + rooms[i + 1].h - 2);
      
      if(tx > tw){
        drawhline(tw, th, tx - tw + 1); 
        if(ty > th){
          drawvline(tx, th, ty - th + 1);
        }else{
          drawvline(tx, ty, th - ty + 1);
        }
      }else{
        drawhline(tx, ty, tw - tx + 1);
        if(ty > th){
          drawvline(tw, th, ty - th + 1);
        }else{
          drawvline(tw, ty, th - ty + 1);
        }
      }
    }
    
    //Ok! Let's place some stuff in this room. 
    //Walls
    addwalllayer();
    //Doors:
    adddoorlayer();
    //Entrance:
    //Exit:
  }
}

function shake(x, y, xoff, yoff){
  if(numshaketiles < 100) {
    shaketiles[numshaketiles].x = x;
    shaketiles[numshaketiles].y = y;
    shaketiles[numshaketiles].xoff = xoff;
    shaketiles[numshaketiles].yoff = yoff;
    shaketiles[numshaketiles].shake = 5;
    shaketiles[numshaketiles].entity = 0;
    if(currentmap[x][y] == 999){
      for(i in 0 ... numentity){
        if(entity[i].active){
          if(x == entity[i].x){
            if(y == entity[i].y){
            	shaketiles[numshaketiles].entity = entity[i].tile;
            	shaketiles[numshaketiles].hurtcol = entity[i].hurtcol;
            	shaketiles[numshaketiles].entitycol = entity[i].col;
            }
          }
        }
      }
    }
    numshaketiles++;
  }
}

var shakecol;
function processshake(){
  for(i in 0 ... numshaketiles){
    if(shaketiles[i].shake>0){
      shaketiles[i].shake--;
      var x=shaketiles[i].x;
      var y=shaketiles[i].y;
      var xoff=shaketiles[i].shake * shaketiles[i].xoff;
      var yoff=shaketiles[i].shake * shaketiles[i].yoff;
      if(shaketiles[i].shake==0){
        xoff = 0; yoff = 0;
      }
      var t = currentmap[x][y];
      if(t == 999){
        t = shaketiles[i].entity;
        shakecol = shaketiles[i].hurtcol;
        if(shaketiles[i].shake==0){
          shakecol = shaketiles[i].entitycol;
        }
      }else if(t > -1){
        shakecol = iconcolor[t];
      }
      Gfx.fillbox((x * 8), ((y+1) * 8)+3, 8, 8, Col.BLACK);
      pset(x-1,y-1);
      pset(x,y-1);
      pset(x+1,y-1);
      pset(x-1,y);
      pset(x+1,y);
      pset(x-1,y+1);
      pset(x,y+1);
      pset(x+1,y+1);

      if(t > -1) {
        Gfx.imagecolor(shakecol);
        Gfx.drawimage((x * 8) + xoff, ((y+1) * 8)+3 + yoff, icon[t]);
      }
    }
  }
  
  if(numshaketiles > 0){
    if(shaketiles[numshaketiles-1].shake==0){
      numshaketiles--;
    }
  }
}

function moveentityor(t, x1, y1, x2, y2){
  if(collide(entity[t].x + x1, entity[t].y + y1)){
    if(!collide(entity[t].x + x2, entity[t].y + y2)){
    	moveentity(t, x2, y2);
    }
  }else{
    moveentity(t, x1, y1);
  }
}

var doseek;
function seekplayer(t, x, y){
  //Tries to move towards the player. Does some random stuff to make the
  //movement more interesting and less likely to stick behind walls.
  
  //Don't seek if we're literally standing on top of them
  doseek = entity[t].x != x || entity[t].y != y;
  //Don't seek unless you're within 4 steps of them or fully lit
  doseek = doseek && ((entity[t].x + entity[t].y < 4) || 
                     lightmap[entity[t].x][entity[t].y] >= 3);
                      
  if(doseek){
    if(entity[t].x == x){
      if(entity[t].y < y){
        moveentityor(t, 0, 1, Random.int(-1, 1), 0);
      }else{
        moveentityor(t, 0, -1, Random.int(-1, 1), 0);
      }
    }else if(entity[t].x < x){
      if(entity[t].y == y){
        moveentityor(t, 1, 0, 0, Random.int(-1, 1));
      }else{
        if(Random.bool()){
          if(entity[t].y < y){
            moveentityor(t, 1, 0, 0, 1);
          }else{
            moveentityor(t, 1, 0, 0, -1);
          }
        }else{
          if(entity[t].y < y){
            moveentityor(t, 0, 1, 1, 0);
          }else{
            moveentityor(t, 0, -1, 1, 0);
          }
        }
      }
    }else if(entity[t].x > x){
      if(entity[t].y == y){
        moveentityor(t, -1, 0, 0, Random.int(-1, 1));
      }else{
        if(Random.bool()){
          if(entity[t].y < y){
            moveentityor(t, -1, 0, 0, 1);
          }else{
            moveentityor(t, -1, 0, 0, -1);
          }
        }else{
          if(entity[t].y < y){
            moveentityor(t, 0, 1, -1, 0);
          }else{
            moveentityor(t, 0, -1, -1, 0);
          }
        }
      }
    }
  }else{
    //Take a random walk
     if(Random.bool()){
       moveentityor(t, Random.pickint(-1, 1), 0, 0, Random.pickint(-1, 1));
     }else{
       moveentityor(t, 0, Random.pickint(-1, 1), Random.pickint(-1, 1), 0);
     }
  }
}

function drawroom(x, y, w, h){
  for(j in y ... y + h){
    for(i in x ... x + w){
      currentmap[i][j] = floortile;
    }
  }
}

function drawhline(x1, y, w){
  for(i in x1 ... x1 + w){
    currentmap[i][y] = floortile;
  }
}


function drawvline(x1, y1, h){
  for(i in y1 ... y1 + h){
    currentmap[x1][i] = floortile;
  }
}

function adddoorlayer(){
  for(k in 0 ... numrooms){
    for(j in rooms[k].y - 1 ... rooms[k].y + rooms[k].h + 1) {
      //Left edge!
      if(pget(rooms[k].x - 1, j) == floortile){
        if(pget(rooms[k].x - 1, j - 1) != floortile && 
           pget(rooms[k].x - 1, j + 1) != floortile){
          currentmap[rooms[k].x - 1][j] = doortile;
        }
      } 
      //Right edge!
      if(pget(rooms[k].x + rooms[k].w, j) == floortile){
        if(pget(rooms[k].x + rooms[k].w, j - 1) != floortile && 
           pget(rooms[k].x + rooms[k].w, j + 1) != floortile){
          currentmap[rooms[k].x + rooms[k].w][j] = doortile;
        }
      } 
    }
    
    for(i in rooms[k].x - 1 ... rooms[k].x + rooms[k].w + 1){
    	//Top edge!
      if(pget(i, rooms[k].y - 1) == floortile){
        if(pget(i - 1, rooms[k].y - 1) != floortile && 
           pget(i + 1, rooms[k].y - 1) != floortile){
          currentmap[i][rooms[k].y - 1] = doortile;
        }
      }
      //Bottom edge!
      if(pget(i, rooms[k].y + rooms[k].h) == floortile){
        if(pget(i - 1, rooms[k].y + rooms[k].h) != floortile && 
           pget(i + 1, rooms[k].y + rooms[k].h) != floortile){
          currentmap[i][rooms[k].y + rooms[k].h] = doortile;
        }
      }
    }
  }
}

function addwalllayer(){
  for(j in 0 ... mapheight){
    for(i in 0 ... mapwidth){
      if(currentmap[i][j] == -1){
        if(pget(i-1,j) == floortile) currentmap[i][j] = walltile;
        if(pget(i+1,j) == floortile) currentmap[i][j] = walltile;
        if(pget(i,j-1) == floortile) currentmap[i][j] = walltile;
        if(pget(i,j+1) == floortile) currentmap[i][j] = walltile;
        if(pget(i-1,j-1) == floortile) currentmap[i][j] = walltile;
        if(pget(i+1,j-1) == floortile) currentmap[i][j] = walltile;
        if(pget(i-1,j+1) == floortile) currentmap[i][j] = walltile;
        if(pget(i+1,j+1) == floortile) currentmap[i][j] = walltile;
      }
    }
  }
  /*
  for(j in 0 ... mapheight){
    for(i in 0 ... mapwidth){
      if(currentmap[i][j] == floortile){      
        tx = 0;
        if(pget(i-1,j) == floortile) tx++;
        if(pget(i+1,j) == floortile) tx++;
        if(pget(i,j-1) == floortile) tx++; 
        if(pget(i,j+1) == floortile) tx++; 
        if(pget(i-1,j-1) == floortile) tx++;
        if(pget(i+1,j-1) == floortile) tx++;
        if(pget(i-1,j+1) == floortile) tx++;
        if(pget(i+1,j+1) == floortile) tx++;
        
        if(tx == 4){
          if(pget(i-1,j) != floortile && pget(i+1,j) != floortile){
            currentmap[i][j] = doortile;
          }else if(pget(i,j-1) != floortile && pget(i,j+1) != floortile){
            currentmap[i][j] = doortile;
          }
        } 
      }
    }
  }
*/
}

function getlight(x, y){
  if(uselighting > 0){
    if(x>=0 && y>=0){
      if(x < mapwidth && y < mapheight){
        return lightmap[x][y];
      }
    }
  }
  return 0;
}

function setlight(x, y, t){
  if(uselighting > 0){
    if(x>=0 && y>=0){
      if(x < mapwidth && y < mapheight){
        if(lightmap[x][y]<=t){
          lightmap[x][y]=t;
          if(t >= 3){
            if(currentmap[x][y] < 999){
            	drawtile(x, y, currentmap[x][y]);
            }
          }else if(t == 2){
            Gfx.fillbox(x * 8, 3 + (y+1) * 8, 8, 8, Col.BLACK);
            Gfx.imagecolor(Col.GRAY);
            Gfx.drawimage(x*8, 3 + (y+1)*8, icon[25]);
          }else if(t == 1){
            Gfx.fillbox(x * 8, 3 + (y+1) * 8, 8, 8, Col.BLACK);
            Gfx.imagecolor(Col.GRAY);
            Gfx.drawimage(x*8, 3 + (y+1)*8, icon[28]);
          }else if(t == 0){
            Gfx.fillbox(x * 8, 3 + (y+1) * 8, 8, 8, Col.BLACK);
            Gfx.imagecolor(Col.GRAY);
            Gfx.drawimage(x*8, 3 + (y+1)*8, icon[31]);
          }
        }
      }
    }
  }
}

function flashlight(x, y, xoff, yoff){
  x+=xoff;
  y+=yoff;
  while(pget(x, y) == floortile){
    setlight(x, y, 3);
    if(xoff == 0){
      setlight(x - 1, y, 3);
      setlight(x + 1, y, 3);
    }else{
      setlight(x, y - 1, 3);
      setlight(x, y + 1, 3);
    }
    
    x+=xoff;
    y+=yoff;
  }
  
  if(xoff == 0){
    setlight(x - 1, y, 3);
    setlight(x, y, 3);
    setlight(x + 1, y, 3);
  }else{
    setlight(x, y - 1, 3);
    setlight(x, y, 3);
    setlight(x, y + 1, 3);
  }
}

function light(x, y){
  if(uselighting == 1){
    for(j in -5 ... 6){
      for(i in -5 ... 6){
        setlight(x + i, y + j, 5-Convert.toint(Math.sqrt(i*i + j*j)));
      }
    }
    
    flashlight(x, y, -1, 0);
    flashlight(x, y, 1, 0);
    flashlight(x, y, 0, -1);
    flashlight(x, y, 0, 1);
  }
}

function drawtile(x, y, t, ?color){
  if(lightmap[x][y]>=3){
    Gfx.fillbox(x * 8, 3 + (y+1) * 8, 8, 8, Col.BLACK);
    if(t == 999){
      for(i in 0 ... numentity){
        if(entity[i].active){
          if(x == entity[i].x){
            if(y == entity[i].y){
              drawtile(entity[i].x, entity[i].y, entity[i].tile, entity[i].col);
              setlight(entity[i].x, entity[i].y, lightmap[entity[i].x][entity[i].y]);
            }
          }
        }
      }
    }else if(t > -1) {
      if(color == null) color = iconcolor[t];
      Gfx.imagecolor(color);
      Gfx.drawimage(x*8, 3 + (y+1)*8, icon[t]);
    }
  }
}

function pset(x, y, ?t, ?color){
  //Instead of redrawing the entire screen each time, we just
  //draw what's actually changed.
  if(x>=0 && y>=0){
    if(x < mapwidth && y < mapheight){
      //Update the map for reference
      if(t == null){
        t = currentmap[x][y];
      }else{
        currentmap[x][y] = t;  
      }
      
      drawtile(x, y, t, color);
    }
  }
}

var tcollide;
function collide(x, y){
  tcollide = pget(x,y);
  if(tcollide == floortile || 
     tcollide == opendoortile || 
     tcollide == bloodtile ||
     tcollide == player.tile) return false;
  return true;
}

function pget(x, y){
  if(x>=0 && y>=0){
    if(x < mapwidth && y < mapheight){
      return currentmap[x][y];
    }
  }
  return -1;
}

function moveentity(j, xoff, yoff){
  pset(entity[j].x, entity[j].y, floortile);
  
  newtile = pget((entity[j].x + mapwidth + xoff) % mapwidth, (entity[j].y + mapheight + yoff) % mapheight);
  
  if(newtile == walltile){
    xoff = 0; yoff = 0;
  }else if(newtile == player.tile){
    shake((entity[j].x + mapwidth + xoff) % mapwidth, 
          (entity[j].y + mapheight + yoff) % mapheight,
         	xoff, yoff);
    xoff = 0; yoff = 0;
    entity[j].attack(j);
  }
  
  entity[j].x += xoff;
  entity[j].y += yoff;
  
  pset(entity[j].x, entity[j].y, 999);
  /*
  pset(player.x, player.y, steppedon);
  
  //Check new position for interaction
  oldtile = steppedon;
  newtile = pget((player.x + mapwidth + xoff) % mapwidth, (player.y + mapheight + yoff) % mapheight);
  steppedon = newtile;
  if(newtile == 999){
    //ENTITY! Do entity collision logic here.
    for(i in 0 ... numentity){
      if(entity[i].active){
        if(entity[i].x == (player.x + mapwidth + xoff) % mapwidth && 
           entity[i].y == (player.y + mapheight + yoff) % mapheight){
          entity[i].onplayerhit(i);
          if(entity[i].solid){
            shake((player.x + mapwidth + xoff) % mapwidth, 
                  (player.y + mapheight + yoff) % mapheight,
                 	xoff, yoff);
            xoff = 0; yoff = 0;
          }
        }
      }
    }
  }else if(newtile == walltile){
    //Wall, play a bump sound
    Music.playsound(sfx.hitwall);
    //Prevent the player from moving
    shake((player.x + mapwidth + xoff) % mapwidth, 
          (player.y + mapheight + yoff) % mapheight,
         xoff, yoff);
    xoff = 0; yoff = 0;
  }else if(newtile == opendoortile){
    steppedon = opendoortile;
  }else if(newtile == doortile){
    //Remove the door, drop and open door, play a sound
    Music.playsound(sfx.opendoor);
    steppedon = opendoortile;
  }else if(newtile == potiontile){
    //Remove the potion, play a sound
    Music.playsound(sfx.collect);
  }else if(newtile == scrolltile){
    //Scroll, play a collect sound and change the message
    Music.playsound(sfx.collectscroll);
    message = "SEE *** FOR A MORE COMPLEX ROGUELIKE EXAMPLE";
    messagecol = Col.YELLOW;
  }
  
  turn = "enemy";
  
  if(xoff == 0 && yoff == 0){
    steppedon = oldtile;
    turn = "player";
  }
  
  player.x = (player.x + mapwidth + xoff) % mapwidth; player.y = (player.y + mapheight + yoff) % mapheight;
  
  pset(player.x, player.y, player.tile);
  light(player.x, player.y);
  */
}

function moveplayer(xoff, yoff){
  turn = "enemy";
  pset(player.x, player.y, steppedon);
  
  //Check new position for interaction
  oldtile = steppedon;
  newtile = pget((player.x + mapwidth + xoff) % mapwidth, (player.y + mapheight + yoff) % mapheight);
  steppedon = newtile;
  if(newtile == 999){
    //ENTITY! Do entity collision logic here.
    for(i in 0 ... numentity){
      if(entity[i].active){
        if(entity[i].x == (player.x + mapwidth + xoff) % mapwidth && 
           entity[i].y == (player.y + mapheight + yoff) % mapheight){
          entity[i].onplayerhit(i);
          if(entity[i].solid){
            shake((player.x + mapwidth + xoff) % mapwidth, 
                  (player.y + mapheight + yoff) % mapheight,
                 	xoff, yoff);
            xoff = 0; yoff = 0;
          }
        }
      }
    }
  }else if(newtile == walltile){
    //Wall, play a bump sound
    Music.playsound(sfx.hitwall);
    //Prevent the player from moving
    /*
    shake((player.x + mapwidth + xoff) % mapwidth, 
          (player.y + mapheight + yoff) % mapheight,
         xoff, yoff);
*/
    xoff = 0; yoff = 0;
    turn = "player";
  }else if(newtile == opendoortile){
    steppedon = opendoortile;
  }else if(newtile == doortile){
    //Remove the door, drop an open door, play a sound
    Music.playsound(sfx.opendoor);
    pset((player.x + mapwidth + xoff) % mapwidth, 
         (player.y + mapheight + yoff) % mapheight, opendoortile);
    xoff = 0; yoff = 0;
  }else if(newtile == potiontile){
    //Remove the potion, play a sound
    Music.playsound(sfx.collect);
  }else if(newtile == scrolltile){
    //Scroll, play a collect sound and change the message
    Music.playsound(sfx.collectscroll);
    message = "SEE *** FOR A MORE COMPLEX ROGUELIKE EXAMPLE";
    messagecol = Col.YELLOW;
  }
  
  if(xoff == 0 && yoff == 0){
    steppedon = oldtile;
  }
  
  player.x = (player.x + mapwidth + xoff) % mapwidth; player.y = (player.y + mapheight + yoff) % mapheight;
  
  pset(player.x, player.y, player.tile);
  light(player.x, player.y);
}

//Entity functions
function getfreeentityindex(){
  var i = 0;
  var z = -1;
  if(numentity == 0) {
    z = 0;
  }else {
    while (i < numentity) {
      if (!entity[i].active) {
        z = i;
        break;
      }
      i++;
    }
    if (z == -1) z = numentity;
  }

  if(z >= numentity){
    if(z > entity.length - 1){
      entity.push({});
    }
    numentity++;
  }

  return z;
}

function killentity(t){
  entity[t].active = false;
  pset(entity[t].x, entity[t].y, bloodtile);
}

function resetentity(t){
  entity[t].x = 0;
  entity[t].y = 0;
  entity[t].tile = 0;
  entity[t].health = 1;
  entity[t].timer = 0;
  entity[t].alertsound = 0;
  entity[t].alert = false;
  entity[t].col = Col.WHITE;
  entity[t].hurtcol = 0xffbfbf;
  entity[t].active = false;
  entity[t].type = "nothing";
  entity[t].rule = "nothing";
  entity[t].solid = false;
  
  entity[t].onplayerhit = function(t){};
  entity[t].update = function(t){};
  entity[t].attack = function(t){};
}

function getplayer() {
  for(i in 0 ... numentity){
    if(entity[i].type == "player") return i;
  }
  return -1;
}

function displaystats(){
  //Show message
  Gfx.fillbox(0, 0, Gfx.screenwidth, 10, Col.BLACK);
  Gfx.fillbox(0, bottombar, Gfx.screenwidth, 16, Col.BLACK);
  if(messagetime!=0){
    messagetime--;
    if(Game.time%8>4){
    	Text.display(Text.CENTER, 2, message, messagecol);
    }else{
      Text.display(Text.CENTER, 2, message, messageflickercol);
    }
  }
  
  Text.display(1, 3 + bottombar, "HP", Col.LIGHTBLUE);
  if(animation.hplost > 0){
    animation.hplost--;
    Text.display(12, 2 + bottombar, player.health + "/" + player.maxhealth, Col.PINK);
  }else if(animation.hp > 0){
    animation.hp--;
    Text.display(12, 2 + bottombar, player.health + "/" + player.maxhealth, Col.LIGHTGREEN);
  }else{
    Text.display(12, 3 + bottombar, player.health + "/" + player.maxhealth);
  }
  
  
  Text.display(45, 3 + bottombar, "MP", Col.LIGHTBLUE);
  if(animation.mp > 0){
    animation.mp--;
  	Text.display(58, 2 + bottombar, player.sp + "/" + player.maxsp, Col.LIGHTGREEN);
  }else{
  	Text.display(58, 3 + bottombar, player.sp + "/" + player.maxsp);
  }

  Text.display(90, 3 + bottombar, "HUNGER", Col.LIGHTBLUE);
  if(animation.hunger > 0){
    animation.hunger--;
    Text.display(120, 2 + bottombar, hungerstat[Convert.toint(player.hunger/100)], Col.PINK);
  }else if(animation.full > 0){
    animation.full--;
    Text.display(120, 2 + bottombar, hungerstat[Convert.toint(player.hunger/100)], Col.LIGHTGREEN);
  }else{
  	Text.display(120, 3 + bottombar, hungerstat[Convert.toint(player.hunger/100)]);
  }
}

function drawguibox(x, y, w, h, col, ?animate){
  if(animation.menu > 0 && animate != null){
    x += w/2;
    y += h/2;
    w = w * ((5 - animation.menu)/5);
    h = h * ((5 - animation.menu)/5);
    x -= w/2;
    y -= h/2;
  }
  
  Gfx.imagecolor(col);
  Gfx.fillbox(x * 8, y * 8, (w+1) * 8, (h+1) * 8, Col.BLACK);
  
  for(i in x + 1 ... x + w){
    Gfx.drawimage(i*8, y * 8, icon[8]);
    Gfx.drawimage(i*8, (y + h) * 8, icon[8]);
  }
  
  for(j in y + 1 ... y + h){
    Gfx.drawimage(x * 8, j * 8, icon[9]);
    Gfx.drawimage((x+w)*8, j * 8, icon[9]);
  }
  
  //Corners
  Gfx.drawimage(x * 8, y * 8, icon[0]);
  Gfx.drawimage((x + w) * 8, y * 8, icon[1]);
  Gfx.drawimage(x * 8, (y + h) * 8, icon[2]);
  Gfx.drawimage((x + w) * 8, (y + h) * 8, icon[3]);
}

function update(){
  if(state == "game"){
    input();
    logic();
  	render();
  }else if (state == "menu"){
    if(Input.delaypressed(Key.UP, 6)){
      menu.selection = (menu.selection + menu.list.length - 1) % menu.list.length;
      Music.playsound(sfx.menunudge);
    }else if(Input.delaypressed(Key.DOWN, 6)){
      menu.selection = (menu.selection + 1) % menu.list.length;
      Music.playsound(sfx.menunudge);
    }
    //Music.playsound(sfx.select);
    if(Input.justpressed(Key.ENTER)){
      state = "game";
      Music.playsound(sfx.closemenu);
    }
    
    Gfx.imagecolor(0xAAAACC);
    redrawscreen();
    
    if(animation.menu > 0) animation.menu--;
    
    drawguibox(menu.x, menu.y, menu.w, menu.h, Col.WHITE, true);
      
    if(animation.menu == 0){
      for(i in 0 ... menu.list.length){
        if(menu.selection == i){
          Gfx.drawimage((Game.time % 16)/8 + 2+(menu.x+1) * 8, 1 + (menu.y+1) * 8 + (i * 10), icon[19]);
          Text.display(18+(menu.x+1) * 8, 2 + (menu.y+1) * 8 + (i * 10), menu.list[i]);
        }else{
        	Text.display(14+(menu.x+1) * 8, 2 + (menu.y+1) * 8 + (i * 10), menu.list[i]);
        }
      }
    }
    
    displaystats();
    
    
    if(state == "game"){
      Gfx.imagecolor();
    	redrawscreen();
    }
  }
}

function rest(){
  if(player.hunger >= 200){
  	setmessage("You rest for a moment...", Col.WHITE);
  }else{
    setmessage("You rest, but you are too hungry to recover...", Col.GRAY);
  }
  Music.playsound(sfx.rest);
  turn = "enemy";
  
  player.hunger -= player.hungerspeed * 4;
  if(player.hunger <= 0) player.hunger = 0;
  
  player.restclock++;
  if(player.restclock >= player.restrate){
    player.restclock -= player.restrate;
    if(player.hunger >= 200){
      player.health++;
      if(player.health > player.maxhealth){
        player.health = player.maxhealth;
      }else{
        animation.hp = 5;
      }
    }
  }
}
  
var press_left;
var press_right;
var press_up;
var press_down;
var keydelay = 0;
var keypriority = 0;
function input(){
  //Doing a keypriority thing to make input feel nicer. The basic idea is that
  //you keep moving in the last direction your pressed - most recent direction
  //gets priority.
  press_left = Input.pressed(Key.LEFT);
  press_right = Input.pressed(Key.RIGHT);
  press_up = Input.pressed(Key.UP);
  press_down = Input.pressed(Key.DOWN);
  
  if (press_left || press_right) {
    if (press_up || press_down) {
      //Both horizontal and vertical are being pressed: one must take priority
      if (keypriority == 1) { keypriority = 4;
      }else if (keypriority == 2) { keypriority = 3;
      }else if (keypriority == 0) { keypriority = 3;                                                     }
    }else {keypriority = 1;}
  }else if (press_up || press_down) {keypriority = 2;}else {keypriority = 0;}

  if (keypriority == 3) {press_up = false; press_down = false;
  }else if (keypriority == 4) { press_left = false; press_right = false; }
  
  if(keydelay>0){
    keydelay--;
    if(!(press_left || press_right || press_up || press_down)) keydelay=0;
  }else{
    if(turn == "player"){
      if(player.health > 0){
        if(numshaketiles == 0){
          if(press_left){
            moveplayer(-1, 0);
            keydelay=2;
          }else if(press_right){
            moveplayer(1, 0);
            keydelay=2;
          }

          if(press_up){
            moveplayer(0, -1);
            keydelay=2;
          }else if(press_down){
            moveplayer(0, 1);
            keydelay=2;
          }
          
          if(Input.justpressed(Key.SPACE)){
            rest();
          }
          
          if(Input.justpressed(Key.ENTER)){
            grabscreen();
            state = "menu";
            changemenu("init");
            animation.menu = 5;
            Music.playsound(sfx.select);
          }
        }  
      }else{
        //Death sequence stuff
        if(dogamefade){
          if(Game.time % 5 == 0){
            tx = 0;
            for(j in 0 ... mapheight){
              for(i in 0 ... mapwidth){
                if(lightmap[i][j] > 0){
                  lightmap[i][j]--;
                  tx++;
                  setlight(i, j, lightmap[i][j]);
                }
              }
            }
            if(tx == 0) dogamefade = false;
          }
        }
      }
    }
  }
}

function logic(){
  if(turn == "enemy"){
    //wait for shake animations to finish
    if(numshaketiles == 0){
      for(i in 0 ... numentity){
        if(entity[i].active){
          entity[i].update(i);
        }
        if(entity[i].active){
          if(lightmap[entity[i].x][entity[i].y]>=3){
            if(!entity[i].alert){
              if(entity[i].alertsound > 0) Music.playsound(entity[i].alertsound);
              entity[i].alert= true;
            }
          }
          drawtile(entity[i].x, entity[i].y, entity[i].tile, entity[i].col);
          setlight(entity[i].x, entity[i].y, lightmap[entity[i].x][entity[i].y]);
        }
      }
      turn = "player";
      
      //Do game turn update stuff here
      player.hunger -= player.hungerspeed;
      if(player.hunger < 0) player.hunger = 0;
      
      if(player.hunger <= player.starvepoint){
        player.starveclock++;
        if(player.starveclock > 6){
          player.starveclock = 0;
          animation.hunger = 5;
          hurtplayer();
        }
      }
    }
  }
}

function render(){
  if(redrawmap){
    //Redraw the entire map. For when loads of stuff changes at once.
    redrawmap=false; 
    light(player.x, player.y);
    for(j in 0 ... mapheight){
      for(i in 0 ... mapwidth){
        if(currentmap[i][j]<999){
        	pset(i, j, currentmap[i][j]);
        }
        setlight(i, j, lightmap[i][j]);
      }
    }
    
    //Draw entities
    for(i in 0 ... numentity){
      if(entity[i].active){
        drawtile(entity[i].x, entity[i].y, entity[i].tile, entity[i].col);
        setlight(entity[i].x, entity[i].y, lightmap[entity[i].x][entity[i].y]);
      }
    }
  }
  
  processshake();
  
  displaystats();
}