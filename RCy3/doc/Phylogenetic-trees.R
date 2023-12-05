## ---- echo = FALSE------------------------------------------------------------
knitr::opts_chunk$set(
  eval=FALSE
)

## ----setup, include=FALSE-----------------------------------------------------
#  knitr::opts_chunk$set(echo = TRUE)

## -----------------------------------------------------------------------------
#  if(!"RCy3" %in% installed.packages()){
#      install.packages("BiocManager")
#      BiocManager::install("RCy3")
#  }
#  library(RCy3)

## -----------------------------------------------------------------------------
#  install.packages('ape')
#  install.packages('phytools')
#  install.packages('igraph')
#  library(ape)
#  library(phytools)
#  library(igraph)

## -----------------------------------------------------------------------------
#  tree <- phytools::read.newick(system.file("extdata","phylotree.newick", package="RCy3"))
#  ig <- ape::as.igraph.phylo(tree, FALSE) # boolean for whether tree is rooted or not
#  ig <- set_edge_attr(ig,'distance', value=tree$edge.length) # set distances as edge attributes

## -----------------------------------------------------------------------------
#  createNetworkFromIgraph(ig, title="phylotree", collection = "phylotree")

## -----------------------------------------------------------------------------
#  layoutNetwork(paste('force-directed',
#                      'defaultEdgeWeight=3',
#                      'defaultSpringCoefficient=5E-5',
#                      'defaultSpringLength=80',
#                      sep = ' '))

## -----------------------------------------------------------------------------
#  createColumnFilter('junctions', 'id', "^Node\\\\d+$", "REGEX")
#  junctions<-getSelectedNodes()
#  setNodeWidthBypass(junctions,1)
#  setNodeHeightBypass(junctions,1)
#  setNodeLabelBypass(junctions, "")

## -----------------------------------------------------------------------------
#  setEdgeLabelMapping('distance')

## -----------------------------------------------------------------------------
#  layoutNetwork(paste('force-directed',
#                      'edgeAttribute="distance"',
#                      'type="1 - normalized value"',
#                      'defaultSpringCoefficient=5E-4',
#                      'defaultSpringLength=50',
#                      sep = ' '))

