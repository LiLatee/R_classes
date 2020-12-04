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
library(RCurl)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    pokemonData <- reactive({
        temp <- read.table("pokemons.csv", head=TRUE, sep=',')
    })
    output$bg <- renderUI({
        setBackgroundImage(src = input$bgURL, shinydashboard = F)
    })
    
    ################################  Tab - Porownywanie ################################ 
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
    

    observeEvent(input$defaultBG, {
            # updateTextInput(session, "bgURL", value = "https://wallpapercave.com/wp/cqhO8rQ.jpg")
        updateTextInput(session, "bgURL", value = "https://wallpapercave.com/wp/cqhO8rQ.jpg")
        
    })
    
    output$compPlot <- renderPlotly({
        temp <- filter(pokemonData(), name %in% input$selectPokemons )
        temp <- reshape2::melt(temp, id.vars = "name", variable.name = "category", 
                               measure.vars = input$checkboxes,
                               value.name="scores")
        
        plot_ly(temp, x=temp$category, y=temp$scores, type="bar", name=temp$name) %>%
            layout(paper_bgcolor='transparent')
    })
    
    ################################  Tab - Tabela ################################ 
    output$compTable <- DT::renderDataTable({
        DT::datatable(pokemonData(), filter="top", escape=TRUE, selection='single')
        })
    
    ################################ Tab - Reka ################################ 
    output$selectPokemon1 <- renderUI({
        selectInput(
            inputId = "selectPokemon1", 
            label = "Pokemon 1:",
            choices = sort(pokemonData()[['name']]),
            multiple = F,
            selected = "Charmander", 
        )
    })
    
    output$selectPokemon2 <- renderUI({
        selectInput(
            inputId = "selectPokemon2", 
            label = "Pokemon 2:",
            choices = sort(pokemonData()[['name']]),
            multiple = F,
            selected = "Bulbasaur", 
        )
    })
    
    output$selectPokemon3 <- renderUI({
        selectInput(
            inputId = "selectPokemon3", 
            label = "Pokemon 3:",
            choices = sort(pokemonData()[['name']]),
            multiple = F,
            selected = "Squirtle", 
        )
    })
    
    sources = c(
        "https://img.pokemondb.net/sprites/red-blue/normal/",
        "https://img.pokemondb.net/sprites/silver/normal/",
        "https://img.pokemondb.net/sprites/ruby-sapphire/normal/",
        "https://img.pokemondb.net/sprites/diamond-pearl/normal/",
        "https://img.pokemondb.net/sprites/black-white/normal/",
        "https://img.pokemondb.net/sprites/x-y/normal/",
        "https://img.pokemondb.net/sprites/lets-go-pikachu-eevee/normal/",
        "https://img.pokemondb.net/sprites/home/normal/"
    )
    sources  <- rev(sources)
    output$imagesRow <- renderUI({
        for (source in sources)
        {
            url1 <- paste(source, tolower(input$selectPokemon1), ".png", sep="")
            if (url.exists(url1))
                break
        }

        for (source in sources)
        {
            url2 <- paste(source, tolower(input$selectPokemon2), ".png", sep="")
            if (url.exists(url2))
                break
        }


        for (source in sources)
        {
            url3 <- paste(source, tolower(input$selectPokemon3), ".png", sep="")
            if (url.exists(url3))
                break
        }

        fluidRow(
            column(
                4,
                align='center',
                img(src=url1, heigh=100, width=100)
            ),
            column(
                4,
                align='center',
                img(src=url2, heigh=100, width=100)
            ),
            column(
                4,
                align='center',
                img(src=url3, heigh=100, width=100)
            ),
        )
    })

    output$statsRow <- renderUI({
        temp <-reshape2::melt(pokemonData()[,-1], id.vars = "name", variable.name = "category",value.name="scores")
        temp[temp == ""] <- "brak danych"
        
        pokemon1 <- filter(temp, name==input$selectPokemon1)
        pokemon2 <- filter(temp, name==input$selectPokemon2)
        pokemon3 <- filter(temp, name==input$selectPokemon3)
        fluidRow(
            column(
                4,
                align='center',
                renderTable(pokemon1[,2:3])
            ),
            column(
                4,
                align='center',
                renderTable(pokemon2[,2:3])
            ),
            column(
                4,
                align='center',
                renderTable(pokemon3[,2:3])
            ),
            
        )
    })

    output$checkboxesHand <- renderUI({
        columns <- colnames(pokemonData())
        wrongColumns = c("X", "name", "species","growth_rate", "type", "evolution")
        columns <- setdiff(columns, wrongColumns)
        checkboxGroupInput("checkboxesHand", label = "Wybierz statystyki", choices = columns, inline = T, selected = c("hp", "attack"))
    })
    
    output$scorePlot <- renderUI({
        temp <- filter(pokemonData(), name %in% c(input$selectPokemon1,input$selectPokemon2,input$selectPokemon3)) %>%
            reshape2::melt(id.vars = "name", variable.name = "category", value.name="scores", measure.vars = input$checkboxesHand,)

        plot1 <- plot_ly(temp, labels=temp$category, values=temp$scores, type="pie") %>%
            layout(paper_bgcolor='transparent')
        
        plot2 <- plot_ly(temp, x=~category, y=~scores, type="bar", name=temp$name) %>%
            layout(yaxis = list(title = 'Suma'), xaxis = list(title = 'Statystyka'), barmode = 'stack', paper_bgcolor='transparent')

        
        fluidRow(
            column(
                6,
                renderPlotly(plot1)
            ),
            column(
                6,
                renderPlotly(plot2)
            )
        )

    })
})
