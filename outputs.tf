output "ssh" {
    value = "ssh -i ~/keys/${var.key_pair}.pem ubuntu@${module.my-nginx.public_ip}"
}