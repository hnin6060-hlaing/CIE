# Step 1 — Download the step CLI package
➜ wget https://dl.smallstep.com/gh-release/cli/docs-cli-install/v0.25.0/step-cli_0.25.0_amd64.deb
 
# Step 2 — Install it
➜ sudo dpkg -i step-cli_0.25.0_amd64.deb
 
# Step 3 — Verify the install
➜ step version

# Step 4 - Create Root CA
➜ step certificate create mycloud-ca root-ca.crt root-ca.key --profile root-ca --subtle \
   --no-password --kty RSA --insecure --not-after="87600h"

➜ ls -la
-rw-------@  1 nin  staff  1086 Sep 23 13:58 root-ca.crt
-rw-------@  1 nin  staff  1675 Sep 23 13:58 root-ca.key

# Verify
➜ openssl x509 --text --noout --in root-ca.crt

# Step 5 - Create leaf certificate signed by Root CA
➜ step certificate create dashboard.cloud.io dashboard.crt dashboard.key --profile leaf --subtle \
   --no-password --kty RSA --insecure --not-after="8760h" --ca root-ca.crt --ca-key root-ca.key

➜ ls -la
-rw-------@  1 nin  staff  1131 Sep 23 14:04 dashboard.crt
-rw-------@  1 nin  staff  1675 Sep 23 14:04 dashboard.key
-rw-------@  1 nin  staff  1086 Sep 23 13:58 root-ca.crt
-rw-------@  1 nin  staff  1675 Sep 23 13:58 root-ca.key

# Verify
➜ openssl x509 --text --noout --in dashboard.crt

# Step 6 - Verify certificate signature with Root CA
➜ openssl verify -CAfile root-ca.crt dashboard.crt

# Step 7 - Import to ACM
certificate body => dashboard.crt
certificate private key => dashboard.key
certificate chain => root-ca.crt

# Step 8 - Add certificate to client.
#### If client is browser
security -> certificate -> import certificate

# Step 9 - Create leaf certificate signed by Root CA
### If client is VM
➜ step certificate create counting.cloud.io counting.crt counting.key --profile leaf --subtle \
   --no-password --kty RSA --insecure --not-after="8760h" --ca root-ca.crt --ca-key root-ca.key

# Step 10 - Import to ACM
certificate body => counting.crt
certificate private key => counting.key
certificate chain => root-ca.crt

# Step 11 - Add certificate in VM
$ sudo tee /etc/pki/ca-trust/source/anchors/private-ca.pem > /dev/null <<'CACERT'
   > -----BEGIN CERTIFICATE-----
   > root-ca.crt content
   > -----END CERTIFICATE-----
   > CACERT

$ sudo update-ca-trust extract
$ sudo systemctl restart dashboard.service