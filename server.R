library(shiny)
library(tidyverse)
source("R/plotting_functions.R")

server <- function(input, output) {
  data_prs <- reactive({bind_rows(
    tibble(prs = rnorm(input$cases_samples, input$cases_mean, input$cases_sd), group = 'case'),
    tibble(prs = rnorm(input$controls_samples, input$controls_mean, input$controls_sd), group = 'control')) |>
    mutate(z_prs = scale(prs))
  })
  
  output$prsHistogram <- renderPlot({
    plot_histogram(data_prs())
  })

  output$prsPrevalencebyquantile <- renderPlot({
    plot_prevalencebyquantile(data_prs())
  })

  output$prsRoc <- renderPlot({
    plot_roc(data_prs())
  })

  output$prsOrs <- renderPlot({
    plot_ors(data_prs())
  })

  # Reactive expression to generate summary text
  # renderPrint() captures the console output of the expression inside it.
  # It updates when its reactive dependencies change (none in this simple case,
  # but it could depend on inputs if needed).
  output$summary <- renderPrint({
    x <- faithful$waiting
    summary(x) # Calculate and print summary statistics of the waiting times
  }) # End of renderPrint

} # End of server function