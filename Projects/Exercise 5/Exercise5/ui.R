#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    
    # Application title
    titlePanel('Zadanie dodatkowe - wersja 2 "Stworz Pokedexa w R"'),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            # textInput("bgURL",label = "Link do tla", value = "https://wallpapercave.com/wp/cqhO8rQ.jpg"),
            uiOutput("selectPokemons"),
        ),
        mainPanel(
            plotlyOutput("compPlot"),
        )
    ),
    h3("Tabela wszystkich Pokemonow"),
    DT::dataTableOutput("compTable"),
    
    # setBackgroundImage(src = "https://wallpapercave.com/wp/cqhO8rQ.jpg", shinydashboard = FALSE),
))
