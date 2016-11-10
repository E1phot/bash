#!/bin/bash

##usb-stick in [df -h]

usb=`df -h | grep media | awk '{print $1}'`

##install livecd-tools
#CentOs5
if [ `uname -a | grep el5 | wc -l` -gt 0 ];
    then
echo "Вы пытаетесь установить livecd-tools на CentOS 5. Для правильно работы нужна CentOS 6"
#CentOs6
if [ `uname -a | grep el6 | wc -l` -gt 0 ];
    then
yum install livecd-tools -y --nogpg

##umount flash-drive

umount $usb

##write to flash-drive

livecd-iso-to-disk --reset-mbr --format /shared/install/livecd-ks-centos-6-nb.iso $usb

fi
fi
