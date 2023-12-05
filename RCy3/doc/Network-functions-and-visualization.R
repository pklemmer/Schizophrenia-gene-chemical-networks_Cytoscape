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
#  if(!"igraph" %in% installed.packages()){
#      install.packages("igraph")
#  }
#  library(igraph)
#  if(!"plyr" %in% installed.packages()){
#      install.packages("plyr")
#  }
#  library(plyr)

## -----------------------------------------------------------------------------
#  cytoscapePing()

## -----------------------------------------------------------------------------
#  lesmis <- system.file("extdata","lesmis.txt", package="RCy3")
#  dataSet <- read.table(lesmis, header = FALSE, sep = "\t")

## -----------------------------------------------------------------------------
#  gD <- igraph::simplify(igraph::graph.data.frame(dataSet, directed=FALSE))

## -----------------------------------------------------------------------------
#  igraph::vcount(gD)
#  igraph::ecount(gD)

## -----------------------------------------------------------------------------
#  degAll <- igraph::degree(gD, v = igraph::V(gD), mode = "all")

## -----------------------------------------------------------------------------
#  betAll <- igraph::betweenness(gD, v = igraph::V(gD), directed = FALSE) / (((igraph::vcount(gD) - 1) * (igraph::vcount(gD)-2)) / 2)
#  betAll.norm <- (betAll - min(betAll))/(max(betAll) - min(betAll))
#  rm(betAll)

## -----------------------------------------------------------------------------
#  dsAll <- igraph::similarity.dice(gD, vids = igraph::V(gD), mode = "all")

## -----------------------------------------------------------------------------
#  gD <- igraph::set.vertex.attribute(gD, "degree", index = igraph::V(gD), value = degAll)
#  gD <- igraph::set.vertex.attribute(gD, "betweenness", index = igraph::V(gD), value = betAll.norm)

## -----------------------------------------------------------------------------
#  summary(gD)

## -----------------------------------------------------------------------------
#  F1 <- function(x) {data.frame(V4 = dsAll[which(igraph::V(gD)$name == as.character(x$V1)), which(igraph::V(gD)$name == as.character(x$V2))])}
#  dataSet.ext <- plyr::ddply(dataSet, .variables=c("V1", "V2", "V3"), function(x) data.frame(F1(x)))
#  
#  gD <- igraph::set.edge.attribute(gD, "weight", index = igraph::E(gD), value = 0)
#  gD <- igraph::set.edge.attribute(gD, "similarity", index = igraph::E(gD), value = 0)

## -----------------------------------------------------------------------------
#  for (i in 1:nrow(dataSet.ext))
#  {
#      igraph::E(gD)[as.character(dataSet.ext$V1) %--% as.character(dataSet.ext$V2)]$weight <- as.numeric(dataSet.ext$V3)
#      igraph::E(gD)[as.character(dataSet.ext$V1) %--% as.character(dataSet.ext$V2)]$similarity <- as.numeric(dataSet.ext$V4)
#  }
#  rm(dataSet,dsAll, i, F1)

## -----------------------------------------------------------------------------
#  summary(gD)

## -----------------------------------------------------------------------------
#  createNetworkFromIgraph(gD,new.title='Les Miserables')

## -----------------------------------------------------------------------------
#  getLayoutNames()

## -----------------------------------------------------------------------------
#  getLayoutPropertyNames("fruchterman-rheingold")

## -----------------------------------------------------------------------------
#  layoutNetwork('fruchterman-rheingold gravity_multiplier=1 nIterations=10')

## -----------------------------------------------------------------------------
#  layoutNetwork('force-directed defaultSpringLength=70 defaultSpringCoefficient=0.000003')

## -----------------------------------------------------------------------------
#  setNodeColorMapping('degree', c(min(degAll), mean(degAll), max(degAll)), c('#F5EDDD', '#F59777', '#F55333'))
#  lockNodeDimensions(TRUE)
#  setNodeSizeMapping('betweenness', c(min(betAll.norm), mean(betAll.norm), max(betAll.norm)), c(30, 60, 100))

## -----------------------------------------------------------------------------
#  setEdgeLineWidthMapping('weight', c(min(as.numeric(dataSet.ext$V3)), mean(as.numeric(dataSet.ext$V3)), max(as.numeric(dataSet.ext$V3))), c(1,3,5))
#  setEdgeColorMapping('weight', c(min(as.numeric(dataSet.ext$V3)), mean(as.numeric(dataSet.ext$V3)), max(as.numeric(dataSet.ext$V3))), c('#BBEE00', '#77AA00', '#558800'))

## -----------------------------------------------------------------------------
#  setBackgroundColorDefault('#D3D3D3')
#  setNodeBorderColorDefault('#000000')
#  setNodeBorderWidthDefault(3)
#  setNodeShapeDefault('ellipse')
#  setNodeFontSizeDefault(20)
#  setNodeLabelColorDefault('#000000')

## -----------------------------------------------------------------------------
#  cytoscapeVersionInfo()

## -----------------------------------------------------------------------------
#  sessionInfo()

