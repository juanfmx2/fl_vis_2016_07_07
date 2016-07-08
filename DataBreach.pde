
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
      throw e;
    }    
  }

  public String toString(){
    return String.format("%s %s %s %s %s %s %s",entity,orgType,methodOfLeak,dataSensitivity,interesting,year,numOfRecords);
  }

}

void loadExcelDataBreach(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    String[][] data = importExcel(selection.getAbsolutePath());
    allData = new DataBreach[data.length-3];
    for(int i=3 ; i < data.length ;i++){
      allData[i-3] = new DataBreach(data[i]);
    }
  }
}