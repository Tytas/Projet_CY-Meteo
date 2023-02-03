# Projet_CY-Meteo

Cette application utilise un script shell qui utilise des options qui permettront d'analyser des données météorologiques provenant d'un fichier CSV, ici meteo_filtered_data_v1.csv. Les options permettent de spécifier les modalités de traitement de la température, de la pression, de l'humidité et de l'altitude. Les options permettent également de choisir entre différents modes de tri, tels que les tableaux, les arbres binaires de recherche et les arbres binaires de recherche équilibrés.

Utilisation :

Pour utiliser ce script, il faut ouvrir un terminal et accéder au répertoire contenant le fichier shell, "script.sh". Ensuite, exécutez la commande suivante:

./script.sh <OPTIONS>
Les options disponibles sont les suivantes:

--help: Affiche un message d'aide sur l'utilisation du script.
--abr: Utilise les arbres binaires de recherche comme mode de tri dans le programme c.
--avl: Utilise les arbres binaires de recherche équilibrés comme mode de tri dans le programme.
--tab: Utilise les tableaux comme mode de tri dans le programme c.
-f: Spécifie le fichier d'entrée obligatoire.
-t: Spécifie le mode de température (1, 2 ou 3).
  -1) Produit produit en sortie les températures minimales, maximales et moyennes par station.
  -2) produit en sortie les températures moyennes par date/heure.
  -3) produit en sortie les températures par date/heure par station. 
-p: Spécifie le mode de pression (1, 2 ou 3).
  -1) Produit produit en sortie les pressions minimales, maximales et moyennes par station.
  -2) produit en sortie les pressions moyennes par date/heure.
  -3) produit en sortie les pressions par date/heure par station.
-m: Contient les informations sur l'humidité.
-h: Contient les informations sur les altitudes.
  
les options peuvent être entrées dans n'importe quel ordre.

Les fichiers filtrés en sortie sont censése être récupéré par un programme C et trié selon les options en fonction du mode de tri choisit.
