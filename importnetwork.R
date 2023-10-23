# SETUP -----------------------------------------------------------------------------------------------------------------------
setwd("~/GitHub/SCZ-CNV")
sessionInfo()
  #Requires R 4.1.3 and Rtools 4.0
  #dplyr 1.1.2; httr 1.4.7;jsonlite 1.8.4; BiocManager 1.30.22; rWikiPathways 1.14.0; RCy3 2.14.2
  #Cytoscape 3.10.1
file.create("sessioninfo.txt")
writeLines(capture.output(sessionInfo()),"sessionInfo.txt")
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
installApp('BridgeDb')
  #v. 1.2.0
  #Using the Homo sapiens 'Hs_Derby_Ensembl_108' from 2023-03-31 from BridgeDb


# FUNCTION DICTIONARY-------------------------------------------------------------------------------------------------------------------

getPathways.wp<- function(i) {
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
  #Getting the name of the node table of the previously imported network with following nomenclature [Network name default node] (note the single space between "default" and "node")
  commandsRun(sprintf("table create column columnName=WikiPathways table=%s type=string",nodetable))
  commandsRun(sprintf("table create column columnName=DisGeNET table=%s type=string",nodetable))
  commandsRun(sprintf("table create column columnName=PharmGKB table=%s type=string",nodetable))
  commandsRun(sprintf("table create column columnName=Literature table=%s type=string",nodetable))
  #Creating a new column for each source used for all networks
  commandsRun(sprintf("table set values columnName=%1$s handleEquations=false rowList=all table=%2$s value=1",source,nodetable))
  #Filling the new column of the corresponding source with 1 to indicate which source the node is imported from 
}
  #Function to create new column in node table specifying origin of network/node

createNodeSource.wp <- function(source) {
  networkname <- getNetworkName()
  nodetable <- paste0(networkname," default  node")
  #Getting the name of the node table of the previously imported network with following nomenclature [Network name default  node] (note the two spaces between "default" and "node")
  commandsRun(sprintf("table create column columnName=WikiPathways table=%s type=string",nodetable))
  commandsRun(sprintf("table create column columnName=DisGeNET table=%s type=string",nodetable))
  commandsRun(sprintf("table create column columnName=PharmGKB table=%s type=string",nodetable))
  commandsRun(sprintf("table create column columnName=Literature table=%s type=string",nodetable))
  #Creating a new column for each source used for all networks
  commandsRun(sprintf("table set values columnName=%1$s handleEquations=false rowList=all table=%2$s value=1",source,nodetable))
  #Filling the new column of the corresponding source with 1 to indicate which source the node is imported from 
}
  #Same function, but for WikiPathways imports as these have a typo in the designation of node tables

mapToEnsembl <- function(col,from) {
  mapTableColumn(col,"Human",from,"Ensembl")
}
  #Mapping node table columns such as name to Ensembl identifiers for consistent merging 

import <- function(j) {
  commandsRun(paste0('wikipathways import-as-network id=', j))
    #Pasting WikiPathways IDs into a Cytoscape command line prompt to import as networks
  createNodeSource.wp("WikiPathways")
    #Filling the 'WikiPathways' column with 1 to indicate the source
}
  #Importing pathways from WikiPathways by pathway ID

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

# METADATA ============================================================================================================================
metadata <- "metadata.txt"
file.create(metadata)
metadata.add <- function(info) {
  write(as.character(info), "metadata.txt",append=TRUE, sep = "\n")
}
metadata.add(Sys.timezone())
metadata.add(Sys.time())
# SCHIZOPHRENIA =======================================================================================================================
## IMPORTING AND MERGING ---------------------------------------------------------------------------------------------------------------

genedisparams.scz.df <- read.table("CSVs/disgenetparams-scz.txt",header=TRUE,sep = "\t")
  #Loading relevant gene-disease networks from DisGeNET
  #Networks of interest manually added into tsv where it is easier to adjust filters
apply(genedisparams.scz.df,1,function(row) {
  gdp <- geneDisParams(row["source"],row["dis"],row["min"])
  geneDisResult <- disgenetRestCall("gene-disease-net",gdp)
  createNodeSource("DisGeNET")
    #Adding information about data source to each node
  mapToEnsembl("geneName","HGNC")
    #Mapping the HGNC gene name from the geneName column in the node table to Ensembl identifiers
})
  #Importing networks from DisGeNET
wpids <- c("4875","5412","4222","4942","5408","5402","5346","5405","5406","5407","4940","4905","5398","5399","4906","4657","4932")
sczcnv <- sapply(wpids, function(k) paste0("WP",k))
  #Manually adding relevant SCZ CNV pathways from WikiPathways

getPathways.wp("Schizophrenia")
lapply(c(Schizophrenia_wpids,sczcnv), import)
  #Importing WP pathways (both manually added and by keyword). Also adds "WikiPathways" as NodeSource column to node table

commandsRun(sprintf("network import file columnTypeList='sa,sa,source,sa,sa,sa,sa' file=%s firstRowAsColumnNames=true rootNetworkList=-- Create new network collection -- startLoadRow=1", paste0(getwd(),"/CSVs/scz2022-Extended-Data-Table1.txt")))
  #Importing network from file
  #List of 120 genes implicated in Trubetskoy et al., doi: 10.1038/s41586-022-04434-5
commandsRun("table rename column columnName=Ensembl.ID newColumnName=Ensembl table=scz2022-Extended-Data-Table1.txt default node")
  #Renaming the Ensembl.ID column from the dataset to Ensembl for coherence with networks from other sources
createNodeSource("Literature")
  #Adding literature as  source to all imported nodes 
renameNetwork("Trubetskoy risk genes")
  #Renaming the newly imported network


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
  mergeNetworks(c(current,networklist[[i]]), paste(current,networklist[[i]]),"union",inNetworkMerge = TRUE,nodeKeys=c("Ensembl","Ensembl"))
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
commandsRun("string stringify column=Ensembl compoundQuery=TRUE cutoff=0.4 includeNotMapped=false networkNoGui=current networkType='full STRING network' species='Homo sapiens'")
  #compoundQuery=false for now due to problem connecting to STITCH
## SAVING ------------------------------------------------------------------------------------------------------------------------------

preserve <- c(snw_scz, snw_scz_ext)

# ADDICTION ===========================================================================================================================
## IMPORTING AND MERGING --------------------------------------------------------------------------------------------------------------
genedisparams.adc.df <- read.table("CSVs/disgenetparams-adc.txt",header=TRUE,sep = "\t")
  #Loading relevant gene-disease networks from DisGeNET
  #Networks of interest manually added into tsv where it is easier to adjust filters
apply(genedisparams.adc.df,1,function(row) {
  gdp <- geneDisParams(row["source"],row["dis"],row["min"])
  geneDisResult <- disgenetRestCall("gene-disease-net",gdp)
  createNodeSource("DisGeNET")
  mapToEnsembl("geneName","HGNC")
})

getPathways.wp("Dopamine")
getPathways.wp("Addiction")
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
setCurrentNetwork(networklist[[1]])
for(i in 1:length(networklist)) tryCatch({
  current <- getNetworkName()
  mergeNetworks(c(current,networklist[[i]]), paste(current,networklist[[i]]),"union",inNetworkMerge = TRUE,nodeKeys=c("Ensembl","Ensembl"))
}, error = function(e) {
  cat("An error occured:\n")
  cat("Error message: ", conditionMessage(e),"\n")
  cat("Call stack:\n")
  print(sys.calls())
})
#Looping through the network list to merge all currently open networks with each other, creating one large unified network

renameNetwork("Addiction supernetwork")
networklist <- getNetworkList()
snw_adc <- getNetworkName()
  #Getting the name of the unified network to preserve it from deletion
lapply(networklist[networklist != snw_adc ],deleteNetwork)
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
## PharmGKB ----------------------------------------------------------------------------------------------------------------------------
pgkb.import <- function(pgkb_id,pgkb_name) {
  url = sprintf("https://api.pharmgkb.org/v1/download/pathway/%s?format=.tsv", pgkb_id)
  pgkb_name <- paste0(pgkb_name,".tsv")
  download.file(url, sprintf("PharmGKB pathways/%s",pgkb_name))
  commandsRun(sprintf("network import file indexColumnSourceInteraction=From indexColumnTargetInteraction=To file=PharmGKB pathways/%s",pgkb_name))
}
pgkb.import("PA166170742","Antipsychotics pathway")
## SAVING ------------------------------------------------------------------------------------------------------------------------------

preserve <- c(snw_scz, snw_scz_ext,snw_adc,snw_adc_ext)

# WIP ==================================================================================================================================


## INTERSECTION -----------------------------------------------------------------------------------------------------------------------

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






