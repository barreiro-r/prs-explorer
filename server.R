# Defines the server-side logic for the Shiny application.
# This file should be saved as 'server.R' in the same directory as ui.R

# Load the shiny library (good practice to include in both files or in global.R)
library(shiny)

# Define the server logic
# This function takes 'input' and 'output' arguments automatically provided by Shiny.
# 'input' is a list-like object containing the current values of all input controls.
# 'output' is a list-like object where you assign reactive outputs (plots, tables, text).
server <- function(input, output) {

  # Reactive expression to generate the histogram plot
  # renderPlot() creates a plot output that automatically updates
  # when any of its reactive dependencies (like input$bins or input$color) change.
  output$distPlot <- renderPlot({

    # Access the built-in 'faithful' dataset (eruption times and waiting times)
    x <- faithful$waiting # Use the 'waiting' column

    # Generate breaks for the histogram based on the slider input
    # input$bins is reactive; accessing it tells Shiny that this plot depends on it.
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # Draw the histogram
    hist(x, breaks = bins, col = input$color, border = 'white', # Use input$color reactively
         xlab = 'Waiting time to next eruption (minutes)',
         main = paste('Histogram of waiting times with', input$bins, 'bins'))

  }) # End of renderPlot

  # Reactive expression to generate summary text
  # renderPrint() captures the console output of the expression inside it.
  # It updates when its reactive dependencies change (none in this simple case,
  # but it could depend on inputs if needed).
  output$summary <- renderPrint({
    x <- faithful$waiting
    summary(x) # Calculate and print summary statistics of the waiting times
  }) # End of renderPrint

} # End of server function