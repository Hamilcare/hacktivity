import de.bezier.data.sql.*;

abstract class CookieReader{
  ArrayList<String> domainName = new ArrayList<String>();//Contient tous les noms de domaines des cookies avec des doublons pour le moment
  int index = 0;
  
  boolean hasNext(){
    return domainName.size()>index;
  }
  
  String next(){
    String resul = domainName.get(index);
    index++;
    return resul;
  }
  
  int size(){
    return domainName.size();
  }

}

public class FirefoxCookieReader extends CookieReader{
  SQLite db;
  FirefoxCookieReader(SQLite db){
    this.db=db;
    this.fillDomainesList();
  }
  
  void fillDomainesList(){
    if(db.connect()){
      println("Connection Reussie");
      db.query("SELECT name as \"TableName\" FROM SQLITE_MASTER where type=\"table\"");
      
      //while(db.next()){
      //  println(db.getString("TableName"));
      //}
      
      db.query("Select * from moz_cookies");
      //String[] colNames = db.getColumnNames();
      //for(String s : colNames){
      //  println(s);
      //}
      
      while(db.next()){
       this.domainName.add(db.getString(2)); 
      }
      
    }
    
    else{
      println("Echec de la connection");
    }
  }
  
  
  
  
}