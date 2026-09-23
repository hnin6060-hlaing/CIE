#!/bin/bash
# download binary 
curl -LO https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip

# unzip 
unzip counting-service_linux_amd64.zip

#remove zip file and rename
rm -rf counting-service_linux_amd64.zip
sudo mv counting-service_linux_amd64 /usr/local/bin/counting-service

#execute permission
chmod +x /usr/local/bin/counting-service

# create user and change permisssion
sudo useradd counting-admin
sudo chown counting-admin:counting-admin /usr/local/bin/counting-service

# Create the service file exactly as you wrote it
sudo tee /etc/systemd/system/counting.service << 'EOF'
[Unit]
Description=HashiCorp demo counting-service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=counting-admin
Group=counting-admin
Environment=PORT=9000
ExecStart=/usr/local/bin/counting-service
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

# Enable it so it boots on every instance startup automatically
sudo systemctl daemon-reload
sudo systemctl enable counting.service
sudo systemctl start counting.service