#!/bin/bash

#A script celja az, hogy az osztalek-portfolio kivalasztasahoz aktualizalja 3 nagy csoportban levo reszvenyekhez
#tartozo tickerek arat, ami igy bemasolhato a letoltott XLSX-be es elvegezheto rajta a szures.
echo ""
echo "Valassz, hogy melyik listat szeretned elkeszittetni!"
PS3='Valaszod: '
echo ""
TCHAMP="ticker-champions"
PCHAMP="price-champions"
TCHALL="ticker-challengers"
PCHALL="price-challengers"
TCONTD="ticker-contenders"
PCONTD="price-contenders"

func_champ() {
			if [[ -s $TCHAMP ]]
			then
     				echo "Champions lista keszitese folyamatban..."
			    	sed -i 's/\./\-/g' $TCHAMP && sed -i 's/ARTN-A/ARTNA/' $TCHAMP
				NO_COLOR=1 ./ticker.sh $(cat $TCHAMP) | awk '{ print $2 }' > $PCHAMP
			   	NUMCHAMP=$(cat $PCHAMP | wc -l)
				TICKCHAMP=$(cat $TCHAMP | wc -l)
			    	echo "Ticker darabszama: $TICKCHAMP"
			    	echo "Keszitett arak darabszama: $NUMCHAMP"
				if [[ $NUMCHAMP -eq $TICKCHAMP ]]
			        then
			        	#EU-ban a tizedesjegyeket vesszovel irjuk, nem ponttal
			        	sed -i 's/\./\,/g' $PCHAMP
			        	echo "A champions lista keszitese elkeszult."
				else
					echo "A tickerek darabszama nem egyezik a keszitett arak darabszamaval! Csekkold a ticker fajlt, hogy van-e olyan ticker, aminek a neveben pont van es helyettesitsd kotojellel vagy hagyd el!"
			    		exit 1
			    	fi
			else
				echo "A $TCHAMP nevu fajl nem letezik!"
				exit 2
			fi
		}

func_contd () {
			if [[ -s $TCONTD ]]
			then
			    	sed -i 's/\./\-/g' $TCONTD && sed -i 's/CMCS-A/CMCSA/' $TCONTD
				echo "Contenders lista keszitese folyamatban..."
				NO_COLOR=1 ./ticker.sh $(cat $TCONTD) | awk '{ print $2 }' > $PCONTD
				NUMCONTD=$(cat $PCONTD | wc -l)
				TICKCONTD=$(cat $TCONTD | wc -l)
				echo "Ticker darabszama: $TICKCONTD"
				echo "Keszitett arak darabszama: $NUMCONTD"
			      	if [[ $NUMCONTD -eq $TICKCONTD ]]
				then
	    				#EU-ban a tizedesjegyeket vesszovel irjuk, nem ponttal
			        	sed -i 's/\./\,/g' $PCONTD
			    		echo "A contenders lista keszitese elkeszult."
			    	else
			    		echo "A tickerek darabszama nem egyezik a keszitett arak darabszamaval! Csekkold a ticker fajlt, hogy van-e olyan ticker, aminek a neveben pont van es helyettesitsd kotojellel vagy hagyd el!"
		    			exit 1
			        fi
			else
				echo "A $TCONTD nevu fajl nem letezik!"
				exit 2
			fi
		}

func_chall () {
			if [[ -s $TCHALL ]]
			then
			    	sed -i 's/\./\-/g' $TCHALL
				echo "Challengers lista keszitese folyamatban..."
				NO_COLOR=1 ./ticker.sh $(cat $TCHALL) | awk '{ print $2 }' > $PCHALL
				NUMCHALL=$(cat $PCHALL | wc -l)
				TICKCHALL=$(cat $TCHALL | wc -l)
				echo "Ticker darabszama: $TICKCHALL"
				echo "Keszitett arak darabszama: $NUMCHALL"
			       	if [[ $NUMCHALL -eq $TICKCHALL ]]
				then
					#EU-ban a tizedesjegyeket vesszovel irjuk, nem ponttal
			        	sed -i 's/\./\,/g' $PCHALL
			    		echo "A challengers lista keszitese elkeszult."
		       		 else
		       			echo "A tickerek darabszama nem egyezik a keszitett arak darabszamaval! Csekkold a ticker fajlt, hogy van-e olyan ticker, aminek a neveben pont van es helyettesitsd kotojellel vagy hagyd el!"
		    			exit 1
		       		 fi
			else
				echo "A $TCHALL nevu fajl nem letezik!"
				exit 2
			fi
		}

select opt in champions contenders challengers osszes
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

	osszes)
	    	func_champ
	    	func_contd
	    	func_chall
	        break
	    ;;

        *)
            echo "Ervenytelen valasztas: $REPLY. Valassz masikat!"
        ;;

    esac
done
