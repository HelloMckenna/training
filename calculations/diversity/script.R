require(dplyr)

data <- read.table("occurrence.txt", sep="\t", header=TRUE, stringsAsFactors=FALSE)

stations <- data %>% group_by(eventID) %>% summarize(diversity = length(unique(scientificName)))
