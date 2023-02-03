#!/bin/bash


sort_option="avl"

if [ "$1" == "--help" ]; then
echo "Usage : $0 [-f file] [-t temp_mode] [-p press_mode] [-w] [-m] [-h] [--tab | --abr | --avl] [--help]"
echo " -f : obligatory input file"
echo " -t : temperature mode (1, 2, or 3)"
echo " -p : pressure mode (1, 2, or 3)"
echo " -w : include wind sort"
echo " -m : include humidity sort"
echo " -h : include altitude information"
echo " --tab : sort using a structure like array or linked list"
echo " --abr : sort using an ABR (binary search tree)"
echo " --avl : sort using an AVL (balanced binary search tree)"
echo " --help : display this help message"
exit 0
fi

# Function error message
error() {
  echo "Error: Missing or invalid argument(s)."
  echo "Try ./script.sh --help for more"
  exit 1 
}

while getopts "f:tababravl:t:p:wmh" opt; do
case $opt in
f)
file="$OPTARG"
;;
--tab)
sort_option="tab"
;;
--abr)
sort_option="abr"
;;
--avl)
sort_option="avl" 
;;
t)
temp_mode="$OPTARG"
if [ "$temp_mode" != "1" ] && [ "$temp_mode" != "2" ] && [ "$temp_mode" != "3" ]; then
error
fi
;;
p)
press_mode="$OPTARG"
if [ "$press_mode" != "1" ] && [ "$press_mode" != "2" ] && [ "$press_mode" != "3" ]; then
error
fi
;;
w)
wind=1
;;
m)
humid=1
;;
h)
alt=1
;;
?)
error
;;
esac
done



if [ "$sort_option" == "tab" ] ; then
echo "Sorting using a linear structure (array or linked list)"
elif [ "$sort_option" == "abr" ] ; then
echo "Sorting using an ABR (binary search tree)"
elif [ "$sort_option" == "avl" ] ; then
echo "Sorting using an AVL (balanced binary search tree)"
fi


if [ $# -eq 0 ]; then
  error
fi

if [ -z "$file" ]; then
  echo "Error: the -f option is required."
  exit 1
fi


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
}' $file | sort -k1,1 -n > modet1.csv

elif [ "$temp_mode" == "2" ]; then
	OFMT="%.2f"
# extract date/hours and temperature
cut -d ";" -f 2,11 $file > date_temp.csv

#sort by date/hour
sort -t ";" -k 1 date_temp.csv > date_temp_sorted.csv

# average temperatures by dates and hours
awk -F ";" 'NR > 1 {
  dates[$1]+=$2
  n[$1]++ 
} END {
  for (date in dates) {
    print date ";" dates[date]/n[date]
  }
}' date_temp_sorted.csv > modet2.csv

rm date_temp.csv date_temp_sorted.csv

 elif [ "$temp_mode" == "3" ]; then
	OFMT="%.2f"
	awk -F ";" 'NR > 1 { dates[$2 " " $1] += $11
   count[$2 " " $1]++ } 
END { 
  for (date_station in dates) { 
    split(date_station, parts, " ") 
     avg = dates[date_station] / count[date_station]
    print parts[1] ";" parts[2] ";" avg }
}' $file | sort -k1,2 > modet3.csv
fi
fi

if [ -n "$press_mode" ]; then
  if [ "$press_mode" == "1" ]; then
OFMT="%.2f"
#The command awk checks whether in the pressure clumn, boxes are empty. If not, it counts the number of mesures per stations and determines max and min. Finally, it displays the desired results.
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
}' $file | sort -k1,1 -n > modep1.csv

elif [ "$press_mode" == "2" ]; then
	OFMT="%.2f"


cut -d ";" -f 2,7 $file > date_press.csv


sort -t ";" -k 1 date_press.csv > date_press_sorted.csv

awk -F ";" 'NR > 1 {
  dates[$1]+=$2
  n[$1]++
}  END {
  for (date in dates) {
    print date ";" dates[date]/n[date]
  }
}' date_press_sorted.csv > modep2.csv
rm date_press.csv date_press_sorted.csv

elif [ "$press_mode" == "3" ]; then
	OFMT="%.2f"
	awk -F ";" 'NR > 1 { 
  dates[$2 " " $1] += $7
  count[$2 " " $1]++ } 
END { 
  for (date_station in dates) { 
    split(date_station, parts, " ") 
     avg = dates[date_station] / count[date_station]
    print parts[1] ";" parts[2] ";" avg }
}' $file | sort -k1,2 > modep3.csv

fi
fi

if [ -n "$alt" ]; then
	awk -F ";" 'NR > 1 {print $1 ";" $14}' $file > alt1.csv
	sort -t ";" -k 2 -n -r alt1.csv > alt2.csv
	uniq alt2.csv > altitudes.csv
	rm alt2.csv alt1.csv
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
}' $file | sort -k 2 -n -r > humidity.csv
fi
