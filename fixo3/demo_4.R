require(dplyr)
require(vegan)
require(reshape2)
require(RColorBrewer)
require(leaflet)

data <- read.csv("data_embos/FixO3_EMBOS_softsubBeach_clean.csv", sep = "\t")
env <- read.csv("data_embos/environs_soft_beach.csv", sep = "\t")
stations <- data %>%
  group_by(stationCode) %>%
  summarise(lat = mean(lat), lon = mean(long)) %>%
  arrange(stationCode)

# check station codes

data %>% select(stationCode) %>% distinct()
env %>% select(stationCode) %>% distinct()

# check parameters, keep only counts

View(data %>% group_by(WoRMS_scientificName, parameter) %>% summarise(n = n()))
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

# reshape environmental data

env <- env %>%
  group_by(stationCode, parameter) %>%
  summarise(value = mean(value, na.rm = TRUE)) %>%
  dcast(stationCode ~ parameter, value.var = "value") %>%
  arrange(stationCode)

# environmental data: vector and surface fitting

ord.fit <- envfit(ord ~ Salinity, env, na.rm = TRUE)

plot(ord, type = "n")
orditorp(ord, display = "spec", cex = 0.5)
text(ord, display = "sites", cex = 0.7, col = "red")
plot(ord.fit)
with(env, ordisurf(ord, Salinity, add = TRUE, col = "green4"))

# anosim

# hierarchic clustering

dis <- vegdist(data)
clus <- hclust(dis)
plot(clus)

rect.hclust(clus, 5)
grp <- cutree(clus, 5)
grp <- grp[order(names(grp))]
grp

stations$grp <- grp
stations$color <- brewer.pal(5, "Set1")[stations$grp]

m <- leaflet()
m <- addProviderTiles(m, "CartoDB.Positron")
m <- addCircleMarkers(m, data = stations, radius = 5, weight = 0, fillColor = stations$color, fillOpacity = 1)
m

# biodiversity indices
