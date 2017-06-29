PShape [] metaShape=new PShape[5];

int [] tabScore = new int[]{0, 0, 0, 0, 0};

ArrayList<MetaData> tabMeta = new ArrayList<MetaData>();
Table table;

final int WIDTH_METADATA = 25;
final int HEIGHT_METADATA = 25;

//Generate meta data randomly
void createRandomMetaData(int nbMetaData) {
  metaShape[0]=loadShape("carre.svg");
  metaShape[1]=loadShape("etoile.svg");
  metaShape[2]=loadShape("polygone.svg");
  metaShape[3]=loadShape("rond.svg");
  metaShape[4]=loadShape("triangle.svg");

  int compteurMetaDataValide = 0;
  while (compteurMetaDataValide < nbMetaData) {
    int meta_shape = int(random(0, 5));
    int meta_abs = 0;
    int meta_ord = 0;
    boolean valide = true;

    do {
      meta_abs = int(random(0, width_world));
      meta_ord = int(random(0, height_world));

      int i=0;
      //On s'assure que la metaData n'est pas dans un bloc
      for (i=0; i < parser.tabBloc.size(); i++) {
        valide = !parser.tabBloc.get(i).inside(meta_abs, meta_ord, WIDTH_METADATA, HEIGHT_METADATA);//return false if md outside bloc
        if (valide==false) break;
      }
    } while (valide==false);

    tabMeta.add(new MetaData(metaShape[meta_shape], meta_abs, meta_ord, WIDTH_METADATA, HEIGHT_METADATA));
    compteurMetaDataValide++;

    //Barre de chargement qui marche po :'(
    fill(255, 0, 0);
    noStroke();
    rect(20, height-40, map(compteurMetaDataValide, 0, nbMetaData, 0, width-20), 20);
  }
}



void initMetaData() {
  metaShape[0]=loadShape("carre.svg");
  metaShape[1]=loadShape("etoile.svg");
  metaShape[2]=loadShape("polygone.svg");
  metaShape[3]=loadShape("rond.svg");
  metaShape[4]=loadShape("triangle.svg");


  table = loadTable("meta.csv", "header");

  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {
    String type = row.getString("type");
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    println("found Meta >> type : "+type+"   x : "+x+"   y : "+y);

    PShape temp=null;
    if (type.equals("c"))temp=metaShape[0];
    if (type.equals("e"))temp=metaShape[1];
    if (type.equals("p"))temp=metaShape[2];
    if (type.equals("r"))temp=metaShape[3];
    if (type.equals("t"))temp=metaShape[4];


    if (temp!=null) tabMeta.add( new MetaData(temp, x, y, WIDTH_METADATA, HEIGHT_METADATA));
  }
}

void drawMetaData() {
  for (int i=0; i<tabMeta.size(); i++) {
    tabMeta.get(i).draw();
    tabMeta.get(i).insideAndKill(p.p.x, p.p.y);//Bof bof
  }

  for (int i=0; i<tabMeta.size(); i++) {
    if (tabMeta.get(i).life==false)tabMeta.remove(i);
  }
}


//------------------------------------------------------------------
//  CLASS META DATA
//------------------------------------------------------------------
class MetaData {
  float x=0;
  float y=0;
  float w=0; 
  float h=0;
  boolean life=true;
  PShape shape;

  MetaData(PShape _shape, float _x, float _y, float _w, float _h) {  
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    shape=_shape;
  }

  void draw() {
    if (p.camX+width>x && p.camX<x+w && p.camY+height>y && p.camY<y+h) {  
      noFill();
      stroke(0, 0, 255);
      //rect(x, y, w, h, 5);

      if (shape!=null)shape(shape, x, y, w, h);
    }
  }

  void insideAndKill(float px, float py) {
    if (px>x && px<x+w && py>y && py<y+h) {
      life=false;
      tabMeta.remove(this);
      //NOQA
      if (shape==metaShape[0]) {
        tabScore[0]++;
      }
      if (shape==metaShape[1]) {
        tabScore[1]++;
      }
      if (shape==metaShape[2]) {
        tabScore[2]++;
      }
      if (shape==metaShape[3]) {
        tabScore[3]++;
      }
      if (shape==metaShape[4]) {
        tabScore[4]++;
      }
    }
  }

  boolean inside(float px, float py) {
    if (px>x && px<x+w && py>y && py<y+h) {
      return true;
    } else {
      return false;
    }
  }

  boolean inside(float min_x, float min_y, float max_x, float max_y) {
    if (x>min_x && x<max_x && y>min_y && y <max_y) return true;
    return false;
  }
}