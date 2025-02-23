#!/bin/bash

SCRIPT_PATH="/usr/local/bin/sync_hosts.sh"
SERVICE_PATH="/etc/systemd/system/hosts-sync.service"
LOG_FILE="/var/log/hosts_sync.log"

cat << 'EOF' > $SCRIPT_PATH
#!/bin/bash

SYNC_FILE="/etc/pve/priv/hosts.sync"
HOSTS_FILE="/etc/hosts"
LOG_FILE="/var/log/hosts_sync.log"

if [[ ! -f $SYNC_FILE ]]; then
    cp "$HOSTS_FILE" "$SYNC_FILE"
    echo "$(date) - Criado arquivo de sincronização inicial." >> "$LOG_FILE"
fi

sync_hosts() {
    if ! diff -q "$SYNC_FILE" "$HOSTS_FILE" > /dev/null 2>&1; then
        echo "$(date) - Alteração detectada, sincronizando..." >> "$LOG_FILE"
        
        if [[ "$SYNC_FILE" -nt "$HOSTS_FILE" ]]; then
            cp "$SYNC_FILE" "$HOSTS_FILE"
            echo "$(date) - /etc/hosts atualizado a partir de $SYNC_FILE" >> "$LOG_FILE"
        else
            cp "$HOSTS_FILE" "$SYNC_FILE"
            echo "$(date) - $SYNC_FILE atualizado a partir de /etc/hosts" >> "$LOG_FILE"
        fi
    fi
}

while true; do
    sync_hosts
    sleep 5
done
EOF

chmod +x $SCRIPT_PATH

echo "$(date) - Script de sincronização instalado em $SCRIPT_PATH" >> "$LOG_FILE"

# Criar o serviço systemd
cat << EOF > $SERVICE_PATH
[Unit]
Description=Sincronização automática do /etc/hosts via Corosync
After=network.target

[Service]
ExecStart=$SCRIPT_PATH
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Habilitar e iniciar o serviço
systemctl daemon-reload
systemctl enable hosts-sync.service
systemctl start hosts-sync.service
systemctl status hosts-sync.service
