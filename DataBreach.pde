
TreeSet<String> organizationTypes                  = new TreeSet<String>();
TreeSet<String> typesOfLeak                        = new TreeSet<String>();
TreeMap<Integer,String> dataSensitivityLeves       = new TreeMap<Integer,String>();
{
  dataSensitivityLeves.put(1,"Just email address/Online information");
  dataSensitivityLeves.put(20,"SSN/Personal details 300 Credit card information");
  dataSensitivityLeves.put(4000,"Email password/Health records");
  dataSensitivityLeves.put(50000,"Full bank account details");
}
TreeMap<String,Integer> orgColors = new TreeMap<String,Integer>();
TreeMap<String,Integer> dltColors = new TreeMap<String,Integer>();

void assignColors(){
  orgColors.clear();
  dltColors.clear();
  int i = 0;
  for(String orgI:organizationTypes){
    orgColors.put(orgI,i++);
  }
  i = 0;
  for(String tlI:typesOfLeak){
    dltColors.put(tlI,i++);
  }
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
      orgType         = (excelRow[5]==null || excelRow[5].trim().length() == 0)? "Unknown Organization":excelRow[5].trim();
      methodOfLeak    = (excelRow[6]==null || excelRow[6].trim().length() == 0)? "Unknown Leak Type":excelRow[6].trim();
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

  public color getColor(boolean groupByOrgType){
    return getColorPallete(groupByOrgType?orgColors.get(orgType):dltColors.get(methodOfLeak));
  }

  public String toString(){
    return String.format("%s %s %s %s %s %s %s",entity,orgType,methodOfLeak,dataSensitivity,interesting,year,numOfRecords);
  }

}

class ByYearComparator implements Comparator<DataBreach>{
  public int compare(DataBreach o1,DataBreach o2){
    if(o1 == null){return -1;}
    if(o2 == null){return 1;}
    return o1.year - o2.year;
  }
}