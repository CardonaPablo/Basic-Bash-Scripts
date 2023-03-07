#! /bin/bash

FILE_PATH=$1
SCOPE_SELECTED=0
PERMISSION_SELECTED=0
OPERATOR_SELECTED=0


function set_permissions() {
	# 1 Char target u g o a
	# 1 Char action + - =
	# 3 Char permissoins r w x
	OPTIONS="$SCOPE_SELECTED$OPERATOR_SELECTED$PERMISSION_SELECTED"
	echo "Running $OPTIONS"
	chmod $OPTIONS $FILE_PATH

	IFS=' '     # : is set as delimiter
	read -ra LINE <<< $(ls -la $FILE_PATH)   # str is read into an array as tokens separated by IFS
	printf "%30s %s \n\n" "Permisos actualizados: " ${LINE[0]}
}

function read_scope_option {
	RESPONSE=""
	printf "%s \n" "Selecciona una opción:"
	read RESPONSE
	while [[ -z $RESPONSE ]]; do
		printf "%s \n" "Selecciona una opción válida: "
		read RESPONSE
	done
	SCOPE_SELECTED=$RESPONSE
}

function read_operator_option {
	RESPONSE=""
	printf "%s \n" "Selecciona una opción:"
	read RESPONSE
	while [[ -z $RESPONSE ]]; do
		printf "%s \n" "Selecciona una opción válida: "
		read RESPONSE
	done
	OPERATOR_SELECTED=$RESPONSE
}

function read_permission_option {
	RESPONSE=""
	printf "%s \n" "Selecciona una opción:"
	read RESPONSE
	while [[ -z $RESPONSE ]]; do
		printf "%s \n" "Selecciona una opción válida: "
		read RESPONSE
	done
	PERMISSION_SELECTED=$RESPONSE
}


function print_header {
	printf "\n%30s \e[4m%s\e[0m \n" "Modificando: " $FILE_PATH
	IFS=' '     # : is set as delimiter
	read -ra LINE <<< $(ls -la $FILE_PATH)   # str is read into an array as tokens separated by IFS
	printf "%30s %s \n\n" "Permisos iniciales: " ${LINE[0]}
}

function print_operator_menu {
	print_header
	printf "%-30s [%s] \n" "Agregar permiso" "+"
	printf "%-30s [%s] \n" "Quitar permiso" "-"
	printf "%-30s [%s] \n\n" "Dejar igual" "="
	# printf "\e[1;37m%-31s\e[0m [%d] \n\n" "volver" "4"
	read_operator_option
	set_permissions
}

function print_permissions_menu {
	print_header
	printf "\e[1m%-30s\e[0m \n" "Cambiar permisos de:"
	printf "%-30s [%s] \n" "Lectura" "r"
	printf "%-30s [%s] \n" "Escritura" "w"
	printf "%-30s [%s] \n\n" "Ejecucion" "x"
	# printf "\e[1;37m%-31s\e[0m [%d] \n\n" "Volver" "4"
	read_permission_option
	print_operator_menu
}

function print_scope_menu {
	print_header
	printf "\e[1m%-30s\e[0m \n" "Cambiar permisos para:"
	printf "%-30s [%s] \n" "Propietario" "u"
	printf "%-30s [%s] \n" "Grupo" "g"
	printf "%-30s [%s] \n" "Resto de usuarios" "o"
	printf "%-30s [%s] \n\n" "Todos" "a"
	# printf "\e[1;37m%-31s\e[0m [%s] \n\n" "Salir" "s"

	read_scope_option
	print_permissions_menu
}

function validate_args {
	if [[ -z "$FILE_PATH" ]]
	then
		echo "Por favor, pasa una ruta de archivo o directorio como argumento"
		return
	fi
	# Check if file exists
	if [[ -e $FILE_PATH ]]
	then
		echo ""
		return 
	fi
	echo "Archivo o directorio no existente"
	return 
}

function run {
	ARGS_INVALID=$(validate_args)
	if [[ -n $ARGS_INVALID ]]
	then
		echo $ARGS_INVALID
		return 0
	fi
	print_scope_menu
}

run