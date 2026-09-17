```bash
#!/bin/bash

# SCRIPT INICIAL DEL SERVIDOR

opc=0

function menu(){
    clear
    echo "========================================="
    echo "           MENÚ PRINCIPAL"
    echo "========================================="
    echo "1 - Gestión de usuarios"
    echo "2 - Gestión de grupos"
    echo "3 - Gestión de respaldos"
    echo "4 - Gestión de redes"
    echo "5 - Gestión de Bases de datos"
    echo "6 - Gestión de Firewall"
    echo "7 - Gestión de Logs del Sistema"
    echo "8 - Gestión de Docker"
    echo "9 - Salir"
    echo "========================================="
    echo "Ingrese una opción: "
}

while [ "$opc" -ne 9 ]
do
    menu
    read opc

    case $opc in
        1)
            ./menu_de_usuarios.sh
            ;;

        2)
            ./menu_de_grupos.sh
            ;;

        3)
            ./menu_de_gestion_respaldos.sh
            ;;

        4)
            ./menu_de_redes.sh
            ;;

        5)
            echo "Gestión de Bases de Datos"
            ;;

        6)
            ./menu_de_gestion_firewall.sh
            ;;

        7)
            menu_de_logs.sh
            ;;

        8)
            echo "Gestión de Docker"
            ;;

        9)
            echo "Hasta pronto!, buena jornada"
            ;;

        *)
            echo "Opción no soportada por el sistema"
            ;;
    esac

    if [ "$opc" -ne 9 ]; then
        echo
        read -p "Presione ENTER para continuar..."
    fi
done
```
