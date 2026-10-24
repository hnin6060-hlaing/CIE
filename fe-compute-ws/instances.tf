resource "aws_instance" "fe-public-instance-01" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = data.terraform_remote_state.vpc.outputs["fe-public-subnet-01"][0].id
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs["fe-public-sgp-01"][0].id]
  key_name               = aws_key_pair.fe_key_pair.key_name
  associate_public_ip_address = true

  tags = {
    Name = "fe-public-instance-01"
  }
}

resource "aws_instance" "fe-private-instance-01" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = data.terraform_remote_state.vpc.outputs["fe-private-subnet-01"][0].id
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs["fe-private-sgp-01"][0].id]
  key_name               = aws_key_pair.fe_key_pair.key_name

  tags = {
    Name = "fe-private-instance-01"
  }
}
resource "aws_instance" "fe-private-instance-02" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = data.terraform_remote_state.vpc.outputs["fe-private-subnet-02"][0].id
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs["fe-private-sgp-02"][0].id]
  key_name               = aws_key_pair.fe_key_pair.key_name

  tags = {
    Name = "fe-private-instance-02"
  }
}

resource "aws_instance" "fe-private-instance-03" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = data.terraform_remote_state.vpc.outputs["fe-private-subnet-03"][0].id
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs["fe-private-sgp-03"][0].id]
  key_name               = aws_key_pair.fe_key_pair.key_name

  tags = {
    Name = "fe-private-instance-03"
  }
}