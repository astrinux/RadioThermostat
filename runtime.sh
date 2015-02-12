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
#########################
source	~/therm/config.sh
### File maintance
if 	[ -f $r_filename ]; then echo "File Exists" >> /dev/null 2>&1		#
else	touch $r_filename && echo "Date,Cool Time,Heat Time" >> $r_filename	#
### creates link on web server
#	ln ~/$r_filename $web/runtime.csv;
fi										#
#
if	[ -f $s_filename ]; then echo "File Exists" >> /dev/null 2>&1		#
else	touch $s_filename; fi        						#	
### Pole Runtime  Data String from Thermostat
	runtime=$(curl --silent -m 5 "http://$thermostat/tstat/datalog" | sed -e 's/.*"yesterday":{//')						#
### Yesterday cool runtime
	c_time=`echo -e $runtime | sed -e 's/.*:0},//' | sed -e 's/.*r"://' -e 's/}.*//' | sed -e 's/,"minute"//' | awk -F: '{ print ($1 * 60) + $2}'`	#
### Yesterday Heat Runtime
	h_time=`echo -e $runtime | sed -e 's/},".*//' | sed -e 's/.*r"://' -e 's/,"minute"//' | awk -F: '{ print ($1 * 60) + $2}'`			#
### Output Date, Cool Timt, Heat Time, to Log File 
	echo `date -d '1 day ago' +'%m/%d/%Y',"$c_time","$h_time"` >> $r_filename	#
###
### mv runtime.csv `date -d '1 day ago' +'%B%Y'`.cvs
### calculate cooling cost for yeasterday
	c_dollar=`echo -e $c_time |  awk -F: '{ print ($1 / 10) * .16 }'` 		#
### ECHO Cooling Cost to email file to be delivered with next realtime update
if	[ "$c_time" -gt "0" ]; then echo "Cooling cost for yesterday was $"$c_dollar > $EMAILMESSAGE; fi			#
### Pars Date "sat, sun, mon..." for sckedule look up and push changes to thermostate 
	yeasterdate=`date -d '1 day ago' +'%a' | awk '{print tolower($0)}'`						#
	todate=`date -d 'today' +'%a' | awk '{print tolower($0)}'`							#
### Pars numeracicle value for Date "mon = 0, tue = 1 ... " used in sked push to thermostat.
if 	[ $todate = "mon" ]; then date="0"; fi										#
if 	[ $todate = "tue" ]; then date="1"; fi										#
if 	[ $todate = "wed" ]; then date="2"; fi										#
if 	[ $todate = "thu" ]; then date="3"; fi										#
if 	[ $todate = "fri" ]; then date="4"; fi										#
if 	[ $todate = "sat" ]; then date="5"; fi										#
if 	[ $todate = "sun" ]; then date="6"; fi										#
### pulling skedules from thermostate
	h_yskd=`curl	--silent "http://$thermostat/tstat/program/heat/$yeasterdate" | sed -e 's/].*//' | sed -e 's/.*\[//' | cut -f8 -d,`	#
	h_skd=`curl	--silent "http://$thermostat/tstat/program/heat/$todate" | sed -e 's/].*//' | sed -e 's/.*\[//'`			#
	c_yskd=`curl	--silent "http://$thermostat/tstat/program/cool/$yeasterdate" | sed -e 's/].*//' | sed -e 's/.*\[//' | cut -f8 -d,`	#
	c_skd=`curl	--silent "http://$thermostat/tstat/program/cool/$todate" | sed -e 's/].*//' | sed -e 's/.*\[//'`			#
### get sun rise and set data from wunderground pars to day minuet value
	sun=`curl --silent -m 5 "http://$wunderground=$location#conditions"`									#
	s_rise=`echo -e "$sun" | sed -n '/Sunrise/{p;q;}' | sed -e 's/.*<b>//' -e 's/<.*//'`							#
	s_set=`echo -e "$sun"  | sed -n '/Sunset/{p;q;}' | sed -e 's/.*<b>//' -e 's/<.*//'`							#
	rise=`date --date="$s_rise" +%T | awk -F: '{ print ($1 * 60) + $2}'`									#
	set=`date --date="$s_set" +%T | awk -F: '{ print ($1 * 60) + $2}'`									#
### ECHO schedule from thermostat to file.
	echo $h_skd","$h_yskd > $s_filename													#
	echo $c_skd","$c_yskd >> $s_filename													#
### ECHO $ver values from sked file
	c_skd1=`tail -n 1 $s_filename | cut -f1 -d,`			#
	c_skd2=`tail -n 1 $s_filename | cut -f3 -d,`			#
	c_skd3=`tail -n 1 $s_filename | cut -f5 -d,`			#
	c_skd4=`tail -n 1 $s_filename | cut -f7 -d,`			#
	c_tmp1=`tail -n 1 $s_filename | cut -f2 -d,`			#
	c_tmp2=`tail -n 1 $s_filename | cut -f4 -d,`			#
	c_tmp3=`tail -n 1 $s_filename | cut -f6 -d,`			#
	c_tmp4=`tail -n 1 $s_filename | cut -f8 -d,`			#
	h_skd1=`head -n 1 $s_filename | cut -f1 -d,`			#
	h_skd2=`head -n 1 $s_filename | cut -f3 -d,`			#
	h_skd3=`head -n 1 $s_filename | cut -f5 -d,`			#
	h_skd4=`head -n 1 $s_filename | cut -f7 -d,`			#
	h_tmp1=`head -n 1 $s_filename | cut -f2 -d,`			#
	h_tmp2=`head -n 1 $s_filename | cut -f4 -d,`			#
	h_tmp3=`head -n 1 $s_filename | cut -f6 -d,`			#
	h_tmp4=`head -n 1 $s_filename | cut -f8 -d,`			#
### If nul value returned from WX lookup set $ver to $Sked 
if	[ -z "$sun" ]; then			#
	rise="$c_skd1"				#
	set="$c_skd3"; fi			#
#echo $rise,$set
#### ECHO tmode valuse for sun time 
	h_rise=$(($rise))			#
	h_day=$(($rise + 60))			#
	h_set=$(($set + 60))			#
	h_night=$(($set + 240))			#
	c_rise=$(($rise - 180))			#
	c_day=$(($rise + 60))			#
	c_set=$(($set + 60))			#
	c_night=$(($set + 120))			#
### Set new schedule on thermostate
	`curl --silent -d '{"'$date'":['$c_rise','$c_tmp1','$c_day','$c_tmp2','$c_set','$c_tmp3','$c_night','$c_tmp4']}' http://$thermostat/tstat/program/cool/$todate` >> /dev/null 2>&1			#
	`curl --silent -d '{"'$date'":['$h_rise','$h_tmp1','$h_day','$h_tmp2','$h_set','$h_tmp3','$h_night','$h_tmp4']}' http://$thermostat/tstat/program/heat/$todate` >> /dev/null 2>&1			#
#	`curl -d '{"'$date'":['$c_rise','$c_tmp1','$c_skd2','$c_tmp2','$c_set','$c_tmp3','$c_skd4','$c_tmp4']}' http://$thermostat/tstat/program/cool/$todate`			#
#	`curl -d '{"'$date'":['$h_rise','$h_tmp1','$h_skd2','$h_tmp2','$h_set','$h_tmp3','$h_skd4','$h_tmp4']}' http://$thermostat/tstat/program/heat/$todate`			#

### Echo Schedule to SKED file. 
	echo $h_rise,$h_tmp1,$h_day,$h_tmp2,$h_set,$h_tmp3,$h_night,$h_tmp4,$h_yskd > $s_filename			#
	echo $c_rise,$c_tmp1,$c_day,$c_tmp2,$c_set,$c_tmp3,$c_night,$c_tmp4,$c_yskd >> $s_filename			#
###########################################################################################################################
