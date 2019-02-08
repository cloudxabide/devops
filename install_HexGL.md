# Install and run HexGL (using Apache)


## Basic Provisioning from AWS Console
-- Create an EC2 instance

-- Login (ssh) to the EC2 and run

```
sudo su -
yum -y install git httpd
cd /var/www/; mv html html.bak
git clone git://github.com/BKcore/HexGL.git
ln -s HexGL html
restorecon -RFvv /var/www/html
systemctl start httpd
```

-- Test status
```
netstat -anp | grep 80
curl localhost:80
yum -y install tcpdump
tcpdump port not 22
```

## NOTES:
The reference webpage suggests using python SimpleHTTPServer - which should work fine, other than it starts on port 8000.  If you are running this from a container, I recommend still going that route.
