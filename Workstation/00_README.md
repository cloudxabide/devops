# README

The intent of this repo, going forward, is to create modular scripts to address Areas of Concern - as opposed to having one script to do 'all the things'.  

Some scripts will be run as root, but most will be run as the non-root user to managing as their own resources.


## TODO 
* figure out how to determine what OS / Version we are running that is "universal"
 * many menthods are in the scripts currently "source /etc/*release*" vs "lsb_release -ib" vs "grep ID /etc/*release*", etc..


git add .; git commit -m "Yupdates" -a; git push
