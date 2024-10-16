#!/bin/bash

# Definir color verde
GREEN='\033[0;32m'
NC='\033[0m' # Sin color (para resetear el color)

# Nombre del servicio
SERVICE_NAME="signalingserver"

# Archivo del servicio
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

# Comprobando si el directorio /tmp/SignalingServer existe
if [ ! -d "/tmp/SignalingServer" ]; then
    echo -e "${GREEN}The directory /tmp/SignalingServer does not exist. Please ensure that it exists before running this script.${NC}"
    exit 1
fi

# Crear el archivo del servicio de systemd
echo -e "${GREEN}Creating the systemd service file at ${SERVICE_FILE}...${NC}"

sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Signaling Server Service
After=network.target

[Service]
ExecStart=/usr/bin/npm start
WorkingDirectory=/tmp/SignalingServer
Restart=always
User=pi
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOL

echo -e "${GREEN}Service file created.${NC}"

# Recargar los archivos de servicio de systemd
echo -e "${GREEN}Reloading systemd daemon...${NC}"
sudo systemctl daemon-reload

# Habilitar el servicio para que se inicie automáticamente en cada arranque
echo -e "${GREEN}Enabling the service to start on boot...${NC}"
sudo systemctl enable ${SERVICE_NAME}

# Iniciar el servicio inmediatamente
echo -e "${GREEN}Starting the service now...${NC}"
sudo systemctl start ${SERVICE_NAME}

# Verificar el estado del servicio
echo -e "${GREEN}Checking the status of the service...${NC}"
sudo systemctl status ${SERVICE_NAME}

echo -e "${GREEN}Setup complete. The Signaling Server will now start on boot.${NC}"
