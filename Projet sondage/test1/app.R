library(shiny)
library(ggplot2)
library(dplyr)
str(d)

# library(googlesheets4)
# 
# # Authentification Google Sheets
# gs4_auth()
# 
# # Récupérer les données depuis une feuille Google Sheets
# d <- read_sheet("https://docs.google.com/spreadsheets/d/1fWHl5EpG-fnCEK8wtwYGpaHbqRHK4hgTErtNXdVBqI0/edit?resourcekey#gid=1935173226")
# 
# # Utilisez maintenant l'objet "sheet" pour manipuler les données comme vous le souhaitez.
# d <- d[-(1:33), ]

# Define UI for the application
ui <- fluidPage(
  titlePanel("Test shiny APP, Sondage sur l'IA"),
  
  fluidRow(
    column(6,
           plotOutput("aiUsageFrequencyPlot"),
           plotOutput("educationLevelPlot")
    ),
    
    column(6,
           plotOutput("agePlot"),
           plotOutput("genderPieChart")
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Plot for Age Distribution
  output$agePlot <- renderPlot({
    ggplot(d, aes(y=..density..,x=`1 - Quel est ton âge ? (nombre)`)) + 
      geom_histogram(binwidth = 1, fill="grey", color="black") +
      theme_minimal() +
      xlab("Age") + 
      ylab("Proportion") +
      ggtitle("Distribution des Âges")
  })
  
  # Pie Chart for Gender Distribution with Custom Colors
  output$genderPieChart <- renderPlot({
    gender_data <- d %>% 
      group_by(`2 - Quel est ton genre ?`) %>% 
      summarise(Count = n()) %>% 
      mutate(freq = Count / sum(Count) * 100)
    
    colors <- c("Féminin" = "pink", "Masculin" = "lightblue", "Autre" = "purple")
    
    ggplot(gender_data, aes(x="", y=freq, fill=`2 - Quel est ton genre ?`)) +
      geom_bar(width = 1, stat = "identity") +
      coord_polar("y", start=0) +
      scale_fill_manual(values=colors) +
      theme_void() +
      theme(legend.title = element_blank()) +
      labs(fill = "Genre") +
      ggtitle("Répartition des Genres")
  })
  
  # Bar Chart for AI Usage Frequency
  output$aiUsageFrequencyPlot <- renderPlot({
    ai_usage_data <- d %>% 
      group_by(`6 - Si oui, à quelle fréquence utilises-tu une IA générative (ChatGPT, Mid-journey ou équivalent) ?`) %>% 
      summarise(Count = n()) %>%
      filter(!is.na(`6 - Si oui, à quelle fréquence utilises-tu une IA générative (ChatGPT, Mid-journey ou équivalent) ?`)) %>%
      mutate(Proportion = Count / sum(Count))
    
    ggplot(ai_usage_data, aes(x=reorder(`6 - Si oui, à quelle fréquence utilises-tu une IA générative (ChatGPT, Mid-journey ou équivalent) ?`, -Proportion), y=Proportion)) +
      geom_bar(stat="identity", aes(fill=Proportion)) +
      scale_fill_gradient(low="lightblue", high="blue") +
      coord_flip() + 
      theme_minimal() +
      xlab("") +
      ylab("Proportion") +
      ggtitle("Proportion d'utilisation des IA génératives")
  })
  
  output$educationLevelPlot <- renderPlot({
    education_data <- d %>% 
      group_by(`3 - Quel est ton niveau universitaire actuel ?`) %>% 
      summarise(Count = n()) %>%
      filter(!is.na(`3 - Quel est ton niveau universitaire actuel ?`)) %>%
      mutate(Proportion = Count / sum(Count))
    
    ggplot(education_data, aes(x=reorder(`3 - Quel est ton niveau universitaire actuel ?`, -Proportion), y=Proportion)) +
      geom_bar(stat="identity", aes(fill=Proportion)) +
      coord_flip() + 
      theme_minimal() +
      xlab("Niveau de formation") +
      ylab("Proportion") +
      ggtitle("Distribution des Niveaux de Formation")
  })
  
  
    
}


# Run the application
shinyApp(ui = ui, server = server)

