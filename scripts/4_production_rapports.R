#%%%%%%%%%%%%%%%%%%%%%%%%% Production en chaine des rapports par station %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#------------------Définir le working directory comme source file location 

current_path = rstudioapi::getActiveDocumentContext()$path 

setwd(dirname(current_path ))

#---------------- Année pour laquelle produire les rapports--------------------------------

annee <- "2023" #à changer en fonction du besoin 

#----------------Scripts sources (packages, data frames, vecteurs necessaires)---------------

source("1_packages.R")
source("2_imports_aspe.R")
source("3_stations_prog.R")

#---------------- Production des rapports pour toutes les stations de l'année en régie---------------------------------------------------

purrr:: map(.x = stations_prog,   
    .f = ~ 
      rmarkdown::render(input = "../templates/template_rapport_peche.Rmd",
                        output_file = paste0("../output/rapport_peche_", .x, "_", annee,".docx"),
                        params= list(code_station = .x, 
                                     annee = annee)))

#-----------------Production d'un rapport pour une seule station si besoin est------------------------------------

station <- "01000729"  #modifier le code station en fonction de la station ciblée
rmarkdown::render(input = "../templates/template_rapport_peche.Rmd",
                  output_file = paste0("../output/test_", station, "_", annee,".docx"),
                  params= list(code_station = station,   
                               annee = annee))

