# http://geog.uoregon.edu/GeogR/topics/netCDF-read-ncdf4.html
# http://geog.uoregon.edu/GeogR/topics/netcdf-to-raster.html

require(ncdf4)
require(raster)

sst_file <- "sst.mnmean.nc"

nc <- nc_open(sst_file)
lon <- ncvar_get(nc, "lon")
lat <- ncvar_get(nc, "lat")
sst <- ncvar_get(nc, "sst")
time <- ncvar_get(nc, "time")

ras <- raster(sst_file)
plot(ras)

