variable "region" {
  description = "The AWS region to create resources in."
  default = "us-west-2"
}

variable "availability_zone" {
  description = "The availability zone"
  default = "us-west-2c"
}

variable "nginx_name" {
  description = "The name of the webserver server."
  default = "webserver"
}
variable "amis" {
  description = "The Ubuntu AMI to spawn. Ubuntu 16.04 LTS Xenial -hvm:ebs-ssd"
  default = {
    us-west-2= "ami-efd0428f"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "/Users/sharepointoscar/.ssh/terraform.pem"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "/Users/sharepointoscar/.ssh/terraform.pub"
}
variable "key_name" {
  default = "terraform"
  description = "SSH key name in your AWS account for AWS instances."
}
resource "aws_key_pair" "terraformkeypair" {
  key_name = "terraform"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
  lifecycle {
    ignore_changes = ["public_key"]
  }
}
