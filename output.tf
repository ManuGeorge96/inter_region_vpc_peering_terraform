output "WEB-Server-Private-IP" {
  value = aws_instance.APP.private_ip
}
output "WEB-Server-Public-IP" {
  value = aws_instance.APP.public_ip
}
output "SSH-Server-Public-IP" {
  value = aws_instance.SSH.public_ip
}
output "SSH-Server-Private-IP" {
  value = aws_instance.SSH.private_ip
}
output "DB-Server-Private-IP" {
  value = aws_instance.DB.private_ip
}
