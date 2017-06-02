# AWS Fundamentals   


![AWS](https://cloudcraft.co/view/3266719c-9c40-409b-be96-70b16f1b3e34?key=wDV9TpYXYr5SSHWg6AQq6g&embed=true)


## Overview
This solution provides an example of deploying an EC2 Ubuntu instance to a custom VPC to AWS.  It uses Terraform to deploy an entire AWS VPC to the `us-west-2` region.

### Getting Started
Fist, you will need to have the following:
* AWS account and AWS CLI installed on your machine
* Terraform

Within the root of the solution directory, execute the following to see the Terraform Plan

```shell
terraform plan
```
To deploy the entire *Infrastructure as Code* to AWS, execute the following command
```shell
terraform apply

Apply complete! Resources: 2 added, 0 changed, 1 destroyed.


The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path:

Outputs:

elastic ip = 52.33.19.212
nginx_webserver_public_dns = [ ec2-52-10-198-77.us-west-2.compute.amazonaws.com ]
private ip address = 10.0.1.163
```

The output of the last command shows you the _EIP_ Elastic IP Address (public IP Address), which you can use to access the deployed website home page.
