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
#
### Change to home directory
	cd ~ 						#
### Thermostat IP or hostname				
	thermostat="ip address" 			#address
### Router IP or Hostname				
	router="ip address" 				#address
### Path to Web site					
#	web="/var/www/full/path.com/folder"	#
### location 						
	location="klas" 				#
### last four of device MAC Addess			
	c1="AA:BB" 					#
	c2="BB:CC" 					#
	c3="CC:EE"					#
### Away Temp Cool					
	c_away="87"					#
### Away Temp Heat					
	h_away="60"					#
### Spech Cool						
#	c_spec="80"					#
### Path to even txt					
	eventfile="therm/temp/event.txt"		#
### Path to log file					
	filename="therm/log/templog.csv" 		#
### Path to Runtime Log					
	t_filename="therm/temp/runtimecurrent.csv" 	#
### Path to sked Data					
	s_filename="therm/temp/skd.csv" 		#
### Path to acive Mobil Device clients log			
	c_filename="therm/temp/client.txt" 		#
### runtime						
	r_filename="therm/log/runtime.csv" 		#
### sent
#	sent_msg_client="therm/temp/here.txt"		#
### WX URL						
	wunderground="mobile.wunderground.com/cgi-bin/findweather/getForecast?brand=mobile&query"	#
### 					#######	email settings #######
### Subject:						
#	SUBJECT="" 					#
### Addresses:						
#	TO="you@yourdomain.com" 			#
#	FROM="thermostat@yourdomain.com" 			#
### Path to File for email 				
#	EMAILMESSAGE="/tmp/emailmessage.txt" 		#
#############################################################################################################
