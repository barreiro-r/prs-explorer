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
  }, width = '100%')

  output$ttestPvalue <- renderText({
    pvalue <- calc_t_test_pvalue(data_prs())

    color_p_value <-
      if_else(pvalue < 0.01, "#53AD63", "#DB615D")

    str_c(
      "p-value<br><span style='color:",color_p_value,"; font-size:18pt' >",
      format(round(pvalue, 7), nsmall = 7),
      '</span>'
    )
  })

  output$miniBoxplot <- renderGirafe({
    girafe(ggobj = mini_boxplot(data_prs()), width_svg = 4, height_svg = 1.7 )
  })

  output$tableOr <- renderTable({
    table_ors(data_prs())
  }, width = '100%')

  output$nagelkerkeR <- renderText({
    r2 <- nagelkerke_r2(data_prs())
  
    str_c(
      "R2<br><span style='font-size:18pt'>",
      format(round(r2, 7), nsmall = 7),
      '</span>'
    )
  })

  output$orPerSd <- renderText({
    or_per_sd <- or_per_sd(data_prs())
    str_c(
      "OR/SD (scaled)<br><span style='font-size:18pt'>",
      format(round(or_per_sd, 7), nsmall = 7),
      '</span>'
    )
  })
}

