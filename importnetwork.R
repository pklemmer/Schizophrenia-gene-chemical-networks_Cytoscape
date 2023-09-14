sessionInfo()
setwd("~/GitHub/SCZ-CNV")
install.packages("BiocManager")
BiocManager::install("RCy3")
BiocManager::install("rWikiPathways")
#Installing packages
library(RCy3)
library(rWikiPathways)
library(dplyr)
  #Opening libraries this script depends on 

cytoscapePing()
cytoscapeVersionInfo()
  #Checking if Cytoscape is running and version info
installApp('WikiPathways')
installApp('CyTargetLinker')
  #Installing required Cytoscape apps to query and expand WikiPathways networks

scz_pathways <- findPathwaysByText("Schizophrenia")
  #Querying WikiPathways for relevant pathways using "Schizophrenia" as keyword
scz_pathways <- scz_pathways %>%
  dplyr::filter(species %in% c("Homo sapiens", "Rattus norvegicus", "Mus musculus"))
  #Filtering by species
scz_pathways.ids <- scz_pathways$id
  #Selecting the WP IDs of the relevant pathways

adc_pathways <- findPathwaysByText("Addiction")
adc_pathways <- adc_pathways %>%
  dplyr::filter(species %in% c("Homo sapiens", "Rattus norvegicus", "Mus musculus"))
adc_pathways.ids <- adc_pathways$id
  #Finding addiction pathways 

import <- function(i) 
  {commandsRun(paste0('wikipathways import-as-network id=', i))
}

lapply(scz_pathways.ids,import)
lapply(adc_pathways.ids,import)  
  #Opening all the pathways previously selected consecutively - probably not so great if there are a lot of pathways

scz_pathways.names <- scz_pathways$name
adc_pathways.names <- adc_pathways$name

intersect_df <- expand.grid(scz_pathways.names, adc_pathways.names)
  #Matching every SCZ pathway against every addiction pathway to detect all interactions


intersect <- function(j) {
  mergeNetworks(c(j[,1],j[,2]), "test","intersection")
}


a <- as.character(intersect_df[1,1])
b <- as.character(intersect_df[2,1])

mergeNetworks(c(a,b),"test","intersection")
mergeNetworks(c("Disruption of postsynaptic signaling by CNV - Homo sapiens","Opioid receptor pathways - Homo sapiens"),"test")
  #overlay all addiction pathways with all scz pathways and extract interactions
  #group networks together? tidier and easier for overlapping
