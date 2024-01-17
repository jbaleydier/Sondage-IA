# Chargement des librairies
library(ggplot2)
library(ggmosaic)



# Préparation des données
# Remplacer 'd' par le nom de votre dataframe complet
d_principes <- d %>% filter(principes != "NA")

# Graphique 1: Diagramme à barres empilées
#sans dodge pour empilé
ggplot(d_principes, aes(x=principes, fill=sexe)) +
  geom_bar(position="dodge") + 
  ggtitle("Diagramme à barres empilées")

# Graphique 2: Graphique en nuage de points
ggplot(d_principes, aes(x=principes, y=sexe)) +
  geom_point() +
  ggtitle("Graphique en nuage de points")

# Graphique 3: Diagramme en boîte
ggplot(d_principes, aes(x=principes, y=sexe)) +
  geom_boxplot() +
  ggtitle("Diagramme en boîte")

# Graphique 4: Graphique à violons
ggplot(d_principes, aes(x=principes, y=sexe)) +
  geom_violin() +
  ggtitle("Graphique à violons")

# Graphique 5: Graphique à secteurs
ggplot(d_principes, aes(x="", fill=principes)) +
  geom_bar(width=1) +
  coord_polar(theta="y") +
  ggtitle("Graphique à secteurs")

# Graphique 6: Graphique en mosaïque
ggplot(data=d_principes) +
  geom_mosaic(aes(x=product(mosaic=principes, sexe), fill=sexe)) +
  ggtitle("Graphique en mosaïque")




