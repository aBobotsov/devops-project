output "be_public_ip" {
  value = aws_instance.be.public_ip
}

output "fe_public_ip" {
  value = aws_instance.fe.public_ip
}
