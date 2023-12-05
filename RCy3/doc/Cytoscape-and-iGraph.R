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
#  library(igraph)

## -----------------------------------------------------------------------------
#  cytoscapePing()

## -----------------------------------------------------------------------------
#  actors <- data.frame(name=c("Alice", "Bob", "Cecil", "David",
#                              "Esmeralda"),
#                       age=c(48,33,45,34,21),
#                       gender=c("F","M","F","M","F"))
#  relations <- data.frame(from=c("Bob", "Cecil", "Cecil", "David",
#                                 "David", "Esmeralda"),
#                          to=c("Alice", "Bob", "Alice", "Alice", "Bob", "Alice"),
#                          same.dept=c(FALSE,FALSE,TRUE,FALSE,FALSE,TRUE),
#                          friendship=c(4,5,5,2,1,1), advice=c(4,5,5,4,2,3))
#  ig <- graph_from_data_frame(relations, directed=TRUE, vertices=actors)
#  
#  # if function not found, then you need to install igraph. Try library(igraph)

## -----------------------------------------------------------------------------
#  createNetworkFromIgraph(ig,"myIgraph")

## -----------------------------------------------------------------------------
#  ig2 <- createIgraphFromNetwork("myIgraph")

## ---- eval=F------------------------------------------------------------------
#  ig
#  ig2

