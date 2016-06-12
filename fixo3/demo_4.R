require(dplyr)
require(vegan)
require(reshape2)

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

# reshape

data <- data %>%
  dcast(stationCode ~ WoRMS_scientificName, value.var = "count") %>%
  arrange(stationCode)

row.names(data) <- data$stationCode
data <- data %>% select(-stationCode)

data[is.na(data)] <- 0

# DCA

dca <- decorana(data)
plot(dca)

# NMDS

ord <- metaMDS(data)

plot(ord, type = "n")
points(ord, display = "sites", cex = 0.8, pch = 21, col = "red", bg = "red")
text(ord, display = "spec", cex = 0.5)

# ordihull, ordiellipse?

# reshape environmental data

env <- env %>%
  group_by(stationCode, parameter) %>%
  summarise(value = mean(value, na.rm = TRUE)) %>%
  dcast(stationCode ~ parameter, value.var = "value") %>%
  arrange(stationCode)

# fit environmental data

ord.fit <- envfit(ord ~ Salinity, env, na.rm = TRUE)

plot(ord, type = "n")
orditorp(ord, display = "spec", cex = 0.5)
text(ord, display = "sites", cex = 0.7, col = "red")
plot(ord.fit)
with(env, ordisurf(ord, Salinity, add = TRUE, col = "green4"))

# CCA

ord <- cca(data ~ Salinity, env)
plot(ord)
