# 1. Generate a secure private key natively within Terraform
resource "tls_private_key" "fe_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Register the public half of the generated key with AWS
resource "aws_key_pair" "fe_key_pair" {
  key_name   = "fe-instance-key"
  public_key = tls_private_key.fe_key.public_key_openssh
}
# 3. Save the private key directly to your local machine
resource "local_sensitive_file" "fe-instance-key-pem" {
  filename        = "${path.module}/fe-instance-key.pem" # Saves it right inside your current directory
  content         = tls_private_key.fe_key.private_key_pem
  file_permission = "0400" # Automatically restricts access permissions so SSH won't reject it
}

output "private_key" {
  value     = tls_private_key.fe_key.private_key_pem
  sensitive = true
}