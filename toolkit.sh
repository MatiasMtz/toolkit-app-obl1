#!/usr/bin/env bash

showToolkit=1
path=""
# test
# manejar casos donde el path sea . o .. o / o ~ 
# EVALUAR MODIFICAR FUNCION routeRequest para tomar argumentos y cambiar el echo relativo a esto (en el case 6, saveURL, tiene que decir Ingrese la ruta de la carpeta donde quiera guardar su URL: en vez de lo que dice la FUNCION) 

showMenu() {
    # Menú dependiendo de si la variable path está vacía o no
    if [[ $path -eq "" ]]; then
        echo "*** MENÚ DE HERRAMIENTAS ***"
        echo "----------------"
        echo "1 >> Mostrar propiedades de una carpeta."
        echo "2 >> Renombrar todos los archivos de una ruta."
        echo "3 >> Resumen del estado del disco duro."
        echo "4 >> Buscar palabras en los archivos de una carpeta."
        echo "5 >> Mostrar reporte del sistema."
        echo "6 >> Guardar URL en un archivo."
        echo "7 >> Establecer ruta predeterminada."
        echo "8 >> Salir."
        echo "----------------"
    else
        echo "Menú de Herramientas"
        echo "----------------"
        echo "1 >> Mostrar propiedades de una carpeta."
        echo "2 >> Renombrar todos los archivos de una ruta."
        echo "3 >> Resumen del estado del disco duro."
        echo "4 >> Buscar palabras en los archivos de una carpeta."
        echo "5 >> Mostrar reporte del sistema."
        echo "6 >> Guardar URL en un archivo."
        echo "7 >> Cambiar/eliminar ruta predeterminada."
        echo "8 >> Salir."
        echo "----------------"
    fi
    return
}
# error, si el path esta mal sigue pidiendo: "Ingrese la ruta de la carpeta: ", al ingresar una ruta valida find devuelve: "La ruta no es válida. Intente nuevamente: " x 
# la cantidad de veces que se ingresa una ruta no valida
# Permitir volver al menu principal

# debugging con echo si es necesario
routeRequest() {
    local tempPath=""
    local prompt="${1:-Ingrese la ruta de la carpeta: }"
    while true; do
        read -p "$prompt" tempPath
        if [ -d "$tempPath" ]; then
            break
        fi
        echo "La ruta no es válida. Intente nuevamente: " >&2
    done
    echo "$tempPath"
}

showProperties() {
    if [ -n "$path" ]; then
        tempPath="$path"
    else
        tempPath=$(routeRequest)
    fi
        echo
        echo "*****************"
        echo "PROPIEDADES DE LA CARPETA <$tempPath>"
        echo "-- Número de archivos en la ruta: $(find "$tempPath" -maxdepth 1 -type f | wc -l)"
        echo "-- Número de archivos en subcarpetas: $(find "$tempPath" -mindepth 2 -type f | wc -l)"
        echo "-- Archivo de mayor tamaño: $(find "$tempPath" -type f -exec du -b {} + | sort -nr | head -n 1 | awk '{n=split($2, parts, "/"); print parts[n], "->", $1, "BYTES"}')"
        echo "-- Archivo de menor tamaño: $(find "$tempPath" -type f -exec du -b {} + | sort -n | head -n 1 | awk '{n=split($2, parts, "/"); print parts[n], "->", $1, "BYTES"}')"
        echo "*****************"
        echo
}

# agregar output luego de renombrar los archivos, mostrar los archivos que se modificaron y el nombre actual.
renameFiles() {
	if [ -n "$path" ]; then
		tempPath="$path"
	else
		tempPath=$(routeRequest)
	fi
	for file in "$tempPath"/*; do
		if [[ -f "$file" ]]; then
			mv "$file" "${file}bck"
		fi
	done
		
}

# Muestra un resumen del estado del disco duro. 
# cambiar output para mostrar <nombre de archivo> <peso en bytes>
diskSummary() {
    echo
    echo "*****************"
    echo "-- Resumen del estado del disco duro:"
	echo -e "$(df -h)\n"
    echo
    echo "Resumen del disco:"
    used=$(df --block-size=1G | awk 'N3R>1 {used+=$3} END {print used " GB"}')
    avail=$(df --block-size=1G | awk 'NR>1 {avail+=$4} END {print avail " GB"}')
    echo "-- Espacio total utilizado: $used"
    echo "-- Espacio disponible: $avail"
    echo
    echo "-- Archivo mas grande del disco:"
	echo -e "$(find / -type f -exec du -b {} + 2>/dev/null | sort -nr | head -n 1 | awk '{n=split($2, parts, "/"); print parts[n], "->", $1, "BYTES"}'))"
    echo "*****************"
    echo
}

# Pide una palabra y una carpeta. Muestra las líneas donde aparece dicha palabra (dentro de los archivos) y los diferentes archivos a los que pertenecen las líneas. 
# el searchword no esta buscando o mostrando los resultados
searchWord() {
	# funcionamiento si hay path
	if [ -n "$path" ]; then
		tempPath="$path"
	else
		tempPath=$(routeRequest)
	fi
	read -p "Ingrese la palabra a buscar: " word
	while [ "$( echo "$word" | wc -w )" -ne 1 ]; do
        echo -e "*** Ingrese únicamente 1 palabra ***\n"
        read -p "Ingrese la palabra a buscar: " word
        echo
    done
    echo
    echo "*****************"
	# ver awk man > flag -F y substr 
	grep -r -n -w "$word" "$tempPath" 2>/dev/null | awk -F: '{ print "--", $1, "<Línea "$2">", "|",substr($0, index($0,$3)) }' || echo "No se encontró la palabra '$word'"
    echo "*****************"
    echo
}

showSystemReport() {
	#mostrar> usuario actual, cuando se encendio la pc, fecha y hora actual
    echo
    echo "*****************"
	echo "-- Usuario actual: $(whoami)"
	echo "-- La PC se encendió el: $(uptime -s | awk '{print $1}') a las $(uptime -s | awk '{print $2}')"
	echo "-- Fecha del día de hoy: $(date '+%d-%m-%Y')"
	echo "-- Hora actual: $(date '+%H-%M-%S')"
    echo "*****************"
    echo
}

saveURL() {
	read -p "Ingrese la URL que desea guardar: " url
    tempPath=$(routeRequest "Ingrese la ruta de la carpeta donde quiera guardar su URL: ")

	echo "$url" > "$tempPath/paginaweb.txt"
    echo
    echo "*****************"
    echo "La URL se guardó correctamente en $tempPath/paginaweb.txt"
    echo "*****************"
    echo
	
	echo "* Verificando la URL... "
    if curl --head --silent --fail --max-time 5 "$url" > /dev/null; then
        echo "-- La URL es accesible."
    else
        echo "La URL no es válida o el servidor no responde."
    fi
    echo
}

# Establecer ruta predeterminada
defaultPath() {
	if [ -n "$path" ]; then
        echo "Ruta predeterminada actual: '$path'"
        echo "¿Qué desea hacer?"
        echo "1) Modificar ruta"
        echo "2) Eliminar ruta"
        echo "3) Volver"
        read -p "Seleccione una opción [1-3]: " feature
		
		case $feature in
            1)
                read -p "Ingrese la nueva ruta de la carpeta: " tempPath
                while [ ! -d "$tempPath" ]; do
                    echo "La ruta no es válida. Intente nuevamente:"
                    read -p "Ingrese la nueva ruta de la carpeta: " tempPath
                done
                path="$tempPath"
                echo "Ruta actualizada: '$path'"
                ;;
            2)
                path=""
                echo "Ruta eliminada."
                ;;
            3)
                return
                ;;
            *)
                echo "*** Opción no reconocida. Intente nuevamente. ***"
                ;;
            esac
	else
		read -p "Ingrese la ruta de la carpeta: " tempPath
		while [ ! -d "$tempPath" ]; do
			echo "La ruta no es válida. Intente nuevamente: "
			read -p "Ingrese la ruta de la carpeta: " tempPath
			echo
		done
		path="$tempPath"
		echo "La ruta predeterminada a partir de ahora es: '$path'"
	fi
}

closeApp() {
    echo "Saliendo de la aplicación..."
    sleep 1
    showToolkit=0
}

clear
while [ "$showToolkit" -eq 1 ]; do
    showMenu
    read -p "Ingrese su opción: " option
    case $option in
        1)
            clear
            showProperties
            ;;
        2) 
            clear
			renameFiles
            ;;
        3)
			clear
            diskSummary
            ;;
        4)
			clear
            searchWord
            ;;
        5)
            clear
			showSystemReport
            ;;
        6)
			clear
			saveURL
            ;;
        7)
			clear
			defaultPath
            ;;
        8)
            closeApp
            ;;
        *)
            echo "*** Opción no reconocida. Intente nuevamente. ***"
            sleep 2
            clear
            ;;
    esac
done