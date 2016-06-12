require(dplyr)
require(vegan)

data <- read.csv("EMBOS_softsubBeach_2.csv", sep = "\t")
env <- read.csv("environs_soft_beach.csv", sep = "\t")

# check station codes

data %>% select(stationCode) %>% distinct()
env %>% select(stationCode) %>% distinct()

# check parameters, keep only counts

View(data %>% group_by(WoRMS_scientificName, parameter) %>% summarise(n()))
data <- data %>% filter(parameter == "Individual Count")

# check sample size

data %>% select(WoRMS_scientificName, sampleAreaOrVolume) %>% distinct()

# check replicates, average

data %>% group_by(stationCode, WoRMS_scientificName) %>% summarise(n())
data %>% filter(stationCode == "CY-SFDA-SUB" & WoRMS_scientificName == "Callianassa")

data <- data %>% group_by(stationCode, WoRMS_scientificName) %>% summarise(count = mean(value))
