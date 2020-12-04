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
shinyServer(function(input, output) {
    pokemonData <- reactive({
        temp <- read.table("pokemons.csv", head=TRUE, sep=',')
    })
    
    # output$pokemonData <- c("a", "b")
    
    # output$compPlot <- renderPlot({
    #     
    #     data <- reshape2::melt(pokemonData(), id.vars = "name", variable.name = "category", 
    #                  measure.vars = c("hp", "attack", "defense", "speed", "sp_atk", "sp_def", "happiness", "exp"),
    #                  value.name="scores")
    #     ggplot(data, aes(x=category, y=scores, fill=name)) +
    #         geom_col(position="dodge2") +
    #         labs(y="Wartosc", x="Statystyki", fill="Nazwa pokemona")
    # 
    # })
    
    output$selectPokemons <- renderUI({selectInput(
        inputId = "selectPokemons", 
        label = "Wybierz Pokemony do porownania:",
        choices = sort(pokemonData()[['name']]),
        multiple = TRUE,
        selected = c("Charmander", "Bulbasaur", "Squirtle"), 
        
    )})
    
    output$compPlot <- renderPlotly({
        temp <- filter(pokemonData(), name %in% input$selectPokemons )
        temp <- reshape2::melt(temp, id.vars = "name", variable.name = "category", 
                               measure.vars = c("hp", "attack", "defense", "speed", "sp_atk", "sp_def", "happiness", "exp"),
                               value.name="scores")
        
        plot_ly(temp, x=temp$category, y=temp$scores, type="bar", name=temp$name)
    })
    
    output$compTable <- DT::renderDataTable({
        DT::datatable(pokemonData(), filter="top", escape=TRUE, selection='single')
        })
    


})
