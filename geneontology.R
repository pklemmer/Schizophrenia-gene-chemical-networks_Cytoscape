## SETUP -----------------------------------------------------------------------------------------------------------------------

#Requires R 4.3.2. and Rtools 43

setwd("~/GitHub/SCZ-CNV")

packages <- c("gprofiler2","dplyr")
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
  #Checking if required packages are installed and installing if not
invisible(lapply(packages, require, character.only = TRUE))
  #Loading required libraries

clustered_nodetable <- readLines("temp/clustered_nodetable_path.txt",warn=FALSE)
read_clustered_nodetable <- read.csv(clustered_nodetable)
  #Reading the clustered for node table from the save path previously stored in the supernetwork script

## GENE ONTOLOGY ANALYSIS -----------------------------------------------------------------------------------------------------------
read_clustered_nodetable %>% select(c('gLayCluster','Ensembl'))
  #Reading the node table exported earlier for processing with gprofiler and selecting relevant columns
split_df <- split(read_clustered_nodetable$Ensembl,read_clustered_nodetable$gLayCluster)
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

##FILTERING --------------------------------------------------------------------------------------------

go_list_filtered <- go_list[sapply(go_list, function(x) !is.null(x))]
  #Many clusters do not produce any results from the GO analysis (due to significance thresholds), so they are filtered out here 

storeresults <- lapply(seq_along(go_list_filtered), function(i) {
  cluster_dir <- sprintf("GO Output/Cluster_%s",i)
  dir.create(cluster_dir)
  data.table::fwrite(go_list_filtered[[i]]$result, file.path(cluster_dir, "result.csv"), row.names = FALSE)
  saveRDS(go_list_filtered[[i]]$metadata, file.path(cluster_dir,"meta.rds"))
  })
  #Storing the 'result' df and the metadata for each cluster analysed in separate folders per cluster

