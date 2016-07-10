
void loadExcelDataBreach(File selection) {
  if(selection == null){
    println("User did not select a file.");
    System.exit(1);
  }
  else{
    try{
      if(plot != null){
        plot.loading = true;
      }
      String[][] data = importExcel(selection.getAbsolutePath());
      ArrayList<DataBreach> allData = new ArrayList<DataBreach>();
      for(int i=3 ; i < data.length ;i++){
        DataBreach nextData = new DataBreach(data[i]);
        int pos = Collections.binarySearch(allData,nextData,new ByYearComparator());
        if (pos < 0){
          allData.add(-pos-1, nextData);
        }
        else{
          allData.add(pos, nextData);
        }
      }
      if(plot != null){
        plot.loadData(allData);
      }
    }catch(Exception e){
      e.printStackTrace();
      System.exit(1);
    }
  }
}

class DataBreachPlot{
  boolean groupByOrgType;
  boolean loaded;
  boolean loading;
  ArrayList<DataBreach> data;
  ArrayList<DataBreach> drawData;
  int minYear,maxYear;
  int minHist,maxHist;
  int minLost,maxLost;
  TreeMap<Integer,TreeMap<String,Integer>> histogram;
  int xPos,yPos,plotWidth,plotHeight;
  int rMargin,lMargin,bMargin,tMargin;
  int yearsFSize, yearsGap, timelineWidth, timelineHeight;
  int histX,histY;
  int step;
  
  DataBreachPlot(int x, int y, int w, int h){
    loaded        = false;
    loading       = false;
    xPos          = x;
    yPos          = y;
    plotWidth     = w;
    plotHeight    = h;
    histogram     = new TreeMap<Integer,TreeMap<String,Integer>>();
    rMargin       = 30;
    lMargin       = 30;
    bMargin       = 30;
    tMargin       = 60;
    yearsFSize    = 16;
    step          = 100;
  }
  
  void startLoading(){ 
    selectInput("Select the file to process:", "loadExcelDataBreach");
  }
  
  void filterData(){
    drawData  = new ArrayList<DataBreach>();
    for(DataBreach dbi:data){
      if(orgSelection.contains(dbi.orgType) && leakTypeSelection.contains(dbi.methodOfLeak)){
        drawData.add(dbi);
      }
    }
    recalc();
  }
  
  void loadData(ArrayList<DataBreach> allData){
    createSelections();
    data     = allData;
    assignColors();
    for(String orgI:organizationTypes){
      orgSelection.add(orgI);
    }
    for(String tolI:typesOfLeak){
      leakTypeSelection.add(tolI);
    }
    filterData();
    loaded   = true;
  }
  
  void calcHistogram(){
    minHist = 0;
    maxHist = 1;
    for(Integer yearI:histogram.keySet()){
      TreeMap<String,Integer> categories = histogram.get(yearI);
      int count = 0;
      for(int countI:categories.values()){
        count+=countI;
      }
      if(count > maxHist){
        maxHist = count;
      }
    }
  }
  
  void recalc(){
    loading  = true;
    minYear = Integer.MAX_VALUE;
    maxYear = Integer.MIN_VALUE;
    minLost = Integer.MAX_VALUE;
    maxLost = Integer.MIN_VALUE;
    histogram.clear();
    for(DataBreach dbi:drawData){
      if(dbi.year < minYear){
        minYear = dbi.year;
      }
      if(dbi.year > maxYear){
        maxYear = dbi.year;
      }
      if(dbi.numOfRecords > maxLost){
        maxLost = dbi.numOfRecords;
      }
      if(!histogram.containsKey(dbi.year)){
        histogram.put(dbi.year,new TreeMap<String,Integer>());
      }
      String category = groupByOrgType?dbi.orgType:dbi.methodOfLeak;
      if(!histogram.get(dbi.year).containsKey(category)){
        histogram.get(dbi.year).put(category,0);
      }
      histogram.get(dbi.year).put(category,histogram.get(dbi.year).get(category)+1);
    }
    minYear--;
    maxYear++;
    minLost = 0;
    calcHistogram();
    step     = 1;
    loading  = false;
  }
  
  public color getColor(String orgOrLType){
    return getColorPallete(groupByOrgType?orgColors.get(orgOrLType):dltColors.get(orgOrLType));
  }
  
  void drawHistogram(){
    pushMatrix();
    float drawHeight = plotHeight -bMargin-(plotHeight/2+timelineHeight/2)-1;
    int deltaVals  = maxHist - minHist;
    translate(rMargin,plotHeight/2+timelineHeight/2+1);
    stroke(255);
    int deltaLines = deltaVals>4? deltaVals/4:1;
    for(int line=1;line<=4;line++){
      int linePosY = round(line*deltaLines*drawHeight/deltaVals);
      line(0, linePosY, timelineWidth, linePosY);
      fill(255);
      drawText(""+(line*deltaLines),0,linePosY+1,yearsFSize,LEFT,TOP);
    }
    pushMatrix();
    translate(-rMargin/2,plotHeight/4);
    rotate(-PI/2.0);
    drawText("Number of Data Breaches",0,0,yearsFSize,CENTER,CENTER);
    popMatrix();
    noStroke();
    translate(-yearsGap,0);
    for(int i = minYear; i <= maxYear ; i++){
      translate(yearsGap,0);
      if(histogram.containsKey(i)){
        TreeMap<String,Integer> cats = histogram.get(i);
        pushMatrix();
        for(String catI:cats.keySet()){
          int val = cats.get(catI);
          fill(getColor(catI),200);
          int catH = round(val*drawHeight/deltaVals*step/100.0);
          rectWithToolTip(-yearsGap/2+1,0,yearsGap-2,catH,catI+"\n"+String.format("%,d",val)+" Data Breach event(s)");
          translate(0,catH);
        }
        popMatrix();
      }
    }
    popMatrix();
  }
  
  void drawTopChart(){
    pushMatrix();
    float drawHeight      = plotHeight -tMargin-(plotHeight/2+timelineHeight/2)-1;
    float maxLog = round(log(float(maxLost)));
    float minLog = 0;
    float deltaValsRecordsLog  = maxLog-minLog;
    translate(rMargin,tMargin);
    stroke(255);
    fill(255);
    float deltaLines = deltaValsRecordsLog>4.0? deltaValsRecordsLog/4.0:1.0;
    for(int line=1;line<=4;line++){
      float val = line*deltaLines;
      int linePosY = round(drawHeight-val*drawHeight/deltaValsRecordsLog);
      line(0, linePosY, timelineWidth, linePosY);
      drawText(String.format("%,d",round(exp(val))),timelineWidth,linePosY+1,yearsFSize,RIGHT,TOP);
    }
    pushMatrix();
    translate(timelineWidth+lMargin/2,plotHeight/4);
    rotate(-PI/2.0);
    drawText("Records Compromised",0,0,yearsFSize,CENTER,CENTER);
    popMatrix();
    noStroke();
    ellipseMode(RADIUS);
    for(DataBreach dbi:drawData){
      stroke(255);
      fill(dbi.getColor(groupByOrgType),200);
      int radius = 4+round(log(float(dbi.dataSensitivity)));
      int yPos = round(drawHeight-log(float(dbi.numOfRecords))*drawHeight/deltaValsRecordsLog*step/100.0);
      ellipse((dbi.year-minYear)*yearsGap, yPos, radius, radius);
      noStroke();
      noFill();
      rectWithToolTip((dbi.year-minYear)*yearsGap-radius,yPos-radius,2*radius,2*radius,dbi.entity+" Data Breach\n"+String.format("%,d",dbi.numOfRecords)+" records Lost");
    }
    popMatrix();
  }
  
  void drawTimeline(){
    strokeWeight(2);
    textSize(yearsFSize);
    timelineWidth = plotWidth-rMargin-lMargin;
    timelineHeight = round(textAscent()+textDescent()+4);
    yearsGap = timelineWidth/(maxYear-minYear);
    drawHistogram();
    drawTopChart();
    pushMatrix();
    translate(rMargin,plotHeight/2-timelineHeight/2);
    stroke(255);
    line(0, 0, timelineWidth, 0);
    fill(0, 102, 153);
    line(0, round(textAscent()+textDescent()+4), timelineWidth, timelineHeight);
    translate(-yearsGap,2);
    for(int i = minYear; i <= maxYear ; i++){
      translate(yearsGap,0);
      if(textWidth(""+i)+20>yearsGap && i%2==0){continue;}
      drawText(""+i,0,0,yearsFSize,CENTER,TOP);
    }
    popMatrix();
  }
  
  void drawText(String text,int x,int y,int size,int xAl, int yAl){
    textSize(size);
    textAlign(xAl, yAl);
    text(text, x, y);
  }
  
  void draw(){
    pushMatrix();
    translate(xPos,yPos);
    
    if(loaded && !loading){
      fill(0, 102, 153);
      drawText("Biggest Data Breaches",0,0,20,LEFT,TOP);
      drawTimeline();
      if(step < 100){step+=25;}
    }
    else if(loaded && loading){
      pushMatrix();
      fill(0, 102, 153);
      translate(plotWidth/2,plotHeight/2);
      drawText("Calculating plot . . .",0,0,32,CENTER,CENTER);
      popMatrix();
    }
    else if(!loaded && loading){
      pushMatrix();
      fill(0, 102, 153);
      translate(plotWidth/2,plotHeight/2);
      drawText("Loading Excel File . . .",0,0,32,CENTER,CENTER);
      popMatrix();
    }
    else{
      pushMatrix();
      fill(0, 102, 153);
      translate(plotWidth/2,plotHeight/2);
      drawText("Waiting on user selecetion.",0,0,32,CENTER,CENTER);
      popMatrix();
    }
    popMatrix();
  }
  
}