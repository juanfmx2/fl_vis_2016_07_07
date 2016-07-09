import java.io.*;
import java.util.*;
import org.gicentre.utils.stat.*;    // For chart classes.
import org.apache.poi.ss.usermodel.Sheet; // For apache excel reading libraries
import org.gicentre.utils.move.*;

DataBreachPlot plot;
BarChart barChart;
XYChart scatterplot;

void setup() {
  size(1000,800);
  plot = new DataBreachPlot(10,10,600,600);
  plot.startLoading();
}

void draw() {
  pushMatrix();
  try{
    // manipulate data
    background(25);
    if(plot != null){
      plot.draw();
    }
  }catch(Exception e){
    e.printStackTrace();
    println("Unexpected error drawing!");
    System.exit(1);
  }
  popMatrix();
}

void keyPressed() {
  //export a 2d string to an excel file:
  // exportExcel(a 2D string, a new filepath/name);
}