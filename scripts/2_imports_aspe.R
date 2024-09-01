#%%%%%%%% Import des données ASPE pour les Hauts-de-France #%%%%%%%%%

#------------------Définir le working directory comme source file location 

current_path = rstudioapi::getActiveDocumentContext()$path 

setwd(dirname(current_path))

#### Import données individuelles #### ----------------------------------------------------

#--------importation des RData des tables de base 

load(file="../raw_data/tables_sauf_mei_2024_05_23_10_07_36.117841.Rdata")
load(file="../raw_data/mei_2024_05_23_10_07_36.063491.RData")

#--------création du data frame de données individuelles pour les HDF 
## pour les HDF = toutes les opérations commanditées par la DR HDF 

aspe_mei_hdf <- 
  
  aspe::mef_creer_passerelle() %>% # creation passerelle
  
  aspe::mef_ajouter_objectif() %>%  # ajout objectif de peche et selection des reseaux de suivi DCE 
  dplyr::filter(obj_libelle %in% c(
    "RCS – Réseau de Contrôle de Surveillance",
    "RHP – Réseau Hydrobiologique Piscicole",
    "RRP – Réseau de Référence Pérenne",
    "RNSORMCE – Réseau National de Suivi des Opérations de Restauration hydroMorphologiques des Cours d'Eau")) %>% 
  
  aspe::mef_ajouter_ope_date() %>%  # ajout de la date des opérations
  
  aspe::mef_ajouter_intervenants() %>% # ajout des intervenants
  dplyr::select(-operateur_ofb, 
                - commanditaire_ofb, 
                - validation_ofb, 
                - starts_with('ope_int_id')) %>%
  dplyr::left_join(operation %>% 
                     dplyr::select(ope_id, ope_directeur_peche),
                   by="ope_id") %>% 
  
 
  dplyr::filter(grepl('HAUTS DE FRANCE', commanditaire)) %>%  # filtre sur les opérations commanditées par la DR HDF 
  

  dplyr::left_join(station %>%   # jointure infos SANDRE sur les stations
                     dplyr::select(sta_id, sta_code_sandre, sta_libelle_sandre, sta_coordonnees_x, sta_coordonnees_y, 
                                   sta_code_national_masse_eau), 
                   by="sta_id") %>% 
  
  
  dplyr::left_join(point_prelevement %>% # jointure infos SANDRE PP 
                     dplyr::select(pop_id, pop_code_sandre, pop_bas_id, pop_coordonnees_x, pop_coordonnees_y), by = "pop_id") %>% 
  dplyr:: left_join(ref_bassin %>% 
                      dplyr::select(bas_id, bas_libelle_sandre), by= c("pop_bas_id"= "bas_id")) %>%  #jointure nom de bv 
  
  aspe::mef_ajouter_dept() %>% # ajout info de departement 
  
 
  aspe::mef_ajouter_moyen_prospection() %>% # ajout infos moyen de prospection
  
 
  aspe::mef_ajouter_lots() %>% # ajout lot poissons
  
  aspe::mef_ajouter_esp() %>% # noms des espèces
  
  aspe::mef_ajouter_mei() %>% # mesures individuelles
  
  aspe::mef_ajouter_passage() %>% # numéro du passage pour éventuellement filtrer dessus + calculer nombre de passages 
  
  aspe::mef_ajouter_type_longueur() %>% 
  
  aspe::mef_ajouter_type_lot() %>% 
  
  aspe::mef_ajouter_type_protocole() %>%  # ajout protocole
  
  aspe::mef_ajouter_ope_env() %>%  # ajout donnees env
  
  aspe::mef_ajouter_groupe_points() %>% 
  
  dplyr::select(- starts_with('grp_nombre_points')) %>% 
  
  dplyr::left_join(operation %>% dplyr::select(ope_id, ope_surface_calculee)) %>% # ajout surface
  
  dplyr :: left_join(operation_description_peche %>% 
                       dplyr::select(odp_ope_id,
                                     odp_mom_id, 
                                     odp_tension, odp_intensite, odp_puissance,
                                     odp_nombre_anodes, odp_nombre_epuisettes,
                                     odp_temperature_instantanee,
                                     odp_conductivite,
                                     odp_ted_id,
                                     odp_tur_id,
                                     odp_coh_id,
                                     odp_debit_moyen_journalier
                                     ),
                     by= c("ope_id" = "odp_ope_id")) %>% 
  dplyr:: left_join(ref_modele_materiel %>% 
                      dplyr::select(mom_id, mom_libelle, mom_fam_id),
                    by=c("odp_mom_id" ="mom_id")) %>% 
  dplyr:: left_join(ref_fabricant_materiel %>% 
                     dplyr::select(fam_id, fam_libelle),
                   by= c("mom_fam_id" = "fam_id")) %>% 
  dplyr::left_join(ref_condition_hydrologique, by=c("odp_coh_id"="coh_id")) %>% 
  dplyr::left_join(ref_turbidite, by=c("odp_tur_id"="tur_id")) %>% 
  
  dplyr::select(-odp_tur_id, #enlever colonnes inutiles d'id 
                -odp_coh_id,
                -pop_bas_id,
                -tyl_id,
                -tlo_id,
                -mei_age,
                -odp_mom_id,
                -mom_fam_id,
                -coh_libelle_sandre,
                -coh_code_sandre,
                -coh_ordre_affichage,
                -tur_code_sandre)

  
#### Import données d'IPR ####

#--------création du data frame de données d'ipr pour les HDF 
## pour les HDF = toutes les opérations commanditées par la DR HDF (repris du data frame aspe_mei_hdf)

aspe_ipr_hdf <-
  aspe_mei_hdf %>% 
  select(sta_code_sandre, sta_libelle_sandre, pop_code_sandre, ope_id, annee) %>%  
  mef_ajouter_ipr() %>%
  mef_ajouter_metriques() %>% 
  select(-(ner_observe :
          dti_observe)) %>% 
  dplyr::left_join(operation_ipr %>% 
                     select(opi_ope_id, opi_date_execution:opi_param_bassin), 
                   by=c("ope_id" = "opi_ope_id")) %>% 
  unique() %>% 
  dplyr:: mutate(cli_libelle = factor(cli_libelle, 
                       ordered = T, 
                       levels= c("Très bon",
                                 "Bon",
                                 "Moyen",
                                 "Médiocre",
                                 "Mauvais")))

#-----------tableau des classes de qualité de l'ipr (directement disponible dans les tables de base)

qualite_ipr<- classe_ipr %>% 
  filter(cli_altitude_min != 500 | 
           is.na(cli_altitude_min)) %>% 
  dplyr::select(cli_libelle : cli_borne_sup) %>% 
  dplyr:: mutate(cli_libelle = factor(cli_libelle, 
                                      ordered = T, 
                                      levels= c("Très bon",
                                                "Bon",
                                                "Moyen",
                                                "Médiocre",
                                                "Mauvais")))

#-----------tableau des probabilité de présence pour chaque opération (directement disponible dans les tables de base)

proba_presence <- probabilite_presence_ipr %>% 
  filter(ppi_opi_ope_id %in% aspe_ipr_hdf$ope_id) %>% 
  dplyr:: left_join(aspe_ipr_hdf %>% 
                      select(ope_id, sta_code_sandre, sta_libelle_sandre, annee),
                    by = c("ppi_opi_ope_id" = "ope_id")) %>% 
  dplyr::left_join(ref_espece %>% 
                     select(esp_id, esp_code_alternatif, esp_nom_commun, esp_nom_latin),
                   by= c("ppi_esp_id" = "esp_id")) %>% 
  select(ope_id = ppi_opi_ope_id,
         sta_code_sandre, sta_libelle_sandre, 
         annee,
         esp_code_alternatif, esp_nom_commun, esp_nom_latin, 
         ppi_valeur_probabilite, ppi_param_effectif)
