# Packages necessaires pour faire tourner les rapports automatisés de pêche et scripts annexes 

if (!require(pacman)) install.packages("pacman") 
if(!require("aspe")) devtools::install_github("PascalIrz/aspe")

pacman::p_load(tidyverse, 
               readxl,
               aspe, 
               sf, 
               mapview, 
               leaflet,
               flextable,
               datawizard,
               scales,
               ggpubr,
               ggiraphExtra,
               rstudioapi,
               officedown
               ) # installe les packages non installés et charge tout
