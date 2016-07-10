import g4p_controls.*;

import java.io.*;
import java.util.*;
import org.apache.poi.ss.usermodel.Sheet;

DataBreachPlot plot;
ArrayList<ToolTip> regTooltips;
TreeSet<String> orgSelection;
TreeSet<String> leakTypeSelection;

void setup() {
  size(1200,800);
  regTooltips = new ArrayList<ToolTip>();
  orgSelection      = new TreeSet<String>();
  leakTypeSelection = new TreeSet<String>();
  plot = new DataBreachPlot(10,10,800,600);
  plot.startLoading();
}

void draw() {
  regTooltips.clear();
  pushMatrix();
  try{
    // manipulate data
    background(25);
    if(plot != null){
      plot.draw();
    }
    for(ToolTip tti:regTooltips){
      if(tti.isIn()){
        tti.display();
        break;
      }
    }
  }catch(Exception e){
    e.printStackTrace();
    println("Unexpected error drawing!");
    System.exit(1);
  }
  popMatrix();
}

void rectWithToolTip(int _x,int _y, int _w, int _h, String tttext){
  rect( _x, _y,  _w,  _h);
  ToolTip tt = new ToolTip(round(screenX(float(_x),float(_y))),round(screenY(float(_x),float(_y))), _w, _h, tttext);
  if(tt.isIn()){
    regTooltips.add(0,tt);
  }
}