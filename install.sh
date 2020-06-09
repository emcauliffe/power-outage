#!/bin/bash
dir=$(pwd)
chmod -R 700 .

email=""
while [[ $REPLY != "n" ]] && [[ $REPLY != "N" ]]; do
    read -p "Enter email address to send notifications to: " newEmail
    read -p "Would you like to add another email (y/N)? "
    if [[ -z $email ]]; then
        email="$newEmail"
    else
        email="$email,$newEmail"
    fi
done

timeresponse="null"
echo "Please select 24h/12h"
echo 
echo "[1] 24h"
echo "[2] 12h"
echo
while [[ $timeresponse != "1" ]] && [[ $timeresponse != "2" ]]; do
    read -p ": " timeresponse
done

timeformat=""
if [[ $timeresponse == "1" ]]; then
    timeformat="24h"
elif [[ $timeresponse == "2" ]]; then
    timeformat="12h"
fi

(crontab -l 2>/dev/null; echo "* * * * * $dir/power_outage.sh $email $timeformat") | crontab -