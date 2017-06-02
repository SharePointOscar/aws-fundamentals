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
    "Name" = "${var.nginx_name}"
  }

  # Add the NGINX install script
  provisioner "file" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.nginx_webserver.public_ip}"
      timeout = "1m"
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
      timeout = "1m"
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
      timeout = "1m"
      agent = false
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
    }
    source      = "nginx/_site"
    destination = "/home/ubuntu"
  }

  # move the site directory to the NGINX root directory
  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.nginx_webserver.public_ip}"
      timeout = "1m"
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
      agent = false
    }
    inline = [
      "sudo mv -v /home/ubuntu/_site/* /var/www/html/"
    ]
  }


}
