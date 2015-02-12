# RadioThermostat
Raadio Thermostat CT80 control 

#TGandPO on twitter

WORK IN PROGRESS> 

Unzip to home directory

cd therm/
mkdir temp
mkdir log

edit config.sh "set local var"

chmod 755 test.sh
./test.sh
chmod 755 runtime.sh
./runtime.sh
chmod 755 client.sh
./client.sh
chmod 755 quary.sh
./quary.sh
chmod 755 logroll.sh
./logroll.sh


set crontab as follows

* * * * * /home/"user"/therm/client.sh #Search for Phone # runs client.sh every minuet
0,15,30,45 * * * * /home/"user"/therm/quary.sh # runs quary.sh every 15 minuets
59 23 * * * /home/"user"/therm/logroll.sh >/dev/null 2>&1 # runs once a day
5 0 * * * /home/"user"/therm/runtime.sh >/dev/null 2>&1 #Thermostat daily runtime 









TEST
