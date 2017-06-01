provider "aws" {
  region = "${var.region}"
}


resource "aws_instance" "nginx_webserver" {
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.sg_nginx.name}"]
  ami = "${lookup(var.amis, var.region)}"
  availability_zone = "${var.availability_zone}"
  key_name = "${aws_key_pair.terraformkeypair.key_name}"

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

  # Copies the custom index.html file
  provisioner "file" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.nginx_webserver.public_ip}"
      timeout = "1m"
      agent = false
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
    }
    source      = "nginx/index.html"
    destination = "/home/ubuntu/index.nginx-debian.html"
  }

  # move the index.html to the NGINX root directory
  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.nginx_webserver.public_ip}"
      timeout = "1m"
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
      agent = false
    }
    inline = [
      "sudo mv /home/ubuntu/index.nginx-debian.html /var/www/html/index.nginx-debian.html"

    ]
  }

}
