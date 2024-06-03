#!/bin/bash

#while true; do
    
    output=$(pvecm status)

    quorum=$(echo "$output" | grep "Nodes:" | awk '{print $2}')

    if [ "$quorum" -lt 2 ]; then
        pvecm expected 1
        echo "$(date): pvecm expected 1 command executed." >> /var/log/syslog
#    else
#        echo "$(date): Quorum é igual ou maior que 2. Nada a fazer." >> /var/log/syslog
    fi

    # Espera por 5 segundos antes de repetir
    # sleep 5
#done

