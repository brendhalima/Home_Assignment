function(input, output, session) {
  # Update the market selector input with available market columns
  # 'market_columns' should be a predefined vector of column names representing markets
  
  updateSelectInput(session, "selected_market", choices = market_columns, selected = market_columns[1])
  
  # Create reactive values to store current editable data and original data (for reset)
  rv <- reactiveValues(
    data = Market,
    original_data = Market
  )
  
  # ObserveEvent to "Reset Data" button click
  observeEvent(input$reset_data, {
    rv$data <- rv$original_data
  })
  
  # Render the editable DataTable output
  output$editable_table <- renderDT({
    req(input$selected_market)
    
    # Determine which columns should NOT be editable
    # 'datatable' uses zero-based indexing for columns
    # Editing has been disabled on all columns except the one selected in 'selected_market'
    disable_columns <- which(colnames(rv$data) != input$selected_market) - 1
    
    # Create the datatable
    
    datatable(
      rv$data,
      extensions = 'KeyTable', # Enables keyboard navigation
      editable = list(
        target = "cell", # Allow editing at cell level
        disable = list(columns = disable_columns) # Disable editing on non-selected market columns
      ),
      options = list(
        keys = TRUE,     # Enable keyboard keys navigation
        pageLength = 12, # Number of rows per page
        scrollX = TRUE,  # Enable horizontal scrolling for wide tables
        columnDefs = list(
          list(visible = FALSE, targets = 0), # Hide first column
          list(width = '70px', targets = 1),  # Set width for second column
          list(width = '50px', targets = 2:(ncol(rv$data) - 1))) # Set width for remaining columns
      ),
      rownames = FALSE,
    )
  })
  
  # ObserveEvent when a cell is edited in the DataTable
  observeEvent(input$editable_table_cell_edit, {
    info <- input$editable_table_cell_edit      # Get info about the edited cell
    i <- info$row                               # Edited row (1-based)
    j <- info$col + 1                           # Edited column (convert zero-based DT to R's 1-based)
    colname <- colnames(rv$data)[j]             # Get the name of the edited column
    
    
    # Only allow changes if the edited column is one of the market columns
    if (colname %in% market_columns) {
      new_value <- as.numeric(info$value)       # Convert new value to numeric
      if (!is.na(new_value)) {                  # Validate it is a number
        # Update the reactive data with the rounded new value (2 decimal places)
        rv$data[i, j] <- round(new_value, 2)
      }
    }
  })
  
  # Render a Plotly comparison plot between original and edited data for the selected market
  
  output$market_plot <- renderPlotly({
    req(input$selected_market)        # Require a selected market
    
    # Prepare data frame for plotting, converting TERM column to Date
    
    df_plot <- data.frame(
      Date = as.Date(rv$data$TERM),
      Original = rv$original_data[[input$selected_market]],
      New = rv$data[[input$selected_market]]
    )
    
    # Build the ggplot object
    p <- ggplot(df_plot, aes(x = Date)) +
      geom_line(aes(y = Original, color = "Original"), size = 1) +                # Original data line
      geom_point(aes(y = Original, color = "Original"), size = 2) +               # Original data points
      geom_line(aes(y = New, color = "Edited"), size = 1, linetype = "dashed") +  # Edited data line (dashed)
      geom_point(aes(y = New, color = "Edited"), size = 2) +                      # Edited data points
      labs(title = paste(input$selected_market, ": Original vs Edited"),
           x = "Date", y = "Value", color = ""
      ) +
      theme_minimal(base_size = 12) + 
      theme(plot.title = element_text(size = 10))
    
    # Convert ggplot to interactive plotly plot
    ggplotly(p)
  })
  
  # Download handler for exporting the edited data as CSV file
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("edited_market_", Sys.Date(), ".csv")    # Filename with current date
    },
    content = function(file) {
      # Write the reactive edited data to CSV without row names
      write.csv(rv$data, file, row.names = FALSE)
    }
  )
  
  # Toggle visibility of the user guide panel when the help button is clicked
  observeEvent(input$toggle_guide, {
    shinyjs::toggle(id = "user_guide_panel")
  })
  
  
}
