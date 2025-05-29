#!/usr/bin/env bash
path=""

showMenu() {
    if [ -z "$path" ]; then
        echo "*** MENÚ DE HERRAMIENTAS ***"
        echo "----------------"
        echo "1 >> Mostrar propiedades de una carpeta."
        echo "2 >> Renombrar los archivos de una carpeta."
        echo "3 >> Resumen del estado del disco duro."
        echo "4 >> Buscar palabras en los archivos de una carpeta."
        echo "5 >> Mostrar reporte del sistema."
        echo "6 >> Guardar URL en un archivo."
        echo "7 >> Establecer ruta predeterminada."
        echo "8 >> Salir."
        echo "----------------"
    else
        echo "*** MENÚ DE HERRAMIENTAS ***"
        echo "----------------"
        echo "1 >> Mostrar propiedades de una carpeta."
        echo "2 >> Renombrar los archivos de una carpeta."
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
    clear
    echo "*****************"
    echo "PROPIEDADES DE LA CARPETA <$tempPath>"
    echo "-- Archivos: $(find "$tempPath" -maxdepth 1 -type f | wc -l)"
    echo "-- Archivos en subcarpetas: $(find "$tempPath" -mindepth 2 -type f | wc -l)"
    echo "-- Archivo de mayor tamaño en carpeta y subcarpetas: $(find "$tempPath" -type f -printf '%s %p\n' | sort -nr | head -n 1 | awk '{print $2, "->", $1, "Bytes"}')"
    echo "-- Archivo de menor tamaño en carpeta y subcarpetas: $(find "$tempPath" -type f -printf '%s %p\n' | sort -n | head -n 1 | awk '{print $2, "->", $1, "Bytes"}')"
    echo "*****************"
    echo
}

renameFiles() {
	if [ -n "$path" ]; then
		tempPath="$path"
	else
		tempPath=$(routeRequest)
	fi
	for file in "$tempPath"/*; do
		if [[ -f "$file" && "$(basename "$file")" != "toolkit.sh" ]]; then
			mv "$file" "${file}bck"
            echo ">> Archivo renombrado: $(basename "$file") a $(basename "${file}bck")"
		fi
	done
    echo		
}

diskSummary() {
    echo "*****************"
    echo "-- Resumen del estado del disco duro:"
	echo -e "$(df -h)\n"
    echo
    echo "Resumen del disco:"
    used=$(df --block-size=1G | awk 'NR>1 {used+=$3} END {print used " GB"}')
    avail=$(df --block-size=1G | awk 'NR>1 {avail+=$4} END {print avail " GB"}')
    echo "-- Espacio total utilizado: $used"
    echo "-- Espacio disponible: $avail"
    echo
    echo "-- Calculando archivo mas grande del disco..."
	echo "$(find / -type f -printf '%s %p\n' 2>/dev/null | sort -nr | head -n 1 | awk '{print $2, "->", $1 / 1024 ** 3, "GB"}')"
    echo "* Algunos archivos pueden no ser accesibles debido a permisos de usuario o restricciones del sistema (procesos en ejecución, archivos protegidos, etc.)."
    echo "*****************"
    echo
}

searchWord() {
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
    clear
    echo "*****************"
    echo "Buscando '$word' en la ruta '$tempPath'..."
    echo "-----------------"
	results=$(grep -nw "$word" "$tempPath"/* 2>/dev/null)
    if [ -n "$results" ]; then
        echo "$results" | awk -F: '{ print ">>", $1, "<Línea "$2">", "|", $3 }'
    else
        echo "No se encontró la palabra '$word' en los archivos de la carpeta."
    fi
    echo "*****************"
    echo
}

showSystemReport() {
    echo "*****************"
	echo "-- Usuario actual: $(whoami)"
	echo "-- La PC se encendió el: $(uptime -s | awk '{print $1}') a las $(uptime -s | awk '{print $2}')"
	echo "-- Fecha del día de hoy: $(date '+%d-%m-%Y')"
	echo "-- Hora actual: $(date '+%H:%M:%S')"
    echo "*****************"
    echo
}

saveURL() {
	read -p "Ingrese la URL que desea guardar: " url
    tempPath=$(routeRequest "Ingrese la ruta de la carpeta donde quiera guardar su URL: ")
	echo "$url" > "$tempPath/paginaweb.txt"
    clear
    echo "*****************"
    if [[ "${tempPath: -1}" == "/" ]]; then
        tempPath="${tempPath: 0:-1}"
    fi
    echo "La URL se guardó correctamente en $tempPath/paginaweb.txt"
    echo "*****************"
    echo
	echo "* Verificando la URL... "
    if curl --head --silent --fail --max-time 5 "$url" > /dev/null; then
        echo "-- Su URL es accesible."
    else
        echo "-- Su URL no es accesible."
    fi
    echo
}

defaultPath() {
	if [ -n "$path" ]; then
        echo
        echo "*****************"
        echo "Ruta predeterminada actual: '$path'"
        echo "¿Qué desea hacer?"
        echo "1) Modificar ruta"
        echo "2) Eliminar ruta"
        echo "3) Volver"
        echo
        read -p "Seleccione una opción [1-3]: " feature
		
		case $feature in
            1)
                path=$(routeRequest "Ingrese su nueva carpeta predeterminada: ")
                clear
                echo "Ruta actualizada a: '$path'"
                echo
                ;;
            2)
                path=""
                clear
                echo "Ruta eliminada."
                echo
                ;;
            3)
                clear
                return
                ;;
            *)
                echo "*** Opción no reconocida. Intente nuevamente. ***"
                echo
                ;;
            esac
	else
		path=$(routeRequest "Ingrese su carpeta predeterminada: ")
        clear
		echo "La ruta predeterminada a partir de ahora es: '$path'"
        echo
	fi
}

clear
while true; do
    showMenu
    read -p "Ingrese el número de la herramienta que desea: " option
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
            echo "Saliendo de la aplicación..."
            sleep 1
            break
            ;;
        *)
            echo "*** Opción no reconocida. Intente nuevamente. ***"
            sleep 2
            clear
            ;;
    esac
done