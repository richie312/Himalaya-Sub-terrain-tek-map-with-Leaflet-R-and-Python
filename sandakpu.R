## Load the library
setwd('C:/Users/aritra.chatterjee/Desktop/Trek_Maps')
library(ggmap)
library(leaflet)

## Get the lat and lon for the camping locations

sandakpu_loc = read.csv('sandakpu_loc.csv',stringsAsFactors = FALSE)



popup_tpl <- paste0("<font color= #E34F4F><h3>Camp: </h3></font>",sandakpu_loc$Location,"<br>",
                    popup =sprintf("<img src = %s style=width:104px;height:142px;>",sandakpu_loc$Links),"<br>",
                    "<font color= #E34F4F><h3>Longitude: </h3></font>",sandakpu_loc$lon,"<br>",
                    "<font color= #E34F4F><h3>Latitude: </h3></font>",sandakpu_loc$lat,"<br>",
                    "<font color= #E34F4F><h3>Altitude: </h3></font>",sandakpu_loc$Altitude,"<br>")
## Get the lonlat for bounding box



## Plot the hiking location in leaflet


leaflet(sandakpu_loc)%>%addProviderTiles(providers$Stamen.TerrainBackground)%>%
  addCircleMarkers(lng=~sandakpu_loc$lon,lat=~sandakpu_loc$lat,radius=20,popup = popup_tpl)%>%
  fitBounds(minLong,minLat,maxLong,maxLat)
