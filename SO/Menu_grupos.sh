```bash
#!/bin/bash

# VARIABLES
opc=10
year=$(date +%Y-%m-%d)

# FUNCIONES

function menu(){
    clear
    echo "========================================="
    echo "       MENÚ DE GESTIÓN DE GRUPOS         "
    echo "========================================="
    echo "1 - Agregar grupo"
    echo "2 - Borrar grupo"
    echo "3 - Listar grupos del sistema"
    echo "4 - Buscar un grupo en el sistema"
    echo "0 - Salir"
    echo "========================================="
}

function listar_grupos(){
    clear

    echo "GRUPOS DEL SISTEMA"

    cut -d ":" -f 1 /etc/group | sort | more

    echo "Presione ENTER para volver al menú principal"
    read pausa
}

function agregar_grupo(){
    clear

    read -p "Ingrese el nombre del grupo a agregar: " grupoUsuario

    grupo=$(echo "$grupoUsuario" | tr '[:upper:]' '[:lower:]')

    if getent group "$grupo" > /dev/null; then
        echo "El grupo $grupo ya existe en el sistema"
    else
        groupadd "$grupo"

        if [ $? -eq 0 ]; then
            echo "Grupo $grupo agregado exitosamente"
        else
            echo "Error al agregar el grupo $grupo"
        fi
    fi

    echo "Presione ENTER para volver al menú principal"
    read pausa
}

function borrar_grupo(){
    clear

    read -p "Ingrese el nombre del grupo a borrar: " grupoUsuario

    grupo=$(echo "$grupoUsuario" | tr '[:upper:]' '[:lower:]')

    if getent group "$grupo" > /dev/null; then

        groupdel "$grupo"

        if [ $? -eq 0 ]; then
            echo "Grupo $grupo borrado exitosamente"
        else
            echo "Error al borrar el grupo $grupo"
        fi

    else
        echo "El grupo $grupo no existe en el sistema"
    fi

    echo "Presione ENTER para volver al menú principal"
    read pausa
}

function buscar_grupo(){
    clear

    read -p "Ingrese el nombre del grupo a buscar: " grupoUsuario

    grupo=$(echo "$grupoUsuario" | tr '[:upper:]' '[:lower:]')

    if getent group "$grupo" > /dev/null; then
        echo "El grupo $grupo existe en el sistema"
    else
        echo "El grupo $grupo no existe en el sistema"
    fi

    echo "Presione ENTER para volver al menú principal"
    read pausa
}

# MAIN

while [ "$opc" -ne 0 ]
do
    clear
    menu

    read -p "Ingrese la opción correspondiente: " opc

    case $opc in
        1)
            agregar_grupo
            ;;

        2)
            borrar_grupo
            ;;

        3)
            listar_grupos
            ;;

        4)
            buscar_grupo
            ;;

        0)
            echo "Volviendo al menú principal"
            ;;

        *)
            echo "Seleccionó una opción incorrecta"
            read -p "Presione ENTER para continuar..."
            ;;
    esac
done
```
