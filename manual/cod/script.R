require(lubridate)
require(mapdata)
require(ggplot2)

atlantic <- read.csv(unz("atlantic.csv.zip", "atlantic.csv"), stringsAsFactors=FALSE)
pacific <- read.csv(unz("pacific.csv.zip", "pacific.csv"), stringsAsFactors=FALSE)

# extract month from date

atlantic$month <- month(ymd(atlantic$datecollected))
pacific$month <- month(ymd(pacific$datecollected))

# Atlantic cod distribution

world <- map_data(map="world")

ggplot() +
  geom_polygon(data=world, aes(x=long, y=lat, group=group), fill="gray90", color="gray90") +
  geom_point(data=atlantic[!is.na(atlantic$month),], aes(x=longitude, y=latitude, colour=month), alpha=0.2) +
  scale_colour_gradientn(colours=c(rainbow(4), rainbow(1))) +
  theme(panel.background=element_blank()) +
  coord_quickmap(xlim=c(-100, 60), ylim=c(30, 85))

# Atlantic and Pacific cod depth distribution

ggplot() + 
  geom_histogram(data=pacific, aes(x=depth, y=..count../sum(..count..), fill="p"), alpha=0.7, binwidth=10) +
  geom_histogram(data=atlantic, aes(x=depth, y=..count../sum(..count..), fill="a"), alpha=0.7, binwidth=10) +
  xlim(0, 600) +
  ylab("proportion") +
  scale_fill_manual(name="species", values=c("a"="#86BB1B", "p"="#DF036E"), labels=c("a"="Atlantic cod", "p"="Pacific cod"))

