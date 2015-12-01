require(openxlsx)

# distance calculation

rad <- function(deg) {
  return(deg * pi / 180)
}

distance <- function(lon1, lat1, lon2, lat2) {
  if (is.na(lon1) | is.na(lat1) | is.na(lon2) | is.na(lat2)) {
    return(NA)
  }
  lon1 <- rad(lon1)
  lat1 <- rad(lat1)
  lon2 <- rad(lon2)
  lat2 <- rad(lat2)
  dlat <- lat2 - lat1
  dlon <- lon2 - lon1
  a <- sin(dlat / 2) * sin(dlat / 2) + cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2)
  b <- 2 * atan2(sqrt(a), sqrt(1 - a))
  d <- 6371000 * b
  return(d)
}

# open the file and read the first sheet

data <- read.xlsx("Arthropodaf_OBIS_1DEC_noAphiaRemoved.xlsx", startRow=1, colNames=TRUE)
data$lat1 <- data$FLDGEO_LAT_DN_DD_COMB
data$lon1 <- data$FLDGEO_LON_DN_DD_COMB
data$lat2 <- data$FLDGEO_LAT_UP_DD_COMB
data$lon2 <- data$FLDGEO_LON_UP_DD_COMB

# calculate distance

data$distance <- NA

for (i in 1:nrow(data)) {
  data$distance[i] <- distance(data$lon1[i], data$lat1[i], data$lon2[i], data$lat2[i])
}

# write

write.xlsx(data, file="output.xlsx")
