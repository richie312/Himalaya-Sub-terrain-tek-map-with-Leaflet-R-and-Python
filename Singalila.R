## Load the library

library(ggmap)
library(leaflet)

## Get the lat and lon for the camping locations

locs<-c("uttarey","Phoktey Dara","Singalila National Park", "Gangtok","Namchi",
        "Yuksom","Dzongri","Ravangla","Jorethang","Zuluk")
#lon_lat<-geocode(locs)


#lon_lat_df<-cbind(locs,lon_lat)

#write.csv(lon_lat,"lon_lat_27th_Aug.csv",row.names = FALSE)

lon_lat_27th_Aug<-read.csv("lon_lat_27th_Aug.csv",stringsAsFactors = FALSE)
lon_lat_27th_Aug<-cbind(lon_lat_27th_Aug,locs)

## Add the images and altitude

#c<-"https://www.google.co.in/search?tbm=isch&q="

#lon_lat_27th_Aug$link<-paste(c,'',lon_lat_27th_Aug$locs,'',sep="")


popup_tpl <- paste0("<font color= #E34F4F><h3>Camp: </h3></font>",lon_lat_27th_Aug$locs,"<br>",
                    "<font color= #E34F4F><h3>Longitude: </h3></font>",lon_lat_27th_Aug$lon,"<br>",
                    "<font color= #E34F4F><h3>Latitude: </h3></font>",lon_lat_27th_Aug$lat,"<br>")
## Get the lonlat for bounding box

minLong<-min(lon_lat_27th_Aug$lon,na.rm = TRUE)
maxLong<-max(lon_lat_27th_Aug$lon,na.rm = TRUE)
minLat<-min(lon_lat_27th_Aug$lat,na.rm = TRUE)
maxLat<-max(lon_lat_27th_Aug$lat,na.rm = TRUE)


## Plot the hiking location in leaflet


leaflet(lon_lat_27th_Aug)%>%addProviderTiles(providers$HikeBike)%>%
  addCircleMarkers(lng=~lon_lat_27th_Aug$lon,lat=~lon_lat_27th_Aug$lat,radius=20,popup = popup_tpl)%>%
  fitBounds(minLong,minLat,maxLong,maxLat)

## Add the polylines

## Make a dataframe from place A to place B to place C and place D
newlon<-as.numeric(c(lon_lat_27th_Aug$lon[lon_lat_27th_Aug$locs=="uttarey"],
          lon_lat_27th_Aug$lon[lon_lat_27th_Aug$locs=="Singalila National Park"],
          lon_lat_27th_Aug$lon[lon_lat_27th_Aug$locs=="Phoktey Dara"],
          lon_lat_27th_Aug$lon[lon_lat_27th_Aug$locs=="Jorethang"]))
          
newlat<-as.numeric(c(lon_lat_27th_Aug$lat[lon_lat_27th_Aug$locs=="uttarey"],
          lon_lat_27th_Aug$lat[lon_lat_27th_Aug$locs=="Singalila National Park"],
          lon_lat_27th_Aug$lat[lon_lat_27th_Aug$locs=="Phoktey Dara"],
          lon_lat_27th_Aug$lat[lon_lat_27th_Aug$locs=="Jorethang"]))

Group<-c("A","A","A","A")

initlon<-as.numeric(c(lon_lat_27th_Aug$lon[lon_lat_27th_Aug$locs=="Gangtok"],
           lon_lat_27th_Aug$lon[lon_lat_27th_Aug$locs=="uttarey"],
           lon_lat_27th_Aug$lon[lon_lat_27th_Aug$locs=="Singalila National Park"],
           lon_lat_27th_Aug$lon[lon_lat_27th_Aug$locs=="Phoktey Dara"]))

initlat<-as.numeric(c(lon_lat_27th_Aug$lat[lon_lat_27th_Aug$locs=="Gangtok"],
           lon_lat_27th_Aug$lat[lon_lat_27th_Aug$locs=="uttarey"],
           lon_lat_27th_Aug$lat[lon_lat_27th_Aug$locs=="Singalila National Park"],
           lon_lat_27th_Aug$lat[lon_lat_27th_Aug$locs=="Phoktey Dara"]))


## Combine all the columns to get a new data frame


route_map_df<-cbind.data.frame(Group,initlon,initlat,newlon,newlat)

## Combine the latitude and longitude in another data frame

mydf2 <- data.frame(group = route_map_df$Group,
                    lat = c(route_map_df$initlat, route_map_df$newlat),
                    long = c(route_map_df$initlon,route_map_df$newlon))



leaflet(mydf2)%>%addProviderTiles(providers$HikeBike)%>%
  addCircleMarkers(radius=10)%>%
  addPolylines( lng = ~long,lat = ~initlat,group = Group)



###### API Key

Key<-"AIzaSyDyoY_fJsQ3jCoII8EvX72J9u7IY0LrWgs"

df <- google_directions(origin = "Kolkata, India",
                        destination = "Siliguri, India",
                        key = Key,
                        mode = "walking",
                        simplify = TRUE)

url <- paste0("https://maps.googleapis.com/maps/api/distancematrix/json?&origins=Melbourne+Airport,+Australia|MCG,+Melbourne,+Australia|-37.81659,144.9841&destinations=Portsea,+Melbourne,+Australia&alternatives=false&units=metric&mode=driving&key=", Key)
jsonlite::fromJSON(url)



