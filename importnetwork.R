# SETUP -----------------------------------------------------------------------------------------------------------------------
sessionInfo()
  #Requires R 4.1.3 and Rtools 4.0
  #dplyr 1.1.2; httr 1.4.7;jsonlite 1.8.4; BiocManager 1.30.22; rWikiPathways 1.14.0; RCy3 2.14.2
  #Cytoscape 3.10.1
setwd("~/GitHub/SCZ-CNV")
packages <- c("dplyr","httr","jsonlite")
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
if(!"rWikiPathways" %in% installed.packages()){
  if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager")
  BiocManager::install("rWikiPathways")
}
if(!"RCy3" %in% installed.packages()){
  if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager")
  BiocManager::install("RCy3")
}
  #Checking if required packages are installed and installing if not
invisible(lapply(c(packages,"rWikiPathways","RCy3"), require, character.only = TRUE))
  #Loading libraries

cytoscapePing()
cytoscapeVersionInfo()
  #Checking if Cytoscape is running and version info
installApp('WikiPathways')
  #v. 3.3.10
installApp('DisGeNET-app')
  #Using DisGeNET app for the first time requires the user to define the directory for the database file
  #v. 7.3.0
installApp('CyTargetLinker')
  #v. 4.1.0
installApp('stringApp')
  #v. 2.0.1
  #Installing required Cytoscape apps to query and expand WikiPathways networks

# FUNCTIONS------------------------------------------------------------------------------------------------------------------------

getpathways.wp<- function(i) {
  pw <- findPathwaysByText(i)
  pw <- pw %>%
    dplyr::filter(species %in% c("Homo sapiens","Rattus norvegicus","Mus musculus"))
    #Filtering by species
  pw.ids <- paste0(i, "_wpids")
  assign(pw.ids, as.character(pw$id),envir = .GlobalEnv)
    #Extracting WP IDs
}
  #Function to query WikiPathways using keyword and to extract WP IDs for the import function

createNodeSource <- function(source) {
  networkname <- getNetworkName()
  nodetable <- paste0(networkname," default node")
  #Getting the name of the node table of the previously imported network with following nomenclature [Network name - species default node] (note the single space between "default" and "node")
  commandsRun(sprintf("table create column columnName=NodeSource table=%s type=string",nodetable))
  #Creating a new column named "NodeSource" in which the source of the node is stored 
  commandsRun(sprintf("table set values columnName=NodeSource handleEquations=false rowList=all table=%1$s value=%2$s",nodetable,source))
  #Filling the new "NodeSource" column with the source 
}
  #Function to create new column in node table specifying origin of network/node

createNodeSource.wp <- function(source) {
  networkname <- getNetworkName()
  nodetable <- paste0(networkname," default  node")
  #Getting the name of the node table of the previously imported network with following nomenclature [Network name - species default  node] (note the two spaces between "default" and "node")
  commandsRun(sprintf("table create column columnName=NodeSource table=%s type=string",nodetable))
  #Creating a new column named "NodeSource" in which the source of the node is stored 
  commandsRun(sprintf("table set values columnName=NodeSource handleEquations=false rowList=all table=%1$s value=%2$s",nodetable,source))
  #Filling the new "NodeSource" column with the source 
}
  #Same function, but for WikiPathways imports as these have a typo in the designation of node tables


import <- function(j) {
  commandsRun(paste0('wikipathways import-as-network id=', j))
    #Pasting WikiPathways IDs into a Cytoscape command line prompt to import as networks
  createNodeSource.wp("WikiPathways")
}

disgenetRestUrl<-function(netType,host="127.0.0.1",port=1234,version="v7"){
  if(is.null(netType)){
    print("Network type not specified.")
  }else{
    url<-sprintf("http://%s:%i/disgenet/%s/%s",host,port,version,netType)
  }
  return (url)
}
disgenetRestUrl(netType = "gene-disease-net")
  #Defining object for REST to call DisGeNET automation module; defining that we will be using gene-disease associations (GDA)
disgenetRestCall<-function(netType,netParams){
  url<-disgenetRestUrl(netType)
  restCall<-POST(url, body = netParams, encode = "json")
  result<-content(restCall,"parsed")
  return(result)
}
  #Object that executes REST calls to DisGeNET module in Cytoscape 
geneDisParams <- function(source,dis,min) {list(
  source = source,
  assocType = "Any",
  diseaseClass = "Any",
  diseaseSearch = dis,
  geneSearch = " ",
  initialScoreValue = min,
  finalScoreValue = "1.0"
)}
  #Specifying parameters of the GDA network to be imported

# SCHIZOPHRENIA =======================================================================================================================
## IMPORTING AND MERGING ---------------------------------------------------------------------------------------------------------------

genedisparams_scz_df <- read.table("CSVs/disgenetparams-scz.txt",header=TRUE,sep = "\t")
  #Loading relevant gene-disease networks from DisGeNET
  #Networks of interest manually added into tsv where it is easier to adjust filters
apply(genedisparams_scz_df,1,function(row) {
  gdp <- geneDisParams(row["source"],row["dis"],row["min"])
  geneDisResult <- disgenetRestCall("gene-disease-net",gdp)
  createNodeSource("DisGeNET")
})
  #Importing networks from DisGeNET
wpids <- c("4875","5412","4222","4942","5408","5402","5346","5405","5406","5407","4940","4905","5398","5399","4906","4657","4932")
sczcnv <- sapply(wpids, function(k) paste0("WP",k))
  #Manually adding relevant SCZ CNV pathways from WikiPathways

getpathways.wp("Schizophrenia")
lapply(c(Schizophrenia_wpids,sczcnv), import)
  #Importing WP pathways (both manually added and by keyword). Also adds "WikiPathways" as NodeSource column to node table

networklist.dup <- getNetworkList()
dup.filter <- function(input,suffix) {
  filtered_list <- input[substr(input, nchar(input) - 1,nchar(input))==suffix]
}
duplicates <- dup.filter(networklist.dup,"_1")
  #Getting duplicate networks (Cytoscape marks duplicate networks with a "_1" suffix to the network name)
delete.dupes <- function(nw) {
  setCurrentNetwork(nw)
  deleteNetwork()
}
lapply(duplicates,delete.dupes)
  #Selecting and deleting duplicate networks

networklist <- getNetworkList()
setCurrentNetwork(networklist[[1]])
for(i in 1:length(networklist)) {
  current <- getNetworkName()
  mergeNetworks(c(current,networklist[[i]]), paste(current,networklist[[i]]),"union")
}
  #Looping through the network list to merge all currently open networks with each other, creating one large unified network
renameNetwork("Schizophrenia supernetwork")
networklist <- getNetworkList()
snw_scz <- getNetworkName()
  #Getting the name of the unified network to preserve it from deletion
lapply(networklist[networklist != snw_scz],deleteNetwork)
  #Deleting all networks besides newly generated unified network

## CTL EXTENSION ----------------------------------------------------------------------------------------------------------------------
setCurrentNetwork(snw_scz)
hsa <- file.path(getwd(), "Linksets", "wikipathways-20220511-hsa-WP.xgmml")
hsa_react <- file.path(getwd(), "Linksets", "wikipathways-20220511-hsa-REACTOME.xgmml")
  #Loading the WikiPathways linksets available at https://cytargetlinker.github.io/pages/linksets/wikipathways
CTLextend.cmd = paste('cytargetlinker extend idAttribute="XrefId" linkSetFiles="', hsa, ',', hsa_react, '" network=current direction=TARGETS', sep="")
commandsRun(CTLextend.cmd)
  #Extending the network with previously loaded linksets
layoutNetwork()
  #Adding basic network layout
snw_scz_ext <- getNetworkName()
  
## STRINGIFY --------------------------------------------------------------------------------------------------------------------------
setCurrentNetwork(snw_scz)
commandsRun("string stringify column=name compoundQuery=false cutoff=0.4 includeNotMapped=false networkNoGui=current networkType='full STRING network' species='Homo sapiens'")
  #compoundQuery=false for now due to problem connecting to STITCH
## SAVING ------------------------------------------------------------------------------------------------------------------------------

preserve <- c(snw_scz, snw_scz_ext)

# ADDICTION ===========================================================================================================================
## IMPORTING AND MERGING --------------------------------------------------------------------------------------------------------------
genedisparams_adc_df <- read.table("CSVs/disgenetparams-adc.txt",header=TRUE,sep = "\t")
  #Loading relevant gene-disease networks from DisGeNET
  #Networks of interest manually added into tsv where it is easier to adjust filters
apply(genedisparams_adc_df,1,function(row) {
  gdp <- geneDisParams(row["source"],row["dis"],row["min"])
  geneDisResult <- disgenetRestCall("gene-disease-net",gdp)
  createNodeSource("DisGeNET")
})

getpathways.wp("Dopamine")
getpathways.wp("Addiction")
lapply(c(Dopamine_wpids,Addiction_wpids), import)

networklist.dup <- getNetworkList()
dup.filter <- function(input,suffix) {
  filtered_list <- input[substr(input, nchar(input) - 1,nchar(input))==suffix]
}
duplicates <- dup.filter(networklist.dup,"_1")
  #Getting duplicate networks (Cytoscape marks duplicate networks with a "_1" suffix to the network name)
delete.dupes <- function(nw) {
  setCurrentNetwork(nw)
  deleteNetwork()
}
lapply(duplicates,delete.dupes)
  #Selecting and deleting duplicate networks

networklist <- getNetworkList()
networklist <- networklist[!networklist %in% preserve]
  #Getting all networks besides the big SCZ networks
setCurrentNetwork(networklist[[2]])
for(i in 1:length(networklist)) tryCatch({
  current <- getNetworkName()
  mergeNetworks(c(current,networklist[[i]]), paste(current,networklist[[i]]),"union")
}, error = function(e) {
  cat("An error occured:\n")
  cat("Error message: ", conditionMessage(e),"\n")
  cat("Call stack:\n")
  print(sys/calls())
})
#Looping through the network list to merge all currently open networks with each other, creating one large unified network

renameNetwork("Addiction supernetwork")
networklist <- getNetworkList()
snw_adc <- getNetworkName()
preserve <- c(snw_scz, snw_scz_ext,snw_adc)
  #Getting the name of the unified network to preserve it from deletion
lapply(networklist[!networklist %in% preserve],deleteNetwork)
  #Deleting all networks besides newly generated unified networks

## CTL EXTENSION -----------------------------------------------------------------------------------------------------------------------

hsa <- file.path(getwd(), "Linksets", "wikipathways-20220511-hsa-WP.xgmml")
hsa_react <- file.path(getwd(), "Linksets", "wikipathways-20220511-hsa-REACTOME.xgmml")
  #Loading the WikiPathways linksets available at https://cytargetlinker.github.io/pages/linksets/wikipathways
CTLextend.cmd = paste('cytargetlinker extend idAttribute="XrefId" linkSetFiles="', hsa, ',', hsa_react, '" network=current direction=TARGETS', sep="")
commandsRun(CTLextend.cmd)
  #Extending the network with previously loaded linksets
layoutNetwork()
  #Adding basic network layout
snw_adc_ext <- getNetworkName()

## STRINGIFY ---------------------------------------------------------------------------------------------------------------------------
setCurrentNetwork(snw_adc)
commandsRun("string stringify column=name compoundQuery=false cutoff=0.4 includeNotMapped=false networkNoGui=current networkType='full STRING network' species='Homo sapiens'")
## SAVING ------------------------------------------------------------------------------------------------------------------------------

preserve <- c(snw_scz, snw_scz_ext,snw_adc,snw_adc_ext)

# WIP ==================================================================================================================================
url = "https://api.pharmgkb.org/v1/download/pathway/PA166170742?format=.tsv"
download.file(url, "PharmGKB pathways/antipsychotics-pw-pharmgkb.csv")



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






