#!/bin/bash


for i in "$*" ; do
	if [ "$i" == "-t1" ] ; then
		sort -t';' -h -k 11 meteo_filtered_data_v1.csv | cut -d';' -f11,12,13 >> resultat.csv
	fi
	#if [ "$i" == "-t2" ] ; then
	#	sort -t';' -n -k 2 meteo_filtered_data_v1.csv | cut -d';' -f 11, 12, 13 >> resultat.csv
	#fi
	#if [ "$i" == "-t1" ] ; then
	#	sort -t';' -n -k 2 meteo_filtered_data_v1.csv | sort -t';' -n -k 11, 12, 13 | cut -d';' -f 11, 12, 13 >> resultat.csv
	#fi
done



