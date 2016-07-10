
public void checkGroupBy(GCheckbox source, GEvent event){
  if(plot != null){
    plot.groupByOrgType = source.isSelected();
    plot.filterData();
  }
}

public void checkOrg(GCheckbox source, GEvent event) { //_CODE_:checkbox1:463547:
  if(source.isSelected()){
    orgSelection.add(source.getText());
  } else{
    orgSelection.remove(source.getText());
  }
  if(plot != null){
    plot.filterData();
  }
} 

public void checkTypeOfLeak(GCheckbox source, GEvent event) { //_CODE_:checkbox1:463547:
  if(source.isSelected()){
    leakTypeSelection.add(source.getText());
  } else{
    leakTypeSelection.remove(source.getText());
  }
  if(plot != null){
    plot.filterData();
  }
} 


public void createSelections(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.GOLD_SCHEME);
  G4P.setCursor(ARROW);
  int baseX = 820;
  int baseY = 10;
  int baseW = 200;
  int baseH = 14;
  int current = 0;
  createLabel(baseX,baseY+current*(baseH+3),baseW,baseH,"Color Grouping:");
  current++;
  createCheckBox(baseX,baseY+current*(baseH+3),baseW,baseH,false,"Group Colors by Organization","checkGroupBy");
  current+=2;
  createLabel(baseX,baseY+current*(baseH+3),baseW,baseH,"Filter by Organization Type:");
  current++;
  for(String orgI:organizationTypes){
    if(orgI != null && orgI.trim().length() > 0){
      createCheckBox(baseX,baseY+current*(baseH+3),baseW,baseH,true,orgI,"checkOrg");
      current++;
    }
  }
  baseX += baseW;
  current = 0;
  createLabel(baseX,baseY+current*(baseH+3),baseW,baseH,"Filter by Leak Type:");
  current++;
  for(String tlI:typesOfLeak){
    if(tlI != null && tlI.trim().length() > 0){
      createCheckBox(baseX,baseY+current*(baseH+3),baseW,baseH,true,tlI,"checkTypeOfLeak");
      current++;
    }
  }
}

void createLabel(int _x, int _y, int _w, int _h, String name){
  GLabel lab = new GLabel(this, _x, _y, _w, _h);
  lab.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  lab.setText(name);
  
}

void createCheckBox(int _x, int _y, int _w, int _h,boolean selected, String name, String func){
  GCheckbox cb = new GCheckbox(this, _x, _y, _w, _h);
  cb.setSelected(selected);
  cb.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  cb.setText(name);
  cb.setOpaque(false);
  cb.addEventHandler(this, func);
}