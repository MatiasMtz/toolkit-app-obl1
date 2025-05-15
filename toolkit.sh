#!/usr/bin/env bash

showToolkit=1
path=""
# manejar casos donde el path sea . o .. o / o ~ 

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

routeRequest() {
    read -p "Ingrese la ruta de la carpeta: " tempPath
    while [ ! -d "$tempPath" ]; do
        echo "La ruta no es válida. Intente nuevamente: "
        read -p "Ingrese la ruta de la carpeta: " tempPath
        echo
    done
    echo $tempPath
}

showProperties() {
    if [ -n "$path" ]; then
        echo
        echo "*****************"
        echo "PROPIEDADES DE LA CARPETA $path:"
        echo "Número de archivos en la ruta: $(find $path -maxdepth 1 -type f | wc -l)"
        echo "Número de archivos en subcarpetas: $(find $path -mindepth 2 -type f | wc -l)"
        # cambiar output para mostrar -> solo nombre de archivo en lugar de ruta completa
        echo -e "Archivo de mayor tamaño | Peso en Bytes\n$(find $tempPath -type f -exec du -b {} + | sort -nr | head -n 1 | awk '{print $2, $1}')"
        echo -e "Archivo de menor tamaño | Peso en Bytes\n$(find $tempPath -type f -exec du -b {} + | sort -n | head -n 1 | awk '{print $2, $1}')"
        echo "*****************"
        echo
        return
    fi
    tempPath=$(routeRequest)
    echo
    echo "*****************"
    echo "PROPIEDADES DE LA CARPETA $tempPath"
    echo "-- Número de archivos en la ruta: $(find $tempPath -maxdepth 1 -type f | wc -l)"
    echo "-- Número de archivos en subcarpetas: $(find $tempPath -mindepth 2 -type f | wc -l)"
    echo
    # cambiar output para mostrar -> solo nombre de archivo en lugar de ruta completa
    echo -e "-- Archivo de mayor tamaño | Peso en Bytes\n$(find $tempPath -type f -exec du -b {} + | sort -nr | head -n 1 | awk '{print $2, $1}')"
    echo -e "-- Archivo de menor tamaño | Peso en Bytes\n$(find $tempPath -type f -exec du -b {} + | sort -n | head -n 1 | awk '{print $2, $1}')"
    echo "*****************"
    echo
    return
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
            
            ;;
        3)
            
            ;;
        4)
            
            ;;
        5)
            
            ;;
        6)
        
            ;;
        7)

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
