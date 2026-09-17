#!/bin/bash

opc=0

function menu(){
    echo "GESTIÓN DE LOGS DEL SISTEMA"
    echo "1 - Ver logs del sistema"
    echo "2 - Ver logs de autenticación"
    echo "3 - Buscar en logs"
    echo "4 - Limpiar logs antiguos"
    echo "5 - Volver"
    echo "Ingrese una opción: "
}

while [ $opc -ne 5 ];
do
    menu
    read opc
    case $opc in
        1)
            sudo journalctl -n 50 ;;
        2)
            sudo tail -n 50 /var/log/auth.log ;;
        3)
            read -p "Texto a buscar: " texto
            sudo grep -r "$texto" /var/log ;;
        4)
            sudo journalctl --vacuum-time=7d
            echo "Logs antiguos han sido eliminados" ;;
        5)
            echo "Volviendo..." ;;
        *)
            echo "La opción no es válida" ;;
    esac
done
