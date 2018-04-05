#!/bin/bash
# List most used extentions in the folder
# Released in GNU GPLv3 by chkrr00k

iflag=1
narg=5
regEx='^[^\.].*\.[^\.]*[^:]$'
crntPth='.'

while getopts 'he:n:p:g' OPTION ; do
	case $OPTION in
		h)	echo $(basename $0) 
			echo "[-e regExp] filter only given extention (separated by | (pipe))"
			echo "[-n number] number of extention to be listed"
			echo "[-p path] file path to check"
			echo "[-g] avoid to write the header (grepable)"
			echo "[-h] display this useful message (defualt 5)"
			echo "Developed by chkrr00k"
			exit 0 ;;
		e)	regEx='^[^\.].*\.('"$OPTARG"')$';;
		n)	if echo $OPTARG | egrep -q '^[0-9]+$' ; then 
				narg="$OPTARG"
			else
				echo "-n argument need to be a number" >&2
				exit 2
			fi
			;;
		p)	crntPth="$OPTARG" ;;
		g)	iflag= ;;
		?)	echo Usage $(basename $0) "[-e regExp] [-n number] [-h] [-p path]" >&2
			exit 1 ;;
	esac
done
shift $(( $OPTIND - 1 ))
if [ "$iflag" ] ; then
	echo -e "\e[1;20mtimes\textention\e[0m"
fi
ls -R $crntPth | egrep $regEx | rev | awk -F '.' '{print $1}' | rev | sort | uniq -c | sort -nr | head -$narg | awk '{print $1 "\t" $2}'

# cat da | (while read A B && read C D; do echo $A $D; done)
