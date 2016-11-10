#!/bin/bash
wineserver stop
kill -9 `ps aux | grep "\.exe" | awk '{print $2}'`
filesize=`find /shared-from-server/Documents/public/ -type f -name "*.exe" -exec ls -la {} \; | cut -d" " -f5 | sort | uniq -c | cut -d" " -f6`
find /shared-from-server/Documents/ -type f -size ${filesize}c -a \( -name "*.exe" -o -name "*.pif" -o -name "*.scr" -o -name "*.bat" \) -exec rm -f {} \;
find /home/ -type f -size ${filesize}c -a \( -name "*.exe" -o -name "*.pif" -o -name "*.scr" -o -name "*.bat" \) -exec rm -rf {} \;
find /shared-from-server/Documents/ /home/ -type f -size 520192c -a \( -name "*.exe" -o -name "*.pif" -o -name "*.scr" -o -name "*.bat" \) -exec rm -f {} \;
for i in *.vuz *.zhp *.scr *.igt *.hiz *.xyq *.qcp *.twp *.cfh *.phy *.uwx *.rje *.eaw *.eif *.twp;
do
find /home/ -type f -name ${i} -exec rm -f {} \;
done
find /home/ -type f -name autorun.inf -exec rm -f {} \;
wineserver start
exit 0
