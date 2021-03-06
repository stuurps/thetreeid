#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyMobile)
library(leaflet)

# Define UI
shinyUI(f7Page(
    theme = "dark",
    f7SingleLayout(
        navbar = f7Navbar(
            title = "The Tree ID",
            subtitle = a("Get In Touch", href = "mailto:thetreeid@gmail.com"),
            hairline = F,
            shadow = T,
            tags$script(
                '$(document).ready(function () {

                function getLocation(callback){
                var options = {
                  enableHighAccuracy: true,
                  timeout: 5000,
                  maximumAge: 0
                };

                navigator.geolocation.getCurrentPosition(onSuccess, onError);

                function onError (err) {
                  Shiny.onInputChange("geolocation", false);
                }

                function onSuccess (position) {
                  setTimeout(function () {
                    var coords = position.coords;
                    var timestamp = new Date();

                    console.log(coords.latitude + ", " + coords.longitude, "," + coords.accuracy);
                    Shiny.onInputChange("geolocation", true);
                    Shiny.onInputChange("lat", coords.latitude);
                    Shiny.onInputChange("long", coords.longitude);
                    Shiny.onInputChange("accuracy", coords.accuracy);
                    Shiny.onInputChange("time", timestamp)

                    console.log(timestamp);

                    if (callback) {
                      callback();
                    }
                  }, 1100)
                }
              }

              var TIMEOUT = 100000; //SPECIFY
              var started = false;
              function getLocationRepeat(){
                //first time only - no delay needed
                if (!started) {
                  started = true;
                  getLocation(getLocationRepeat);
                  return;
                }

                setTimeout(function () {
                  getLocation(getLocationRepeat);
                }, TIMEOUT);

              };

              getLocationRepeat();

            });
                        '
            )
        ),
        leafletOutput("map"),
        tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
        
        
        toolbar = f7Toolbar(
            position = "bottom",
            f7Link(
                label = "Home",
                src = "https://thetreeid.com/",
                external = T
            ),
            f7Link(
                label = "Survey",
                src = "https://thetreeid.com/shiny/survey",
                external = T
            )
        )
        
    )#,
    
    #f7BlockFooter(text = "For more information please contact..")
    
))
