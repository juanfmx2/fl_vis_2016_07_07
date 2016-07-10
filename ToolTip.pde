// CODE COPIED FROM https://gist.github.com/jdurbin/1205509 to create tooltips

/****
*  roundRect  method
*  ToolTip    class
*  
*  Author: James Durbin 
*       http://bayesianconspiracy.blogspot.com
* 
*       See running example here:
*       http://bayesianconspiracy.blogspot.com/2011/09/tooltip-class-for-html5-canvas-written.html
*  
*  -----------------------
* Rounded rectangle class and color scheme came from here:
* http://bocoup.com/processing-js/docs/index.php?page=Rounded%20Corners%20with%20Processing.js
* 
* Tooltip class combines implements a snazzy tooltip that is semi-transparent.  .  
* 
* Include this library pde in your script header, separated from other .pde files, by a space, like:
* 
*  <script type="text/javascript" src="processing.js"></script>
* <canvas id="tooltiptest" datasrc="ToolTip.pde ToolTipTest.pde"></canvas>
* 
* For static sketches (ones that don't use draw() ), you can update the tooltip based 
*  on mouse position in a canvas with something like this in your mouseMoved() method:
* 
* void mouseMoved(){  
*     // Look up a new tool tip each time x,y cell changes...
*     x = mouseX;
*     y = mouseY;
*  
*     String tipText = "X112U375\nStatus:Normal\nx="+x+" y="+y;  
*     toolTip = new ToolTip(x,y,tipText);
*     toolTip.display();
* }
*  
*  For sketches that invoke the draw() method, simply put the toolTip code lines as the 
*  last thing in the draw() method.  In this situation ToolTip doesn't need to handle 
*  clipping, so you will need to tell the toolTip this with: toolTip.doClip=false;  The
*  default value is true. 
*  
* 
* TODO: Fade in/out tooltip. 
*/ 


/***
* A method to produce a rounded rectangle.   
**/
void roundedRect(int left, int top, int width, int height, int roundness)
{
  beginShape();               
  vertex(left + roundness, top);
  vertex(left + width - roundness, top);
  bezierVertex(left + width - roundness, top,
               left + width, top,
               left + width, top + roundness);
                          
  vertex(left + width, top + roundness);
  vertex(left + width, top + height - roundness);
  bezierVertex(left + width, top + height - roundness,
               left + width, top + height,
               left + width - roundness, top + height);
        
  vertex(left + width - roundness, top + height);
  vertex(left + roundness, top + height);        
  bezierVertex(left + roundness, top + height,
               left, top + height,
               left, top + height - roundness);
        
  vertex(left, top + height - roundness);
  vertex(left, top + roundness);
  bezierVertex(left, top + roundness,
               left, top,
               left + roundness, top);        
  endShape();
}

/***
* A class to display a tooltip in a nice bubble. 
**/
class ToolTip{
  String mText; 
  int x;
  int y; 
  int wIn;
  int hIn; 
  
  int myWidth;
  int fontSize = 16;
  int totalHeight = 0;
  
  int rectWidthMargin;
  int rectHeightMargin;
    
  int shadowOffset = 8;
    
  color tbackground = color(80,150,0);  
  PFont ttfont;  

  
  void setBackground(color c){
    tbackground = c;
  }
  
  boolean isIn(){
    return x<=mouseX && mouseX <= x+wIn && y<=mouseY && mouseY <= y+hIn;
  }
  
  ToolTip(int _x,int _y, int _w, int _h, String tttext){
    x = _x;
    y = _y;
    wIn = _w;
    hIn = _h;
    mText = tttext;
    ttfont = createFont("Arial",20,true);
    textFont(ttfont,fontSize);    
        
    // Figure out text size... font metrics don't seem quite right, at least on Chrome
    String lines[] = split(mText,"\n");
    int maxWidth = 0;
    totalHeight = 0;
    for(int i = 0;i < lines.length;i++){
      totalHeight += fontSize;
      String line = lines[i];
      myWidth = round(textWidth(line));
      if (int(myWidth) > int(maxWidth)){
        maxWidth = myWidth;
      }
    }
    myWidth = int(maxWidth);
    myWidth += 8;
    totalHeight += 8;
  }  
  
  void drawText(String mText,int x,int y,int fontSize){  
    // Print the text to screen
    fill(255);
    int xindent = int(myWidth*(10/128));
    int yindent = int(fontSize*(10/128));
    text(mText,x+xindent, y-yindent);
  }

  void drawBalloon(int x,int y, int w,int h){

    w = int(w);
    h = int(h);
    rectWidthMargin = int(w*(10/64));
    rectHeightMargin = int(h*(10/64));

    int rounding = int(h*(10/64));

    //size(200,100);
    strokeWeight(2);
    stroke(0,0,0,10);  
    fill(0,0,0,50);

    roundedRect(x+shadowOffset+2,y+shadowOffset+2,w+rectWidthMargin,h+rectHeightMargin,rounding);     

    stroke(255,255,255,200);  
    fill(tbackground);
    roundedRect(x,y, w+rectWidthMargin, h+rectHeightMargin,rounding);

    // Highlight x,y coords... at top left...
    //fill(0,0,255);
    //rect(x,y,4,4);
  }
        
  void display(){    
    if(mText.indexOf("\n") != -1){
      textAlign(LEFT,CENTER);
    }
    else{
      textAlign(LEFT,BOTTOM);
    }
    // x and y are mouse coordinates, so determine where tip should be relative to that...              
    int bx = int(x+5);
    int by = int(y-totalHeight);    
    int rectRight = bx+myWidth +20;
    int rectTop = by-totalHeight+30;
    
    rectWidthMargin = int(myWidth*(10/64));
    rectHeightMargin = int(totalHeight*(10/64));
    
    if (rectRight >= width){
      bx = int(x-5-myWidth-rectWidthMargin); 
    }  
    
    if (rectTop <= 0){
      by = int(y+totalHeight+rectHeightMargin);
    }    
    
    //bx = x+10;
    //by = y - totalHeight;

        
    drawBalloon(bx-2,by-fontSize-2,myWidth,totalHeight);        
    drawText(mText,bx,by,fontSize);
    stroke(0,200,20);
    noFill();
    rect(x,y,wIn,hIn);
  }
}