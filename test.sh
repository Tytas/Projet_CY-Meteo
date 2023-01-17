#!/bin/bash
a=8

for (( i=1 ; i<=20 ; i++)) ; do
	if [[ $a -eq $i ]] ; then
		cut -d',' -f $i soccer.csv > UwU.csv
	fi
done
