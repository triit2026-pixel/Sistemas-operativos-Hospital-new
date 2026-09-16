```bash
#!/bin/bash

# VARIABLES
opc=10
year=$(date +%Y-%m-%d)

# FUNCIONES

function menu(){
    clear
    echo "========================================="
    echo "       MENÚ DE GESTIÓN DE USUARIOS       "
    echo "========================================="
    echo "1 - Agregar usuario"
    echo "2 - Borrar usuario"
    echo "3 - Listar usuarios del sistema"
    echo "4 - Buscar un usuario en el sistema"
    echo "5 - Cambiar contraseña de un usuario"
    echo "6 - Bloquear usuario"
    echo "7 - Desbloquear usuario"
    echo "0 - Salir"
    echo "========================================="
}

function agregar_usuario(){
    clear

    echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre:"
    read nombre

    nomb=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')

    if id "$nomb" &>/dev/null; then
        echo "El usuario ya existe"
        echo "El usuario $USER en la fecha $(date +%Y-%m-%d-%H:%M:%S) trato de crear un usuario con el nombre $nomb pero el usuario ya existe en el sistema" >> /root/log/log_propios/usuarios.txt
        read -p "Presione ENTER para continuar..."
    else
        echo "Ingrese el grupo:"
        read grupo

        user_group=$(echo "$grupo" | tr '[:upper:]' '[:lower:]')

        if getent group "$user_group" > /dev/null; then
            useradd -g "$user_group" -c "$user_group $year" -m -k /etc/skel -s /bin/bash "$nomb"

            echo "$nomb:12345" | chpasswd

            echo "El usuario $USER en la fecha $(date +%Y-%m-%d-%H:%M:%S) agrego el usuario $nomb perteneciente al grupo $user_group al sistema" >> /root/log/log_propios/usuarios.txt

            echo "Usuario dado de alta, se le asigno la contraseña 12345"
            read -p "Presione ENTER para continuar..."
        else
            echo "El grupo no existe"
            echo "$(date +%Y-%m-%d-%H:%M:%S) Se trato de agregar el usuario $nomb al grupo $user_group, pero el grupo no existe." >> /root/log/log_propios/grupos.txt
            read -p "Presione ENTER para continuar..."
        fi
    fi
}

function borrar_usuario(){
    clear

    echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre:"
    read nombre

    nomb=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')

    if id "$nomb" &>/dev/null; then
        echo "El usuario $nomb será eliminado del sistema, ¿está seguro? S/N"
        read letra

        if [[ "$letra" == "S" || "$letra" == "s" ]]; then
            userdel -r "$nomb"

            echo "Usuario eliminado del sistema"
            echo "$(date +%Y-%m-%d-%H:%M:%S) Usuario: $nomb eliminado del sistema" >> /root/log/log_propios/usuarios.txt

            read -p "Presione ENTER para continuar..."
        else
            echo "Operación cancelada"
            read -p "Presione ENTER para volver al menú..."
        fi
    else
        echo "El usuario $nomb no existe en el sistema"
        read -p "Presione ENTER para continuar..."
    fi
}

function listar_usuarios(){
    clear

    echo "USUARIOS DEL SISTEMA"

    cut -d ":" -f 1 /etc/passwd | sort | more

    echo "Presione ENTER para volver al menú principal"
    read pausa
}

function buscar_usuario(){
    clear

    echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre:"
    read nombre

    nomb=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')

    if id "$nomb" &>/dev/null; then
        echo "El usuario $nomb existe en el sistema"
    else
        echo "El usuario $nomb no existe en el sistema"
    fi

    read -p "Presione ENTER para continuar..."
}

function cambiar_contra_usuario(){
    clear

    echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre:"
    read nombre

    nomb=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')

    if id "$nomb" &>/dev/null; then
        echo "Se procede a cambiar la contraseña del usuario $nomb"
        passwd "$nomb"
    else
        echo "El usuario $nomb no existe en el sistema"
    fi

    read -p "Presione ENTER para continuar..."
}

function bloquear_usuario(){
    clear

    echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre:"
    read nombre

    nomb=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')

    if id "$nomb" &>/dev/null; then
        echo "Se procede a bloquear la cuenta del usuario $nomb"
        usermod -L "$nomb"
        echo "Usuario bloqueado correctamente"
    else
        echo "El usuario $nomb no existe en el sistema"
    fi

    read -p "Presione ENTER para continuar..."
}

function desbloquear_usuario(){
    clear

    echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre:"
    read nombre

    nomb=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')

    if id "$nomb" &>/dev/null; then
        echo "Se procede a desbloquear la cuenta del usuario $nomb"
        usermod -U "$nomb"
        echo "Usuario desbloqueado correctamente"
    else
        echo "El usuario $nomb no existe en el sistema"
    fi

    read -p "Presione ENTER para continuar..."
}

# PROGRAMA PRINCIPAL

while [ "$opc" -ne 0 ]
do
    menu

    read -p "Ingrese la opción correspondiente: " opc

    case $opc in
        1)
            agregar_usuario
            ;;

        2)
            borrar_usuario
            ;;

        3)
            listar_usuarios
            ;;

        4)
            buscar_usuario
            ;;

        5)
            cambiar_contra_usuario
            ;;

        6)
            bloquear_usuario
            ;;

        7)
            desbloquear_usuario
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
