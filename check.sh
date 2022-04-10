#!/bin/bash

#A script celja az, hogy az osztalek-portfolio kivalasztasahoz aktualizalja 3 nagy csoportban levo reszvenyekhez
#tartozo tickerek arat, ami igy bemasolhato a letoltott XLSX-be es elvegezheto rajta a szures.

#
# basic checks
#

if [ ! -s ticker.sh ]
then
	echo
	echo "ticker.sh not exists, downloading it from GitHub..."
	echo
	wget -q https://raw.githubusercontent.com/pstadler/ticker.sh/e6b57a34c07dd1fb5c89bac5baf97e502a08c2b3/ticker.sh && echo "Download is done"
	if [ ! -s ticker.sh ]
	then
		echo
		echo "Download has failed. Check your internet connection!"
		echo
		exit 1
	fi
	chmod u+x ticker.sh
fi

#
# defining variables
#

TCHAMP="ticker-champions"
PCHAMP="price-champions"
TCHALL="ticker-challengers"
PCHALL="price-challengers"
TCONTD="ticker-contenders"
PCONTD="price-contenders"

#
# defining functions
#


func_champ () {
			if [[ -s $TCHAMP ]]
			then
				echo "Creating Champions' price list..."
				sed -i 's/\./\-/g' $TCHAMP && sed -i 's/ARTN-A/ARTNA/' $TCHAMP
				NO_COLOR=1 ./ticker.sh $(cat $TCHAMP) | awk '{ print $2 }' > $PCHAMP
				NUMCHAMP=$(cat $PCHAMP | wc -l)
				TICKCHAMP=$(cat $TCHAMP | wc -l)
				echo "Sum of tickers: $TICKCHAMP"
				echo "Sum of retrieved prices: $NUMCHAMP"
				if [[ $NUMCHAMP -eq $TICKCHAMP ]]
				then
					#in EU decimal-points are written with dot, not with comma
					sed -i 's/\./\,/g' $PCHAMP
					echo "Creating Champions' price list is done."
				else
					echo "Sum of tickers and of retrieved prices are not equal! Check your ticker file whether ther are any ticker in whose name is a dot dot and replace it with a hyphen or omit it!"
					exit 2
				fi
			else
				echo "File $TCHAMP not exists!"
				exit 3
			fi
		}

func_contd () {
			if [[ -s $TCONTD ]]
			then
				sed -i 's/\./\-/g' $TCONTD && sed -i 's/CMCS-A/CMCSA/' $TCONTD
				echo "Creating Contenders' price list..."
				NO_COLOR=1 ./ticker.sh $(cat $TCONTD) | awk '{ print $2 }' > $PCONTD
				NUMCONTD=$(cat $PCONTD | wc -l)
				TICKCONTD=$(cat $TCONTD | wc -l)
				echo "Sum of tickers: $TICKCONTD"
				echo "Sum of retrieved prices: $NUMCONTD"
				if [[ $NUMCONTD -eq $TICKCONTD ]]
				then
	    				#EU-ban a tizedesjegyeket vesszovel irjuk, nem ponttal
			        	sed -i 's/\./\,/g' $PCONTD
			    		echo "Creating Contenders' price list is done."
			    	else
					echo "Sum of tickers and of retrieved prices are not equal! Check your ticker file whether ther are any ticker in whose name is a dot dot and replace it with a hyphen or omit it!"
		    			exit 4
			        fi
			else
				echo "File $TCONTD not exists!"
				exit 5
			fi
		}

func_chall () {
			if [[ -s $TCHALL ]]
			then
				sed -i 's/\./\-/g' $TCHALL
				echo "Creating Challengers' price list..."
				NO_COLOR=1 ./ticker.sh $(cat $TCHALL) | awk '{ print $2 }' > $PCHALL
				NUMCHALL=$(cat $PCHALL | wc -l)
				TICKCHALL=$(cat $TCHALL | wc -l)
				echo "Sum of tickers: $TICKCHALL"
				echo "Sum of retrieved prices: $NUMCHALL"
				if [[ $NUMCHALL -eq $TICKCHALL ]]
				then
					#EU-ban a tizedesjegyeket vesszovel irjuk, nem ponttal
			       		sed -i 's/\./\,/g' $PCHALL
			    		echo "Creating challengers' price list is done."
		       		 else
		       			echo "A tickerek darabszama nem egyezik a keszitett arak darabszamaval! Csekkold a ticker fajlt, hogy van-e olyan ticker, aminek a neveben pont van es helyettesitsd kotojellel vagy hagyd el!"
		    			exit 6
		       		 fi
			else
				echo "File $TCHALL not exists!"
				exit 7
			fi
		}

#
# main routine
#

echo
echo "Choose which list to make!"
PS3='Your choice: '

select opt in champions contenders challengers all
do
	case $opt in

		champions)
			func_champ
			break
			;;

		contenders)
			func_contd
			break
			;;

		challengers)
			func_chall
			break
			;;

		all)
			func_champ
			func_contd
			func_chall
			break
			;;

		*)
			echo
			echo "Invalid choice: $REPLY. Choose another!"
			echo
			;;

	esac
done
