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

## ---- eval=FALSE--------------------------------------------------------------
#  g <- new ('graphNEL', edgemode='directed')
#  g <- graph::addNode ('A', g)
#  g <- graph::addNode ('B', g)
#  g <- graph::addNode ('C', g)
#  g <- graph::addEdge ('A', 'B', g)
#  g <- graph::addEdge ('B', 'C', g)
#  cw <- CytoscapeWindow ('vignette', graph=g, overwrite=TRUE)
#  displayGraph (cw)
#  layoutNetwork (cw, layout.name='grid')

## -----------------------------------------------------------------------------
#  g <- new ('graphNEL', edgemode='directed')
#  g <- graph::addNode ('A', g)
#  g <- graph::addNode ('B', g)
#  g <- graph::addNode ('C', g)
#  g <- graph::addEdge ('A', 'B', g)
#  g <- graph::addEdge ('B', 'C', g)
#  net.suid <- createNetworkFromGraph (g, 'vignette')

## -----------------------------------------------------------------------------
#  node.df <- data.frame(id=c("A","B","C","D"),
#             stringsAsFactors=FALSE)
#  edge.df <- data.frame(source=c("A","A","A","C"),
#             target=c("B","C","D","D"),
#             interaction=c("inhibits","interacts","activates","interacts"),  # optional
#             stringsAsFactors=FALSE)
#  g <- cyPlot(node.df, edge.df)
#  cw <- CytoscapeWindow("vignette2", g)
#  displayGraph(cw)
#  layoutNetwork(cw, "force-directed")

## -----------------------------------------------------------------------------
#  node.df <- data.frame(id=c("A","B","C","D"),
#             stringsAsFactors=FALSE)
#  edge.df <- data.frame(source=c("A","A","A","C"),
#             target=c("B","C","D","D"),
#             interaction=c("inhibits","interacts","activates","interacts"),  # optional
#             stringsAsFactors=FALSE)
#  net.suid <- createNetworkFromDataFrames (node.df, edge.df, "vignette2")

## ---- eval=FALSE--------------------------------------------------------------
#  g <- initNodeAttribute (graph=g,  attribute.name='moleculeType',
#                              attribute.type='char',
#                              default.value='undefined')
#  g <- initNodeAttribute (graph=g,  'lfc', 'numeric', 0.0)
#  nodeData (g, 'A', 'moleculeType') <- 'kinase'
#  nodeData (g, 'B', 'moleculeType') <- 'TF'
#  nodeData (g, 'C', 'moleculeType') <- 'cytokine'
#  nodeData (g, 'D', 'moleculeType') <- 'cytokine'
#  nodeData (g, 'A', 'lfc') <- -1.2
#  nodeData (g, 'B', 'lfc') <- 1.8
#  nodeData (g, 'C', 'lfc') <- 3.2
#  nodeData (g, 'D', 'lfc') <- 2.2
#  cw = setGraph (cw, g)
#  displayGraph (cw)

## -----------------------------------------------------------------------------
#  node.data <- data.frame(id=c('A','B','C','D'),
#                          moleculeType=c('kinase','TF','cytokine','cytokine'),
#                          lfc=c(-1.2, 1.8, 3.2, 2.2),
#                          stringsAsFactors = FALSE)
#  loadTableData(node.data, 'id')

## ---- eval=FALSE--------------------------------------------------------------
#  setDefaultNodeShape (cw, 'OCTAGON')
#  setDefaultNodeColor (cw, '#AAFF88')
#  setDefaultNodeSize  (cw, 80)
#  setDefaultNodeFontSize (cw, 40)

## -----------------------------------------------------------------------------
#  setNodeShapeDefault ('OCTAGON')
#  setNodeColorDefault ('#AAFF88')
#  setNodeSizeDefault  (80)
#  setNodeFontSizeDefault (40)

## ---- eval=FALSE--------------------------------------------------------------
#  attribute.values <- c ('kinase',  'TF',       'cytokine')
#  node.shapes      <- c ('DIAMOND', 'TRIANGLE', 'RECTANGLE')
#  setNodeShapeRule (cw, 'moleculeType', attribute.values, node.shapes)
#  setNodeColorRule (cw, 'lfc', c (-3.0, 0.0, 3.0),
#                    c ('#00AA00', '#00FF00', '#FFFFFF', '#FF0000', '#AA0000'),
#                    mode='interpolate')
#  control.points = c (-1.2, 2.0, 4.0)
#  node.sizes     = c (30, 40, 60, 80, 90)
#  setNodeSizeRule (cw, 'lfc', control.points, node.sizes, mode='interpolate')

## -----------------------------------------------------------------------------
#  attribute.values <- c ('kinase',  'TF',       'cytokine')
#  node.shapes      <- c ('DIAMOND', 'TRIANGLE', 'RECTANGLE')
#  setNodeShapeMapping('moleculeType', attribute.values, node.shapes)
#  setNodeColorMapping('lfc', c(-3.0, 0.0, 3.0),
#                      c('#00AA00', '#00FF00', '#FFFFFF', '#FF0000', '#AA0000'))
#  control.points = c (-1.2, 2.0, 4.0)
#  node.sizes     = c (30, 40, 60, 80, 90)
#  setNodeSizeMapping('lfc',control.points, node.sizes)

## ---- eval=FALSE--------------------------------------------------------------
#  selectNodes(cw, 'B')
#  nodes <- getSelectedNodes (cw)
#  selectFirstNeighborsOfSelectedNodes (cw)

## -----------------------------------------------------------------------------
#  selectNodes('B', 'name') #or 'id'
#  nodes <- getSelectedNodes()
#  selectFirstNeighbors()

## -----------------------------------------------------------------------------
#  nodes <- selectNodes('B', 'name')$nodes

## ---- eval=FALSE--------------------------------------------------------------
#  saveImage(cw, "sample_image", "png", h = 800)
#  saveNetwork(cw, "sample_session", format = "cys")

## -----------------------------------------------------------------------------
#  exportImage("sample_image", "png", h= 800)
#  saveSession("sample_session")

## -----------------------------------------------------------------------------
#  browseVignettes('RCy3')

