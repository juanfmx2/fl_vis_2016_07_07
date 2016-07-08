import java.io.*;
import java.util.*;
import org.apache.poi.ss.usermodel.Sheet;

DataBreach[] allData;

void setup() {
  // import excel data to a 2d string:
  selectInput("Select a file to process:", "loadExcelDataBreach");
}

void draw() {
  // manipulate data
}

void keyPressed() {
  //export a 2d string to an excel file:
  // exportExcel(a 2D string, a new filepath/name);
}