#!bin/bash


# Definiendo funciones

generarLLave (){
    echo "Generando llave privada ........"
    wg genkey > private
    echo 'Llave privada:'
    cat private

}

configurarInterface (){

    echo "Esta es la llave publica ........"
    wg pubkey < private

    MYIP='192.168.60.2/24'
    ALLOWIPS='192.168.60.0/24'

    PORT=38000
    INTERFACE='wg0'

    echo 'Ingrese llave publica del peer .....'
    read LLAVEPUBLICA

    echo 'Ingrese ip publica del peer .....'
    read ENDIP


    ip link add $INTERFACE type wireguard # se crea una INTERFACE virtual
    ip addr add $MYIP dev $INTERFACE # se establece la dirección ip a la INTERFACE

    wg set $INTERFACE private-key private # se establece una llave privada a la INTERFACE
    ip link set $INTERFACE up # se sube la INTERFACE


    wg set $INTERFACE peer $LLAVEPUBLICA allowed-ips $ALLOWIPS endpoint $ENDIP:$PORT # se habilita trafico desde la ip del peer con llave especifica
    wg set $INTERFACE listen-port $PORT # Se cambia el puerto de escucha

    wg # se valida la configuración actual

}

FILE=private

if  test -f "$FILE";
    then
        echo "LLave privada existe"
        configurarInterface
                
    else
        generarLLave
        configurarInterface

fi




