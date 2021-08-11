library(shiny)
library(reticulate)
library(tidyverse)

use_condaenv(conda = "/opt/conda/bin/conda")

get_translation <- function(token, part_of_speech, language = "jpn"){
    # get the first two lemmas of a given language
    # for every synset that contains the token and matches the part_of_speech
    synsets <- reticulate::import("nltk", delay_load = TRUE)$wordnet$wordnet$synsets
    
        purrr::map(
            1:length(synsets(token, pos = part_of_speech)) ,
            ~synsets(token, pos = part_of_speech)[[.x]]$lemma_names(lang = language)[1]
        ) %>%
            # lose anything that did not return a value
            # lose all results with capitals (they are probably unwanted proper nouns)
            purrr::discard(is.null) %>%
            unlist() %>%
            utils::head(2) %>%
            stringr::str_flatten(collapse = " || ") 
        }

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Can I reprex?"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("language",
                        "select language",
                        choices = c(
                            "Finnish" = "fin",
                            "Thai" = "tha",
                            "French" = "fra"
                            )
            ),
            textInput("word",
                      "write one noun",
                      width = "300px",
                      value = "apple"
                      )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            textOutput("text"),
            textOutput("translation"),
        )
    )
)

# Define server logic 
server <- function(input, output) {
    
    output$translation <- renderText({
        
        get_translation(token = input$word, part_of_speech = "n", language = input$language)

    })
    
    output$text <- renderText({
        input$word
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
