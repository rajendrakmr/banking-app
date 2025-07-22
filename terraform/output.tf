output "public_ip" {
  value = aws_instance.my_intance[*].public_ip
}