#!/bin/bash


tri_option="avl"






# Fonction qui affiche un message d'erreur
error() {
  echo "Erreur: Arguments manquant(s) ou invalide(s)."
  echo "Essayez ./script.sh --help pour plus"
  exit 1 
}

# Transformation des options longues en option courte, comme getopts ne prend pas en compte d'options longues.
for arg in "$@"; do
  shift
  case "$arg" in
    '--help') set -- "$@" '-a' ;;
    '--abr') set -- "$@" '-b' ;;
    '--avl') set -- "$@" '-c' ;;
    '--tab') set -- "$@" '-e' ;;
    *)  set -- "$@" "$arg" ;;
  esac
done

#valeur de abr, avl et tab fixées à 0, avant l'analyse des options.
abr=0; avl=0; tab=0


#Analyse des options courtes
OPTIND=1
 


#Utilisation de getopts pour traiter les arguments de la ligne de commande. Des commandes sont executées en fonction des arguments.
while getopts "abcef:t:p:wmh" opt; do
case $opt in
'a') echo "Utilisation : $0 [-f file] [-t temp_mode] [-p press_mode] [-w] [-m] [-h] [--tab | --abr | --avl] [--help]" #Lorsque l'option --help est utilisée, un message d'aide sur l'utilisation du script est affiché
echo " -f : fichier d'entrée obligatoire"
echo " -t : mode temperature (1, 2, ou 3)"
echo " -p : mode pression (1, 2, ou 3)"
echo " -m : contient le données sur l'humidité"
echo " -h : contient les informations sur les altitudes"
echo " --tab : utilisation des tableaux comme mode de tri"
echo " --abr : utilisation des arbres binaire de recherche comme mode de tri"
echo " --avl : utilisation des arbres binaire de recherche équilibréscomme mode de tri"
echo " --help : afficher le message d'aide"
exit 0
;;
'b') tri_option="abr"  ;;
'c') tri_option="avl"  ;;
'e') tri_option="tab" ;;
f)
fichier="$OPTARG"
;;
t)
temp_mode="$OPTARG"
#Si le mode de température n'est pas le bon (différent de 1, 2, 3)  un message d'erreur s'affiche
if [ "$temp_mode" != "1" ] && [ "$temp_mode" != "2" ] && [ "$temp_mode" != "3" ]; then 
error
fi
;;
p)
press_mode="$OPTARG"
#Pareil pour le mode pression
if [ "$press_mode" != "1" ] && [ "$press_mode" != "2" ] && [ "$press_mode" != "3" ]; then
error
fi
;;
m)
humid=1
;;
h)
alt=1
;;
*)
error
;;
esac
done


#Si aucune option n'est rentrée lors de l'execution, un message d'erreur s'affiche

if [ $# -eq 0 ] ; then
  error
fi



# Erreur si l'option -f n'est pas renséignée lors de l'execution
if [ -z "$fichier" ]; then
  echo "Erreur: L'option -f est requise."
  exit 1
fi




#Le nombre de mesure des temperatures est stocké dans count. 
#Awk définit le min et le max par station et fait aussi une moyenne à l'aide de toutes les mesures. 
#La fonction lenght verifie sur une case de la colonne temperature est vide.
#Si c'est le cas, aucune mesure n'est faite.
#dans awk, NR > 1 nous permet d'ignorer la premiere ligne du fichier csv.

if [ -n "$temp_mode" ]; then
  if [ "$temp_mode" == "1" ]; then
OFMT="%.2f"
awk -F ";" 'NR > 1 {
  station = $1
  temperature = $11
  if (length(temperature) > 0) { 
  count[station]++
  sum[station] += temperature
  if (temperature < min[station] || !min[station]) {
    min[station] = temperature
  }
  if (temperature > max[station] || !max[station]) {
    max[station] = temperature
  }
}
}
END {
  for (station in count) {
    avg = sum[station] / count[station]
    print station ";" max[station] ";" min[station] ";" avg
  }
}' $fichier > modet1.csv
temp_fichier="modet1.csv"
#Choix du tri en fonction de l'argument choisi (--avl, --abr, --tab)
if [ "$tri_option" == "tab" ] ; then
  make 
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des tableaux comme mode de tri t1"
elif [ "$tri_option" == "abr" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche comme mode de tri t1"
elif [ "$tri_option" == "avl" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche équilibrés scomme mode de tri t1"
fi


elif [ "$temp_mode" == "2" ]; then
	OFMT="%.2f"
# extraction des dates et heures
cut -d ";" -f 2,11 $fichier > date_temp.csv


#Temperatures moyenne par dates et heures.
awk -F ";" 'NR > 1 {
  dates[$1]+=$2
  n[$1]++ 
} END {
  for (date in dates) {
    print date ";" dates[date]/n[date]
  }
}' date_temp.csv > modet2.csv
temp_fichier="modet2.csv"
rm date_temp.csv 
#Choix du tri en fonction de l'argument choisi (--avl, --abr, --tab)
if [ "$tri_option" == "tab" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des tableaux comme mode de tri t2"
elif [ "$tri_option" == "abr" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
 #echo "Utilisation des arbres binaire de recherche comme mode de tri t2"
elif [ "$tri_option" == "avl" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option" 

fi


 elif [ "$temp_mode" == "3" ]; then
	OFMT="%.2f"
	awk -F ";" 'NR > 1 { dates[$2 " " $1] += $11
   count[$2 " " $1]++ } 
END { 
  for (date_station in dates) { 
    split(date_station, parts, " ") 
     avg = dates[date_station] / count[date_station]
    print parts[1] ";" parts[2] ";" avg }
}' $fichier > modet3.csv
temp_fichier="modet3.csv"
#Choix du tri en fonction de l'argument choisi (--avl, --abr, --tab)
if [ "$tri_option" == "tab" ] ; then
  make
  ./prog4 "$temp_fichier" "$sort_option"

elif [ "$tri_option" == "abr" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"

elif [ "$tri_option" == "avl" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"

fi

fi
fi

if [ -n "$press_mode" ]; then
  if [ "$press_mode" == "1" ]; then #mode de pression 1
OFMT="%.2f"
#La commande awk vérifie si dans la colonne de pression, les cases sont vides. Sinon, il compte le nombre de mesures par stations et détermine le max et le min. Enfin, elle affiche les résultats souhaités.
awk -F ";" 'NR > 1 {
  station = $1
  pressure = $7
  if (length(pressure) > 0) {
  count[station]++
  sum[station] += pressure
  if (pressure < min[station] || !min[station]) {
    min[station] = pressure
  }
  if (pressure > max[station] || !max[station]) {
    max[station] = pressure
  }
}
}
END {
  for (station in count) {
    avg = sum[station] / count[station]
    print station ";" max[station] ";" min[station] ";" avg
  }
}' $fichier > modep1.csv
temp_fichier="modep1.csv"

#Choix du tri en fonction de l'argument choisi (--avl, --abr, --tab)
if [ "$tri_option" == "tab" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des tableaux comme mode de tri p1"
elif [ "$tri_option" == "abr" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche comme mode de tri p1"
elif [ "$tri_option" == "avl" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche équilibrés comme mode de  p1"
fi


elif [ "$press_mode" == "2" ]; then # mode de pression 2
	OFMT="%.2f"


cut -d ";" -f 2,7 $fichier > date_press.csv


awk -F ";" 'NR > 1 {
  dates[$1]+=$2
  n[$1]++
}  END {
  for (date in dates) {
    print date ";" dates[date]/n[date]
  }
}' date_press.csv > modep2.csv
temp_fichier="modep2.csv"
rm date_press.csv
#Choix du tri en fonction de l'argument choisi (--avl, --abr, --tab)
if [ "$tri_option" == "tab" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des tableaux comme mode de tri p2"
elif [ "$tri_option" == "abr" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche comme mode de tri p2"
elif [ "$tri_option" == "avl" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche équilibrés comme mode de tri p2"
fi


elif [ "$press_mode" == "3" ]; then #mode de pression 3
	OFMT="%.2f"
	awk -F ";" 'NR > 1 { 
  dates[$2 " " $1] += $7
  count[$2 " " $1]++ }  
END { 
  for (date_station in dates) { 
    split(date_station, parts, " ") 
     avg = dates[date_station] / count[date_station]
    print parts[1] ";" parts[2] ";" avg }
}' $fichier > modep3.csv
temp_fichier="modep3.csv"
#Choix du tri en fonction de l'argument choisi (--avl, --abr, --tab)
if [ "$tri_option" == "tab" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des tableaux comme mode de tri p3"
elif [ "$tri_option" == "abr" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche comme mode de tri p3"
elif [ "$tri_option" == "avl" ] ; then
  make
  ./prog4 "$temp_file" "$tri_option"
#echo "Utilisation des arbres binaire de recherche équilibrés comme mode de tri p3"
fi


fi
fi

#On prend les colonnes de numéro de station et d'altitudes, on trie la colonne des stations par ordre croissant (pas nécessaire), puis on utilise uniq pour afficher qu'une fois chaque station, étant donnée que l'altitude ne change pas.
if [ -n "$alt" ]; then
	awk -F ";" 'NR > 1 {print $1 ";" $14}' $fichier > alt1.csv
  sort -t ";" -k 1 -n  alt1.csv > alt2.csv
	uniq  alt2.csv > altitudes.csv
  temp_fichier="altitudes.csv"
	rm alt1.csv alt2.csv
  #Choix du tri en fonction de l'argument choisi (--avl, --abr, --tab)
if [ "$tri_option" == "tab" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des tableaux comme mode de tri alt"
elif [ "$tri_option" == "abr" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche comme mode de tri alt"
elif [ "$tri_option" == "avl" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche équilibrés comme mode de tri alt"
fi
fi

if [ -n "$humid" ]; then
	awk -F ";" 'NR > 1 {
  station = $1
  humidity = $6
  if (length(humidity) > 0) {
    count[station]++
  if (humidity > max[station] || !max[station]) {
    max[station] = humidity
  }
}
}
END {
  for (station in count) {
    print station ";" max[station] 
  }
}' $fichier > humidity.csv
temp_fichier="humidity.csv"

#Choix du tri en fonction de l'argument choisi (--avl, --abr, --tab)
if [ "$tri_option" == "tab" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des tableaux comme mode de tri humid"
elif [ "$tri_option" == "abr" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche comme mode de tri humid"
elif [ "$tri_option" == "avl" ] ; then
  make
  ./prog4 "$temp_fichier" "$tri_option"
#echo "Utilisation des arbres binaire de recherche équilibrés comme mode de tri humid"
fi
fi



