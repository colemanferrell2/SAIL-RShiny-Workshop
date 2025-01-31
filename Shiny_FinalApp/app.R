library(shiny)
library(dplyr)
library(DT)
library(shinythemes)
library(shinyWidgets)
library(ggplot2)

# Load player statistics dataset
player_stats <- readRDS("player_stats.rds")

########## UI #######################################
ui <- navbarPage(
  title = "Shiny Template",
  
########## Webpage Styling #######################################
  # Avaliable themes from https://bootswatch.com/
  theme = shinythemes::shinytheme("cerulean"),  
  
  # Inline Custom CSS to Adjust Colors Further (un-comment part you want to adjust)
  # header = tags$head(
  #   tags$style(HTML("
  #       :root {
  #         --bs-primary: #007bff; /* Primary color */
  #         --bs-secondary: #6c757d; /* Secondary color */
  #         --bs-text-color: #ffffff; /* Text color */
  #       }
  # 
  #       /* Navbar */
  #       .navbar {
  #         background-color: var(--bs-primary) !important;
  #       }
  #       .navbar .navbar-brand, .navbar .nav-link {
  #         color: var(--bs-text-color) !important;
  #       }
  #       .navbar .nav-link:hover {
  #         color: #f8f9fa !important;
  #       }
  # 
  #       /* Buttons */
  #       .btn-primary {
  #         background-color: var(--bs-primary) !important;
  #         border-color: var(--bs-primary) !important;
  #       }
  #       .btn-secondary {
  #         background-color: var(--bs-secondary) !important;
  #         border-color: var(--bs-secondary) !important;
  #       }
  # 
  #       /* Global text color */
  #       body {
  #         color: var(--bs-text-color);
  #         background-color: #222; /* Dark background */
  #       }
  # 
  #       h1, h2, h3, h4, h5, h6 {
  #         color: var(--bs-text-color);
  #       }
  # 
  #       p, span, a {
  #         color: var(--bs-text-color);
  #       }
  # 
  #       a:hover {
  #         color: #f8f9fa !important;
  #       }
  #     "))
  # ),
  
########## Webpage Content ####################################### 
  
  # Home Tab
  tabPanel("Home",
           sidebarLayout(
             sidebarPanel(
               h3("Sidebar"),
               
               # Dropdown for selecting a player
               pickerInput(
                 inputId = "dropdown",
                 label = "Select a Player:",
                 choices = unique(player_stats$player_display_name),
                 multiple = FALSE,  
                 options = list(style = "btn-primary")
               ),
               
               # Slider to filter pass completions
               sliderInput(
                 inputId = "pass_range",
                 label = "Select a range of completed passes:",
                 min = 0,
                 max = 50,
                 value = c(min(player_stats$completions), max(player_stats$completions)) # Default range
               )
             ), 
             position = "right",
             
             mainPanel(
               h2("Dot Plot of Pass Completions"),
               plotOutput("pass_hist")  
             )
           )
  ),
  
  # Player Stats Tab
  tabPanel("Player Stats",
           sidebarLayout(
             sidebarPanel(
               h3("Sidebar"),
             ), position = "right",
             mainPanel(
               h2("Main Content"),
               DT::dataTableOutput("player_stats_table")
             )
           )
  )
)

########## Server #######################################
  server <- function(input, output, session) {
    
    # Reactive expression to filter player stats based on dropdown
    selected_player_stats <- reactive({
      player_stats %>%
        filter(player_display_name == input$dropdown) 
    })
    
    # Render the data table
    output$player_stats_table <- DT::renderDataTable({
      DT::datatable(selected_player_stats(), options = list(
        scrollX = TRUE,  
        autoWidth = TRUE, 
        pageLength = 10  
      ))
    })
    
    # Render dot plot of completed passes
    output$pass_hist <- renderPlot({
      # Filter dataset based on slider range
      filtered_data <- player_stats %>%
        filter(completions >= input$pass_range[1] & completions <= input$pass_range[2])
      
      # Create the dot plot
      ggplot(filtered_data, aes(x = completions)) +
        geom_dotplot(binwidth = 1, dotsize = 0.5, fill = "#007bff", color = "white", stackdir = "up") +
        labs(title = "Dot Plot of Completed Passes",
             x = "Completed Passes",
             y = "Number of Players") +
        theme_minimal()
    })
  }

########## Run App #######################################
shinyApp(ui = ui, server = server)
