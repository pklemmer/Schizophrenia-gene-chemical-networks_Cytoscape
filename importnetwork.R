sessionInfo()
  #Requires R 4.1.3 and Rtools 4.0
  #dplyr v.1.1.2; BiocManager v. 1.30.22; rWikiPathways 1.14.0; RCy3 2.14.2
setwd("~/GitHub/SCZ-CNV")
packages <- c("dplyr")
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
if(!"rWikiPathways" %in% installed.packages()){
  if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager")
  BiocManager::install("rWikiPathways")
}
n
if(!"RCy3" %in% installed.packages()){
  if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager")
  BiocManager::install("RCy3")
}
n
  #'n' is to deny BiocManager packages updadates
invisible(lapply(c("dplyr","rWikiPathways","RCy3"), require, character.only = TRUE))

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
  #RCy3 command to import queried pathways as networks by network WP ID
lapply(scz_pathways.ids,import)
lapply(adc_pathways.ids,import)  
  #Opening all the pathways previously selected consecutively

scz_pathways.names <- paste(scz_pathways$name, scz_pathways$species, sep = " - ")
adc_pathways.names <- paste(adc_pathways$name, adc_pathways$species, sep = " - ")
  #Getting the names of the pathways as shown in Cytoscape, which includes the species 

intersect_df <- expand.grid(scz_pathways.names, adc_pathways.names)
intersect_df <- as.data.frame(lapply(intersect_df, as.character))
  #Matching every SCZ pathway against every addiction pathway to detect all interactions and forcing entries to be characters (required for mergeNetwork)
intersect <- function(row) {
  col1 <- row[1]
  col2 <- row[2]
  mergeNetworks(c(col1,col2),(paste(col1,col2, sep =  " - ")),"intersection")
  getIntersections <- as.character(getAllNodes())
  #Getting the nodes resulting in the intersection networks
  list(intersection_names = paste(getIntersections,collapse = ", "))
  #Extracting the names of these nodes and making them more legible
    #Merging networks with 'intersect' parameter
}
df_results <- apply(intersect_df,1,intersect)
intersection_names <- sapply(df_results, function(x) x$intersection_names)
intersect_df$intersection_names <- intersection_names
  #Adding the intersections to a new column in the df 
intersect_df <- intersect_df %>% mutate_all(~na_if(.,""))
  #Some pathways do not have any overlaps, so the field in the df is marked as NA
intersect_df <- cbind(intersect_df, scz_pathways.ids, adc_pathways.ids)
intersect_df <- intersect_df %>%
  select (scz_pathways.ids,Var1, adc_pathways.ids,Var2,intersection_names)
names(intersect_df) <- c("SCZ WP ID","SCZ pathway","ADC WP ID","Addiction pathway", "Intersections")
  #Reordering and renaming the df columns for easier reading

View(intersect_df)
write.csv(intersect_df, file = "CSVs/Intersections.csv")






