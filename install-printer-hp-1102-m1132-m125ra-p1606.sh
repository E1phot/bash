#! /bin/bash

#install usb printer Hewlett-packard without GUI
#script fot install P1102 | M1132mfp | MFP 125ra | P1606dn
#USB Vendor ID 03f0:002a — P1102 | 03f0:042a — M1132mfp | 03f0:222a — MFP 125ra | 03f0:0a2a — P1606dn
#vendor="002a\|042a\|222a\|0a2a"
model="p1102[^w^s]\|1132\|1606\|125ra"
model_list=("03f0:002a|1102" "03f0:042a|m1132" "03f0:222a|m125ra" "03f0:0a2a|p1606dn")
vendor=`lsusb | grep 'Hewlett-Packard' | awk '{print $6}'`
url="hp:/usb"
dev_url=`lpinfo -v | grep "${url}" | awk '{print $2}'`

#get model
for modeliter in ${model_list[*]}
do
if [[ `echo $modeliter | grep $vendor` != "" ]];
then devid=`echo $modeliter | grep $vendor | cut -d '|' -f 2`
fi
done
#get ppd file
drv=`lpinfo -m | grep "${model}" | awk '{print $1}' | grep "${devid}"`

echo "Переустановка Hplip"
#
hplipver=`grep version /etc/hp/hplip.conf | awk -F"=" '{ print $2}'`
new_mfu=`lsusb | grep Hewlett-Packard | awk {'print $6'}`
if [ "${new_mfu}" = "03f0:222a" ]
    then
yum remove hplip\* -y
yum remove openprinting-ppds-postscript-kyocera.noarch -y
yum install hplip.x86_64 hplip-common.x86_64 hplip-libs.x86_64 -y --nogpgcheck
if [ `hostname | grep server | wc -l` -eq 0 ];
    then
if [ `uname -a | grep el6 | wc -l` -gt 0 ];
    then
yum install hplip* -y --nogpg
    else 
if [ `uname -a | grep el5 | wc -l` -gt 0 ];
    then
yum install hplip* -y --nogpg
fi
fi
cd /root
wget http://0.0.0.1/hplip/hplip-$hplipver-plugin.run
sh hplip-$hplipver-plugin.run --keep --noexec --target /root/hplip-plugin
cd /root/hplip-plugin
yes | . /root/hplip-plugin/hplip-plugin-install -i
rm -f  /root/hplip-$hplipver-plugin.run
rm -rf /root/hplip-plugin/
fi
fi

echo

echo
if [ `hostname | grep server | wc -l` -eq 0 ];
then
#CentOs5
if [ `uname -a | grep el5 | wc -l` -gt 0 ];
then
lpadmin -x printer
lpadmin -h localhost -p printer -E -v "${dev_url}"
lpadmin -h localhost -d printer
lpadmin -h localhost -p printer -o printer-error-policy=abort-job
lpadmin -h localhost -p printer -m "${drv}"
else
#CentOs6
if [ `uname -a | grep el6 | wc -l` -gt 0 ];
then
lpadmin -x printer
lpadmin -h localhost -p printer -E -v "${dev_url}"
lpadmin -h localhost -d printer
lpadmin -h localhost -p printer -o printer-error-policy=abort-job
lpadmin -h localhost -p printer -m "${drv}"
echo
fi
fi
fi
break
echo "Вы установили принтер. Проверьте печать."
