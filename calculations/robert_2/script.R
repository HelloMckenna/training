require(openxlsx)
require(dplyr)

data <- read.xlsx("Arthropoda_matchRecordsToTaxonomy.xlsx", 1)
taxonomy <- read.xlsx("Arthropoda_matchRecordsToTaxonomy.xlsx", 2)

data <- left_join(data, taxonomy, by="AphiaID")
write.xlsx(data, file="output.xlsx")