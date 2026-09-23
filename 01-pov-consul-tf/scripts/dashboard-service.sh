#!/bin/bash
# download binary 
curl -LO https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip

# unzip 
unzip dashboard-service_linux_amd64.zip

# remove zip file and rename
rm -rf dashboard-service_linux_amd64.zip
sudo mv dashboard-service_linux_amd64 /usr/local/bin/dashboard-service

# execute permission
chmod +x /usr/local/bin/dashboard-service

# create user and change permisssion
sudo useradd dashboard-admin
sudo chown dashboard-admin:dashboard-admin /usr/local/bin/dashboard-service

# Create the service file exactly as you wrote it
sudo tee /etc/systemd/system/dashboard.service << 'EOF'
[Unit]
Description=HashiCorp demo dashboard-service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=dashboard-admin
Group=dashboard-admin
Environment=PORT=8000
Environment=COUNTING_SERVICE_URL=http://${counting_dns}
ExecStart=/usr/local/bin/dashboard-service
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

# Enable it so it boots on every instance startup automatically
sudo systemctl daemon-reload
sudo systemctl enable dashboard.service
sudo systemctl start dashboard.service