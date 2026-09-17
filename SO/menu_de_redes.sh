#!/bin/bash

opc=0

function menu(){
    echo "GESTIÓN DE REDES"
    echo "1 - Ver configuración de red"
    echo "2 - Ver tabla de rutas"
    echo "3 - Probar conectividad"
    echo "4 - Ver puertos abiertos"
    echo "5 - Reiniciar red"
    echo "6 - Volver"
    echo "Ingrese una opción: "
}

while [ $opc -ne 6 ];
do
    menu
    read opc
    case $opc in
        1)
            ip a ;;
        2)
            ip route ;;
        3)
            read -p "Host o IP a probar: " host
            ping -c 4 "$host" ;;
        4)
            sudo ss -tulnp ;;
        5)
            sudo systemctl restart systemd-networkd
            echo "Servicio de red reiniciado" ;;
        6)
            echo "Volviendo..." ;;
        *)
            echo "La opción no es válida" ;;
    esac
done
