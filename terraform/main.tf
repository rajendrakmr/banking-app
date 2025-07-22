resource "aws_key_pair" "aws_key" {
  key_name   = var.aws_key_name
  public_key = file("terraform-key.pub")
}

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "aws_security" {
  name        = var.aws_sg_name
  description = "Allowed the security group incomming and outgoing traffic."
  vpc_id      = aws_default_vpc.default.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow port 22"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow https port 443"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http port 80"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outgoing traffic."
  }
}
resource "aws_instance" "my_intance" {
  ami                    = var.aws_ami_id
  key_name               = aws_key_pair.aws_key.key_name
  count                  = 1
  instance_type          = var.aws_instance_type
  vpc_security_group_ids = [aws_security_group.aws_security.name]

  root_block_device {
    volume_size = var.aws_volume_size
    volume_type = "gp3"
  }

}
