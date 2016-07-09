
void loadExcelDataBreach(File selection) {
  if(selection == null){
    println("User did not select a file.");
    System.exit(1);
  }
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

class DataBreachPlot{
  boolean loaded;
  boolean loading;
  ArrayList<DataBreach> data;
  ArrayList<DataBreach> drawData;
  int minYear,maxYear;
  int minHist,maxHist;
  int minSen,maxSens;
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
  void loadData(ArrayList<DataBreach> allData){
    data     = allData;
    drawData = data;
    loaded   = true;
    recalc();
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
    minSen = Integer.MAX_VALUE;
    maxSens = Integer.MIN_VALUE;
    histogram.clear();
    for(DataBreach dbi:drawData){
      if(dbi.year < minYear){
        minYear = dbi.year;
      }
      if(dbi.year > maxYear){
        maxYear = dbi.year;
      }
      if(dbi.dataSensitivity < minSen){
        minSen = dbi.dataSensitivity;
      }
      if(dbi.dataSensitivity > maxSens){
        maxSens = dbi.dataSensitivity;
      }
      if(!histogram.containsKey(dbi.year)){
        histogram.put(dbi.year,0);
      }
      histogram.put(dbi.year,histogram.get(dbi.year)+1);
    }
    minYear--;
    maxYear++;
    calcHistogram();
    step     = 1;
    loading  = false;
  }
  
  int getRightMargin(){
    return 30;
  }
  
  int getLeftMargin(){
    return 30;
  }
  int getTimelineLength(){
    
    return plotWidth - getRightMargin();
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
      drawText(""+(line*deltaLines),-1,linePosY,yearsFSize,RIGHT,CENTER);
    }
    noStroke();
    translate(-yearsGap,0);
    for(int i = minYear; i <= maxYear ; i++){
      translate(yearsGap,0);
      if(histogram.containsKey(i)){
        int val = histogram.get(i);
        color histColor = color(0, 102, 153);
        fill(histColor);
        rect(-yearsGap/2+1,0,yearsGap-2,round(val*drawHeight/deltaVals*step/100.0));
      }
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
    stroke(0, 102, 153);
    noFill();
    rect(0, 0, plotWidth, plotHeight);
    rect(0, plotHeight/2-lMargin/2, lMargin, lMargin);
    rect(plotWidth-lMargin, plotHeight/2-lMargin/2, lMargin, lMargin);
    rect(plotWidth/2-lMargin/2, plotHeight/2-lMargin/2, lMargin, lMargin);
    if(loaded && !loading){
      drawTimeline();
      if(step < 100){step++;}
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