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
#
### Change to home directory
	cd ~ 						#
### Thermostat IP or hostname				
	thermostat="192.168.0.106" 			#address
### Router IP or Hostname				
	router="192.168.0.1" 				#address
### Path to Web site					
	web="/var/www/virtual/zenfaust.com/shopping"	#
### location
#	location="id=$id&APPID=$APPID&units=$units" 						
	location="id=5509952&APPID=dd139b9a9c5330487d38537bc821ddaf&units=imperial"	#
#	location="pws:KNVLASVE492"			#
#	location="klas" 				#
#	location="KNVLASVE137"				#
### last four of device MAC Addess			
	c1="B9:32" 					#
	c2="7B:A9" 					#
	c3="88:57"					#
### Away Temp Cool					
	c_away="84"					#
### Away Temp Heat					
	h_away="60"					#
### Spech Cool						
	c_spec="80"					#
### Path to even txt					
	eventfile="therm/temp/event.txt"		#
### Path to log file					
	filename="therm/log/templog.csv" 		#
### Path to Runtime Log					
	t_filename="therm/temp/runtimecurrent.csv" 	#
	t2_filename="therm/temp/runtimecurrent2.csv" 	#
### Path to sked Data					
	s_filename="therm/temp/skd.csv" 		#
### Path to acive Mobil Device clients log			
	c_filename="therm/temp/client.txt" 		#
### runtime						
	r_filename="therm/log/runtime.csv" 		#
### sent
	sent_msg_client="therm/temp/here.txt"		#
### WX URL						
	openweather="http://api.openweathermap.org/data/2.5/weather"			#
	id="5509952"
	APPID="dd139b9a9c5330487d38537bc821ddaf"
	units="imperial"
	cacert="cacert.pem"
#	wunderground="mobile.wunderground.com/cgi-bin/findweather/getForecast?query"	#
#	url="http://www.wunderground.com/personal-weather-station/dashboard?ID"				#
### 					#######	email settings #######
### Subject:						
	SUBJECT="" 					#
### Addresses:						
	TO="7025922933@vtext.com;7027161592@vtext.com" 			#
	FROM="automation@zenfaust.com" 			#
### Path to File for email 				
	EMAILMESSAGE="/tmp/emailmessage.txt" 		#
#############################################################################################################
