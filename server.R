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

  output$observedMetrics <- renderUI({
    obs_metrics <- observed_metrics(data_prs())

    div(
      class = 'table_cell',
      tagAppendAttributes(class = 'table shiny-table table- spacing-s',tags$table(
        tags$thead(
          tags$tr(
            tagAppendAttributes(rowspan = "2", tags$th("Group")),
            tagAppendAttributes(
              colspan = "2",
              class = "text-center",
              tags$th("Observable")
            ),
            tagAppendAttributes(
              colspan = "2",
              class = "text-center",
              tags$th("Scaled (Z)")
            )
          ),
          tags$tr(
            tags$th("Mean"),
            tags$th("SD"),
            tags$th("Mean"),
            tags$th("SD"),
          )
        ),
        tags$tbody(
          tags$tr(
            tags$td("Case"),
            tags$td(obs_metrics |> filter(Group == 'Case') |> pull(`Obs Mean`) |> round(digits = 2)),
            tags$td(obs_metrics |> filter(Group == 'Case') |> pull(`Obs SD`) |> round(digits = 2)),
            tags$td(obs_metrics |> filter(Group == 'Case') |> pull(`Z-score Mean`) |> round(digits = 2)),
            tags$td(obs_metrics |> filter(Group == 'Case') |> pull(`Z-score SD`) |> round(digits = 2))
          ),
          tags$tr(
            tags$td("Control"),
            tags$td(obs_metrics |> filter(Group == 'Control') |> pull(`Obs Mean`) |> round(digits = 2)),
            tags$td(obs_metrics |> filter(Group == 'Control') |> pull(`Obs SD`) |> round(digits = 2)),
            tags$td(obs_metrics |> filter(Group == 'Control') |> pull(`Z-score Mean`) |> round(digits = 2)),
            tags$td(obs_metrics |> filter(Group == 'Control') |> pull(`Z-score SD`) |> round(digits = 2))
          )
        )
      )
    ))
  })

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
  }, width = '100%', sanitize.text.function = function(x) x)

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

