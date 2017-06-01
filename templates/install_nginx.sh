
#!/bin/bash

# NOTE: In Ubuntu 14.04, by default, Nginx automatically starts when it is installed.
sudo apt-get update --assume-yes

# install NGINX
 sudo apt-get install nginx --assume-yes

# make sure NGINX is started when server is rebooted
sudo update-rc.d nginx defaults
