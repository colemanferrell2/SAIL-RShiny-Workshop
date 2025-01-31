library(shiny)
library(dplyr)
library(DT)
library(shinythemes)
library(shinyWidgets)
library(ggplot2)

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