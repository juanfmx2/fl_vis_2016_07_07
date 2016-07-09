
Set<String> organizationTypes                  = new TreeSet<String>();
Set<String> typesOfLeak                        = new TreeSet<String>();
TreeMap<Integer,String> dataSensitivityLeves   = new TreeMap<Integer,String>();
{
  dataSensitivityLeves.put(1,"Just email address/Online information");
  dataSensitivityLeves.put(20,"SSN/Personal details 300 Credit card information");
  dataSensitivityLeves.put(4000,"Email password/Health records");
  dataSensitivityLeves.put(50000,"Full bank account details");
}

class DataBreach{
  
  String entity,story,orgType,methodOfLeak,urlSource;
  boolean interesting;
  int year,numOfRecords,dataSensitivity;
  
  DataBreach(String[] excelRow){
    try{
      entity          = excelRow[0];
      story           = excelRow[2];
      year            = 2004+int(excelRow[3]);
      orgType         = excelRow[5];
      methodOfLeak    = excelRow[6];
      interesting     = boolean(excelRow[7]);
      numOfRecords    = int(excelRow[8]);
      dataSensitivity = int(excelRow[9]);
      urlSource       = excelRow[14];
      organizationTypes.add(orgType);
      typesOfLeak.add(methodOfLeak);
    }catch(Exception e){
      e.printStackTrace();
      println("Could not parse Excel File properly!");
      System.exit(1);
    }    
  }
  
  void draw(){
    fill(204, 102, 0);
    ellipse(0, 0, 10, 10);
  }

  public String toString(){
    return String.format("%s %s %s %s %s %s %s",entity,orgType,methodOfLeak,dataSensitivity,interesting,year,numOfRecords);
  }

}

public void drawScatter(ArrayList<DataBreach> list,float x,float y, float w,float h){
  pushMatrix();
  float origX = x;
  float origY = y+h;
  for(DataBreach dbi:list){
  }
  popMatrix();
}

class ByYearComparator implements Comparator<DataBreach>{
  public int compare(DataBreach o1,DataBreach o2){
    if(o1 == null){return -1;}
    if(o2 == null){return 1;}
    return o1.year - o2.year;
  }
}

void mouseMoved() {
  if(scatterplot != null){
    PVector vect = scatterplot.getScreenToData(new PVector(mouseX,mouseY));
    if(vect != null){
      println(vect.x);println(vect.y);
    }
  }
}