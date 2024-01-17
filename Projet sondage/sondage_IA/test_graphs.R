library(ggplot2)
library(googlesheets4)
library(tidyverse)
library(wordcloud)
# Test graphiques



d <- read_sheet("https://docs.google.com/spreadsheets/d/1fWHl5EpG-fnCEK8wtwYGpaHbqRHK4hgTErtNXdVBqI0/edit?resourcekey#gid=1935173226")
d <- d[-(175:177),]
d <- d[2:26]

# Définir les nouveaux noms de colonnes
nouveaux_noms <- c("age", "sexe", "niveau", "domaine", "utilisation", "utilisation_non", "ia_frequence", "ia_pourquoi", "productif", "compétences", "amélioration", "satisfaction", "premium", "premium2", "principes", "apprendre","concerné", "emploi", "optimiste", "conscience", "éthique", "réguler", "reguler2", "puce", "vision")

# Renommer les colonnes
colnames(d) <- nouveaux_noms

#age
ggplot(d,aes(x=age))+
  geom_bar()
length(which(d$age>25))/length(d$age)
#9% > 25 ans

#sexe (camembert) 
sexe=as.data.frame(table(d$sexe))
sexe$Freq[2]/sum(sexe$Freq)
#62% Femmes

ggplot(sexe,aes(y=Freq,x="",fill=Var1))+
  geom_histogram(stat = "identity")+
  coord_polar(theta="y")

#niveau
ggplot(d,aes(y=niveau))+
  geom_bar()
prop_niveau=table(d$niveau)/length(d$niveau)
sum(prop_niveau[1:3])
#87% de bac +1 à +3

#domaine
#regroupement des domaines
for (i in 1:nrow(d)){
  if (unlist(strsplit(d$domaine[i],","))[1]=="Informatique"){
    d$domaine[i]="Informatique"
  }
  if (unlist(strsplit(d$domaine[i],","))[1]=="Médecine"){
    d$domaine[i]="Médecine"
  }
  if (unlist(strsplit(d$domaine[i],","))[1]=="Commerce"){
    d$domaine[i]="Commerce"
  }
  if (unlist(strsplit(d$domaine[i],","))[1]=="Economie"){
    d$domaine[i]="Economie"
  }
  if (unlist(strsplit(d$domaine[i],","))[1]=="Psychologie"){
    d$domaine[i]="Psychologie,sociologie"
  }
  if (unlist(strsplit(d$domaine[i],","))[1]=="Ingénieurie"){
    d$domaine[i]="Ingénieurie"
  }
  if (unlist(strsplit(d$domaine[i],","))[1]=="Littérature"){
    d$domaine[i]="Littérature"
  }
  if (unlist(strsplit(d$domaine[i],","))[1]=="Santé biologie"){
    d$domaine[i]="Biologie"
  }
}

table(d$domaine)

ggplot(d,aes(y=domaine))+
  geom_bar()

#utilisation
ggplot(d,aes(y=utilisation))+
  geom_bar()



#utilisation_non
d_utilisation_non=d %>% filter(utilisation_non!="NA")
ggplot(d_utilisation_non,aes(y=utilisation_non))+
  geom_bar()
nrow(d_utilisation_non)

#ia_pourquoi
d_ia_pourquoi = d %>% filter(ia_pourquoi!="NA")
d_ia_pourquoi=table(d_ia_pourquoi$ia_pourquoi)
d_ia_pourquoi=as.data.frame(d_ia_pourquoi)

d_ia_pourquoi #marche pas avec les choix multiples

#frequence
d_ia_frequence = d %>% filter(ia_frequence!="NA")
ggplot(d_ia_frequence,aes(y=ia_frequence))+
  geom_bar()

#productif
d_productif = d %>% filter(productif!="NA")
ggplot(d_productif,aes(x=productif))+
  geom_bar()

#compétences
d_compétences = d %>% filter(compétences!="NA") #peut etre les reclasser par modalités.
  geom_bar()

#amélioration
d_amélioration = d %>% filter(amélioration!="NA")
ggplot(d_amélioration,aes(x=amélioration))+
  geom_bar()

#satisfaction
d_satisfaction = d %>% filter(satisfaction!="NA")
ggplot(d_satisfaction,aes(x=satisfaction))+
  geom_bar()

#principes
d_principes = d %>% filter(principes!="NA")
ggplot(d_principes,aes(x=principes))+
  geom_bar()

#apprendre
d_apprendre = d %>% filter(apprendre!="NA")
ggplot(d_apprendre,aes(x=apprendre))+
  geom_bar()

#concerné
d_concerné = d %>% filter(concerné!="NA")
ggplot(d_concerné,aes(x=concerné))+
  geom_bar()

#evolution
d_évolution = d %>% filter(évolution!="NA")
ggplot(d_évolution,aes(x=évolution))+
  geom_bar()

#emploi
d_emploi = d %>% filter(emploi!="NA")
ggplot(d_emploi,aes(x=emploi))+
  geom_bar()

#optimiste
ggplot(d,aes(y=d$optimiste))+
  geom_bar()



