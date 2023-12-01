# ui.R

library(shiny)

shinyUI(fluidPage(
  titlePanel("Sondage sur l'IA"),
  
  # Diagramme en barres pour l'âge
  plotOutput("age_plot"),
  
  # Camembert pour le sexe
  plotOutput("sexe_pie_chart")
))
