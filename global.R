library(shiny)
library(shinyjs)
library(DT)
library(ggplot2)
library(plotly)
library(bslib) 

# Load the data from Excel sheet
Market <- read.csv("market_projection.csv", stringsAsFactors = FALSE)

# Ensures that market values are numeric and have 2 decimal places
market_columns <- grep("^MARKET_", colnames(Market), value = TRUE)
for (col in market_columns) {
  Market[[col]] <- as.numeric(Market[[col]])
  Market[[col]][is.na(Market[[col]])] <- 0
  Market[[col]] <- round(Market[[col]], 2)
}
