#to do
#Add current location, same as google #
#Update marker to include distance #
#Add table with N/S pointer or link to Gmaps

library(shiny)
library(leaflet)
library(leaflet.extras)
library(data.table)
library(proj4)
library(stringr)
library(geosphere)
library(shinyMobile)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    md <- fread("trees.csv")
    nrow(md)
    head(md)
    
    setDT(md)[, paste0("loc", 1:2) := tstrsplit(geo_point_2d, ",")]
    
    observe({
        if (!is.null(input$lat)) {
            #Current location
            lc <- NULL
            lc$Name <- "Current Location"
            lc$loc1 <- input$lat
            lc$loc2 <- input$long
            lc$dist <- 0
            lc$type <- "currentlocation"
            
            #Clean
            colnames(md)[24] <- "Name"
            md_sub <- subset(md, select = c(Name, loc1, loc2))
            md_sub$loc1 <- as.numeric(md_sub$loc1)
            md_sub$loc2 <- as.numeric(md_sub$loc2)
            
            #Find closest trees (100m)
            md_sub$dist <-
                distHaversine(c(input$long, input$lat), md_sub[, 3:2])
            md_cls <- subset(md_sub, dist <= 75)
            md_cls$type <- "tree"
            
            #Add current location to date fram
            md_cls <- rbind(md_cls, lc)
            
            
            #Define marker icon
            #treeicon <- makeIcon(
            #   iconUrl = "https://cdn2.iconfinder.com/data/icons/camping-nature/24/camping-nature-12-512.png",
            #   iconWidth = 20, iconHeight = 20,
            #   iconAnchorX = 22, iconAnchorY = 94,
            #)
            
            icon.pop <- awesomeIcons(
                icon = 'trees',
                markerColor = ifelse(md_cls$type == "currentlocation", 'blue', 'green'),
                library = 'fa',
                iconColor = 'black'
            )
            #Load map
            output$map <- renderLeaflet({
                leaflet(md_cls) %>%
                    addTiles() %>%
                    addAwesomeMarkers(
                        lng = ~ loc2,
                        lat = ~ loc1,
                        popup = ~ paste0(Name, " <br/>Distance: ", round(dist), "m"),
                        icon = icon.pop
                    )
                
            })
            
        }
    })
})
