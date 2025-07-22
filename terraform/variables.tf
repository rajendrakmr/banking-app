variable "aws_ami_id" {
  default = "ami-03fd334507439f4d1"
  description = "Aws instance AMI ID"
}

variable "aws_volume_size" {
  default = 28
  description = "AWS gp3 volume size of instance"
}

variable "aws_key_name" {
  default = "terraform-auto-key"
  description = "AWS key pair name"
}
variable "aws_region" {
  default = "eu-west-1"
  description = "Default region where all intance should create"
}

variable "aws_sg_name" {
  default = "Terrform-bank-sg"
  description = "This is the aws security group name"
}

variable "aws_instance_type" {
  default = "t2.medium"
  description = "This is type of instance aws"
}