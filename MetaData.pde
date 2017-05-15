PShape [] metaShape=new PShape[5];

ArrayList<MetaData> tabMeta = new ArrayList<MetaData>();
Table table;

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

    if (temp!=null)tabMeta.add( new MetaData(temp, x, y, 50, 50) );
  }
}

void drawMetaData() {
  for (int i=0; i<tabMeta.size(); i++) {
    tabMeta.get(i).draw();
    tabMeta.get(i).insideAndKill(p.p.x,p.p.y);
  }
  
  for (int i=0; i<tabMeta.size(); i++) {
    if(tabMeta.get(i).life==false)tabMeta.remove(i);
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
    }
  }

  boolean inside(float px, float py) {
    if (px>x && px<x+w && py>y && py<y+h) {
      return true;
    } else {
      return false;
    }
  } 
}