output "nginx_webserver_public_dns" {
  value = "[ ${aws_instance.nginx_webserver.public_dns} ]"
}

output "private ip address" {
  value = "${aws_instance.nginx_webserver.private_ip}"
}

output "elastic ip" {
  value = "${aws_eip.default.public_ip}"
}
