# Defines the User Interface (UI) for the Shiny application.
library(shiny)
library(ggiraph)

# Define the UI using a fluidPage layout
# fluidPage provides a responsive layout that adjusts to the browser window size.
ui <- fluidPage(
  tags$head(
    includeCSS("www/styles.css"),
    tags$link(rel = "shortcut icon", href = "favicon.png"),
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
    ),
    tags$link(
      rel = "stylesheet",
      href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
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
          # tags$span(class = "material-symbols-outlined", "explore")
          tags$img(
            src = "logo.svg",
            width = "100px",
            height = "80px",
            alt = "My SVG Image"
          ),
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
        tags$hr(),
        tags$button(
          id = "openModalButton",
          class = "open-slideshow-button",
          tags$span(class = "material-symbols-outlined", "info"),"What is a PRS?"
        )
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
        # girafeOutput(outputId = "prsHistogram"),
        plotOutput(outputId = "prsHistogram",  , width='500px', height= '750px')
      ),
      div(
        id = 'plot-metrics',
        class = c('plot-panel', 'my-table'),
        tags$h1('Observed Metrics'),
        # tagAppendAttributes(tableOutput(outputId = "observedMetrics"), class = "table_cell")
        uiOutput(outputId = 'observedMetrics')
      ),
      div(
        id = 'plot-orperquantile',
        class = 'plot-panel',
        tags$h1('Odds Ratio by Quintile'),
        # girafeOutput(outputId = "prsOrs"),
        plotOutput(outputId = "prsOrs", width='340px', height= '250px'),
      ),
      div(
        id = 'plot-prevalenceperquantile',
        class = 'plot-panel',
        tags$h1('Prevalence by Quantile'),
        # girafeOutput(outputId = "prsPrevalencebyquantile"),
        plotOutput(outputId = "prsPrevalencebyquantile", width='340px', height= '250px'),
      ),
      div(
        id = 'plot-roc',
        class = 'plot-panel',
        tags$h1('ROC'),
        # girafeOutput(outputId = "prsRoc")
        plotOutput(outputId = "prsRoc", width='340px', height= '250px'),
      ),
      div(
        id = 'plot-topOR',
        class = 'plot-panel',
        tags$h1('Top OR'),
        tagAppendAttributes(
          tableOutput(outputId = "tableOr"),
          class = "table_cell"
        )
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
        # girafeOutput(outputId = "miniBoxplot"),
        plotOutput(outputId = "miniBoxplot", width='150px', height= '70px')
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
  ),

  tags$div(id = "modalBackdrop", class = "modal-backdrop"),

  tags$div(id = "slideshowModal", class = "modal-container",
    tags$button(id = "closeModalButton", class = "modal-close-button", HTML("&times;")), # Use HTML() for special characters

    tags$div(class = "slideshow-content",
      # Slide 1
      tags$div(class = "slide-item active",
        tags$h2(class = "slide-title", "What is a PRS?"),
        tags$p(class = "slide-text", "A polygenic risk score (also called a genetic risk score or simply polygenic score) aggregates the effects of multiple genetic variants associated with the likelihood of developing a given trait (for example, a disease or height).  A higher PRS indicates a greater relative probability of expressing the trait.  Most PRS quantify risk only in comparison to a reference population—so while individuals with higher scores are more likely to develop the trait, a high score alone doesn’t guarantee it, nor does it necessarily imply an absolute high risk."),
        tags$img(
            class = "slide-image",
            src = "images/slide1.png",
            alt = "Slide 1",
            onerror = "this.onerror=null;this.src='https://placehold.co/700x400/cccccc/333333?text=Image+Not+Found';"
        )
      ),
      # Slide 2
      tags$div(class = "slide-item",
        tags$h2(class = "slide-title", "What is a PRS?"),
        tags$p(class = "slide-text", "One way to grasp polygenic risk scores is to contrast them with classic single-gene (Mendelian) inheritance, where a single, often rare, genetic variant drives a trait’s expression or markedly elevates disease risk. Take, for example, pathogenic BRCA1 mutations and their strong association with breast cancer.  By contrast, polygenic inheritance sums the effects of many common variants, each imparting a small increase in risk, to yield an overall susceptibility score."),
        tags$img(
            class = "slide-image",
            src = "images/slide2.png",
            alt = "Slide 2",
            onerror = "this.onerror=null;this.src='https://placehold.co/700x400/cccccc/333333?text=Image+Not+Found';"
        )
      ),
      # Slide 3
      tags$div(class = "slide-item",
        tags$h2(class = "slide-title", "What is a PRS?"),
        tags$p(class = "slide-text", "Single-gene and polygenic mechanisms both play important roles in shaping traits.  A rare, high-impact mutation accounts for only some affected individuals, whereas a polygenic risk score helps explain why, under equivalent environmental conditions, certain people are more likely to develop a disease or carry extra weight."),
        tags$img(
            class = "slide-image",
            src = "images/slide3.png",
            alt = "Slide 3",
            onerror = "this.onerror=null;this.src='https://placehold.co/700x400/cccccc/333333?text=Image+Not+Found';"
        )
      ),
      # Navigation Arrows
      tags$a(class = "prev nav-arrow", tags$span(class = "material-symbols-outlined", "arrow_back_ios")),
      tags$a(class = "next nav-arrow", tags$span(class = "material-symbols-outlined", "arrow_forward_ios"))
    )
  ),
  div(class = 'footer',
    HTML('<i class="fab fa-github"></i>'),
    tags$a(href = "https://github.com/barreiro-r/prs-explorer", "barreiro-r")
    ),
  tags$script(src = "script.js")
) # End of fluidPage
