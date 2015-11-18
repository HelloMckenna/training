require(RPostgreSQL)

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