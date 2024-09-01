#%%%%%%%%%%%%%%%%%%%Import des codes stations de l'année de travail depuis le tableau de programmation des pêches %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#------------------Définir le working directory comme source file location 

current_path = rstudioapi::getActiveDocumentContext()$path 

setwd(dirname(current_path ))

##----------------si besoin de chercher tableau de prog sur le réseau : -------------------------------------------------------------- 
###### ATTENTION : la feuille ProgHDF du fichier excel contient des lignes cachées (ligne 1 à 9), avec des informations de légende 
## => l'importation de cette feuille du fichier excel doit se faire de la ligne 10 à 96 (dernière ligne)


readxl::excel_sheets("../raw_data/20221019_Planning_pluriannuel_peches_electriques.xlsx")

prog_PE<-readxl::read_excel("//ad.intra/dfs/COMMUNS/REGIONS/HDF/DR/ServicesRegionaux/Service_Connaissance/5-Milieux/1-Peche_electrique_CE/Programmation/20221019_Planning_pluriannuel_peches_electriques.xlsx",
                            sheet = "ProgHDF", range = cell_rows (10:96))
# Si les 9 premières lignes sont supprimées, enlever l'argument "range = cell_rows (10:96)" ci-dessus



##---------------si le tableau de programmation est intégré dans le projet R (fichier raw_data)--------------------------------------- 

#prog_PE <- readxl::read_excel("raw_data/20221019_Planning_pluriannuel_peches_electriques.xlsx", 
#                     sheet = "ProgHDF", range = cell_rows (10:96)) 


##--------------- Extraction des codes stations de l'année étudiée--------------------------------------------------------------------

annee_colonne<- get_columns(prog_PE, select = starts_with(annee)) 

stations_prog <- prog_PE %>% 
  mutate(annee_cible = annee_colonne) %>% 
  filter(annee_cible == "R") %>% 
# #       |annee_cible == "E") %>% 
  pull(`Code Sandre`)
