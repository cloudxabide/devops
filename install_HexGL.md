# Install HexGL 


## Basic Provisioning from AWS Console
-- Create an EC2 instance

-- Login (ssh) to the EC2 and run

```
yum -y install git 
mkdir -p /var/www/html ; cd $_
git clone git://github.com/BKcore/HexGL.git
cd HexGL
restorecon -RFvv /var/www/html
python -m SimpleHTTPServer &
```

-- Test status
```
netstat -anp | grep 8000
curl localhost:8000
yum -y install tcpdump
tcpdump port 8000 
