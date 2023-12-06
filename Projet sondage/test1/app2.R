library(shiny)
library(googlesheets4)
library(ggplot2)
library(dplyr)

# Define UI
ui <- fluidPage(
  ( tabsetPanel(
    tabPanel("tab 1",  titlePanel("Test shiny APP, Sondage sur l'IA"),
             actionButton("authButton", "Authentifier avec Google Sheets"),
             actionButton("loadData", "Charger les données"),
             fluidRow(
               column(6, plotOutput("aiUsageFrequencyPlot"), plotOutput("educationLevelPlot")),
               column(6, plotOutput("agePlot"), plotOutput("genderPieChart")),
               # Zone d'affichage pour les messages
               verbatimTextOutput("messageOutput")),
    tabPanel("tab 2", "contents"),
    tabPanel("tab 3", "contents")))
 
  )
)

# Define server logic
server <- function(input, output) {
  # Variable réactive pour stocker les données
  data_reactive <- reactiveVal(NULL)
  message_reactive <- reactiveVal("En attente de chargement des données...")
  observeEvent(input$authButton, {
    gs4_auth()
    message_reactive("Authentification effectuée. Vous pouvez maintenant charger les données.")
  })
  
  
  observeEvent(input$loadData, {
    # Authentification Google Sheets
    gs4_auth()
    
    # Récupérer les données depuis une feuille Google Sheets
    d <- tryCatch({
      read_sheet("https://docs.google.com/spreadsheets/d/1fWHl5EpG-fnCEK8wtwYGpaHbqRHK4hgTErtNXdVBqI0/edit?resourcekey#gid=1935173226")
    }, error = function(e) {
      message_reactive("Erreur lors du chargement des données.")
      NULL
    })
   
    d <- d[-(175:177), ]
    
    # Mettre à jour la variable réactive avec les données
    data_reactive(d)
  })
  
  # Graphique de distribution des âges
  output$agePlot <- renderPlot({
    if (is.null(data_reactive())) return(NULL)
    d <- data_reactive()
    ggplot(d, aes(y=..density..,x=`1 - Quel est ton âge ? (nombre)`)) + 
      geom_histogram(binwidth = 1, fill="grey", color="black") +
      theme_minimal() +
      xlab("Age") + 
      ylab("Proportion") +
      ggtitle("Distribution des Âges")
  })
  
  # Graphique de répartition des genres
  output$genderPieChart <- renderPlot({
    if (is.null(data_reactive())) return(NULL)
    d <- data_reactive()
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
  
  # Graphique de fréquence d'utilisation de l'IA
  output$aiUsageFrequencyPlot <- renderPlot({
    if (is.null(data_reactive())) return(NULL)
    d <- data_reactive()
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
  
  # Graphique de distribution des niveaux de formation
  output$educationLevelPlot <- renderPlot({
    if (is.null(data_reactive())) return(NULL)
    d <- data_reactive()
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
  output$messageOutput <- renderText({
    message_reactive()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
