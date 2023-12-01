# server.R

library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {
  # Charger les données
  d <- data.frame(
    Age = c(25, 30, 35, 40, 45),
    Sexe = c("Féminin", "Masculin", "Féminin", "Autres", "Masculin")
  )
  
  # Diagramme en barres pour l'âge
  output$age_plot <- renderPlot({
    ggplot(d[1]) +
      geom_bar() +
      labs(title = "Répartition par âge", x = "Âge", y = "Nombre de personnes")
  })
  
  # Camembert pour le sexe
  output$sexe_pie_chart <- renderPlot({
    sexe_counts <- d[2] %>%
      group_by(Sexe) %>%
      summarize(count = n())
    
    ggplot(sexe_counts, aes(x = "", y = count, fill = Sexe)) +
      geom_bar(stat = "identity") +
      coord_polar(theta = "y") +
      labs(title = "Répartition par sexe")
  })
})
