# Install minishift

```
sudo dnf install libvirt qemu-kvm
sudo groupadd -g 1001 docker 

sudo usermod -aG libvirt jradtke
sudo usermod -aG docker jradtke

newgrp libvirt
for SERVICE in virtlogd libvirtd 
do 
  sudo systemctl enable $SERVICE  --now
done

# Install the docker machine driver (for) KVM
#sudo curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-Linux-x86_64 -o /usr/local/bin/docker-machine-driver-kvm
curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-centos7 -o docker-machine-driver-kvm
sudo mv docker-machine-driver-kvm /usr/local/bin/docker-machine-driver-kvm
sudo chmod +x /usr/local/bin/docker-machine-driver-kvm

#sudo chmod +x /usr/local/bin/docker-machine-driver-kvm

# Pull down and extract the minishift binary (check for new version)
#  https://github.com/minishift/minishift/releases
wget -qO- https://github.com/minishift/minishift/releases/download/v1.34.0/minishift-1.34.0-linux-amd64.tgz | tar --extract --gzip --verbose -C ~/bin/

# Add the minishit directory to your PATH
# I'll figure out how to automate this later
# ~/bin/minishift-1.34.0-linux-amd64/

# or.. add "minishift-latest" to your PATH after running the following:
ln -s `ls ~/bin/ | grep minishift-1 | tail -1` ~/bin/minishift-latest

```

```
minishift profile set minishift-large
minishift config set memory 8GB
minishift config set cpus 2
minishift config set disk-size 40GB 
minishift config set vm-driver kvm
minishift config set static-ip false 
#minishift config set public-hostname minishift.evil.corp
#minishift config set network-ipaddress 192.168.122.99
#minishift config set network-netmask 255.255.255.0
#minishift config set network-gateway 192.168.122.1

minishift start --profile minishift-large \
  --show-libmachine-logs -v5

minishift delete --force --clear-cache
```

