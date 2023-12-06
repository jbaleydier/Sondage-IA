# Installer la bibliothèque googlesheets4 si ce n'est pas déjà fait
#install.packages("googlesheets4")

# Charger la bibliothèque googlesheets4
library(googlesheets4)

# Authentification Google Sheets
gs4_auth()

# Récupérer les données depuis une feuille Google Sheets
d=read_sheet("https://docs.google.com/spreadsheets/d/1fWHl5EpG-fnCEK8wtwYGpaHbqRHK4hgTErtNXdVBqI0/edit?resourcekey#gid=1935173226")

# Utilisez maintenant l'objet "sheet" pour manipuler les données comme vous le souhaitez.
d<- d[-(1:33), ]
d=d[-1]
d
rsconnect::setAccountInfo(name='cedricj07',
                          token='591B2F1088980CF2629214A02AF326B8',
                          secret='pIgoQvJQuywqoLkKGetHwnhBVVww5z5LBzOIFm0x')
