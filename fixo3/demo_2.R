require(dplyr)
require(parsnip)
require(ggplot2)
require(leaflet)
require(landr)

data <- read.csv("data_embos/Faulwetter_FixO3_EMBOS_softsubBeach_Dirty.csv", sep="\t", stringsAsFactors = FALSE, na.strings = "")
original <- data

# inspect data

str(data)
tbl_df(data)
names(data)

count_na <- function(x) { return(sum(is.na(x))) }
data %>% summarise_each(funs(count_na))

# problem: ranges

summary(data)
data %>% summarise_each(funs(min, max))

plot(data$samplingElevation)
plot(data$samplingDepth)
plot(data$sampledSedimentDepth)

plot(data$samplingElevation, ylim = c(-1, 2))
points(data$samplingDepth, col = "red")

i <- which(data$samplingElevation < 0)
data$samplingDepth[i] <- -data$samplingElevation[i]

# problem: field names

required <- c("eventDate", "decimalLatitude", "decimalLongitude", "scientificName", "scientificNameID", "occurrenceStatus", "basisOfRecord")
required[!required %in% names(data)]

data <- data %>%
  rename(
    scientificName = taxonName,
    decimalLatitude = lat,
    decimalLongitude = long
  )

data$occurrenceStatus <- "present"
data$basisOfRecord <- "HumanObservation"

# problem: coordinate format

as.numeric(data$decimalLatitude)
as.numeric(data$decimalLongitude)

parsedms("1??45'25.678''W")

lat <- parsedms(data$decimalLatitude)$lat
lon <- parsedms(data$decimalLongitude)$lon
data$decimalLatitude <- as.numeric(data$decimalLatitude)
data$decimalLongitude <- as.numeric(data$decimalLongitude)
data$decimalLatitude[!is.na(lat)] <- lat[!is.na(lat)]
data$decimalLongitude[!is.na(lon)] <- lon[!is.na(lon)]

stations <- data %>% distinct(decimalLatitude, decimalLongitude) 

m <- leaflet()
m <- addProviderTiles(m, "CartoDB.Positron")
m <- addCircleMarkers(m, ~decimalLongitude, ~decimalLatitude, data = stations, radius = 5, fillColor = "#cc3300", weight = 0, fillOpacity = 1)
m

# problem: points on land

land(3, 51)

stations$distance <- land(stations$decimalLongitude, stations$decimalLatitude)
stations$color <- c("green", "red")[(stations$distance > 0.01) + 1]

m <- leaflet()
m <- addProviderTiles(m, "CartoDB.Positron")
m <- addCircleMarkers(m, ~decimalLongitude, ~decimalLatitude, data = stations, radius = 5, weight = 0, fillOpacity = 1, fillColor =~ color)
m

data <- left_join(data, stations %>% select(decimalLongitude, decimalLatitude, distance), by = c("decimalLongitude", "decimalLatitude"))
