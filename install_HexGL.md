# Install and run HexGL (using Apache)

I have 2 different approaches listed below (Using Apache or python:SimpleHTTPServer - the python method is what the author intended).

Additionally - regardless of the method, I put my "web content" in a "web directory" and apply the SELinux contexts, mostly because that seems like a good practice.  (You may have to mess around with file system permissions)

Finally - at this time, the version published in the git repo only works on Mozilla Firefox.

## Basic Provisioning from AWS Console
-- Create an EC2 instance

-- Login (ssh) to the EC2 and run

### Build Using Apache
```
sudo su -
yum -y install git httpd
cd /var/www/; mv html html.bak
git clone git://github.com/BKcore/HexGL.git
ln -s HexGL html
restorecon -RFvv /var/www/html
systemctl start httpd; systemctl enable $_
```

### Build using Python SimpleHTTPServer
```
sudo su -
yum -y install git
mkdir -p /var/www/html; cd $_
git clone git://github.com/BKcore/HexGL.git
cd HexGl
restorecon -RFvv /var/www/html
python -m SimpleHTTPServer (OSX - $ python -m http.server 8000)
```

## Test status
-- See if the system is listening on port 80 (which also will display 8000)
```
netstat -anp | grep 80
curl localhost:80
curl localhost:8000
yum -y install tcpdump
tcpdump port not 22
```

## NOTES:
The reference webpage suggests using python SimpleHTTPServer - which should work fine, other than it starts on port 8000.  If you are running this from a container, I recommend still going that route.
