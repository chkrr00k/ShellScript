#!/bin/bash
#Save copies of a file saving the old copies into new copies setted as incremental number untill max copy number is met
#Released in GNU GPLv3 by chkrr00k

NCOPIES=4

while getopts 'n:h' OPTION ; do
	case $OPTION in
		h)	echo $(basename $0)
			echo "Create various copies of a given file until a maximum"
			echo "[-n value] the max copies you want to keep (default 4)"
			echo "[-h] display this useful help"
			echo "Developed by chkrr00k"
			exit 0 ;;
		n) 	if echo $OPTARG | egrep -q '^[0-9]+$' ; then
				NCOPIES=$OPTARG
			else
				echo "It's not a number" >&2
				exit 1
			fi
			;;
		?)	echo "Usage" $(basename $0) "[-n value]" >&2
			exit 2 ;;
	esac
done
shift $(( $OPTIND - 1 ))

if [ $# -ne 1 -o ! -f "$1" ] ; then
	echo "Need a file" >&2
	exit 3
else
	LOGFILE=$1
fi

for file in $(ls | egrep '^'$LOGFILE'\.[0-9]+' | sort -r) ; do
	c=$(( $(echo $file | cut -d'.' -f2) + 1 ))
	if [ $c -le $NCOPIES ] ; then
		cp $file $LOGFILE'.'$c
	fi
done

cp $LOGFILE $LOGFILE'.1'
