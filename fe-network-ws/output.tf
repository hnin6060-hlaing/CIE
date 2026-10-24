output "aws-region" {
  value = var.aws-region
}

output "vpc-id" {
  value = aws_vpc.hc-frontend-vpc.id
}

output "fe-public-subnet-01" {
  value = aws_subnet.public-subnet1.*
}
output "fe-private-subnet-01" {
  value = aws_subnet.private-subnet1.*
}
output "fe-private-subnet-02" {
  value = aws_subnet.private-subnet2.*
}
output "fe-private-subnet-03" {
  value = aws_subnet.private-subnet3.*
}