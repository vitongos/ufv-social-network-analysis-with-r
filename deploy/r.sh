#!/bin/bash

cd ~/Downloads
sudo su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm'
sudo yum -y update
sudo yum -y install R
sudo su -c 'rpm -Uhv http://download1.rstudio.org/rstudio-0.97.320-x86_64.rpm'
sudo yum -y install mesa-libGL-devel mesa-libGLU-devel libpng-devel
sudo yum -y install libcurl libcurl-devel
sudo yum -y install libxml2-devel
