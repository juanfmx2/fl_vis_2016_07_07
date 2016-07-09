
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
  boolean loaded;
  boolean loading;
  ArrayList<DataBreach> data;
  ArrayList<DataBreach> drawData;
  int minYear,maxYear;
  int minHist,maxHist;
  int minSens,maxSens;
  int minLost,maxLost;
  TreeMap<Integer,Integer> histogram;
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
    histogram     = new TreeMap<Integer,Integer>();
    rMargin       = 30;
    lMargin       = 30;
    bMargin       = 30;
    tMargin       = 30;
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
      int val = histogram.get(yearI);
      if(val > maxHist){
        maxHist = val;
      }
    }
  }
  
  void recalc(){
    loading  = true;
    minYear = Integer.MAX_VALUE;
    maxYear = Integer.MIN_VALUE;
    minSens = Integer.MAX_VALUE;
    maxSens = Integer.MIN_VALUE;
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
      if(dbi.dataSensitivity > maxSens){
        maxSens = dbi.dataSensitivity;
      }
      if(dbi.numOfRecords > maxLost){
        maxLost = dbi.numOfRecords;
      }
      if(!histogram.containsKey(dbi.year)){
        histogram.put(dbi.year,0);
      }
      histogram.put(dbi.year,histogram.get(dbi.year)+1);
    }
    minYear--;
    maxYear++;
    println(maxSens);
    maxSens = round(log(float(maxSens)));
    println(maxSens);
    minSens = 0;
    minLost = 0;
    calcHistogram();
    step     = 1;
    loading  = false;
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
    noStroke();
    translate(-yearsGap,0);
    for(int i = minYear; i <= maxYear ; i++){
      translate(yearsGap,0);
      if(histogram.containsKey(i)){
        int val = histogram.get(i);
        color histColor = color(0, 102, 153);
        fill(histColor);
        
        rectWithToolTip(-yearsGap/2+1,0,yearsGap-2,round(val*drawHeight/deltaVals*step/100.0),val+" Data Breach event(s)");
      }
    }
    popMatrix();
  }
  
  void drawSensLines(int deltaValsSens, float drawHeight){
    stroke(200,20,20);
    fill(200,20,20);
    for(int level:dataSensitivityLeves.keySet()){
      String text = dataSensitivityLeves.get(level);
      level = round(log(float(level)));
      if(level <= maxSens){
        int linePosY = round(drawHeight-level*drawHeight/deltaValsSens)-10;
        line(0, linePosY, timelineWidth, linePosY);
        fill(255);
        drawText(""+(text),0,linePosY+1,yearsFSize,LEFT,BOTTOM);
      }
    }
  }
  
  void drawTopChart(){
    pushMatrix();
    float drawHeight      = plotHeight -tMargin-(plotHeight/2+timelineHeight/2)-1;
    int deltaValsSens     = maxSens - minSens;
    float maxLog = round(log(float(maxLost)));
    float minLog = 0;
    int deltaValsRecords     = maxLost-minLost;
    float deltaValsRecordsLog  = maxLog-minLog;
    translate(rMargin,tMargin);
    stroke(255);
    fill(255);
    float deltaLines = deltaValsRecordsLog>4.0? deltaValsRecordsLog/4.0:1.0;
    for(int line=1;line<=4;line++){
      float val = line*deltaLines;
      int linePosY = round(drawHeight-val*drawHeight/deltaValsRecordsLog);
      line(0, linePosY, timelineWidth, linePosY);
      drawText(""+round(exp(val)),timelineWidth,linePosY+1,yearsFSize,RIGHT,TOP);
    }
    //drawSensLines(deltaValsSens,drawHeight);
    noStroke();
    ellipseMode(RADIUS);
    for(DataBreach dbi:drawData){
      color histColor = color(0, 102, 153);
      stroke(255);
      fill(histColor);
      int radius = 4+round(log(float(dbi.dataSensitivity)));
      int yPos = round(drawHeight-log(float(dbi.numOfRecords))*drawHeight/deltaValsRecordsLog*step/100.0);
      ellipse((dbi.year-minYear)*yearsGap, yPos, radius, radius);
      noStroke();
      noFill();
      rectWithToolTip((dbi.year-minYear)*yearsGap-radius,yPos-radius,2*radius,2*radius,dbi.entity+" Data Breach\n"+dbi.numOfRecords+" records Lost");
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
      if(textWidth(""+i)>yearsGap && i%2==0){continue;}
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
      drawTimeline();
      if(step < 100){step+=10;}
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