# SAIL RShiny Workshop
## By Coleman Ferrell
Exercises adapted from Shiny basics of [Shiny](https://shiny.posit.co/) 

# Building your RShiny Webpage
### Step 0: Install Packages
You must first install the `shiny` package before building your app
```R
install.packages("shiny")
```

Also install these packages if you do not already have them:
```R
install.packages("dplyr")
install.packages("DT")
install.packages("ggplot")
install.packages("shinyThemes")

```
### Step 1: Open Template
The base template for your app’s framework is located at `Shiny_Template/app.R`. A brief description of the layout is discussed below, and we will then begin building upon this foundation. 

#### Structure of `app.R`
`app.R` has three components:

##### 1. User Interface Object
The user interface (`ui`) object defines the layout and visual elements of your Shiny app. It determines how users interact with the app by specifying inputs, outputs, and the overall structure. For example, if a user hits a "Generate Plot" button, the UI captures this interaction and sends it to the server.
##### 2. Server Function
The `server` function contains the instructions that your computer needs to build your app. It handles the logic in the background of your app inputs/outputs. For example, the server receives a message from the UI that the user hit "Generate Plot", then the server generates the relevant plot, and finally sends the plot back to the UI.
##### 3. Call to the shinyApp function
Finally, the `shinyApp` function creates Shiny app objects from an explicit UI/server pair.

#### Layout of the `ui` 
The `ui` function in `app.R` has already been set up as an example for our app page. However, there are several different options for page dynamics. Page dynamics how the page reacts as the use moves throughout the app (ie fixed width, relative width to screen size, etc). The following list/image displays some standard options. We use `navbarPage` as the default, but this can be replaced with any of the dynamics below.
1. **`fluidPage()`**  
   Creates a responsive layout that adjusts automatically to the user's screen size. Commonly used for simple, flexible web applications.

2. **`navbarPage()`**  
   Creates a multi-tab layout with a navigation bar at the top. Each tab can contain different content, making it ideal for apps with multiple sections.

3. **`sidebarLayout()`**  
   A layout that splits the page into two sections: a sidebar (for inputs) and a main panel (for outputs). Great for dashboards or apps where user input controls outputs.

4. **`splitLayout()`**  
   Divides the page into fixed-width columns. Useful for placing components side by side, such as plots and tables.

5. **`fixedPage()`**  
   Creates a layout with fixed-width elements, regardless of screen size. Suitable for apps where exact positioning matters.

6. **`fluidRow()`**  
   Defines a row in a `fluidPage()` layout, where content is divided into columns. Use it to organize elements in a grid-like structure.

7. **`fixedRow()`**  
   Similar to `fluidRow()`, but the column widths remain fixed and do not adjust with screen size.

8. **`fullPage()`**  
   Provides a layout that fills the entire browser window, useful for creating immersive, full-screen apps.
   
![Shiny Layouts](https://webflow-prod-assets.s3.amazonaws.com/6525256482c9e9a06c7a9d3c%2F65b01cda9506383404c34dde_shiny-layouts.webp "Shiny Page Layouts")

The options above help determine the dynamics of the page, but the layout of the content needs to be determined now. Some layouts are restricted by which dynamics you choose, but you should choose the layout that best suits the needs of your content. We choose `sidebarLayout()` for our template, but below is an image of other potential options.

![Shiny Layouts](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPcu57EaAc0EzjmCwYi97XvDX6SsEgaIyXyfUvmB6YvBRF1BSdW6c-MkUI-uSncYklww&usqp=CAU "Shiny Page Layouts")

Since we use the `navbarPage()`, we have tabs at the top of the page that can link different pages within our app. Creating a tab is like creating a new page, our `Home` taab has the `sidebarLayout` to create the following.
```R
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
```

### Step 2: Rearrange Layout
To practice modifying our layout, we move the Side Bar from the left-hand side to the right-hand side. To accomplish this do the following.

Replace in the `Home` Tab
```R
sidebarLayout(
               sidebarPanel(
                 h3("Sidebar"),
               ),
               mainPanel(
                 h2("Main Content"),
                              )
             )
```
with
```R
sidebarLayout(
               sidebarPanel(
                 h3("Sidebar"),
               ), position = "right",
               mainPanel(
                 h2("Main Content"),
                              )
             )
```
### Step 3: Adding Widgets to UI
A widget is "a web element that your users can interact with. Widgets provide a way for your users to send messages to the Shiny app.
Shiny widgets collect a value from your user. When a user changes the widget, the value will change as well." In other words, widgets are the buttons/sliders the user can react with on the `ui` that sends a signal to the `server`. Example widgets from the `shiny` package can be found [Here](https://shiny.posit.co/r/gallery/widgets/widget-gallery/) 

While these options are sufficient, the `shinyWidgets` package offers a more extensive and diverse collection of widgets. Thus, we will use widgets from this package. First, we must install the pack via the following
```R
install.packages("shinyWidgets")
```

Once installed, you can view available widgets by running the following
```R
library(shinyWidgets)
shinyWidgets::shinyWidgetsGallery()
```


Let's practice adding a widget. Each widget takes at least two arguments, a name for the widget and a inputID used to communicate with the server, but the total number of arguments will depend on the widget. Below is an example of adding a dropdown menu and a number slider; we add it to the sidebar.
```R
sidebarPanel(
      # Dropdown
      pickerInput(
        inputId = "dropdown",
        label = "Select an option:",
        choices = c("Option 1", "Option 2", "Option 3"),
        multiple = FALSE,
        options = list(
          style = "btn-primary"
        )
      ),
      
      # Slider
      sliderInput(
        inputId = "slider",
        label = "Select a range:",
        min = 0,
        max = 100,
        value = c(25, 75)
      )
    )
```
### Step 4: Use R scripts and data
We now will import data into our app. We will be examining NFL player stats from the 2023 season, which are stored in the `player_stats.rds` file. We need to load this data into the `app.R` file by including ```R player_stats <- readRDS("player_stats.rds")``` before the `ui` and the `server`.

Once the data is loaded, we add a reactive expression in the server to filter the player stats based on the user’s selection from the dropdown menu. Additionally, we create a `renderTable()` function to dynamically display the filtered data in the main panel whenever a new player is selected. ie: The reactive expression recieves the input signal from the `ui`, whereas the render table send the updated table back to the `ui`. We add the following code inside the `server`

```R
# Reactive expression to filter player stats
  selected_player_stats <- reactive({
    player_stats %>%
      filter(player_display_name == input$dropdown) 
  })
  
  # Render table output
  output$player_stats_table <- DT::renderDataTable({
    DT::datatable(selected_player_stats(), options = list(
      scrollX = TRUE,  # Enables horizontal scrolling
      autoWidth = TRUE, # Adjusts column widths automatically
      pageLength = 10   # Show 10 rows per page
    ))
  })
```
No table shows because our current current filters in the side panel do not match the values in the table and we have not added a output in the main panel. First, we upadte our widget to reflect our table, we change the `pickerInput()` to:

```R
pickerInput(
        inputId = "dropdown",
        label = "Select a Player:",
        choices = unique(player_stats$player_display_name),
        multiple = FALSE,  # Single selection
        options = list(
          style = "btn-primary"
        )
      )
    )
```

Next, we modify our main panel to have the table. We use the `DT` package because it has better user features and sizes automatically. Below is the code:
```R
mainPanel(
                 h2("Main Content"),
                 DT::dataTableOutput("player_stats_table")
                              )
```
### Step 5: Adding a tab
We can add a new tab at the top of our page, this acts as a new page. You can apply a different dynamics and formatting if you wish. However, reactions and filtering can still go across tabs. Let's move our table to another tab. Note nothing changes in the server since the we still want the same logic for filtering. So, we remove the `DT` table from the main panel in the `Home`. We then create a new tab called `Player Stats` as follows:
```R
tabPanel("Player Stats",
                 sidebarLayout(
                   sidebarPanel(
                     h3("Sidebar"),
                   ),position = "right",
                   mainPanel(
                     h2("Main Content"),
                     DT::dataTableOutput("player_stats_table")
                                        )
                 )
        )
```

Our filter is now on the `Home` tab, but the table outputs onto our new tab.

### Step 6: Styling Page
Shiny apps can use Bootstrap-based themes to enhance their visual appeal. The `shinytheme()` function allows you to apply a **Bootswatch theme**, which provides a pre-designed UI style. This includes color schemes and font styles and colors. In this app, the following line applies the **"Cerulean"** Bootswatch theme (nice because default colors are Light Blue). Even though the current theme is desirably for Tar Heels, let us switch themes to a `yeti` theme. Avaliable themes are [Here](https://rstudio.github.io/shinythemes/)

```R
theme = shinythemes::shinytheme("yeti"),
```

There is a way to use CSS code (used for styling in html) to change color/font/style of one element of a theme if you desire, this is an advanced topic and we will skip. However, the code is included in the template if interested.

### Step 7: Practice!
Now time for you to practice!

Can you include a dot plot on the `Home` tab that shows the players that completed a certain number of passes within a certain range, where the range depends on the slider from the side bar?


Solutions are included in the final app located in the `Shiny_FinalApp/app.R`

### Step 8: Publishing to Posit Cloud
Create an account at [Posit Cloud](https://posit.cloud/), then click publish in RStudio and login using your account. This will push your app to the Posit server.

Once you publish your app, you will get a unique link that corresponds to your app that anyone with the link can access. The example app we created today an be found at this [link](https://colemanferrell2.shinyapps.io/Shiny_FinalApp/)

### Step 9: Extra Topics
Below are other topics that could potentially be useful:
- Shiny Cards
- Conditional Panels
- Tab Panels
- Tab Title Styling


