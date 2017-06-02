resource "aws_security_group" "sg_nginx" {
  vpc_id = "${aws_vpc.main.id}"
  name = "sg_${var.nginx_name}"
  description = "Controls traffic for SSH, HTTP and RDP"

  # Allow incoming SSH connections
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # Allow incoming HTTP requests
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  #
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}
