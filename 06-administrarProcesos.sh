#! /bin/bash

function print_kill_menu {
	printf "%s \n" "Escribe el ID de proceso a eliminar"
	printf "%s \n" "Volver a menú (r)"

	RESPONSE=""
	printf "%s \n" "Selecciona una opción:"
	read RESPONSE
	while [[ -z $RESPONSE ]]; do
		printf "%s \n" "Selecciona una opción válida: "
		read RESPONSE
	done
	if [[ $RESPONSE = "r" ]]
	then
		print_menu
		return 0
	fi


	ps -o pid,cmd -p $RESPONSE  | \
	while IFS= read -r line
	do
		IFS=' '   
		read -ra LINES <<< $line
		ID=${LINES[0]}
		NAME=${LINES[1]}
		if [[ $ID = "PID" ]]
		then
			continue
		fi
		echo "Terminando proceso: " $NAME
		kill $ID
	done

}

function print_user_processes {
	ps | \
	while IFS= read -r line
	do
		IFS=' '   
		read -ra LINES <<< $line
		ID=${LINES[0]}
		NAME=${LINES[3]}
		if [[ $ID = "PID" ]]
		then
			continue
		fi
		printf "\e[1;31m%d\e[0m %s \n" $ID $NAME
	done
}

function print_terminal_processes {
	ps -T | \
	while IFS= read -r line
	do
		IFS=' '   
		read -ra LINES <<< $line
		ID=${LINES[0]}
		NAME=${LINES[3]}
		if [[ $ID = "PID" ]]
		then
			continue
		fi
		printf "\e[1;31m%d\e[0m %s \n" $ID $NAME
	done
}

function print_all_processes {
	ps -eo pid,user:14,cmd | \
	while IFS= read -r line
	do
		IFS=' '   
		read -ra LINES <<< $line
		ID=${LINES[0]}
		USER=${LINES[1]}
		NAME=${LINES[2]}
		if [[ $ID = "PID" ]]
		then
			continue
		fi
		printf "\e[1;31m%6d\e[0m %-20s %s \n" $ID $USER $NAME
	done
}

function read_option {
	RESPONSE=""
	printf "%s \n" "Selecciona una opción:"
	read RESPONSE
	while [[ -z $RESPONSE && ${#RESPONSE} != 1 ]]; do
		printf "%s \n" "Selecciona una opción válida: "
		read RESPONSE
	done

	printf "\e[1;37m%s\e[0m %s %s \n" "PID" "User" "Command"
	if [[ $RESPONSE = "1" ]]
	then
		print_user_processes | more
	elif [[ $RESPONSE = "3" ]]
	then
		print_all_processes | more
	elif [[ $RESPONSE = "2" ]]
	then
		print_terminal_processes | more
	fi
	
	print_kill_menu
}

function print_menu {
	printf "\e[1m%-30s\e[0m \n" "Mostrar procesos de:"
	printf "%-30s [%s] \n" "Usuario" "1"
	printf "%-30s [%s] \n" "Esta terminal" "2"
	printf "%-30s [%s] \n" "Todos los procesos" "3"
	read_option
}

print_menu