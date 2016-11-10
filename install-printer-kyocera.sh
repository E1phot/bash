#!/bin/bash
if [ ! `yum info nmap | grep installed` ];
 then 
    yum install nmap -y
fi
scannet="192.168.5.110-125"
port="161,9100"
ip_printers=`nmap -oG - -PN -sU -sT -p ${port} ${scannet} | grep 9100/open.*/tcp | grep 161/open.*/udp | cut -f2 -d" "`

PS3='Выберите принтер: '

echo

select printer in $ip_printers
do
  echo
  echo "Вы устанавливаете $printer."
  if [ `hostname | grep server | wc -l` -eq 0 ];
      then
#CentOs5
if [ `uname -a | grep el5 | wc -l` -gt 0 ];
    then
	    
  lpadmin -h localhost -p printer -E -v socket://$printer:9100
  lpadmin -p printer -d printer
  lpadmin -p printer -o printer-error-policy=abort-job
  lpadmin -p printer -m foomatic:Generic-PCL_6_PCL_XL_Printer-hpijs.ppd
else
#CentOs6
if [ `uname -a | grep el6 | wc -l` -gt 0 ];
    then
  lpadmin -h localhost -p printer -E -v socket://$printer:9100
  lpadmin -h localhost -d printer
  lpadmin -h localhost -p printer -o printer-error-policy=abort-job
  lpadmin -h localhost -p printer -m 'gutenprint.5.2://pcl-g_6_l/simple Generic PCL 6/PCL XL LF Printer - CUPS+Gutenprint v5.2.5 Simplified'
  echo
fi
fi
fi
  break
done
echo "Вы установили принтер. Проверьте печать."

#foomatic:Generic-PCL_6_PCL_XL_Printer-hpijs.ppd Generic PCL 6/PCL XL Printer Foomatic/hpijs  --centos5
