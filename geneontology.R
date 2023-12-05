## SETUP -----------------------------------------------------------------------------------------------------------------------

#Requires R 4.3.2. and Rtools 43

setwd("~/GitHub/SCZ-CNV")
rm(list=ls())
  #Cleaning up workspace

packages <- c("gprofiler2","dplyr")
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
  #Checking if required packages are installed and installing if not
invisible(lapply(packages, require, character.only = TRUE))
  #Loading required libraries

valid_clustered_nodetable <- readLines("temp/valid_clustered_nodetable_path.txt",warn=FALSE)
read_valid_clustered_nodetable <- read.csv(valid_clustered_nodetable)
  #Reading the clustered for node table from the save path previously stored in the supernetwork script

## GENE ONTOLOGY ANALYSIS -----------------------------------------------------------------------------------------------------------
read_valid_clustered_nodetable %>% select(c('gLayCluster','Ensembl'))
  #Reading the node table exported earlier for processing with gprofiler and selecting relevant columns
split_df <- split(read_valid_clustered_nodetable$Ensembl,read_valid_clustered_nodetable$gLayCluster)
split_list <- lapply(split_df, as.vector)
  #Splitting the node table by cluster number, i.e. lists of Ensembl IDs are created per cluster
go <- function(cluster) {
  gost(
    query = cluster,
    organism = "hsapiens",
    ordered_query = FALSE,
    multi_query = TRUE,
    significant = TRUE,
    exclude_iea = FALSE,
    measure_underrepresentation = FALSE,
    evcodes = FALSE,
    user_threshold = 0.05,
    correction_method = "g_SCS",
    domain_scope ="annotated",
    custom_bg = NULL,
    numeric_ns = "",
    sources = NULL,
    as_short_link = FALSE,
    highlight = TRUE
  )
}
go_list <- lapply(split_list,go)
  #Iterating the gost GO function over all clusters
dir.create("GO Output")
save(go_list,file="GO Output/go_list.Rdata")
saveRDS(go_list, file="GO Output/go_list.rds")
  #Saving the entire generated GO analysis as R object locally
