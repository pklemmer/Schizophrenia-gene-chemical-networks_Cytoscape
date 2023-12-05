## ---- echo = FALSE------------------------------------------------------------
knitr::opts_chunk$set(
  eval=FALSE
)

## -----------------------------------------------------------------------------
#  if(!"RCy3" %in% installed.packages()){
#      install.packages("BiocManager")
#      BiocManager::install("RCy3")
#  }
#  library(RCy3)

## -----------------------------------------------------------------------------
#  openSession()

## -----------------------------------------------------------------------------
#  setVisualStyle('default')
#  setNodeColorDefault('#D8D8D8')

## -----------------------------------------------------------------------------
#  setNodeCustomBarChart(c("gal1RGexp","gal4RGexp","gal80Rexp"))

## -----------------------------------------------------------------------------
#  setNodeCustomPosition(nodeAnchor = "S", graphicAnchor = "N")

## -----------------------------------------------------------------------------
#  setNodeCustomHeatMapChart(c("gal1RGexp","gal4RGexp","gal80Rexp"), slot = 2)
#  setNodeCustomPosition(nodeAnchor = "N", graphicAnchor = "S", slot = 2)

## -----------------------------------------------------------------------------
#  setNodeCustomPieChart(c("Radiality", "Degree"), slot = 3)
#  setNodeCustomPosition(nodeAnchor = "W", xOffset = -20, slot = 3)

## -----------------------------------------------------------------------------
#  installApp("enhancedGraphics")

## -----------------------------------------------------------------------------
#  all.nodes<-getAllNodes()
#  label.df<-data.frame(all.nodes, "label: attribute=COMMON labelsize=10 color=red outline=false background=false")
#  colnames(label.df)<-c("name","my second label")

## -----------------------------------------------------------------------------
#  loadTableData(label.df, data.key.column = "name", table.key.column = "name")

## -----------------------------------------------------------------------------
#  label.map<-mapVisualProperty('node customgraphics 4','my second label','p')
#  updateStyleMapping('default', label.map)

## -----------------------------------------------------------------------------
#  setNodeCustomPosition(nodeAnchor = "E", graphicAnchor = "C", xOffset = 10, slot = 4)

