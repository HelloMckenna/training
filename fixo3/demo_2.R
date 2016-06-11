# rfishbase

require(rfishbase)
common_to_sci("cod")
View(species("Clupea harengus"))

# rgbif

require(rgbif)
cluhar <- occ_search(scientificName = "Clupea harengus", limit = 50)
View(cluhar$data)

# spocc

require(spocc)
setcae <- occ(query = "Setophaga caerulescens", from = c("gbif", "ebird"))
head(occ2df(setcae))
tail(occ2df(setcae))

# rredlist

require(rredlist)
rl_search("Ursus maritimus", key = NULL)
