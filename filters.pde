

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
  int baseX = 800;
  int baseY = 10;
  int baseW = 200;
  int baseH = 14;
  int current = 0;
  for(String orgI:organizationTypes){
    if(orgI != null && orgI.trim().length() > 0){
      createCheckBox(baseX,baseY+current*(baseH+3),baseW,baseH,orgI,"checkOrg");
      current++;
    }
  }
  for(String tlI:typesOfLeak){
    if(tlI != null && tlI.trim().length() > 0){
      createCheckBox(baseX,baseY+current*(baseH+3),baseW,baseH,tlI,"checkTypeOfLeak");
      current++;
    }
  }
}

void createCheckBox(int _x, int _y, int _w, int _h, String name, String func){
  GCheckbox cb = new GCheckbox(this, _x, _y, _w, _h);
  cb.setSelected(true);
  cb.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  cb.setText(name);
  cb.setOpaque(false);
  cb.addEventHandler(this, func);
}