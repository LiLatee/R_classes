#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(data.table)
library(kableExtra)
library(plotly)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    pokemonData <- reactive({
        temp <- read.table("pokemons.csv", head=TRUE, sep=',')
    })
    
    output$selectPokemons <- renderUI({
        selectInput(
            inputId = "selectPokemons", 
            label = "Wybierz Pokemony do porownania:",
            choices = sort(pokemonData()[['name']]),
            multiple = TRUE,
            selected = c("Charmander", "Bulbasaur", "Squirtle"), 
        )
    })
    
    output$checkboxes <- renderUI({
        columns <- colnames(pokemonData())
        wrongColumns = c("X", "name", "species","growth_rate", "type", "evolution")
        columns <- setdiff(columns, wrongColumns)
        checkboxGroupInput("checkboxes", label = "Wybierz statystyki", choices = columns, inline = T, selected = c("hp", "attack"))
    })
    
    output$bg <- renderUI({
        setBackgroundImage(src = input$bgURL, shinydashboard = F)
    })
    
    observeEvent(input$defaultBG, {
            # updateTextInput(session, "bgURL", value = "https://wallpapercave.com/wp/cqhO8rQ.jpg")
        updateTextInput(session, "bgURL", value = "https://wallpapercave.com/wp/cqhO8rQ.jpg")
        
    })
    
    output$compPlot <- renderPlotly({
        temp <- filter(pokemonData(), name %in% input$selectPokemons )
        temp <- reshape2::melt(temp, id.vars = "name", variable.name = "category", 
                               measure.vars = input$checkboxes,
                               value.name="scores")
        
        plot_ly(temp, x=temp$category, y=temp$scores, type="bar", name=temp$name)
    })
    
    output$compTable <- DT::renderDataTable({
        DT::datatable(pokemonData(), filter="top", escape=TRUE, selection='single')
        })
    


})
