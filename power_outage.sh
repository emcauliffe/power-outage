#!/bin/bash
# power_outage.sh <email1,email2,...> <timeformat>

email=${1//,/ }
if [[ $2 == "24h" ]]; then
    dateformat="%a %b %-d %R"
elif [[ $2 == "12h" ]]; then
    dateformat="%a %b %-d %r"
fi

uptime=$(uptime -s)
logtime=$(date -r ./power-outage/power_outage.log)

parsedUptime=$( expr $(date --date="$uptime" "+%s") / 60 )
parsedLogtime=$( expr $(date --date="$logtime" "+%s") / 60 )

if [[ "$parsedLogtime" -lt "$parsedUptime" ]]; then
    message="Power was out for $(expr $parsedUptime - $parsedLogtime) minute(s).\nPower off at: $(date --date="$logtime" "+$dateformat")\nPower on at: $(date --date="$uptime" "+$dateformat")\n"
    printf "$message" | mail -s "Power Outage Detected" $email
    touch ./power-outage/power_outage.log
else
    touch ./power-outage/power_outage.log
fi
