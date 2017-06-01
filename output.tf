output "nginx_webserver_public_dns" {
  value = "[ ${aws_instance.nginx_webserver.public_dns} ]"
}
