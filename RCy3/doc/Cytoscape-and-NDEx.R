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
#  if(!"ndexr" %in% installed.packages()){
#      install.packages("BiocManager")
#      BiocManager::install("ndexr")
#  }
#  library(ndexr)

## -----------------------------------------------------------------------------
#  ndexcon <- ndex_connect()

## -----------------------------------------------------------------------------
#  networks <- ndex_find_networks(ndexcon, "Breast Cancer")
#  print(networks[,c("name","externalId","nodeCount","edgeCount")])

## -----------------------------------------------------------------------------
#  networks <- ndex_find_networks(ndexcon, "BRCA")
#  print(networks[,c("name","externalId","nodeCount","edgeCount")])

## -----------------------------------------------------------------------------
#  networkId = networks$externalId[1]
#  network = ndex_get_network(ndexcon, networkId)
#  print(network)

## -----------------------------------------------------------------------------
#  brca.net.suid <- importNetworkFromNDEx(networkId)

## -----------------------------------------------------------------------------
#  ig2 <- makeSimpleIgraph()
#  net.suid <- createNetworkFromIgraph(ig2, 'Simple Network', 'Simple Collection')

## -----------------------------------------------------------------------------
#  user <- "your_NDEx_account_username"  #replace with your info
#  pass <- "your_NDEx_account_password"  #replace with your info
#  exportNetworkToNDEx(user, pass, isPublic=TRUE, network=net.suid)

