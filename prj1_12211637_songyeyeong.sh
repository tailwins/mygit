#! /bin/bash

echo "--------------------------"
echo "User Name: son gye yeong"
echo "Student Number: 12211637"
echo "[  MENU  ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of ‘action’ genre movies from 'u.item’"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’"
echo "4. Delete the ‘IMDb URL’ from ‘u.item’"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

#item->data->user
stop="N"
until [ $stop = "Y" ]
do
	read -p "Enter your choice [ 1-9 ] " choice
	case $choice in
	1)
		echo " "
		read -p "Please enter 'movie id' (1~1682):" movieid
		echo " "
		cat "$1" | awk -F\| -v id="$movieid" '$1==id'
		echo " "
		;;
	2)
		echo " "
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" dap
		echo " "
		if [ $dap = "y" ]
		then
			cat "$1" | awk -F\| '$7==1{print $1, $2}' | head -n 10
		fi
		echo " "
		;;
	3)
		echo " "
		read -p "Plaese enter the 'movie id'(1~1682):" movieid
		echo " "
		cat "$2" | awk -v id="$movieid" '$2==id{sum+=$3; cnt++} END {printf("average rating of %d: %.5f\n", id, sum/cnt)}'
		echo " "
		;;
	4)
		echo " "
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" dap
		echo " "
		if [ $dap = "y" ]
                then
			cat "$1" | sed -E 's/http.*\)//g' | head -n 10
                fi
		echo " "
		;;
	5)
		echo " "
		read -p "Do you want to get the data about users from 'u.user'?(y/n):" dap
		echo " "
		if [ $dap = "y" ]
		then
			cat "$3" | sed -E 's/F/female/g; s/M/male/g' | awk -F\| '{printf("user %d is %d years old %s %s\n", $1, $2, $3, $4)}' | head -n 10
		fi
		echo " "
		;;
	6)
		echo " "
		read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" dap
		if [ $dap = "y" ]
		then
			echo " "
			cat "$1" | sed -E 's/([0-9]+)-Jan-([0-9]+)/\201\1/; s/([0-9]+)-Feb-([0-9]+)/\202\1/; s/([0-9]+)-Mar-([0-9]+)/\203\1/; s/([0-9]+)-Apr-([0-9]+)/\204\1/; s/([0-9]+)-May-([0-9]+)/\205\1/; s/([0-9]+)-Jun-([0-9]+)/\206\1/; s/([0-9]+)-Jul-([0-9]+)/\207\1/; s/([0-9]+)-Aug-([0-9]+)/\208\1/; s/([0-9]+)-Sep-([0-9]+)/\209\1/; s/([0-9]+)-Oct-([0-9]+)/\210\1/; s/([0-9]+)-Nov-([0-9]+)/\211\1/; s/([0-9]+)-Dec-([0-9]+)/\212\1/' | sed -n '1673,1682p'
		fi
		echo " "
		;;
	7)
		echo " "
		read -p "Please enter the 'user id' (1~943):" userid
		echo " "
		out=$(cat "$2" | awk -v id=$userid '$1==id{print $2}' | sort -n | awk '{printf("%s%s", $1, "|")}' | sed -E 's/.$/\n/g')
		echo "$out"
		echo " "
		list=$(echo "$out" | sed 's/|/ /g')
		cnt=0
		for var in $list
		do
			cat "$1" | awk -F\| -v id="$var" '$1==id{printf("%d|%s\n", $1, $2)}'
			count=$((count+1))
			if [ $count -eq 10 ]; then break; fi
		done
		echo " "
		;;
	8)
		echo " "
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" dap
		if [ $dap = "y" ]
		then
			age=$(cat "$3" | awk -F\| '$2>=20 && $2<=29 && $4=="programmer"{print $1}')
			useridmovieid=$(for var in $age
			do
				cat "$2" | awk -v id="$var" '$1==id{print $2, $3}'
			done)
			for var in $(seq 1 1682)
			do
				echo "$useridmovieid" | awk -v id="$var" '$1==id{sum+=$2; cnt++} END {printf("%d %.5f\n", id, sum/cnt)}' | awk '$2!~"nan"{print $1, $2}'
			done
		fi
		echo " "
		;;
	9)
		echo "Bye!"
		stop="Y"
		echo " "
		;;
	*)
		echo "Error: Invalid option..."
		;;
	esac
done
	

