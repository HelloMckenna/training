require(RPostgreSQL)
require(leaflet)

host <- "obisdb-stage.vliz.be"
db <- "obis"
user <- "obisreader"
password <- # contact the OBIS data manager to obtain a password
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname=db, host=host, user=user, password=password)

taxon <- "Orca gladiator"
valid_taxon <- dbGetQuery(con, paste0("select v.* from obis.tnames t left join obis.tnames v on v.id = t.valid_id where t.tname = '", taxon, "'"))

valid_id <- valid_taxon$valid_id[1]
valid_path <- paste0("'", valid_taxon$storedpath[1], valid_taxon$valid_id[1], "x%'")

data <- dbGetQuery(con, paste0("select p.* from portal.points_ex p left join obis.tnames t on p.valid_id = t.id where t.id = ", valid_id, " or t.storedpath like ", valid_path))

# ggplot2

require(mapdata)
require(ggplot2)

world <- map_data(map="world")

g <- ggplot(world, aes(long, lat)) +
  geom_polygon(aes(group=group), fill="gray90", color="gray90") +
  labs(x="", y="") + theme(panel.background=element_blank()) + coord_fixed(ratio=1)

g + geom_point(data=data, aes(x=longitude, y=latitude, colour=monthcollected)) +
  scale_colour_gradientn(colours=c("#7ED5C8", "#F2D391", "#EF6E4A"))

# leaflet

column <- "monthcollected"
colors <- heat.colors(max(data[[column]], na.rm=TRUE) - min(data[[column]], na.rm=TRUE) + 1)[data[[column]] - min(data[[column]], na.rm=TRUE) + 1]
colors <- substr(colors, 1, 7)
colors[is.na(colors)] <- "#aaaaaa"

m <- leaflet()
m <- addProviderTiles(m, "CartoDB.Positron")
m <- addCircleMarkers(m, data=data.frame(lat=data$latitude, lng=data$longitude), radius=3, weight=0, fillColor=colors, fillOpacity=0.5)
m

