class ResidualMetaData{
 float x=0;
 float y=0;
 int cpt = 120;
 String label;
 
 ResidualMetaData(float _x, float _y, String _label){
   x=_x;
   y=_y;
   label=_label;
 }
 
 void draw(){
   fill(255);  
   textSize(32);
   text(label,x,y);
   cpt--;
   textSize(10);
   
 }
  
}