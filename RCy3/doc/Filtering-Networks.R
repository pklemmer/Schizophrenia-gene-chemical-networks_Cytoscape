## ---- echo = FALSE------------------------------------------------------------
knitr::opts_chunk$set(
  eval=FALSE
)

## ----setup, include=FALSE-----------------------------------------------------
#  knitr::opts_chunk$set(echo = TRUE)

## -----------------------------------------------------------------------------
#  if(!"RCy3" %in% installed.packages()){
#      install.packages("BiocManager")
#      BiocManager::install("RCy3")
#  }
#  library(RCy3)

## -----------------------------------------------------------------------------
#  installApp('STRINGapp')

## -----------------------------------------------------------------------------
#  string.cmd = 'string disease query disease="breast cancer"'
#  commandsRun(string.cmd)
#  string.net<-getNetworkSuid()  #grab handle on network for future reference

## -----------------------------------------------------------------------------
#  createDegreeFilter('degree filter', c(0,2), 'IS_NOT_BETWEEN')

## -----------------------------------------------------------------------------
#  createSubnetwork(subnetwork.name ='Breast cancer: highly connected nodes')

## -----------------------------------------------------------------------------
#  createColumnFilter(filter.name='disease score filter', column='stringdb::disease score', 4, 'GREATER_THAN', network = string.net)

## -----------------------------------------------------------------------------
#  createSubnetwork(subnetwork.name ='Breast cancer: high disease score')

## -----------------------------------------------------------------------------
#  createCompositeFilter('combined filter', c('degree filter','disease score filter'), network = string.net)
#  createSubnetwork(subnetwork.name ='final subnetwork')

## -----------------------------------------------------------------------------
#  layoutNetwork('force-directed defaultSpringCoefficient=5E-6')

## -----------------------------------------------------------------------------
#  applyFilter('combined filter', hide=TRUE, network = string.net)

