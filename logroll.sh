#!/bin/bash
# ,__         __,
#  \)`\_..._/`(/
#  .'  _   _  '.
# /    o\ /o   \
# |    .-.-.    |
# |   /() ()\   |
#  \  '^---^'  /
#   '-..___..-`
#     TG&PO®
# #TGandPO twitter
source	~/therm/config.sh
#
if	[ -f therm/log/fourthday.csv ]; then echo "File Exists" >> /dev/null 2>&1						#
else	touch therm/log/fourthday.csv; fi											#
#
if	[ -f therm/log/thirdday.csv ]; then echo "File Exists" >> /dev/null 2>&1						#
else	touch therm/log/thirdday.csv; fi											#
#
if	[ -f therm/log/yesterday.csv ]; then echo "File Exists" >> /dev/null 2>&1						#
else	touch therm/log/yesterday.csv; fi											#
#
cat ~/therm/log/fourthday.csv >> ~/therm/log/history.csv
cp ~/therm/log/thirdday.csv ~/therm/log/fourthday.csv
cp ~/therm/log/yesterday.csv ~/therm/log/thirdday.csv
cp ~/therm/log/templog.csv ~/therm/log/yesterday.csv
rm -f ~/therm/log/templog.csv
# rm -f $web/templog.csv
rm -f ~/therm/temp/runtimecurrent.csv	
