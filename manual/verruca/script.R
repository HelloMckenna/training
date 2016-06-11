require(leaflet)

data <- read.csv("verruca.csv")

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
m <- addCircleMarkers(m, data=data.frame(lat=data$latitude, lng=data$longitude), radius=3, weight=0, fillColor=colors, fillOpacity=0.5)
m