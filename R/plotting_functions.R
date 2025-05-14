library(tidyverse)
library(ggtext)
library(scales)
library(pROC)
library(ggiraph)
library(performance)

data_prs <- bind_rows(
  tibble(prs = rnorm(10000, 0, 1), group = 'control'),
  tibble(prs = rnorm(10000, 1, 1), group = 'case')
) |>
  mutate(z_prs = scale(prs)[, 1])

# Theme
theme_set(
  theme_minimal() +
    theme(
      # axis.line.x.bottom = element_line(color = '#474747', linewidth = .3),
      # axis.ticks.x= element_line(color = '#474747', linewidth = .3),
      # axis.line.y.left = element_line(color = '#474747', linewidth = .3),
      # axis.ticks.y= element_line(color = '#474747', linewidth = .3),
      # # panel.grid = element_line(linewidth = .3, color = 'grey90'),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.background = element_blank(),
      plot.title.position = "plot",
      plot.title = element_text(
        family = "Helvetica Neue",
        size = 12,
        face = 'bold',
        hjust = .5
      ),
      plot.caption = element_text(
        size = 8,
        color = 'grey60',
        margin = margin(20, 0, 0, 0)
      ),
      plot.subtitle = element_text(
        size = 9,
        lineheight = 1.15,
        margin = margin(5, 0, 0, 0),
        hjust = .5
      ),
      axis.title.x = element_markdown(
        family = "Helvetica Neue",
        hjust = .5,
        size = 12,
        color = "grey40"
      ),
      axis.title.y = element_markdown(
        family = "Helvetica Neue",
        hjust = .5,
        size = 12,
        color = "grey40"
      ),
      axis.text = element_text(
        family = "Helvetica Neue",
        hjust = .5,
        size = 12,
        color = "grey40"
      ),
      legend.position = "top",
      text = element_text(family = "Helvetica Neue")
    )
)

palette <- c("control" = "#C3C3C3", "case" = "#6746BB")


plot_histogram <- function(data_prs) {
  quantile9 <- quantile(data_prs$z_prs, probs = 0.9)
  quantile1 <- quantile(data_prs$z_prs, probs = 0.1)
  data_prs |>
    ggplot(aes(x = z_prs)) +
    geom_histogram(
      aes(color = group, fill = group),
      position = 'identity',
      alpha = .5,
      bins = 50
    ) +
    annotate(
      geom = 'segment',
      x = quantile1,
      y = 0,
      yend = Inf,
      color = 'black',
      linewidth = .4,
      linetype = 'dotted'
    ) +
    annotate(
      geom = 'richtext',
      x = quantile1 + quantile1 * .1,
      y = Inf,
      label = '←<br>**Low-Risk**<br><10% of the samples',
      vjust = 1,
      hjust = 1,
      fill = NA,
      label.color = NA
    ) +

    annotate(
      geom = 'segment',
      x = quantile9,
      y = 0,
      yend = Inf,
      color = 'black',
      linewidth = .4,
      linetype = 'dotted'
    ) +
    annotate(
      geom = 'richtext',
      x = quantile9 + quantile9 * .1,
      y = Inf,
      label = '→<br>**High-Risk**<br>>90% of the samples',
      vjust = 1,
      hjust = 0,
      fill = NA,
      label.color = NA
    ) +
    scale_y_continuous(expand = c(00, 0, 0, 0), ) +
    scale_fill_manual(values = palette) +
    scale_color_manual(values = palette) +
    guides(
      fill = 'none',
      color = 'none'
    ) +
    labs(
      x = 'PRS',
      y = 'Individuals (n)'
    ) +
    theme(
      axis.line.x.bottom = element_line(color = 'grey20', linewidth = 0.5)
    )
}


plot_prevalencebyquantile <- function(data_prs) {
  data2plot <-
    data_prs |>
    mutate(percentile = ntile(prs, n = 100)) |>
    count(group, percentile) |>
    pivot_wider(names_from = group, values_from = n, values_fill = 0) |>
    mutate(prevalence = case / (case + control))

  data2plot |>
    ggplot(aes(x = percentile, y = prevalence)) +
    geom_point(aes(color = prevalence)) +
    scale_color_gradientn(colors = palette) +
    annotate(
      geom = 'segment',
      x = 90,
      y = data2plot |> filter(percentile == 90) |> pull(prevalence),
      yend = .5,
      color = palette['case'],
      linetype = 'dotted'
    ) +
    annotate(
      geom = 'richtext',
      x = 90,
      label = str_c(
        "<span style='font-size:12pt'>at 90th</span><br>",
        data2plot |> filter(percentile == 90) |> pull(prevalence) |> percent()
      ),
      y = .5,
      vjust = if_else(
        (data2plot |> filter(percentile == 90) |> pull(prevalence)) > 0.5,
        1,
        0
      ),
      size = 6,
      fill = NA,
      label.color = NA,
    ) +
    annotate(
      geom = 'segment',
      x = 10,
      y = data2plot |> filter(percentile == 10) |> pull(prevalence),
      yend = .5,
      color = palette['case'],
      linetype = 'dotted'
    ) +
    annotate(
      geom = 'richtext',
      x = 10,
      label = str_c(
        "<span style='font-size:12pt'>at 10th</span><br>",
        data2plot |> filter(percentile == 10) |> pull(prevalence) |> percent()
      ),
      y = .5,
      ,
      vjust = if_else(
        (data2plot |> filter(percentile == 10) |> pull(prevalence)) > 0.5,
        1,
        0
      ),
      size = 6,
      fill = NA,
      label.color = NA,
    ) +
    labs(
      x = 'Percentile',
      y = 'Prevalence (%)'
    ) +
    scale_y_continuous(
      limits = c(0, 1),
      label = percent
    ) +
    guides(
      color = 'none'
    ) 
}

# --- ROC ---
plot_roc <- function(data_prs) {
  # I dont know why this appears:
  # Warning in roc.default(response, predictor, auc = TRUE, ...) :
  # Deprecated use a matrix as predictor. Unexpected results may be produced, please pass a numeric vector.

  data_prs <- data_prs |> mutate(group = if_else(group == 'case', 1, 0))

  roc_obj <- roc(group ~ z_prs, data_prs)
  auc_value <- auc(roc_obj)

  ggroc(roc_obj, color = palette['case']) +
    geom_ribbon(
      fill = palette['case'],
      aes(x = specificity, ymin = -Inf, ymax = sensitivity),
      alpha = .3
    ) +
    annotate(
      'segment',
      x = 1,
      xend = 0,
      y = 0,
      yend = 1,
      linetype = 'dotted'
    ) +
    annotate(
      "richtext",
      size = 6,
      x = 0.5,
      y = 0.4,
      label = paste(
        "<span style='font-size:12pt'>AUC</span><br>",
        round(auc_value, 3)
      ),
      vjust = 1,
      hjust = 0,
      fill = NA,
      label.color = NA
    ) +
    scale_y_continuous(expand = c(0, 0, 0, 0)) +
    labs(
      x = 'Specificity',
      y = 'Sensitivity'
    )
}


plot_ors <- function(data_prs) {
  data2plot <- data_prs

  breaks <- quantile(data2plot$z_prs, probs = seq(0, 1, 0.20), na.rm = TRUE)
  quintile_labels <- c("0-20%", "20-40%", "40-60%", "60-80%", "80-100%")
  data2plot <- data2plot |>
    filter(!is.na(z_prs)) |>
    mutate(
      prs_quintile = cut(
        z_prs,
        breaks = breaks,
        labels = quintile_labels,
        include.lowest = TRUE,
        right = TRUE
      )
    )

  counts_table <- data2plot |>
    filter(!is.na(prs_quintile)) |>
    count(prs_quintile, group, name = "count") |>
    pivot_wider(names_from = group, values_from = count, values_fill = 0) |>
    select(prs_quintile, case, control) |>
    arrange(prs_quintile)

  regression_data <- data2plot |>
    filter(!is.na(prs_quintile)) |> # Ensure no NA quintiles
    mutate(
      outcome = ifelse(group == "case", 1, 0),
      prs_quintile_factor = factor(
        prs_quintile,
        levels = c("40-60%", "0-20%", "20-40%", "60-80%", "80-100%")
      )
    )

  model <- glm(
    outcome ~ prs_quintile_factor,
    data = regression_data,
    family = binomial(link = "logit")
  )

  or_ci <- exp(cbind(OR = coef(model), confint(model)))

  or_results <- as_tibble(or_ci, rownames = "term") |>
    rename(lower_ci = `2.5 %`, upper_ci = `97.5 %`) |>
    mutate(term = gsub("prs_quintile_factor", "", term)) |>
    filter(term != "(Intercept)") |>
    add_row(term = "40-60%", OR = 1.00, lower_ci = 1, upper_ci = 1) |>
    mutate(
      prs_quintile = factor(
        term,
        levels = c("0-20%", "20-40%", "40-60%", "60-80%", "80-100%")
      )
    ) |>
    arrange(prs_quintile) |>
    select(prs_quintile, OR, lower_ci, upper_ci) |>
    mutate(OR = log10(OR), lower_ci = log10(lower_ci), upper_ci = log10(upper_ci))

  final_summary <- left_join(counts_table, or_results, by = "prs_quintile")

  final_summary |>
    ggplot(aes(x = prs_quintile, y = OR)) +
    annotate(
      geom = 'segment',
      x = -Inf,
      xend = Inf,
      y = 0,
      color = palette['case'],
      linetype = 'dotted'
    ) +
    geom_line(group = 1, aes(color = palette), color = '#C3C3C3') +
    geom_errorbar(
      aes(ymin = lower_ci, ymax = upper_ci, color = OR),
      width = .3
    ) +
    geom_point(aes(color = OR)) +
    scale_color_gradientn(colors = palette) +
    guides(color = 'none') +
    labs(x = 'PRS Quintile', y = 'Log Odds Ratio (95%CI)') +
    theme(
      axis.text.x = element_text(size = 10)
    )
}

observed_metrics <- function(data_prs){
  data_prs |>
    group_by(group) |>
    summarise(
      'Obs Mean' = mean(prs),
      'Obs SD' = sd(prs),
      'Z-score Mean' = mean(z_prs),
      'Z-score SD' = sd(z_prs)
    ) |>
    mutate(group = str_to_title(group)) |>
    rename(Group = 'group')
}

calc_t_test_pvalue <- function(data_prs) {
  t_result <-
    t.test(
      data_prs |> filter(group == 'case') |> pull(z_prs),
      data_prs |> filter(group == 'control') |> pull(z_prs)
    )

  # format(round(t_result$p.value, 2), nsmall = 2)
  t_result$p.value
}


mini_boxplot <- function(data_prs){
  data_prs |>
    ggplot(aes(x = z_prs, y = group)) +
    geom_boxplot(aes(color = group, fill = group), alpha = .3, outlier.shape = NA, linewidth = 1.5) +
    theme_void() +
    guides(color = 'none', fill = 'none') +
    scale_fill_manual(values = palette) +
    scale_color_manual(values = palette) 
}


table_ors <- function(data_prs) {
  data2plot <- data_prs

  ref_risk <- data2plot |>
    filter(
      z_prs > quantile(data2plot$z_prs, 0.4),
      z_prs < quantile(data2plot$z_prs, 0.6)
    ) |> 
    mutate(labels = '40-60%')

  thresholds <- c(0.80, 0.90, 0.95, 0.99)
  top_risk <- map_dfr(
    thresholds,
    ~ data2plot |>
        filter(z_prs > quantile(z_prs, .x, na.rm = TRUE)) |>
        mutate(labels = str_c(">",.x * 100,"%"))
  )

  data2plot <- bind_rows(ref_risk,top_risk)

  counts_table <- data2plot |>
    filter(!is.na(labels)) |>
    count(labels, group, name = "count") |>
    pivot_wider(names_from = group, values_from = count, values_fill = 0) |>
    select(labels, case, control) |>
    arrange(labels)

  regression_data <- data2plot |>
    filter(!is.na(labels)) |> # Ensure no NA quintiles
    mutate(
      outcome = ifelse(group == "case", 1, 0),
      labels_factor = factor(
        labels,
        levels = c("40-60%", ">80%", ">90%", ">95%", ">99%")
      )
    )

  model <- glm(
    outcome ~ labels_factor,
    data = regression_data,
    family = binomial(link = "logit")
  )

  or_ci <- exp(cbind(OR = coef(model), confint(model)))

  or_results <- as_tibble(or_ci, rownames = "term") |>
    rename(lower_ci = `2.5 %`, upper_ci = `97.5 %`) |>
    mutate(term = gsub("labels_factor", "", term)) |>
    filter(term != "(Intercept)") |>
    add_row(term = "40-60%", OR = 1.00, lower_ci = 1, upper_ci = 1) |>
    mutate(
      labels = factor(
        term,
        levels = c("40-60%", ">80%", ">90%", ">95%", ">99%")
      )
    ) |>
    arrange(labels) |>
    select(labels, OR, lower_ci, upper_ci) |>
    mutate(OR = log10(OR), lower_ci = log10(lower_ci), upper_ci = log10(upper_ci))

  final_summary <- 
    left_join(counts_table, or_results, by = "labels") |>
    filter(labels != '40-60%') |>
    mutate(label_text = str_c(round(OR,2), '\n(',round(lower_ci,2),'-',round(upper_ci,2),')')) |>
      select(-case, -control, -OR, -lower_ci, -upper_ci) |>
    rename(Group = 'labels', "LOR (95%CI)" = 'label_text') |>
    arrange(desc(Group))
}


nagelkerke_r2 <- function(data_prs) {
  data2plot <- data_prs |>
    mutate(group = if_else(group == 'control',0,1))

  my_model <- glm(group ~ z_prs, data = data2plot, family = binomial)
  nagelkerke_r2 <- r2_nagelkerke(my_model)
  nagelkerke_r2
}

or_per_sd <- function(data_prs) {
  data2plot <- data_prs |>
    mutate(group = if_else(group == 'control',0,1))

  my_model <- glm(group ~ z_prs, data = data2plot, family = binomial)
  or_per_sd <- exp(coef(my_model)["z_prs"])
}
