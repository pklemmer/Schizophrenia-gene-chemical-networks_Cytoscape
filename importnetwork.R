sessionInfo()
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
library(dplyr)
  #Opening libraries that this script depends on 
setwd("~/GitHub/SCZ-CNV")
cytoscapePing()
cytoscapeVersionInfo()
  #Checking if Cytoscape is running and version info
installApp('WikiPathways')
installApp('CyTargetLinker')
  #Installing required Cytoscape apps to query and expand WikiPathways networks

scz_pathways <- findPathwaysByText("Schizophrenia")
  #Querying WikiPathways for relevant pathways using "Schizophrenia" as keyword
scz_pathways <- scz_pathways %>%
    dplyr::filter(species == c("Homo sapiens","Rattus norvegicus","Mus musculus"))
  #Filtering by species
scz_pathways.ids <- scz_pathways$id
  #Selecting the WP IDs of the relevant pathways

adc_pathways <- findPathwaysByText("Addiction")
adc_pathways <- adc_pathways %>%
  dplyr::filter(species == c("Homo sapiens", "Rattus norvegicus", "Mus musculus"))
adc_pathways.ids <- adc_pathways$id
  #Finding and importing addiction pathways 

#Filter doesn't work for SCZ if mouse is added but works fine for adc pathways ??
#Filter works but somehow doesn't extract all the pathways it could

import <- function(i) {commandsRun(paste0('wikipathways import-as-network id=', i))
}

lapply(scz_pathways.ids,import)
lapply(adc_pathways.ids,import)  
  #Opening all the pathways previously selected consecutively - probably not so great if there are a lot of pathways
  #Order is determined by the WP query, in which results are listed according to match scores

scz_pathways.names <- scz_pathways$name
adc_pathways.names <- adc_pathways$name

intersect_matrix <- expand.grid(scz_pathways.names, adc_pathways.names)
  #Matching every SCZ pathway against every addiction pathway to detect all interactions

merge.intersect <- function(j) {
  col1 <- j[,1]
  col2 <- j[,2]
  intersection <- mergeNetworks(c("col1","col2"), "test", operation = "intersection")
}

intersections <- merge.intersect(intersect_matrix)


  #overlay all addiction pathways with all scz pathways and extract interactions
  #group networks together? tidier and easier for overlapping
