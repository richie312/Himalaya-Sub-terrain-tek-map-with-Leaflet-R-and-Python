## Load the library
#setwd('C:/Users/aritra.chatterjee/Desktop/Trek_Maps')
library(leaflet)
library(htmlwidgets)
## Get the lat and lon for the camping locations

sandakpu_loc = read.csv('sandakpu_loc.csv',stringsAsFactors = FALSE)

popup_tpl <- paste0("<font color= #E34F4F><h3>Camp: </h3></font>",sandakpu_loc$Location,"<br>",
                    popup =sprintf("<img src = %s style=width:104px;height:142px;>",sandakpu_loc$Links),"<br>",
                    "<font color= #E34F4F><h3>Longitude: </h3></font>",sandakpu_loc$lon,"<br>",
                    "<font color= #E34F4F><h3>Latitude: </h3></font>",sandakpu_loc$lat,"<br>",
                    "<font color= #E34F4F><h3>Altitude(Feet): </h3></font>",sandakpu_loc$Altitude,"<br>",
                    "<font color= #E34F4F><h3>Distance to Next Camp: </h3></font>",sandakpu_loc$Next_Camp_Distance,"<br>",
                    "<font color= #E34F4F><h3>Day: </h3></font>",sandakpu_loc$Days,"<br>")
## Get Direction on the map

## Make a dataframe from place A to place B to place C and place D
newlon<-as.numeric(c(sandakpu_loc$lon[sandakpu_loc$Location=="Manebhanjang"],
                     sandakpu_loc$lon[sandakpu_loc$Location=="Tumling"],
                     sandakpu_loc$lon[sandakpu_loc$Location=="Kalipokhri"],
                     sandakpu_loc$lon[sandakpu_loc$Location=="Sandakhphu"],
                     sandakpu_loc$lon[sandakpu_loc$Location=="sepi"],
                     sandakpu_loc$lon[sandakpu_loc$Location=="Darjeeling"]))

newlat<-as.numeric(c(sandakpu_loc$lat[sandakpu_loc$Location=="Manebhanjang"],
                     sandakpu_loc$lat[sandakpu_loc$Location=="Tumling"],
                     sandakpu_loc$lat[sandakpu_loc$Location=="Kalipokhri"],
                     sandakpu_loc$lat[sandakpu_loc$Location=="Sandakhphu"],
                     sandakpu_loc$lat[sandakpu_loc$Location=="sepi"],
                     sandakpu_loc$lat[sandakpu_loc$Location=="Darjeeling"]))

# Add colors and group in the dataframe
Group<-c("A","A","A","A","A","B")
sandakpu_loc$group = Group
sandakpu_loc$colors = c("#FF4500","#FF4500","#FF4500","#FF4500","#FF4500","#00FA9A")

# get colors for altitude greater than 10000 and below 10000 feet

get_colors<-function(Altitude){
  sapply(sandakpu_loc$Altitude,function(x){
  
  if (x < 10000){
  "#00FF7F"
    
  }
  else{
  '#FF4500'
    
  }
  })
}


## Plot the hiking location in leaflet
map_plot<-leaflet(sandakpu_loc)%>%addProviderTiles(providers$OpenStreetMap)%>%
  addCircleMarkers(lng = sandakpu_loc$lon,lat = sandakpu_loc$lat,radius=20,
                   opacity = 0.8,
                   fillColor = get_colors(sandakpu_loc$Altitude),
                   color = '#2E8B57',
                   popup = popup_tpl,
                   popupOptions(maxWidth = 500, minWidth = 100, maxHeight = NULL,
                                autoPan = FALSE))%>%
addPolylines(lng=sandakpu_loc$lon,lat=sandakpu_loc$lat, color=sandakpu_loc$colors)


##Create the plot

htmlwidgets::saveWidget(map_plot,'sandakpup_trek_map.html')

