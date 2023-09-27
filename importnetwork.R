sessionInfo()
  #Requires R 4.1.3 and Rtools 4.0
  #dplyr 1.1.2; httr 1.4.7; BiocManager 1.30.22; rWikiPathways 1.14.0; RCy3 2.14.2
setwd("~/GitHub/SCZ-CNV")
packages <- c("dplyr","httr")
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
invisible(lapply(c("dplyr","httr","rWikiPathways","RCy3"), require, character.only = TRUE))

cytoscapePing()
cytoscapeVersionInfo()
  #Checking if Cytoscape is running and version info
  #Script tested using v. 3.10.1
installApp('WikiPathways')
  #v. 3.3.10
installApp('DisGeNET-app')
  #Using DisGeNET app for the first time requires the user to define the directory for the database file
  #v. 7.3.0
installApp('CyTargetLinker')
  #v. 4.1.0
  #Installing required Cytoscape apps to query and expand WikiPathways networks

getpathways.wp<- function(i) {
  pw <- findPathwaysByText(i)
  pw <- pw %>%
    dplyr::filter(species %in% c("Homo sapiens","Rattus norvegicus","Mus musculus"))
  pw.ids <- paste0(i, "_wpids")
  assign(pw.ids, as.character(pw$id),envir = .GlobalEnv)
}
  #Function to query WikiPathways using keyword and to extract WP IDs for the import function

import <- function(j) {
  commandsRun(paste0('wikipathways import-as-network id=', j))
}
  #RCy3 command to import queried pathways as networks by network WP ID


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
geneDisParams <- list(
  source = "CURATED",
  assocType = "Any",
  diseaseClass = "Any",
  diseaseSearch = "Schizophrenia",
  geneSearch = " ",
  initialScoreValue = "0.3",
  finalScoreValue = "1.0"
)
  #Specifying parameters of the GDA network to be imported
geneDisResult <- disgenetRestCall("gene-disease-net",geneDisParams)
  #Importing DisGeNET disease-associated genes for SCZ 

getpathways.wp("Schizophrenia")
wpids <- c("4875","5412","4222","4942","5408","5402","5346","5405","5406","5407","4940","4905","5398","5399","4906","4657","4932")
sczcnv <- sapply(wpids, function(k) paste0("WP",k))
  #Manually adding relevant SCZ CNV pathways from WikiPathways

lapply(c(Schizophrenia_wpids,sczcnv), import)
  #Importing WP pathways (both manually added and by keyword)

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


linkset <- file.path(getwd(),"Linksets","wikipathways-20220511-hsa-WP.xgmml")
CTLextend.cmd = paste('cytargetlinker extend idAttribute="XrefId" linkSetFiles="', linkset, '" network=current direction=TARGETS', sep="")
commandsRun(CTLextend.cmd)
  #Extending the network

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






