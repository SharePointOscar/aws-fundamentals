provider "aws" {
  region = "${var.region}"
}

resource "aws_eip" "default" {
  instance = "${aws_instance.nginx_webserver.id}"
  vpc      = true
}
resource "aws_instance" "nginx_webserver" {

  instance_type = "${var.instance_type}"
  ami = "${lookup(var.amis, var.region)}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.sg_nginx.id}"]
  key_name = "${aws_key_pair.terraformkeypair.key_name}"

  # the main VPC
  subnet_id = "${aws_subnet.main-public-1.id}"

  tags {
    "Name" = "${var.nginx_name} - ${aws_security_group.sg_nginx.id}",
    "Server Role" = "Web-Front End",
    "Tier" = "Presentation Layer",
    "Location" = "AWS Cloud",
    "Environment" = "Production"
  }

  # Add the NGINX install script
  provisioner "file" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.nginx_webserver.public_ip}"
      timeout = "5m"
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
      agent = false
    }
    source = "templates/install_nginx.sh"
    destination = "/home/ubuntu/install_nginx.sh"
  }

  # execute the install script
  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.nginx_webserver.public_ip}"
      timeout = "5m"
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
      agent = false
    }
    inline = [
      "chmod +x /home/ubuntu/install_nginx.sh",
      "/home/ubuntu/install_nginx.sh"
    ]
  }

  # Copy the static website directory to NGINX directory
  provisioner "file" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.nginx_webserver.public_ip}"
      timeout = "5m"
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
      agent = false
    }
    source      = "nginx/_site"
    destination = "/home/ubuntu"
  }

  # Copy the SSH Key to allow SSH
  provisioner "file" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.nginx_webserver.public_ip}"
      timeout = "5m"
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
      agent = false
    }
    source      = "/Users/sharepointoscar/.ssh/terraform.pub"
    destination = "/home/ubuntu/.ssh/terraform.pub"
  }

  # move the site directory to the NGINX root directory
  # add ssh key to authorized_keys
  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.nginx_webserver.public_ip}"
      timeout = "5m"
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
      agent = false
    }
    inline = [
      "sudo mv -v /home/ubuntu/_site/* /var/www/html/",
      "cat /home/ubuntu/.ssh/terraform.pub  >> /home/ubuntu/.ssh/authorized_keys"
    ]
  }


}
