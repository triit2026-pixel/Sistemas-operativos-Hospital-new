```bash
#!/bin/bash

# VARIABLES
opc=10
fecha=$(date +"%Y-%m-%d")

# FUNCIONES

function menu(){
    clear
    echo "========================================="
    echo "       GESTIÓN DE FIREWALLD              "
    echo "========================================="
    echo "1 - Verificar estado de FirewallD"
    echo "2 - Permitir HTTP y HTTPS"
    echo "3 - Bloquear una IP"
    echo "4 - Establecer políticas restrictivas"
    echo "5 - Habilitar solicitudes de ping"
    echo "6 - Listar servicios permitidos"
    echo "7 - Bloquear dirección MAC"
    echo "8 - Agregar servicio"
    echo "0 - Salir"
    echo "========================================="
}

function verificar_firewall(){
    clear
    echo "--- Estado de FirewallD ---"

    firewall-cmd --state

    read -p "Presione ENTER para continuar..." pausa
}

function permitir_http_https(){
    clear
    echo "--- Permitiendo tráfico HTTP y HTTPS ---"

    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-service=https
    firewall-cmd --reload

    echo "HTTP y HTTPS fueron permitidos correctamente."

    read -p "Presione ENTER para continuar..." pausa
}

function bloquear_ip(){
    clear

    echo "--- Bloquear una Dirección IP ---"

    read -p "Ingrese la dirección IP a bloquear (Ej. 192.168.1.50): " ip

    if [ -n "$ip" ]; then
        if firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='$ip' drop"; then
            firewall-cmd --reload
            echo "La IP $ip fue bloqueada correctamente."
        else
            echo "Error al bloquear la IP $ip."
        fi
    else
        echo "La dirección IP no puede estar vacía."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function politicas_restrictivas(){
    clear

    echo "--- Estableciendo Políticas Restrictivas en el Servidor ---"

    echo "Cambiando la zona por defecto a 'drop'."
    echo "Todo tráfico no permitido explícitamente será descartado."

    firewall-cmd --set-default-zone=drop

    if [ $? -eq 0 ]; then
        echo "Política restrictiva configurada correctamente."
    else
        echo "Error al establecer la zona por defecto."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function habilitar_ping(){
    clear

    echo "--- Habilitar solicitudes de PING ---"

    firewall-cmd --permanent --add-rich-rule='rule protocol value="icmp" accept'

    if [ $? -eq 0 ]; then
        firewall-cmd --reload
        echo "Solicitudes de Ping habilitadas."
    else
        echo "Error al habilitar Ping."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function listar_servicios(){
    clear

    echo "--- Servicios permitidos en la zona actual ---"

    zona=$(firewall-cmd --get-default-zone)

    echo "Zona actual: $zona"
    echo "Servicios habilitados:"

    firewall-cmd --zone="$zona" --list-services

    read -p "Presione ENTER para continuar..." pausa
}

function bloquear_mac(){
    clear

    echo "--- Bloquear una Dirección MAC ---"

    read -p "Ingrese la dirección MAC a bloquear (Ej. 00:1A:2B:3C:4D:5E): " mac

    if [ -n "$mac" ]; then
        if firewall-cmd --permanent --add-rich-rule="rule source mac='$mac' drop"; then
            firewall-cmd --reload
            echo "Dirección MAC $mac bloqueada exitosamente."
        else
            echo "Error al bloquear la dirección MAC."
        fi
    else
        echo "La dirección MAC no puede estar vacía."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function agregar_servicio(){
    clear

    echo "--- Agregar Nuevo Servicio a FirewallD ---"

    read -p "Ingrese el nombre del servicio (Ej. mysql, mariadb, dns): " servicio

    if [ -n "$servicio" ]; then

        if firewall-cmd --permanent --add-service="$servicio" 2>/dev/null; then
            firewall-cmd --reload
            echo "[OK] Servicio '$servicio' agregado correctamente."
        else
            echo "[ERROR] El servicio '$servicio' no es válido o no existe en FirewallD."
        fi

    else
        echo "[ERROR] El nombre del servicio no puede estar vacío."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

# MAIN

while [ "$opc" -ne 0 ]
do
    menu

    read -p "Ingrese la opción: " opc

    case $opc in
        1)
            verificar_firewall
            ;;

        2)
            permitir_http_https
            ;;

        3)
            bloquear_ip
            ;;

        4)
            politicas_restrictivas
            ;;

        5)
            habilitar_ping
            ;;

        6)
            listar_servicios
            ;;

        7)
            bloquear_mac
            ;;

        8)
            agregar_servicio
            ;;

        0)
            echo "Saliendo del programa... ¡Hasta luego!"
            ;;

        *)
            echo "[ERROR] Opción incorrecta. Por favor ingrese un número del 0 al 8."
            read -p "Presione ENTER para continuar..." pausa
            ;;
    esac
done
```
