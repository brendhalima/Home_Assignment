library(shiny)
library(shinyjs)
library(DT)
library(ggplot2)
library(plotly)
library(bslib) 

# Carrega os dados
Market <- read.csv("market_projection.csv", stringsAsFactors = FALSE)

# Garante que os valores de mercado são numéricos e com 2 casas decimais
market_columns <- grep("^MARKET_", colnames(Market), value = TRUE)
for (col in market_columns) {
  Market[[col]] <- as.numeric(Market[[col]])
  Market[[col]][is.na(Market[[col]])] <- 0
  Market[[col]] <- round(Market[[col]], 2)
}
