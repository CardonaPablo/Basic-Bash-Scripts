#! /bin/bash
# Programa un script en bash para imprimir en consola la información detallada de los usuarios existentes en Debian.
USERS=()

function print_all_users {
	SHOW_GROUPS=$1
		while IFS= read -r ARCHIVO
		do
			IFS=':'     # : is set as delimiter
			read -ra LINE <<< "$ARCHIVO"   # str is read into an array as tokens separated by IFS
			USERS+=(${LINE[0]})
		done < /etc/passwd

		if [[ $SHOW_GROUPS = "y" ]]
		then
			printf "\e[1;37m %-20s \e[0m \e[1;37m %-20s \e[0m" "USER" "GROUP" 
		else
			printf "\e[1;37m %-20s \e[0m" "USER"
		fi

		for user in "${USERS[@]}"
		do
			printf "\e[1;37m %-20s \e[0m" $user
			if [[ $SHOW_GROUPS = "y" ]]
			then
				groups $user
			else
				echo ""
			fi
		done
}

function print_connected_users {
	SHOW_GROUPS=$1
	if [[ $SHOW_GROUPS = "n" ]]
	then
		printf "\e[1;37m%5s\e[0m \e[1;37m%-20s\e[0m \e[1;37m%-20s\e[0m \n" "UID" "Usuario" "Nombre"
	else
		printf "\e[1;37m%5s\e[0m \e[1;37m%-20s\e[0m \e[1;37m%-20s\e[0m \e[1;37m%s\e[0m \n" "UID" "Usuario" "Nombre" "Grupos"
	fi
	# Get users with who
	who | \
	while IFS= read -r line 
	do
		ARG_ARRAY=()
		IFS=' '   
		read -ra LINES <<< $line

		lslogins -o UID,USER,GECOS -u ${LINES[0]} | \
		while IFS= read -r line
		do
			IFS=':'   
			read -ra LINES <<< $line
			if [[ -z $line ]]
			then
				ID=${ARG_ARRAY[0]}
				USER=${ARG_ARRAY[1]}
				NAME=${ARG_ARRAY[2]}

				printf "%5s %-20s %-20s " $ID $USER $NAME 
				if [[ $SHOW_GROUPS = "y" ]]
				then
					groups $USER
				else
					echo ""
				fi
				break
			fi

			ARR_LEN=${#LINES[@]}
			LAST_ARG_INDEX=$(($ARR_LEN-1))
			LAST_ARG=$(echo ${LINES[${LAST_ARG_INDEX}]} | xargs)
			ARG_ARRAY+=("$LAST_ARG")
		done


	done
}

function print_real_users {

	SHOW_GROUPS=$1
	if [[ $SHOW_GROUPS = "n" ]]
	then
		printf "\e[1;37m%5s\e[0m \e[1;37m%-20s\e[0m \e[1;37m%-20s\e[0m \n" "UID" "Usuario" "Nombre"
	else
		printf "\e[1;37m%5s\e[0m \e[1;37m%-20s\e[0m \e[1;37m%-20s\e[0m \e[1;37m%s\e[0m \n" "UID" "Usuario" "Nombre" "Grupos"
	fi

	lslogins -o UID,USER,GECOS -u  | \
	while IFS= read -r line
	do
		IFS=' '   
		read -ra LINES <<< $line
		ID=${LINES[0]}
		USER=${LINES[1]}
		NAME=${LINES[2]}
		if [[ $ID = "UID" ]]
		then
			continue
		fi

		printf "%5s %-20s %-20s " $ID $USER $NAME 
		if [[ $SHOW_GROUPS = "y" ]]
		then
			groups $user
		else
			echo ""
		fi
	done
}

function print_groups_menu {
	SCOPE=$1
	printf "%s \n" "Mostrar información de grupos?:"
	printf "%-30s [%s] \n" "Si" "y"
	printf "%-30s [%s] \n" "No" "n"

	RESPONSE=""
	printf "%s \n" "Selecciona una opción:"
	read RESPONSE
	while [[ -z $RESPONSE && !($RESPONSE = 'y' || $RESPONSE = 'z') ]]; do
		printf "%s \n" "Selecciona una opción válida: "
		read RESPONSE
	done
	print_${SCOPE}_users "${RESPONSE}"
}

function print_users_menu {
	printf "%s \n" "Listar usuarios:"
	printf "%-30s [%s] \n" "Conectados" "1"
	# who
	printf "%-30s [%s] \n" "Solo usuarios 'reales'" "2"
	# lslogins -u
	printf "%-30s [%s] \n" "Todos" "3"
	# /etc/passwd

	RESPONSE=""
	printf "%s \n" "Selecciona una opción:"
	read RESPONSE
	while [[ -z $RESPONSE ]]; do
		printf "%s \n" "Selecciona una opción válida: "
		read RESPONSE
	done


	if [[ $RESPONSE = "1" ]]
	then
		print_groups_menu "connected"
	elif [[ $RESPONSE = "2" ]]
	then
		print_groups_menu "real"
	elif [[ $RESPONSE = "3" ]]
	then
		print_groups_menu "all"
	fi
}

print_users_menu