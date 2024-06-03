#!/bin/bash

#while true; do
    # Executa o comando pvecm status e armazena a saída em uma variável
    output=$(pvecm status)

    # Extrai o valor de Quorum da saída
    quorum=$(echo "$output" | grep "Nodes:" | awk '{print $2}')

    # Verifica se o Quorum é menor que 2
    if [ "$quorum" -lt 2 ]; then
        # Executa o comando pvecm expected 1
        pvecm expected 1
        echo "$(date): Comando pvecm expected 1 executado." >> /var/log/syslog
#    else
#        echo "$(date): Quorum é igual ou maior que 2. Nada a fazer." >> /var/log/syslog
    fi

    # Espera por 5 segundos antes de repetir
    # sleep 5
#done

