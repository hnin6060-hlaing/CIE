#############################################################
# Create EC2(jump-host)
#############################################################
resource "aws_instance" "jump-host" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.dashboard-public-subnet1.id
  vpc_security_group_ids = [aws_security_group.jump-host-sg.id]
  key_name = "jump-host-keypair"

  tags = {
    Name = "jump-host"
  }
}

resource "null_resource" "copy_keypair" {
  # This triggers the copy every time the Jump Host instance ID changes
  triggers = {
    instance_id = aws_instance.jump-host.id
  }

  # This provisioner runs a command locally on your computer
  provisioner "local-exec" {
    command = <<EOT
      # Wait a moment for SSH to become ready on the server
      sleep 15
      
      # Execute the secure copy command
      scp -o StrictHostKeyChecking=no \
          -o UserKnownHostsFile=/dev/null \
          -i "./keypairs/jump-host-keypair.pem" \
          "./keypairs/dashboard-keypair.pem" \
          ec2-user@${aws_instance.jump-host.public_ip}:~

      scp -o StrictHostKeyChecking=no \
          -o UserKnownHostsFile=/dev/null \
          -i "./keypairs/jump-host-keypair.pem" \
          "./keypairs/counting-keypair.pem" \
          ec2-user@${aws_instance.jump-host.public_ip}:~
    EOT
  }

  # Explicit dependency ensures it runs AFTER the jump host is fully created
  depends_on = [aws_instance.jump-host]
}
#############################################################
# Create EC2(counting-instance)
#############################################################
resource "aws_instance" "counting_instance1" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dashboard-private-subnet1.id
  vpc_security_group_ids = [aws_security_group.counting-instance-sg.id]
  key_name = "counting-keypair"

  user_data = templatefile("${path.module}/scripts/counting-service.sh", {
    app_port = 9000
  })
  # Explicit dependency ensures it runs AFTER the dashboard-private-rtb is fully created
  depends_on = [aws_route_table.dashboard-private-rtb]

  tags = {
    Name = "counting-instance1"
  }
}
resource "aws_instance" "counting_instance2" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dashboard-private-subnet2.id
  vpc_security_group_ids = [aws_security_group.counting-instance-sg.id]
  key_name = "counting-keypair"

  user_data = templatefile("${path.module}/scripts/counting-service.sh", {
    app_port = 9000
  })
  # Explicit dependency ensures it runs AFTER the dashboard-private-rtb is fully created
  depends_on = [aws_route_table.dashboard-private-rtb]

  tags = {
    Name = "counting-instance2"
  }
}

#############################################################
# Create EC2(dashboard-instance)
#############################################################
resource "aws_instance" "dashboard_instance1" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dashboard-private-subnet1.id
  vpc_security_group_ids = [aws_security_group.dashboard-instance-sg.id]
  key_name = "dashboard-keypair"

  user_data = templatefile("${path.module}/scripts/dashboard-service.sh", {
    app_port = 8000,
    counting_dns = aws_lb.counting-alb.dns_name
  })
  
  # Explicit dependency ensures it runs AFTER the counting-alb is fully created
  depends_on = [aws_lb.counting-alb]

  tags = {
    Name = "dashboard-instance1"
  }
}
resource "aws_instance" "dashboard_instance2" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dashboard-private-subnet2.id
  vpc_security_group_ids = [aws_security_group.dashboard-instance-sg.id]
  key_name = "dashboard-keypair"

  user_data = templatefile("${path.module}/scripts/dashboard-service.sh", {
    app_port = 8000,
    counting_dns = aws_lb.counting-alb.dns_name
  })

  # Explicit dependency ensures it runs AFTER the counting-alb is fully created
  depends_on = [aws_lb.counting-alb]

  tags = {
    Name = "dashboard-instance2"
  }
}