```bash
#!/bin/bash

# VARIABLES
opc=10
fecha=$(date +"%Y-%m-%d")

# FUNCIONES

function menu(){
    clear
    echo "========================================="
    echo "       GESTIÓN DE RESPALDOS              "
    echo "========================================="
    echo "1 - Crear respaldo de BD"
    echo "2 - Crear respaldo de Logs del sistema"
    echo "3 - Restaurar respaldo de BD"
    echo "4 - Restaurar respaldo de Logs del sistema"
    echo "5 - Eliminar respaldo"
    echo "6 - Listar respaldos disponibles"
    echo "7 - Configurar programación de respaldos"
    echo "8 - Enviar respaldo a ubicación remota"
    echo "0 - Salir"
    echo "========================================="
}

function crear_respaldo_bd(){
    clear
    echo "--- Creando respaldo de la base de datos ---"

    mysqldump -u root -p --databases cartas --routines --triggers --events > "${fecha}-cartas_bd_backup.sql"

    if [ $? -eq 0 ]; then
        mv "${fecha}-cartas_bd_backup.sql" /root/respaldos_bd/
        echo "Respaldo de BD creado exitosamente."
    else
        echo "Error al crear el respaldo de BD."
        rm -f "${fecha}-cartas_bd_backup.sql"
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function crear_respaldo_logs(){
    clear
    echo "--- Creando respaldo de los logs del sistema ---"

    tar -czvf "${fecha}-logs_sistema_backup.tar.gz" /var/log

    if [ $? -eq 0 ]; then
        mv "${fecha}-logs_sistema_backup.tar.gz" /root/respaldos_logs/
        echo "Respaldo de logs creado exitosamente."
    else
        echo "Error al crear el respaldo de logs."
        rm -f "${fecha}-logs_sistema_backup.tar.gz"
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function restaurar_respaldo_bd(){
    clear
    echo "--- Restaurando respaldo de la base de datos ---"
    echo "Respaldos de BD guardados en el sistema:"

    ls -lh /root/respaldos_bd/*.sql 2>/dev/null

    read -p "Ingrese el nombre del archivo de respaldo de BD: " respaldo_bd

    if [ -f "/root/respaldos_bd/$respaldo_bd" ]; then
        mysql -u root -p < "/root/respaldos_bd/$respaldo_bd"

        if [ $? -eq 0 ]; then
            echo "Respaldo de BD restaurado exitosamente."
        else
            echo "Error al restaurar el respaldo de BD."
        fi
    else
        echo "El archivo de respaldo no existe."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function restaurar_respaldo_logs(){
    clear
    echo "--- Restaurando respaldo de los logs del sistema ---"
    echo "Respaldos de logs guardados en el sistema:"

    ls -lh /root/respaldos_logs/*.tar.gz 2>/dev/null

    read -p "Ingrese el nombre del archivo de respaldo de logs: " respaldo_logs

    if [ -f "/root/respaldos_logs/$respaldo_logs" ]; then

        mkdir -p /root/logs_restaurados

        tar -xzvf "/root/respaldos_logs/$respaldo_logs" -C /root/logs_restaurados

        if [ $? -eq 0 ]; then
            echo "Respaldo de logs restaurado exitosamente."
        else
            echo "Error al restaurar el respaldo de logs."
        fi
    else
        echo "El archivo de respaldo no existe."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function eliminar_respaldo(){
    clear
    echo "--- Eliminando respaldo ---"

    echo "Respaldos de BD:"
    ls -lh /root/respaldos_bd/*.sql 2>/dev/null

    echo
    echo "Respaldos de logs:"
    ls -lh /root/respaldos_logs/*.tar.gz 2>/dev/null

    echo
    echo "Ingrese la ruta completa del respaldo que desea eliminar:"
    read respaldo

    if [ -f "$respaldo" ]; then

        rm -i "$respaldo"

        if [ $? -eq 0 ]; then
            echo "Respaldo eliminado exitosamente."
        else
            echo "El respaldo no fue eliminado."
        fi

    else
        echo "El archivo indicado no existe."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function listar_respaldos(){
    clear

    echo "--- Listando respaldos disponibles ---"

    echo
    echo "RESPALDOS DE BD:"
    ls -lh /root/respaldos_bd/*.sql 2>/dev/null

    echo
    echo "RESPALDOS DE LOGS DEL SISTEMA:"
    ls -lh /root/respaldos_logs/*.tar.gz 2>/dev/null

    echo
    echo "Respaldos listados exitosamente."

    read -p "Presione ENTER para continuar..." pausa
}

function configurar_programacion_respaldos(){
    clear

    echo "--- Configurando programación de respaldos ---"

    crontab -e

    echo "Programación de respaldos configurada."
    read -p "Presione ENTER para continuar..." pausa
}

function enviar_respaldo_remoto(){
    clear

    echo "--- Enviando respaldo a ubicación remota ---"

    echo "Ingrese la ruta del respaldo que desea enviar:"
    read respaldo

    echo "Ingrese el usuario remoto:"
    read usuario_remoto

    echo "Ingrese la IP o nombre del equipo remoto:"
    read servidor_remoto

    echo "Ingrese la ruta de destino en el equipo remoto:"
    read destino_remoto

    if [ -f "$respaldo" ]; then

        scp "$respaldo" "$usuario_remoto@$servidor_remoto:$destino_remoto"

        if [ $? -eq 0 ]; then
            echo "Respaldo enviado a ubicación remota exitosamente."
        else
            echo "Error al enviar el respaldo."
        fi

    else
        echo "El archivo de respaldo no existe."
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
            crear_respaldo_bd
            ;;

        2)
            crear_respaldo_logs
            ;;

        3)
            restaurar_respaldo_bd
            ;;

        4)
            restaurar_respaldo_logs
            ;;

        5)
            eliminar_respaldo
            ;;

        6)
            listar_respaldos
            ;;

        7)
            configurar_programacion_respaldos
            ;;

        8)
            enviar_respaldo_remoto
            ;;

        0)
            clear
            echo "Saliendo del programa... ¡Hasta luego!"
            ;;

        *)
            echo "[ERROR] Opción incorrecta. Por favor ingrese un número del 0 al 8."
            read -p "Presione ENTER para continuar..." pausa
            ;;
    esac
done
```
