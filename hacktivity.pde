import static javax.swing.JOptionPane.*;
//import maths.*;
Parser parser;
Player p;
Pluie pluie;
Fire fires;

PImage old;

PImage neige;
PImage part;

PGraphics hudA;
int start_time= millis();

int alpha=240;

int width_world=0;
int height_world=0;

final int ABS_SPAWN_PLAYER=960;
final int ORD_SPAWN_PLAYER=540;

final int NB_METADATA = 10;//number of metada to generate

final int time_limit=1200;

//CookieReader
SQLite dbFirefox = new SQLite(this,"/home/valentin/.mozilla/firefox/77x3h8j8.default/cookies.sqlite");

//Remanant MetaData
ArrayList<ResidualMetaData> listResidualMetaData = new ArrayList<ResidualMetaData>();

void setup() {
  //fullScreen(P3D);
  size(600,600,P3D);
  frameRate(60);
  old = loadImage("back.png");
  part = loadImage("particuleOP.png");
  neige = loadImage("neige.png");

  //noCursor();


  smooth(2);
  pluie = new Pluie();
  parser = new Parser(loadShape("levelTINY_test.svg"));
  //p = new Player(width/2-200, height/2-200); 
  p = new Player(ABS_SPAWN_PLAYER, ORD_SPAWN_PLAYER);//Ainsi le spawn du joueur ne dépend plus de la résolution de l'écran

  fires = new Fire();

  //  initSound();
  hudA = createGraphics(width, height, P2D);
  hudA.noSmooth();
  hudA.beginDraw();
  hudA.clear();
  hudA.endDraw();

  //METADATA
  //initMetaData();
  //createRandomMetaData(NB_METADATA);
  createMetaDataFromCookies(new FirefoxCookieReader(dbFirefox));
}

float ang=0;


void draw() {
  background(255);

  imageMode(CORNER);
  tint(255, alpha);
  image(old, 0, 0, width, height);

  p.startCam();
  //runSound();

  pushMatrix();
  //translate(width/2, height, -400);Responsable du mouvement du cercle
  // Cercle visible au lancement
  fill(45, 44, 50, 70);
  noStroke();
  ellipse(ABS_SPAWN_PLAYER, ORD_SPAWN_PLAYER, width*0.8, width*0.8);
  popMatrix();
  rectMode(CORNER);

  p.draw();
  parser.draw();

  for (int i=0; i<5; i++) pluie.gen(p.p.x+random(-width, width), p.p.y-random(height/2));
  pluie.draw();

  p.collide(parser.tabBloc);

  PVector dir = p.v.copy().normalize().mult(10);
  dir.rotate(random(-0.05, 0.05));
  if (fire)fires.gen(p.p.copy(), dir);
  fires.draw();

  //p.draw2();
  //p.drawPost();
  fires.draw();

  drawMetaData();
  //Affiche les anciennes meta data
  for(ResidualMetaData data : listResidualMetaData){
    if(data.cpt>=0){
     data.draw();
    }
  }

  camera();



  p.startCam();

  // ligne pour connaître position caméra au départ ?  
  //strokeWeight(0.8);
  //stroke(0);
  //line(0, 0, 1000, 300);
  camera();

  hudA.beginDraw();
  //hudA.clear();
  hudA.noFill();
  hudA.stroke(0);
  hudA.strokeWeight(0.4);

  //hudA.ellipse(-p.camX+p.p.x+p.v.x,-p.camY+p.p.y+p.v.y,60,60);
  hudA.endDraw();

  image(hudA, 0, 0);



  // carré du haut 
  fill(0);
  rect(10, 10, 80, 80);

  fill(255);
  //text(frameRate, 12, 20);
  //text(pluie.pluie.size(), 12, 40);
  //text(parser.count, 12, 60);
  text(p.p.x, 12, 20);
  text(p.p.y, 12, 40);
  text(tabMeta.size(), 12, 60);
  text(p.dir_to_closest_md(), 12, 80);



  //text(abs(p.camX-p.p.x),12,100); show player abs on screen (!= on the map)
  if (arrow) drawArrowToClosestMetaData();
  // barre en bas
  fill(255, 40);
  noStroke();
  //rect(20, height-40, map(p.energie, 60, 100, 0, 200), 20);
  
  
  
 

  int elapsed_time = int((millis()-start_time)/1000);
  rect(20, height-40, map(elapsed_time, 0, time_limit, 0, width-20), 20);
  if (elapsed_time >= time_limit) {//AU bout de 60 secondes, on demande au joueur s'il veut poursuivre sa partie
    int confirmResult = showConfirmDialog(null, "Temps écoulé, souhaitez-vous continuer à jouer ?", 
      "Temps écoulé !", ERROR_MESSAGE);
    if (confirmResult==YES_OPTION) {
      start_time=millis();
    } else {
      showMessageDialog(null, printTabScore(), "Score", PLAIN_MESSAGE);
      exit();
    }
  }
}

String printTabScore() {
  String s = "Carrés: "+tabScore[0];
  s+="\nÉtoiles: "+tabScore[1];
  s+="\nPolygone: "+tabScore[2];
  s+="\nCercle: "+tabScore[3];
  s+="\nTriangle: "+tabScore[4];
  return s;
}

/*persistent problem with the origin of the arrow
 the camera handling seems to be at fault
 no idea to correct it ATM
 */
void drawArrowToClosestMetaData() {
  //println(arrow);

  MetaData md = p.getClosestMetaData();
  int x1 = int(p.p.x);
  int y1 = int(p.p.y);

  float x2 = md.x;
  float y2 = md.y;

  PVector direction = new PVector();
  direction.x=x2-x1;
  direction.y=y2-y1;
  direction.normalize();
  direction.mult(50);
  pushMatrix();
  translate(abs(x1-p.camX), abs(y1-p.camY));//Centre le repère sur la position du joueur à l'écran
  rotateZ(atan2(y2-y1, x2-x1));


  //uncomment following block for debug purposes
  /*/
   //axe Y
   stroke(255, 0, 0);
   line(0, -height, 0, height);
   line(0, height/2, 20, height/2-10);
   line(0, height/2, -20, height/2-10);
   //axe x
   stroke(0, 0, 255);
   line(-width, 0, width, 0);
   line(width/2, 0, width/2-10, 20);
   line(width/2,0,width/2-10,-20);
  /*/

  stroke(0);
  strokeWeight(4);
  line(0, 0, 50, 0);
  line(50, 0, 20, 10);
  line(50, 0, 20, -10);


  popMatrix();
}