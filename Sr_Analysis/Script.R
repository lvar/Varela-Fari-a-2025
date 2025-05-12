library(assignR)
library(terra)

# Loading global isoscape from Bataille et al. (2020)
#isoSr = rast(x=c("GlobalSr.tif","GlobalSr_se.tif"))

# Loading masks for Uruguay
mask = vect("mask_Uy.shp")
mask2 = vect("mask_Uy2.shp")

# Loading masked isoscape from Bataille et al. (2020)
isoSr = rast(x=c("UYisoSr.tif","UYisoSr_se.tif"))

# Loading Water and fish otoliths data for Uruguay from Avigliano et al. (2020)
calSr = vect(x="UYData.shp")
# Loading Fossil data
vecSr = vect(x="FossilData.shp")
datSr = read.csv("FossilData.csv")
dfSr = data.frame(datSr$ID2, datSr$Sr, datSr$Sd)

# Isoscape calibration
Sr = calRaster(known = calSr, isoscape = isoSr, mask=mask2, interpMethod=2)
#writeRaster(Sr$isoscape.rescale$mean, filename="SrCAL.tif", overwrite=TRUE)
#writeRaster(Sr$isoscape.rescale$sd, filename="SrCALsd.tif", overwrite=TRUE)
#Sr = rast(x=c("SrCAL.tif","SrCALsd.tif"))

# Creating probability of origin rasters
Sr_prob = pdRaster(Sr, dfSr, mask = mask)
#writeRaster(Sr_prob$A1, filename="Aigua.tif", overwrite=TRUE)
#writeRaster(Sr_prob$C1, filename="Caño.tif", overwrite=TRUE)
#writeRaster(Sr_prob$Y, filename="Yi.tif", overwrite=TRUE)
#writeRaster(Sr_prob$M, filename="Mercedes.tif", overwrite=TRUE)
#writeRaster(Sr_prob$B, filename="Barreto.tif", overwrite=TRUE)
#writeRaster(Sr_prob$AdV1, filename="AdV1.tif", overwrite=TRUE)

# Creating distance probabilty density
wDist_north = wDist(c(Sr_prob$Y,Sr_prob$M,Sr_prob$B), vecSr[c(5:7)], maxpts = 1e5, bw = "sj")
wDist_south = wDist(c(Sr_prob$A1,Sr_prob$C1,Sr_prob$AdV1), vecSr[c(1,3,8)], maxpts = 1e5, bw = "sj")
plot(wDist_north)
plot(wDist_south)

# Visualizing tooth time series
plot(datSr$Sr~datSr$Tooth.position..cm., ylim=c(0.7075,0.7080), ylab="87Sr/86Sr", xlab="Tooth position (cm)")
