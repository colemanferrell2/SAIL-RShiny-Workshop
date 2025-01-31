# SAIL RShiny Workshop
## By Coleman Ferrell
Exercises adapted from Shiny basics of https://shiny.posit.co/ 

# Building your RShiny Webpage
### Step 0: Install Packages
You must first install the `shiny` package before building your app
```R
install.packages("shiny")
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
Shiny widgets collect a value from your user. When a user changes the widget, the value will change as well." In other words, widgets are the buttons/sliders the user can react with on the `ui` that sends a signal to the `server`. Example widgets from the `shiny` package can be found [Here]((https://shiny.posit.co/r/gallery/widgets/widget-gallery/)) 

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
