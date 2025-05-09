library(ggiraph)
library(shiny)
library(tidyverse)
source("R/plotting_functions.R")

server <- function(input, output) {
  data_prs <- reactive({bind_rows(
    tibble(prs = rnorm(input$cases_samples, input$cases_mean, input$cases_sd), group = 'case'),
    tibble(prs = rnorm(input$controls_samples, input$controls_mean, input$controls_sd), group = 'control')) |>
    mutate(z_prs = scale(prs))
  })
  
  output$prsHistogram <- renderGirafe({
    girafe(code = print(plot_histogram(data_prs())),  width_svg = 6, height_svg = 5.7)
  })

  output$prsPrevalencebyquantile <- renderGirafe({
    girafe(code = print(plot_prevalencebyquantile(data_prs())), width_svg = 4, height_svg = 2.5)
  })

  output$prsRoc <- renderGirafe({
    girafe(ggobj = plot_roc(data_prs()), width_svg = 4, height_svg = 2.5)
  })

  output$prsOrs <- renderGirafe({
    girafe(ggobj = plot_ors(data_prs()), width_svg = 4, height_svg = 2.5)
  })

  output$observedMetrics <- renderTable({
    observed_metrics(data_prs())
  })
} 