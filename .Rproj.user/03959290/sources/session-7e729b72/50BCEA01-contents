fluidPage(
  useShinyjs(),
  
  # Choice Theme
  theme = bs_theme(
    version = 5,
    bootswatch = "cosmo",
    primary = "#005f73",
    font_scale = 0.9
  ),
  
  titlePanel("📊 Market Data"),
  
  actionButton("toggle_guide", label = NULL, icon = icon("circle-question"), 
               class = "btn btn-outline-info", style = "float: right; margin-top: -40px; margin-right: 10px;"),
  
  
  # Market selector and reset button
  fluidRow(
    column(
      width = 4,
      selectInput("selected_market", "Select Market:", choices = NULL)
    ),
    column(
      width = 8,
      br(),
      actionButton("reset_data", "Reset Data", icon = icon("arrow-rotate-left"), class = "btn btn-danger")
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      width = 7,
      
      # Linha com título e botão lado a lado
      fluidRow(
        column(
          width = 8,
          h4("📋 Market Table")
        ),
        column(
          width = 4,
          downloadButton("download_data", "Download Data", class = "btn btn-success", style = "float: right;")
        )
      ),
      
      helpText("Double-click on a cell to edit. Use arrow keys to navigate. Click 'Reset Data' to revert changes."),
      DTOutput("editable_table"),
      br(), br()
    ),
    
    column(
      width = 5,
      h4("📈 Comparison Plot"),
      br(),br(),br(),
      plotlyOutput("market_plot", height = "400px")
    )
  ),
  
  div(
    id = "user_guide_panel",
    style = "display:none;",
    absolutePanel(
      top = 10, right = 10, width = 300, draggable = TRUE,
      style = "z-index: 999; background-color: #f8f9fa; padding: 10px; border-radius: 8px; box-shadow: 0 0 5px rgba(0,0,0,0.2);",
      h5("📘 Guide User"),
      tags$ul(
        tags$li("Select a market to show the graph/edit the values."),
        tags$li("Use arrow keys to navigate the cells."),
        tags$li("Double-click to edit the cell."), 
        tags$li("NOTE: Just the market selected is editable."),
        tags$li("Click Reset to undo edits."),
        tags$li("Download your table when done.")
      )
    )
  ), 
  
  tags$footer(
    style = "
    position: fixed;
    bottom: 0;
    width: 100%;
    background-color: #f8f9fa;
    color: #555;
    text-align: center;
    padding: 8px 0;
    border-top: 1px solid #ddd;
    font-size: 0.9em;
    z-index: 1000;
  ",
    "© 2025 Argus Media | Brendha Rodrigues de Lima's Home Assignment"
  )
  
  
  
)