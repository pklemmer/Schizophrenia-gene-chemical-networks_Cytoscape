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
#  
#  if(!"RColorBrewer" %in% installed.packages()){
#      install.packages("RColorBrewer")
#  }
#  library(RColorBrewer)

## -----------------------------------------------------------------------------
#  cytoscapePing()

## -----------------------------------------------------------------------------
#  string.cmd = 'string disease query disease="breast cancer" cutoff=0.9 species="Homo sapiens" limit=150'
#  commandsRun(string.cmd)

## -----------------------------------------------------------------------------
#  string.cmd = 'string disease query disease="ovarian cancer" cutoff=0.9 species="Homo sapiens" limit=150'
#  commandsRun(string.cmd)

## -----------------------------------------------------------------------------
#  getNetworkList()

## -----------------------------------------------------------------------------
#  layoutNetwork(layout.name='circular')

## -----------------------------------------------------------------------------
#  getLayoutNames()

## -----------------------------------------------------------------------------
#  getLayoutPropertyNames(layout.name='force-directed')
#  layoutNetwork('force-directed defaultSpringCoefficient=0.0000008 defaultSpringLength=70')

## -----------------------------------------------------------------------------
#  getTableColumnNames('node')

## -----------------------------------------------------------------------------
#  disease.score.table <- getTableColumns('node','stringdb::disease score')
#  disease.score.table

## -----------------------------------------------------------------------------
#  par(mar=c(1,1,1,1))
#  plot(factor(row.names(disease.score.table)),disease.score.table[,1], ylab=colnames(disease.score.table)[1])
#  summary(disease.score.table)

## -----------------------------------------------------------------------------
#  top.quart <- quantile(disease.score.table[,1], 0.75)
#  top.nodes <- row.names(disease.score.table)[which(disease.score.table[,1]>top.quart)]
#  createSubnetwork(top.nodes,subnetwork.name ='top disease quartile')
#  #returns a Cytoscape network SUID

## -----------------------------------------------------------------------------
#  createSubnetwork(edges='all',subnetwork.name='top disease quartile connected')  #handy way to exclude unconnected nodes!

## -----------------------------------------------------------------------------
#  setCurrentNetwork(network="STRING network - ovarian cancer")
#  top.nodes <- row.names(disease.score.table)[tail(order(disease.score.table[,1]),3)]
#  selectNodes(nodes=top.nodes)
#  selectFirstNeighbors()
#  createSubnetwork('selected', subnetwork.name='top disease neighbors') # selected nodes, all connecting edges (default)

## -----------------------------------------------------------------------------
#  setCurrentNetwork(network="STRING network - ovarian cancer")
#  selectNodes(nodes=top.nodes)
#  commandsPOST('diffusion diffuse') # diffusion!
#  createSubnetwork('selected',subnetwork.name = 'top disease diffusion')
#  layoutNetwork('force-directed')

## -----------------------------------------------------------------------------
#  load(system.file("extdata","tutorial-ovc-expr-mean-dataset.robj", package="RCy3"))
#  load(system.file("extdata","tutorial-ovc-mut-dataset.robj", package="RCy3"))
#  load(system.file("extdata","tutorial-brc-expr-mean-dataset.robj", package="RCy3"))
#  load(system.file("extdata","tutorial-brc-mut-dataset.robj", package="RCy3"))

## -----------------------------------------------------------------------------
#  str(brc.expr)  # gene names in row.names of data.frame
#  str(brc.mut)  # gene names in column named 'Hugo_Symbol'

## -----------------------------------------------------------------------------
#  setCurrentNetwork(network="STRING network - breast cancer")
#  layoutNetwork('force-directed') #uses same settings as previously set

## -----------------------------------------------------------------------------
#  ?loadTableData
#  loadTableData(brc.expr,table.key.column = "display name")  #default data.frame key is row.names
#  loadTableData(brc.mut,'Hugo_Symbol',table.key.column = "display name")  #specify column name if not default

## -----------------------------------------------------------------------------
#  style.name = "dataStyle"
#  createVisualStyle(style.name)
#  setVisualStyle(style.name)
#  
#  setNodeShapeDefault("ellipse", style.name) #remember to specify your style.name!
#  setNodeSizeDefault(60, style.name)
#  setNodeColorDefault("#AAAAAA", style.name)
#  setEdgeLineWidthDefault(2, style.name)
#  setNodeLabelMapping('display name', style.name)

## -----------------------------------------------------------------------------
#  brc.expr.network = getTableColumns('node','expr.mean')
#  min.brc.expr = min(brc.expr.network[,1],na.rm=TRUE)
#  max.brc.expr = max(brc.expr.network[,1],na.rm=TRUE)
#  data.values = c(min.brc.expr,0,max.brc.expr)

## -----------------------------------------------------------------------------
#  display.brewer.all(length(data.values), colorblindFriendly=TRUE, type="div") # div,qual,seq,all
#  node.colors <- c(rev(brewer.pal(length(data.values), "RdBu")))

## -----------------------------------------------------------------------------
#  setNodeColorMapping('expr.mean', data.values, node.colors, style.name=style.name)

## -----------------------------------------------------------------------------
#  brc.mut.network = getTableColumns('node','mut_count')
#  min.brc.mut = min(brc.mut.network[,1],na.rm=TRUE)
#  max.brc.mut = max(brc.mut.network[,1],na.rm=TRUE)
#  data.values = c(min.brc.mut,20,max.brc.mut)
#  display.brewer.all(length(data.values), colorblindFriendly=TRUE, type="seq")
#  border.colors <- c(brewer.pal(3, "Reds"))
#  setNodeBorderColorMapping('mut_count',data.values,border.colors,style.name=style.name)
#  border.width <- c(2,4,8)
#  setNodeBorderWidthMapping('mut_count',data.values,border.width,style.name=style.name)

## -----------------------------------------------------------------------------
#  top.mut <- (brc.mut$Hugo_Symbol)[tail(order(brc.mut$mut_count),2)]
#  top.mut
#  selectNodes(nodes=top.mut,'display name')
#  commandsPOST('diffusion diffuse')
#  createSubnetwork('selected',subnetwork.name = 'top mutated diffusion')
#  layoutNetwork('force-directed')

## -----------------------------------------------------------------------------
#  setCurrentNetwork(network="STRING network - ovarian cancer")
#  clearSelection()
#  str(ovc.expr)  # gene names in row.names of data.frame
#  str(ovc.mut)  # gene names in column named 'Hugo_Symbol'
#  
#  loadTableData(ovc.expr, table.key.column = 'display name')
#  loadTableData(ovc.mut,'Hugo_Symbol', table.key.column = 'display name')

## -----------------------------------------------------------------------------
#  setVisualStyle(style.name=style.name)

## -----------------------------------------------------------------------------
#  saveSession('tutorial_session') #.cys

## -----------------------------------------------------------------------------
#  exportImage(filename='tutorial_image2', type = 'PDF') #.pdf
#  ?exportImage

