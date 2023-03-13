#!/bin/bash

function UpdateAmount(){
	read -p "Enter the name of the Record you want to update : " record_name
	result=$(grep -in "$record_name" file.txt | sort)
	if [ -z  "$result" ]
	then
		echo "there is no Record like this"
		echo "Failure"
	else
		echo $result
		select i in $result
		do
			oldnum=$(echo $i | awk -F "," '{print $2}')
			n=$(echo $i | awk -F ":" '{print $1}')
			echo $oldnum
			echo $n
			read -p "type the new amount you want to change to it : " newnum
			if [[ "$newnum" =~ ^[0-9]+$ && "$newnum" -ge 1 ]]
			then
				
				#sed -i "$n s~$oldnum~$newnum~" file.txt
				sed -i "$n s/$oldnum/$newnum/" file.txt
				echo Success 
			else
				echo "The amount is smaller than 1 you have to enter number bigger than 0"
				echo
				echo
			fi
		done 
		#read -p "choose line number to Update : " num 
		#oldnum=$(sed -n "$num"p file.txt | awk -F "," '{print $2}')
		#read -p "type the new amount you want to change to it : " newnum
		#if [[ "$newnum" =~ ^[0-9]+$ && "$newnum" -ge 1 ]]
		#then
		#	sed -i "s/$oldnum/$newnum/" file.txt
		#	echo Success 
		#else
		#	echo "The amount is smaller than 1 you have to enter number bigger than 0"
		#	echo
		#	echo
		#fi
		
		
	fi
	Menu
}

function Insert(){
 
 read -p "enter record name "  record_name
 if grep -q "$record_name," "file.txt" 
 then
 	echo $record_name is already in the DataBase
 	UpdateAmount 
 
 else
 	read -p "enter the amount of the record : " amount
 	if [[ "$record_name" =~ [0-9a-zA-Z] && "$amount" =~ ^[0-9]+$ && "$amount" -ge 0 ]]
 	then
 		echo  $record_name,$amount >> file.txt
 	else
		echo invaild input
 		function_insert 
 	fi

 fi
 Menu
}

function Search(){
	read -p "enter a record name : " record_name
	result=$(grep -in  "$record_name" file.txt | sort) 
	if [ -z  "$result" ]
	then
	echo "fail"
	else
	echo -e  "$result\n"
	fi
	Menu
}

function UpdateName(){
	read -p "Enter the name of the Record you want to update : " record_name

	result=$(grep -in  "$record_name" file.txt | sort | uniq)
	if [ -z  "$result" ]
	then
		echo "there is no Record like this"
		echo "Failure"
	else
		if grep -q "$record_name," "file.txt" 
		then
		echo $record_name is already in the DataBase
		fi
		select i in $result
		do
		#read -p "choose line number to Update : " num 
		oldname=$(echo $i | awk -F "," '{print $1}' | awk -F ":" '{print $2}')
		#oldname2=$(echo $oldname | awk -F ":" '{print $2}')
		n=$(echo $i | awk -F ":" '{print $1}')
		read -p "type the new name you want to change to it : " newname
		sed -ie "$n s/$oldname/$newname/" file.txt
		echo Success 
		done
	fi	
		Menu
}

function Delete(){
	read -p " Do you want to Delete or Update choose D/U : " choice
	if [[ $choice == D ]] || [[ $choice == d ]] || [[ $choice == Delete ]] || [[ $choice == delete ]]
	then
	read -p "enter name to be delete : "  record_name
	egrep -in  "$record_name" file.txt
	read -p "choose line number to delete : " num 
	sed -ie "$num"'d' file.txt
	echo Deleted 
	elif [[ $choice == U ]] || [[ $choice == u ]] || [[ $choice == Update ]] || [[ $choice == update ]]
	then
	read -p "choose do you want to update Name or Amount N/A: " choice2
	if [[ $choice2 == N ]] || [[ $choice2 == n ]] || [[ $choice2 == Name ]] || [[ $choice2 == name ]]   
	then
		UpdateName
	elif [[ $choice2 == A ]] || [[ $choice2 == a ]] || [[ $choice2 == Amount ]] || [[ $choice2 == amount ]]
	then
		UpdateAmount
	else
		echo Invalid Choice
		Delete
	fi
	else
		echo Invalid Choice
		Delete
	fi
	echo
	Menu
}

function PrintAmount(){
	result=$(awk -F "," '{sum += $2} END {print sum}' file.txt)
	if [[ $result -gt 0 ]]
	then
		echo the amount of the Records is $result
	else
		echo your Collection is empty
	fi
	Menu
}

function PrintAll(){
	if [[ -s file.txt ]]
	then
		sort file.txt 
	else
		echo the file is empty
	fi
	Menu

}

function Menu(){
	awk -F, '{name=$1; value=$2; sum[name]+=value} END {for (name in sum) print name "," sum[name]}' file.txt > temp.txt && mv temp.txt file.txt
	echo Choose an option to Do 
	echo 1- Add a new Record
	echo 2- Delete or Update a Record
	echo 3- Search for a Record By the name
	echo 4- Update the name of an exist Record
	echo 5- Update the amount of and exist Record
	echo 6- Print the amount of all the Records
	echo 7- Display all the Records with the amount of them
	read -p " Choose the Number of the option you want to do and press Enter : " answer
	case $answer in
	1) Insert ;;
	2) Delete ;;
	3) Search ;;
	4) UpdateName ;;
	5) UpdateAmount ;;
	6) PrintAmount ;;
	7) PrintAll ;;
	*) echo Invalid Option 
	esac
}

Menu