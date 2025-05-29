# 🧰 Bash Toolkit - `toolkit.sh`

Este proyecto contiene un script en Bash llamado `toolkit.sh` que actúa como una caja de herramientas para automatizar tareas comunes desde la terminal de Linux. Está diseñado con fines educativos.

---

## 📋 Funcionalidades

Al ejecutar el script, se presenta un menú interactivo con las siguientes opciones:

### 1️⃣ Resumen de propiedades de una carpeta
Solicita al usuario una ruta y muestra:
- Cantidad de archivos en la carpeta (sin incluir subcarpetas).
- Cantidad de archivos en las subcarpetas.
- El archivo de menor tamaño.
- El archivo de mayor tamaño.

### 2️⃣ Renombrar archivos
Solicita una ruta y renombra todos los archivos agregándoles el sufijo `bck`.  
Ejemplo: `hola.txt` → `hola.txtbck`.

### 3️⃣ Estado del disco duro
Muestra:
- Espacio usado y libre en los discos.
- El archivo más pesado del sistema.
> *Nota:* Algunas carpetas pueden no ser accesibles sin permisos de admin.

### 4️⃣ Buscar palabra en archivos
Solicita una palabra clave y una carpeta, y busca dicha palabra en todos los archivos del directorio.  
Muestra:
- Las líneas donde aparece.
- Los archivos correspondientes.

### 5️⃣ Reporte del sistema
Imprime:
- Usuario actual.
- Fecha y hora actual.
- Hora del último arranque del sistema.

### 6️⃣ Descargar contenido web
Solicita una URL y una ruta de guardado.  
Guarda el contenido en un archivo llamado `paginaweb.txt`.

### 7️⃣ Guardar ruta predeterminada
Permite establecer una ruta predeterminada.  
Si se configura, las opciones 1, 2, 4 y 6 utilizarán esta ruta sin volver a pedirla.

---

## ▶️ Ejecución

1. El script debe tener permisos de ejecución:
   ```bash
   chmod +x toolkit.sh
   ```
2.  Ejecutar el script:
   ```bash
   ./toolkit.sh
   ```

##  🛠 Requisitos

- Permisos adecuados para acceder a los archivos del sistema según sea necesario

## 🎯 Objetivos educativos
Este script fue desarrollado con fines didácticos para que el estudiante:

- Practique scripting en Bash.

- Investigue y utilice comandos útiles de Linux.

- Emplee estructuras básicas como funciones, condicionales y menús.

- Genere scripts ejecutables fácilmente verificables.

## 📝 Licencia
Este proyecto se distribuye con fines educativos. Puedes ser modificado libremente.