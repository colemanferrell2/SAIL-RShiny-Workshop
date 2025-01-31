library(shiny)
library(bslib)

########## UI #######################################
ui <- navbarPage(
  title = "Shiny Template",
  
########## Webpage Styling #######################################
  theme = bs_theme(
    # Choose a theme from https://bootswatch.com/
      bootswatch = "cerulean" 
  ),

########## Webpage Content #######################################
  # Home Tab
    tabPanel("Home",
             sidebarLayout(
               sidebarPanel(
                 h3("Sidebar")
               ),
               mainPanel(
                 h2("Main Content"),
                              )
             )
            )
 
 )

########## Server #######################################
server <- function(input, output, session) {
  
}

########## Run App #######################################
shinyApp(ui = ui, server = server)