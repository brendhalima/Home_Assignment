function(input, output, session) {
  # Define colunas disponíveis e popula o selectInput
  updateSelectInput(session, "selected_market", choices = market_columns, selected = market_columns[1])
  
  # Dados reativos
  rv <- reactiveValues(
    data = Market,
    original_data = Market
  )
  
  # Botão "Reset"
  observeEvent(input$reset_data, {
    rv$data <- rv$original_data
  })
  
  # Renderiza a tabela editável
  output$editable_table <- renderDT({
    req(input$selected_market)
    
    # Define colunas não-editáveis (0-based index para DT)
    disable_columns <- which(colnames(rv$data) != input$selected_market) - 1
    
    datatable(
      rv$data,
      extensions = 'KeyTable',
      editable = list(
        target = "cell",
        disable = list(columns = disable_columns)
      ),
      options = list(
        keys = TRUE,
        pageLength = 12,
        scrollX = TRUE,
        columnDefs = list(
          list(visible = FALSE, targets = 0), 
          list(width = '70px', targets = 1),
          list(width = '50px', targets = 2:(ncol(rv$data) - 1)))
      ),
      rownames = FALSE,
    )
  })
  
  # Atualiza valor editado na tabela
  observeEvent(input$editable_table_cell_edit, {
    info <- input$editable_table_cell_edit
    i <- info$row
    j <- info$col + 1  # Ajuste para 1-based do R
    colname <- colnames(rv$data)[j]
    
    if (colname %in% market_columns) {
      new_value <- as.numeric(info$value)
      if (!is.na(new_value)) {
        rv$data[i, j] <- round(new_value, 2)
      }
    }
  })
  
  # Gráfico comparando valores originais e editados
  
  output$market_plot <- renderPlotly({
    req(input$selected_market)
    df_plot <- data.frame(
      Date = as.Date(rv$data$TERM),
      Original = rv$original_data[[input$selected_market]],
      New = rv$data[[input$selected_market]]
    )
    p <- ggplot(df_plot, aes(x = Date)) +
      geom_line(aes(y = Original, color = "Original"), size = 1) +
      geom_point(aes(y = Original, color = "Original"), size = 2) +
      geom_line(aes(y = New, color = "Edited"), size = 1, linetype = "dashed") +
      geom_point(aes(y = New, color = "Edited"), size = 2) +
      labs(title = paste(input$selected_market, ": Original vs Edited"),
           x = "Date", y = "Value", color = ""
      ) +
      theme_minimal(base_size = 12) + 
      theme(plot.title = element_text(size = 10))
    ggplotly(p)
  })
  
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("edited_market_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(rv$data, file, row.names = FALSE)
    }
  )
  
  observeEvent(input$toggle_guide, {
    shinyjs::toggle(id = "user_guide_panel")
  })
  
  
}
