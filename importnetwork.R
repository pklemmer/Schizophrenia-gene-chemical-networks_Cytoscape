install.packages("BiocManager")
BiocManager::install("RCy3")
n
 #'n' added to automatically deny updates in all BiocManager packages
 #'Maybe refine this as probably not all packages are required - takes a few minutes to get started
BiocManager::install("rWikiPathways")
n
#Installing packages
library(RCy3)
library(rWikiPathways)
  #Opening libraries that this script depends on 
setwd("~/GitHub/SCZ-CNV")
cytoscapePing()
cytoscapeVersionInfo()
  #Checking if Cytoscape is running and version info
installApp('WikiPathways')
installApp('CyTargetLinker')
  #Installing required Cytoscape apps to query and expand WikiPathways networks

scz_pathways <- findPathwaysByText("Schizophrenia")
  #Consider using findPathwayIdsByText
  #Querying WikiPathways for relevant pathways using "Schizophrenia as keyword
showresults <- scz_pathways[,"name"]
showresults
  #In case the query needs to be specified further
scz_pathways.ids <- scz_pathways$id
  #Selecting the WP IDs of the relevant pathways (all in this case)
import <- function(i) {commandsRun(paste0('wikipathways import-as-network id=', i))
}
lapply(scz_pathways.ids,import)
  #Opening all the pathways previously selected consecutively - probably not so great if there are a lot of pathways
  #Order is determined by the WP query, in which results are listed according to match scores
add_pathways <- findPathwaysByText("Addiction")
add_pathways[,"name"]

  #import addiction pathways
  #overlay all addiction pathways with all scz pathways and extract interactions
  #group networks together? tidier and easier for overlapping
