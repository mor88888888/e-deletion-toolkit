#!/bin/sh

key="yfPtVZZSHGMd5mej"

# Función que cifra un archivo
cifrar() {
    openssl enc -aes-256-cbc -salt -a -in $1 -out $2 -k $key
}

# Función que descifra un archivo
descifrar() {
    openssl enc -aes-256-cbc -salt -a -in $1 -k $key -d
}

# Verificación de los argumentos
if [ $# -gt 3 ]; then
    echo "Usage: $0 <option:-e,-d> <archivo> [<salida>]"
    exit 1
fi

# Cifrado
if [ "$1" = "-e" ]; then
    cifrar $2 $3
elif [ "$1" = "-d" ]; then
    descifrar $2
else
    echo "Opción no válida"
    exit 1
fi