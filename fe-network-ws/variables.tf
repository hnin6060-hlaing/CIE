variable "aws-region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc-cidr" {
  type    = string
  default = "10.7.0.0/16"
}
variable "availability-zone-a" {
  type    = string
  default = "ap-northeast-1a"
}

variable "public-subnet1-cidr" {
  type    = string
  default = "10.7.1.0/24"
}
variable "public-subnet2-cidr" {
  type    = string
  default = "10.7.2.0/24"
}
variable "public-subnet3-cidr" {
  type    = string
  default = "10.7.3.0/24"
}

variable "private-subnet1-cidr" {
  type    = string
  default = "10.7.253.0/24"
}
variable "private-subnet2-cidr" {
  type    = string
  default = "10.7.254.0/24"
}
variable "private-subnet3-cidr" {
  type    = string
  default = "10.7.255.0/24"
}

