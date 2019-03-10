#!/bin/bash
#Checks Outside and Inside temps and writes them to a CSV file
#This is for development and use at your own risk. 
#   ,__         __,
#    \)`\_..._/`(/
#    .'  _   _  '.
#   /    o\ /o   \
#   |    .-.-.    |
#   |   /() ()\   |
#    \  '^---^'  /
#     '-..___..-`
#
#        TG&PO®
# #TGandPO twitter
##################
source	~/therm/config.sh											#
### file maintance
if	[ -f $filename ]; then echo "File Exists" >> /dev/null 2>&1						#
else	touch $filename												#
	echo "Time,Outside,Inside,Target,Run" > $filename							#
#	ln $filename $web/templog.csv;
	fi									#
###
if	[ -f $t_filename ]; then echo "File Exists" >> /dev/null 2>&1						#
else	touch $t_filename; fi											#
###
if	[ -f $EMAILMESSAGE ]; then echo "File Exists" >> /dev/null 2>&1						#
else	touch $EMAILMESSAGE; fi											#
### 					#######	Get data strings from themostat ########
	THERMY=$(curl --silent -m 6 http://$thermostat/tstat | sed -e 's/[{}]/''/g; s/,/\\n/g')			#
	DATALOG=`curl --silent -m 6 http://$thermostat/tstat/datalog`						#
###					#######	Get Outside temp ########
	o_temp=`curl --silent -m 5 "http://$wunderground=$location#conditions" | sed -n '/&deg;F/{p;q;}' | sed -e 's/.*<b>//' -e 's/<.*//' | sed 's/\.[^ ]*/ /g'`						#
	if [ -z "$o_temp" ]; then o_temp=`tail -n 1 $filename | cut -f2 -d,`; fi				#
### 					#######	define verables ########
### ECHO Mobile Devices presence 0 or 1
	clients=`tail -n 1 $c_filename | cut -f1 -d,`								#
### ECHO Specific Mobil Device 0 or 1 
	client1=`tail -n 1 $c_filename | cut -f2 -d,`								#
### ECHO Specific Mobil Device 0 or 1
	client2=`tail -n 1 $c_filename | cut -f3 -d,`								#
### ECHO Current "Date" time in minuets
	r_time=$(echo `date "+%H:%M"` | awk -F: '{ print ($1 * 60) + $2}')					#
### ECHO Thermostat Mode " Heat '1' or Cool '2' "
	tmode=`echo -e $THERMY | grep tmode | cut -f2 -d:`; if [ -z "$THERMY" ]; then tmode="0"; fi		#
### ECHO override; Schedule interuped either set manualy or scripted override
	override=`echo -e $THERMY | grep override | cut -f2 -d:`; if [ -z "$THERMY" ]; then override="0"; fi	#
### ECHO hold; as Set on Thermostate 0 or 1 
	hold=`echo -e $THERMY | grep hold | cut -f2 -d:`; if [ -z "$THERMY" ]; then hold="0"; fi		#	
### ECHO Inside Temp from Thermostat
	i_temp=`echo -e $THERMY | grep temp | cut -f2 -d: | sed 's/\s*$//g'`; if [ -z "$THERMY" ]; then i_temp=`tail -n 1 $filename | cut -f3 -d,`; fi			#
### ECHO Inside Temp from Thermostat
	i_temp2=`echo -e $i_temp | sed 's/\.[^ ]*/ /g' | sed 's/\s*$//g'`					#
### ECHO Target Temp from Termostate
	target=`echo -e $THERMY | grep -E '(t_cool|t_heat)' | cut -f2 -d: | sed 's/\.[^ ]*/ /g' | sed 's/\s*$//g'`; if [ -z "$THERMY" ]; then target=`tail -n 1 $filename | cut -f4 -d,`; fi	#
### ECHO Fan "On or OFF" 0 or 1
	fstate=`echo -e $THERMY | grep fstate | cut -f2 -d:`; if [ -z "$THERMY" ]; then fstate="0"; fi		#
### Today cooling "curent daily total" runtime
	c_cool=`echo -e $DATALOG | sed -e 's/,"yesterday":.*//' | sed -e 's/.*"cool_runtime"://' | sed -e 's/.*hour"://' | sed -e 's/,"minute"//' -e 's/}.*//' | awk -F: '{ print ($1 * 60) + $2}'`	#
	if [ -z "$DATALOG" ]; then c_cool=`tail -n 1 $t_filename | cut -f4 -d,`; fi				#
### Today heat "curent daily total" runtime
	c_heat=`echo -e $DATALOG | sed -e 's/},".*//' -e 's/.*r"://' | sed -e 's/,"minute"//' | awk -F: '{ print ($1 * 60) + $2}'`; if [ -z "$DATALOG" ]; then c_heat=`tail -n 1 $t_filename | cut -f2 -d,`;fi #
### Previous quarter hour total runtime for cooling
	p_cool=`tail -n 1 $t_filename | cut -f4 -d,`; if [ -z "$p_cool" ]; then	p_cool="0"; fi			#
### Previous quarter hour total runtime for heating
	p_heat=`tail -n 1 $t_filename | cut -f2 -d,`; if [ -z "$p_heat" ]; then	p_heat="0"; fi			#
### This quarter hour runtime for cooling
	q_cool=$(($c_cool - $p_cool))										#
### This quarter Hour runtime for heating
	q_heat=$(($c_heat - $p_heat))										#
### ECHO Previos Window condition "open '1' or closed '0'" 
	windows=`tail -n 1 $t_filename | cut -f6 -d,`; if [ -z "$windows" ]; then windows="0"; fi		#
### ECHO Scheduled temp values
### Cool
	c_skd1=`tail -n 1 $s_filename | cut -f1 -d,`								#
	c_skd2=`tail -n 1 $s_filename | cut -f3 -d,`								#
	c_skd3=`tail -n 1 $s_filename | cut -f5 -d,`								#
	c_skd4=`tail -n 1 $s_filename | cut -f7 -d,`								#
	c_tmp1=`tail -n 1 $s_filename | cut -f2 -d,`								#
	c_tmp2=`tail -n 1 $s_filename | cut -f4 -d,`								#
	c_tmp3=`tail -n 1 $s_filename | cut -f6 -d,`								#
	c_tmp4=`tail -n 1 $s_filename | cut -f8 -d,`								#
	yc_tmp=`tail -n 1 $s_filename | cut -f9 -d,`								#
### Heat
	h_skd1=`head -n 1 $s_filename | cut -f1 -d,`								#	
	h_skd2=`head -n 1 $s_filename | cut -f3 -d,`								#
	h_skd3=`head -n 1 $s_filename | cut -f5 -d,`								#
	h_skd4=`head -n 1 $s_filename | cut -f7 -d,`								#
	h_tmp1=`head -n 1 $s_filename | cut -f2 -d,`								#
	h_tmp2=`head -n 1 $s_filename | cut -f4 -d,`								#
	h_tmp3=`head -n 1 $s_filename | cut -f6 -d,`								#
	h_tmp4=`head -n 1 $s_filename | cut -f8 -d,`								#
	yh_tmp=`head -n 1 $s_filename | cut -f9 -d,`								#
### asigning $sked verable by time 
if	[[ ( "$r_time" -lt "$c_skd1" ) ]]; then	c_skd="$yc_tmp"							#
elif	[[ ( "$r_time" -ge "$c_skd1" ) && ( "$r_time" -lt "$c_skd2" ) ]]; then	c_skd="$c_tmp1"			#
elif	[[ ( "$r_time" -ge "$c_skd2" ) && ( "$r_time" -lt "$c_skd3" ) ]]; then	c_skd="$c_tmp2"			#
elif	[[ ( "$r_time" -ge "$c_skd3" ) && ( "$r_time" -lt "$c_skd4" ) ]]; then	c_skd="$c_tmp3"			#
elif	[[ ( "$r_time" -ge "$c_skd4" ) ]]; then	c_skd="$c_tmp4"; fi						#
if	[[ ( "$r_time" -lt "$h_skd1" ) ]]; then	h_skd="$yh_tmp"							#
elif	[[ ( "$r_time" -ge "$h_skd1" ) && ( "$r_time" -lt "$h_skd2" ) ]]; then	h_skd="$h_tmp1"			#
elif	[[ ( "$r_time" -ge "$h_skd2" ) && ( "$r_time" -lt "$h_skd3" ) ]]; then	h_skd="$h_tmp2"			#
elif	[[ ( "$r_time" -ge "$h_skd3" ) && ( "$r_time" -lt "$h_skd4" ) ]]; then	h_skd="$h_tmp3"			#
elif	[[ ( "$r_time" -ge "$h_skd4" ) ]]; then	h_skd="$h_tmp4"; fi						#
###
	med_temp=$(((($c_skd - $h_skd) / 2) + $h_skd))
### ECHO notice: change window status
if	[[ ( "$o_temp" -lt "$c_skd" ) && ( "$i_temp2" -gt "$med_temp" ) && ( "$clients" -eq "1" ) && ( "$windows" -eq "0" ) ]]; then windows="1"								#
	msg="1" && printf "Please open windows. Outside temp "$o_temp", target " >> $EMAILMESSAGE; fi														#
if	[[ ( "$o_temp" -gt "$c_skd" ) || ( "$i_temp2" -lt "$med_temp" ) && ( "$clients" -eq "1" ) && ( "$windows" -eq "1" ) ]]; then windows="0"								#
	msg="1" && printf "Please close windows. Outside temp "$o_temp", target " >> $EMAILMESSAGE; fi														#
### Set Mode
if	[[ ( "$tmode" -eq "1" ) && ( "$i_temp2" -ge "$c_skd" ) && ( "$windows" -eq "0" ) ]]; then tmode="2" && `curl --silent -d '{"tmode":2}' http://$thermostat/tstat` >> /dev/null 2>&1			#
elif	[[ ( "$tmode" -eq "2" ) && ( "$i_temp2" -le "$h_skd" ) ]]; then tmode="1" && `curl --silent -d '{"tmode":1}' http://$thermostat/tstat` >> /dev/null 2>&1; fi						#
### echo $var set by tmode; $sked, $runtime, $quater, $away 
if	[ "$tmode" = "1" ]; then sked="$h_skd"									#
	runtime="$c_heat"											#
	quarter="$q_heat"											#
	away="$h_away"												#
elif	[ "$tmode" = "2" ]; then sked="$c_skd"									#
	runtime="$c_cool"											#
	quarter="$q_cool"											#
	away="$c_away"; fi											#
### 					#######	temp Control ########	
if	[[ ( "$clients" -eq "0" ) && ( "$hold" -eq "0" ) ]]; then target="$away" && printf "See you soon. Target set to " >> $EMAILMESSAGE									#
	hold="1"												#
	msg="1"													#
	run="1"; fi												#
### 
if	[[ ( "$clients" -eq "1" ) && ( "$hold" -eq "1" ) && ( "$fstate" -eq "0" ) ]]; then target="$sked" && printf "Welcome home. Target set to " >> $EMAILMESSAGE 						#
	hold="0"												#
	override="0"												#
	msg="1"													#
	run="1"													#
elif	[[ ( "$clients" -eq "1" ) && ( "$hold" -eq "1" ) && ( "$fstate" -eq "1" ) && ( "$windows" -eq "0" ) ]]; then echo "0,$client1,$client2" > $c_filename && exit; fi					#
###
#if	[[ ( "$tmode" -eq "2" ) && ( "$client1" -eq "1" ) && ( "$hold" -eq "0" ) && ( "$target" -gt "$c_spec" ) ]]; then target="$c_spec"									#
#	run="1"; fi												#
###
#if	[[ ( "$client1" -eq "0" ) && ( "$client2" -eq "1" ) && ( "$override" -eq "1" ) && ( "$windows" -eq "0" ) ]]; then target="$sked" && printf "Returning to schedule. Target set to " >> $EMAILMESSAGE 	#
#	msg="1"													#
#	override="0"												#
#	run="1"; fi												#
### Follow sked while away. 
if	[[ ( "$target" -ne "$away" ) && ( "$target" -ne "$sked" ) && ( "$hold" -eq "1" ) ]]; then target="$sked" && printf "Following skedule as instructed. Target set to " >> $EMAILMESSAGE 			#
	msg="1"													#
	run="1"; fi												#
### if nul set $run and $msg to zero
if	[ -z "$run" ]; then run="0"; fi										#
if	[ -z "$msg" ]; then msg="0"; fi	
if	[ "$tmode" -eq "1" ]; then set_mode="t_heat"; else set_mode="t_cool"; fi  				#
###				#######	output data to file #######
	echo `date "+%R"`","$o_temp","$i_temp","$target","$quarter >> $filename					#
	echo $r_time,$c_heat,$q_heat,$c_cool,$q_cool,$windows >> $t_filename					#
###
#run="0"				#######	Send changes to thermostat #######
if	[ $run = "1" ]; then `curl --silent -d '{"'$set_mode'":'$target',"hold":'$hold',"override":'$override'}' http://$thermostat/tstat` >> /dev/null 2>&1; fi						#
###				#######	Send an email using /bin/mail ######
#if	[ $msg = "1" ]; then printf $target". Inside temp "$i_temp". Run time today "$runtime" minutes." >> $EMAILMESSAGE && /bin/mail -s "$SUBJECT" "$TO" -- -r "$FROM" < $EMAILMESSAGE			#
#	echo `cat $EMAILMESSAGE` 
#	cat /dev/null > $EMAILMESSAGE; fi									#
#
#############################################################################################################################################################################################################
#echo "filename	 = "$filename
#echo "o_temp	 = "$o_temp
#echo "clients	 = "$clients
#echo "client1	 = "$client1
#echo "client2	 = "$client2 
#echo "tmode	 = "$tmode
#echo "override = "$override
#echo "hold	 = "$hold
#echo "i_temp	 = "$i_temp
#echo "i_temp2	 = "$i_temp2
#echo "target	 = "$target
#echo "fan	 = "$fstate
#echo "Windows	 = "$windows
#echo "p_cool	 = "$p_cool
#echo "q_cool	 = "$q_cool
#echo "c_cool	 = "$c_cool
#echo "p_heat	 = "$p_heat
#echo "q_heat	 = "$q_heat
#echo "c_heat	 = "$c_heat
#echo "MSG	 = "$msg
#echo "run	 = "$run
#echo "sked	 = "$sked
#echo "c_skd	 = "$c_skd
#echo "h_skd	 = "$h_skd
#echo "runtime	 = "$runtime
#echo "r_time	 = "$r_time
#echo "DATALOG	 = "$DATALOG
#echo "away	 = "$away
../therm/quary.sh
