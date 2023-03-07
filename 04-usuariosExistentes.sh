#! /bin/bash
# Programa un script en bash para imprimir en consola la información detallada de los usuarios existentes en Debian.
USERS=()

function obtain_users {

	while IFS= read -r ARCHIVO
	do
		IFS=':'     # : is set as delimiter
		read -ra LINE <<< "$ARCHIVO"   # str is read into an array as tokens separated by IFS
		USERS+=(${LINE[0]})
	done < /etc/passwd
}

function print_users {
	for user in "${USERS[@]}"
	do
		echo $user
	done
}

obtain_users
print_users