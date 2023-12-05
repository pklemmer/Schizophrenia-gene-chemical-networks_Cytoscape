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

## -----------------------------------------------------------------------------
#  cytoscapePing()

## -----------------------------------------------------------------------------
#  openSession()  #Closes current session (without saving) and opens a sample session file

## -----------------------------------------------------------------------------
#  mapped.cols <- mapTableColumn('name','Yeast','Ensembl','Entrez Gene')

## -----------------------------------------------------------------------------
#  mapped.cols[1:3,] #first three entries

## -----------------------------------------------------------------------------
#  #available in Cytoscape 3.7.0 and above
#  installApp('STRINGapp')

## -----------------------------------------------------------------------------
#  string.cmd = 'string disease query disease="breast cancer" cutoff=0.9 species="Homo sapiens" limit=150'
#  commandsGET(string.cmd)
#  
#  # for more information on string commands:
#  # commandsHelp('string')
#  # commandsHelp('string disease query')

## -----------------------------------------------------------------------------
#  mapped.cols <- mapTableColumn('stringdb::canonical name','Human','Uniprot-TrEMBL','Ensembl')

## -----------------------------------------------------------------------------
#  #available in Cytoscape 3.7.0 and above
#  installApp('WikiPathways')

## -----------------------------------------------------------------------------
#  wp.cmd = 'wikipathways import-as-pathway id="WP254"'
#  commandsGET(wp.cmd)
#  
#  # for more information on wikipathways commands:
#  # commandsHelp('wikipathways')
#  # commandsHelp('wikipathways import-as-pathway')
#  

## -----------------------------------------------------------------------------
#  mapped.cols <- mapTableColumn('XrefId','Human','Entrez Gene','Ensembl')

## -----------------------------------------------------------------------------
#  only.mapped.cols <- mapped.cols[complete.cases(mapped.cols), 'Ensembl', drop=FALSE]
#  colnames(only.mapped.cols) <- 'XrefId'
#  loadTableData(only.mapped.cols,table.key.column = 'SUID')

## -----------------------------------------------------------------------------
#  ?mapTableColumn

## -----------------------------------------------------------------------------
#  #available in Cytoscape 3.7.0 and above
#  installApp('BridgeDb')

## -----------------------------------------------------------------------------
#  commandsHelp('bridgedb')

