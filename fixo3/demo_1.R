# data types

a <- 1
class(a)

b <- "banana"
class(b)

d <- FALSE
class(d)

# vectors

a <- c(1, 2)
a

b <- seq(1, 10)
b

x <- seq(0, pi * 3, length = 100)
x
plot(x)
y <- sin(x) + sin(x)^2
plot(x, y)

# matrices

m <- matrix(1:6, nrow = 3, ncol = 2)
m

# data frames

data <- data.frame(a = c(1, 2, 3), b = c("x", "y", "z"))
data
data$a

data(iris)
View(iris)
plot(iris)

# reading CSV files

data <- read.csv("data/nsbs.csv")
View(data)
head(data)

require(dplyr)
tbl_df(data)

# robis

require(robis)
data <- occurrence("Abra")
View(data)

# filtering

unique(data$scientificName)
selection <- data %>% filter(scientificName == "Abra alba" & yearcollected > 2005)

# sorting

sorted <- data %>% arrange(datasetName, locality, catalogNumber)
View(sorted)

# column selection

sorted <- sorted %>% select(datasetName, locality, catalogNumber, scientificName)
View(sorted)

# adding columns (mutate)

data %>%
  mutate(zone = .bincode(minimumDepthInMeters, breaks = c(0, 10, 100))) %>%
  select(minimumDepthInMeters, zone) %>%
  filter(!is.na(zone))

# grouping and aggregation

data %>%
  group_by(scientificName) %>%
  summarise(lat_mean = mean(decimalLatitude), lat_sd = sd(decimalLatitude))

# graphics with ggplot

require(ggplot2)

data <- occurrence(resourceid = 586)

afil <- data %>%
  filter(scientificName == "Amphiura filiformis") %>%
  group_by(locality) %>%
  summarise(
    n = mean(individualCount),
    lon = mean(decimalLongitude),
    lat = mean(decimalLatitude),
    depth = mean(minimumDepthInMeters)
  )

ggplot() + geom_point(data = afil, aes(lon, lat, size = n, colour = depth)) +
  scale_colour_distiller(palette = "Spectral") +
  theme(panel.background = element_blank()) +
  coord_fixed(ratio = 1) +
  scale_size(range = c(2, 12))

# mapping

require(leaflet)

data <- occurrence("Verruca stroemia")

qcflag <- function(qc, number) {
  mask <- 2^(number-1)
  return(sapply(qc, function(x) {
    return(sum(bitwAnd(x, mask) > 0))
  }))
}

data$qcnum <- qcflag(data$qc, c(24, 28))

colors <- c("red", "orange", "green")[data$qcnum + 1]

m <- leaflet()
m <- addProviderTiles(m, "CartoDB.Positron")
m <- addCircleMarkers(m, data = data.frame(lat = data$decimalLatitude, lng = data$decimalLongitude), radius = 3, weight = 0, fillColor = colors, fillOpacity = 0.5)
m
