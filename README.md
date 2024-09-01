# rapports_auto_peche_aspe
Projet permettant de générer des rapports automatisés de pêches scientifiques à l'électricité à partir des données de l'OFB des Hauts-de-France (données de l’Application de Saisie des données Piscicoles et Environnementales (ASPE)). 
Ces rapports sont générés pour les pêches des réseaux :
- RCS (Réseau de Contrôle de Surveillance),
- RHP (Réseau Hydrobiologique et Piscicole),
- RRP (Réseau de Référence Pérenne),
- RNSORMCE (Réseau National de Suivi des Opérations de Restauration hydroMorphologiques des Cours d'Eau, dans le cadre notamment des Suivis Scientifiques Minimums)  

Les données ASPE proviennent du package "aspe" (https://pascalirz.github.io/aspe/). 
Ces rapports sont inspirés des rapports de pêche développés par la Direction Régionale de Normandie de l'OFB. 

Structure du projet : 

- dossier "images" : dossier dans lequel sont sauvegardés les images/cartes/ghraphiques retrouvés dans les rapports de pêche
- dossier "output" : dossier où sont sauvegardés les rapports de pêche générés
- dossier "raw_data" : dossier contenant les données brutes utiles au projet (dont tables de base de ASPE, couches .shp des stations des réseaux DCE hors pêches etc.)
- dossier "scripts" : dossier contenant les fichiers .R necessaires pour générer les rapports (packages nécessaires, importation des données piscicoles, importation des stations de pêche de travail, lancement de la production des rapports)
- dossier "template" : dossier contenant le fichier .Rmd squelette des rapports de pêche et le fichier .docx de référence pour la mise en page des rapports
