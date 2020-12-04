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
    
    uiOutput("bg"),
    
    titlePanel('Zadanie dodatkowe - wersja 2 "Stworz Pokedexa w R"'),
    
    tabsetPanel(
        type = "pills",
        tabPanel(
            "Porownywanie", 
            sidebarLayout(
                sidebarPanel(
                    textInput("bgURL",label = "Podaj link do grafiki aby ustawic nowe tlo", value = "https://wallpapercave.com/wp/cqhO8rQ.jpg"),
                    actionButton("defaultBG", "Przywroc domyslne tlo"),
                    br(),
                    br(),
                    uiOutput("selectPokemons"),
                    uiOutput("checkboxes")
                ),
                mainPanel(
                    plotlyOutput("compPlot"),
                )
            ),
        ),
        tabPanel(
            "Tabela Pokemonow",
            DT::dataTableOutput("compTable")
        ),
        tabPanel(
            "Aktualnie wybrane Pokemony",
            helpText("UWAGA: Pierwsze ladowanie chwile trwa..."),
            fluidRow(
                column(
                    4,
                    align='center',
                    uiOutput("selectPokemon1")
                ),
                column(
                    4,
                    align='center',
                    uiOutput("selectPokemon2")
                ),
                column(
                    4,
                    align='center',
                    uiOutput("selectPokemon3")
                ),
            ),
            # uiOutput("imagesRow"),
            uiOutput("statsRow"),
            uiOutput("checkboxesHand"),
            uiOutput("scorePlot"),
            # div(plotlyOutput("scorePlot", width = 500), align="center")
            
        )
    )

    
    
    
))
