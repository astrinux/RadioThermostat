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
source	~/therm/config.sh									#
	r_time=$(echo `date "+%H:%M"` | awk -F: '{ print ($1 * 60) + $2}')			#
	wireless=`curl --silent http://$router/ | grep setWirelessTable`			#
	clients=`echo -e $wireless | grep -Eq "$c1|$c2"	&& echo "1" || echo "0"`		#
	client1=`echo -e $wireless | grep -Eq $c1 	&& echo "1" || echo "0"`		#
	client2=`echo -e $wireless | grep -Eq $c2 	&& echo "1" || echo "0"`		#
	client3=`echo -e $wireless | grep -Eq $c3 	&& echo "1" || echo "0"`		#
#
if 	[ -f $c_filename ]; then					#
	p_clients=`tail -n 1 $c_filename | cut -f1 -d,`			#
	p_client1=`tail -n 1 $c_filename | cut -f2 -d,`			#
	p_client2=`tail -n 1 $c_filename | cut -f3 -d,`			#
	echo $clients,$client1,$client2 > $c_filename			#
else	touch $c_filename						#
        echo $clients,$client1,$client2 > $c_filename			#
	p_clients=$clients						#
	p_client1=$client1						#
	p_client2=$client2; fi						#
#
if	[ "$p_clients" -ne "$clients" ]; then	exec "therm/quary.sh" && exit							#
elif	[[ ( "$p_client1" -ne "$client1" ) && ( "$p_clients" -eq "$clients" ) ]]; then	exec "therm/quary.sh"			#
elif	[[ ( "$p_client2" -ne "$client2" ) && ( "$p_clients" -eq "$clients" ) ]]; then	exec "therm/quary.sh"; fi		#
#
#
###########################################################################################
### Debug
#echo "clients "$clients
#echo "client1 "$client1
#echo "client2 "$client2
#echo "p_clients "$p_clients
#echo "P_client1 "$p_client1
#echo "P_client2 "$p_client2
#
