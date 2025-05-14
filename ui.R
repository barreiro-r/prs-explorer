# Defines the User Interface (UI) for the Shiny application.
library(shiny)
library(ggiraph)

# Define the UI using a fluidPage layout
# fluidPage provides a responsive layout that adjusts to the browser window size.
ui <- fluidPage(
  tags$head(
    includeCSS("www/styles.css"),
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
    ),
    tags$title("PRS Explorer")
  ),

  div(
    id = 'main-container',

    # --- SideBar Menu ---
    div(
      id = 'main-sidebar',
      div(
        id = 'logo',
        div(
          id = 'logo-icon',
          tags$span(class = "material-symbols-outlined", "explore")
        ),
        div(
          id = 'logo-text',
          tags$p(id = 'logo-maintext', "Polygenic Risk Score"),
          tags$p(id = 'logo-subtext', "Explorer"),
        )
      ),
      div(
        id = 'parameters',
        tags$h1(
          tags$span(class = "material-symbols-outlined", "construction"),
          'Parameters'
        ),
        tags$h2("CONTROLS"),
        numericInput(
          inputId = 'controls_samples',
          label = 'Samples',
          min = 0,
          max = 1000000,
          value = 10000
        ),
        div(
          class = "prs-parameters",
          numericInput(
            inputId = 'controls_mean',
            label = 'PRS Mean',
            min = -100,
            max = 100,
            value = 0
          ),
          numericInput(
            inputId = 'controls_sd',
            label = 'PRS SD',
            min = -100,
            max = 100,
            value = 1
          )
        ),
        tags$h2("CASES"),
        numericInput(
          inputId = 'cases_samples',
          label = 'Samples',
          min = 0,
          max = 1000000,
          value = 10000
        ),
        div(
          class = "prs-parameters",
          numericInput(
            inputId = 'cases_mean',
            label = 'PRS Mean',
            min = -100,
            max = 100,
            value = 1
          ),
          numericInput(
            inputId = 'cases_sd',
            label = 'PRS SD',
            min = -100,
            max = 100,
            value = 1
          )
        ),
        # actionButton(
        #   "update",
        #   "Update View",
        #   icon("refresh"),
        #   class = "btn btn-primary"
        # ),
      ),
    ),

    # --- Plot Area  ---
    div(
      id = 'main-content',
      div(
        id = 'plot-distribuition',
        class = 'plot-panel',
        tags$h1('Data Distribuition'),
        girafeOutput(outputId = "prsHistogram"),
      ),
      div(
        id = 'plot-metrics',
        class = c('plot-panel', 'my-table'),
        tags$h1('Observed Metrics'),
        div(
          class = 'table-container',
          tableOutput(outputId = "observedMetrics")
        ),
      ),
      div(
        id = 'plot-orperquantile',
        class = 'plot-panel',
        tags$h1('Odds Ratio by Quintile'),
        girafeOutput(outputId = "prsOrs"),
      ),
      div(
        id = 'plot-prevalenceperquantile',
        class = 'plot-panel',
        tags$h1('Prevalence by Quantile'),
        girafeOutput(outputId = "prsPrevalencebyquantile"),
      ),
      div(
        id = 'plot-roc',
        class = 'plot-panel',
        tags$h1('ROC'),
        girafeOutput(outputId = "prsRoc")
      ),
      div(
        id = 'plot-topOR',
        class = 'plot-panel',
        tags$h1('Top OR'),
        tableOutput(outputId = "tableOr")
      ),
      div(
        id = 'plot-ttest',
        class = 'plot-panel',
        tags$h1('t-test'),
        htmlOutput("ttestPvalue")
      ),
      div(
        id = 'plot-AUROC',
        class = 'plot-panel',
        tags$h1('Boxplot'),
        girafeOutput(outputId = "miniBoxplot"),
        
      ),
      div(
        id = 'plot-r2',
        class = 'plot-panel',
        tags$h1('Nagelkerke R2'),
        htmlOutput("nagelkerkeR")
      ),
      div(
        id = 'plot-beta',
        class = 'plot-panel',
        tags$h1('OR per SD'),
        htmlOutput("orPerSd")
      )
    )
  )
  # # Application title displayed at the top
  # titlePanel("Basic Shiny App Example"),

  # # Sidebar layout: common structure with a sidebar for inputs and a main area for outputs
  # sidebarLayout(

  #   # Sidebar panel: Contains input controls
  #   sidebarPanel(
  #     width = 4, # Adjust sidebar width (optional, default is 4 out of 12 columns)

  #     # Input control: Slider
  #     # Allows the user to select a number within a defined range.
  #     sliderInput(inputId = "bins",                # Unique ID to access this input's value in the server
  #                 label = "Number of bins:",       # Text label displayed above the slider
  #                 min = 5,                         # Minimum selectable value
  #                 max = 50,                        # Maximum selectable value
  #                 value = 30,                      # Default value when the app starts
  #                 step = 1),                       # Increment step of the slider

  #     # Input control: Radio buttons
  #     # Allows the user to choose one option from a set.
  #     radioButtons(inputId = "color",
  #                  label = "Select histogram color:",
  #                  choices = c("Sky Blue" = "skyblue",
  #                              "Light Green" = "lightgreen",
  #                              "Grey" = "grey"),
  #                  selected = "skyblue") # Default selected option
  #   ),

  #   # Main panel: Displays the outputs generated by the server
  #   mainPanel(
  #     width = 8, # Adjust main panel width (optional, default is 8 out of 12 columns)

  #     # Output element: Plot
  #     # Reserves space to display a plot generated by the server.
  #     # The outputId 'distPlot' must match an output object created in the server function.
  #     plotOutput(outputId = "distPlot"),

  #     # Output element: Text
  #     # Reserves space to display text generated by the server.
  #     h4("Summary Statistics"), # Static heading
  #     verbatimTextOutput(outputId = "summary") # Displays fixed-width text output

  #   ) # End of mainPanel
  # ) # End of sidebarLayout
) # End of fluidPage
