# install.packages(c(
#   "gapminder", "ggforce", "gh", "globals", "openintro", "profvis", 
#   "RSQLite", "shiny", "shinycssloaders", "shinyFeedback", 
#   "shinythemes", "testthat", "thematic", "tidyverse", "vroom", 
#   "waiter", "xml2", "zeallot" 
# ))



######## Input Functions ##########
# textInput() ---> text
        #  textInput("name", "", placeholder = "What's your name?") ---> places the caption inside the text area

# passwordInput() ---> password
# textAreaInput() ---> paragraphs
# numericInput() ---> numeric values
# sliderInput() ---> slider value = 3 (a number gives a scalar i.e just a value)
# sliderInput() ---> slider value = c(10,20) (a vector gives a range like an interval)
# dateInput() ---> a single day
# dateRangeInput() ---> a range of two days
# selectInput() ---> drop down list. To allow the user select multiple options, do: multiple = TRUE
# checkboxGroupInput() has multiple selection option
# radioButtons() ---> radio buttons no multiple selection argument
    # arguments: choiceNames is shown to the user, choiceValues is returned in your server function
    # Example: radioButtons("rb", "Choose one:",
                  # choiceNames = list(
                  #   icon("angry"),
                  #   icon("smile"),
                  #   icon("sad-tear")
                  # ),
                  # choiceValues = list("angry", "happy", "sad")
                  # )
# fileInput() ---> to upload files
# actionButton() or actionLink() ---> button/link performs an action. They are paired with observeEvent() or eventReactive()


############## Output functions ################
# text, tables and plots

# textOutput() ---> renderText({}) # used for small, fixed summaries e.g model coefficients
# verbatimTextOutput() ---> renderPrint({})

# tableOutput() ---> renderTable() # static
# dataTableOutput() ---> renderDataTable() # appropriate to display large dataframe and it is dynamic

# plotOutput() ---> renderPlot() # recommend always setting res = 96
    # It has arguments like click, dblclick, hover

# downloadButton() ---> downloadLink() # enable users to download a file

# observerEvent() ---> has two arguments: eventExpr & handlerExpr

# eventReactive() ---> takes two arguments: what to take dependency on and what to compute

# actionButton() ---> performs the action you want on the dashboard

# load the library
library(shiny)
library(ggplot2)

# defines the user interface
ui <- fluidPage(
  "Hello, world!",
  # all input functions have argument (name, label, value)
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)

# specifies the behaviour of the app
server <- function(input, output, session){
  
  # display a statistical summary with text
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  # show the input data in a table
  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    head(dataset)
  })
}

# executes and starts a Shiny application from UI and server
shinyApp(ui, server)


############### Modified ########################

# defines the user interface
ui <- fluidPage(
  "Hello, world!",
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)

# specifies the behaviour of the app
server <- function(input, output, session){
  
  # Create a reactive expression
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })
  
  # show the output data in a table as text
  output$summary <- renderPrint({
    # use a reactive expression by calling it like a function
    summary(dataset())
  })
  
  # show output as table
  output$table <- renderTable({
    dataset()
  })
}

# executes and starts a Shiny application from UI and server
shinyApp(ui, server)

################## First Exercise ###############################

# defines the user interface
# textInput expects text, numericInput expects numbers, textOutput displays output as text
ui <- fluidPage(textInput("name", "What's your name?"),
                numericInput("age", "How old are you?", value = NA),
                textOutput("greeting")
)

# specifies the behaviour of the app
server <- function(input, output, session){
  
  # show the output as text
  output$greeting <- renderText({
    # use a reactive expression by calling it like a function
    paste0("Hello ", input$name, ", you are ", input$age, " years old.")
  })
}

# executes and starts a Shiny application from UI and server
shinyApp(ui, server)

########################## Modified exercise ###########################

# defines the user interface
# textInput expects text, numericInput expects numbers, textOutput displays output as text
ui <- fluidPage(textInput("name", "What's your name?"),
                numericInput("age", "How old are you?", value = NA),
                textOutput("greeting")
)

# specifies the behaviour of the app
server <- function(input, output, session){
  
  # show the output as text
  output$greeting <- renderText({
    if (!is.null(input$name) && !is.na(input$age)){
      # use a reactive expression by calling it like a function
      paste0("Hello ", input$name, ", you are ", input$age, " years old.")
    } else {
      "Please enter your name and age."
    }
  })
}

# executes and starts a Shiny application from UI and server
shinyApp(ui, server)

# To get a message in the console
ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  string <- reactive(paste0("Hello ", input$name, "!"))
  
  output$greeting <- renderText(string())
  
  # this returns a message when there is a change in the value of name
  observeEvent(input$name, {
    message("Greeting performed")
  })
}

shinyApp(ui, server)


#################### Second exercise ##############################

# defines the user interface
# uses the slider value as input
ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", label = "and x is", min = 1, max = 50, value = 5),
  "then x times y is",
  textOutput("product")
)

# specifies the behaviour of the app
server <- function(input, output, session){
  
  # show the output as text
  output$product <- renderText({
    input$x * input$y
  })
}

# executes and starts a Shiny application from UI and server
shinyApp(ui, server)

####################### Modified  ################################

# defines the user interface
# uses the slider value as input
ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", label = "and x is", min = 1, max = 50, value = 5),
  "then, (x * y) is",
  textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)

# specifies the behaviour of the app
server <- function(input, output, session){
  
  # show the output as text
  output$product <- renderText({
    product <- input$x * input$y
    product
  })
  
  output$product_plus5 <- renderText({
    product <- input$x * input$y
    product + 5
  })
  output$product_plus10 <- renderText({
    product <- input$x * input$y
    product + 10
    
  })
}

# executes and starts a Shiny application from UI and server
shinyApp(ui, server)

#################### Reduce the amount of duplicated code by using reactive expression ##################

# defines the user interface
# uses the slider value as input
ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", label = "and x is", min = 1, max = 50, value = 5),
  "then, (x * y) is",
  textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)

# specifies the behaviour of the app
server <- function(input, output, session){
  
  product <- reactive({
    input$x * input$y
  })
  
  output$product_plus5 <- renderText({
    product() + 5
  })
  output$product_plus10 <- renderText({
    product() + 10
    
  })
}

# executes and starts a Shiny application from UI and server
shinyApp(ui, server)

############################# Reactive expressions with ggplot ###################

# datasets
datasets <- c("economics", "faithfuld", "seals")

# defines the user interface
# uses the slider value as input
ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot")
)

# specifies the behaviour of the app
server <- function(input, output, session){
  
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  
  output$summary <- renderPrint({
    summary(dataset())
  })
  output$plot <- renderPlot({
    plot(dataset())
  }, res = 96)  # res sets the resolution of the plot to 96 dots per inch (dpi)
}

# executes and starts a Shiny application from UI and server
shinyApp(ui, server)

########################## Fix me exercise ######################

ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

# Wrong
server1 <- function(input, output, server) {
  input$greeting <- renderText(paste0("Hello ", name))
}

# Correct
server1 <- function(input, output, session) {
  output$greeting <- renderText(paste0("Hello ", input$name))
}

# Wrong
server2 <- function(input, output, server) {
  greeting <- paste0("Hello ", input$name)
  output$greeting <- renderText(greeting)
}

# Correct (wrap inside the reactive function {renderText})
server2 <- function(input, output, session) {
  output$greeting <- renderText({
    greeting <- paste0("Hello ", input$name)
    greeting
  })
}


# executes and starts a Shiny application from UI and server
shinyApp(ui, server2)

##################### Simulation Dashboard ######################
# In this code the simulate button only simulates from the distributions
# the reactive function is vulnerable to the changes
ui <- fluidPage(
  fluidRow(
    column(3, 
           numericInput("lambda1", label = "lambda1", value = 3),
           numericInput("lambda2", label = "lambda2", value = 5),
           numericInput("n", label = "n", value = 1e4, min = 0),
           actionButton("simulate", "Simulate!")
    ),
    column(9, plotOutput("hist"))
  )
)

server <- function(input, output, session) {
  x1 <- reactive({
    input$simulate
    rpois(input$n, input$lambda1)
  })
  x2 <- reactive({
    input$simulate
    rpois(input$n, input$lambda2)
  })
  output$hist <- renderPlot({
    ggplot() +  # Create a ggplot object
      geom_freqpoly(aes(x = x1()), binwidth = 1, color = "red") +  # Frequency polygon for x1
      geom_freqpoly(aes(x = x2()), binwidth = 1, color = "blue") +  # Frequency polygon for x2
      xlim(0, 40)  # Set the x-axis limits
  }, res = 96)
}

shinyApp(ui, server)

# Modified
# In this code the simulate button only simulates from the distributions
# but in this case, the reactive function is NOT vulnerable to the changes
# the effect is only noticed when the button is clicked.

ui <- fluidPage(
  fluidRow(
    column(3, 
           numericInput("lambda1", label = "lambda1", value = 3),
           numericInput("lambda2", label = "lambda2", value = 5),
           numericInput("n", label = "n", value = 1e4, min = 0),
           actionButton("simulate", "Simulate!")
    ),
    column(9, plotOutput("hist"))
  )
)

server <- function(input, output, session) {
  x1 <- eventReactive(input$simulate, {
    rpois(input$n, input$lambda1)
  })
  x2 <- eventReactive(input$simulate, {
    rpois(input$n, input$lambda2)
  })
  
  output$hist <- renderPlot({
    ggplot() +  # Create a ggplot object
      geom_freqpoly(aes(x = x1()), binwidth = 1, color = "red") +  # Frequency polygon for x1
      geom_freqpoly(aes(x = x2()), binwidth = 1, color = "blue") +  # Frequency polygon for x2
      xlim(0, 40) + # Set the x-axis limits
      scale_color_manual(values = c("red", "blue"), 
                         labels = c("Distribution 1", "Distribution 2"))  + # Set legend labels and colors
      labs(color = "Distributions") # Set legend title
  }, res = 96)
}


shinyApp(ui, server)


########################## First App using the dataset #################

prod_codes <- setNames(products$prod_code, products$title)

# ui

ui <- fluidPage(
  fluidRow(
    column(6,
           selectInput("code", "Product", choices = prod_codes)
    )
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  )
)

# server

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  output$diag <- renderTable(
    selected() %>% count(diag, wt = weight, sort = TRUE)
  )
  output$body_part <- renderTable(
    selected() %>% count(body_part, wt = weight, sort = TRUE)
  )
  output$location <- renderTable(
    selected() %>% count(location, wt = weight, sort = TRUE)
  )
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    summary() %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  }, res = 96)
}

shinyApp(ui, server)

############### Modified ###############

