#!/bin/bash

## Depends on iw, awk, pamixer
## Change values according system, PC_TYPE accepts "desktop" or random values for devices with battery, if your desktop is using wlan you may add "wlan $net $sig" in line 53

CORE_COUNT=4
WIFI_NAME="wlan0"
PC_TYPE="desktop"
#IDEV="enp5s0" #device to collect internet traffic from
# Battery
#bat=$(acpi -b | awk '{print $1,$3,$4,$5,$6,$7}')

# Network
#net=$(iw dev ${WIFI_NAME} link | grep SSID | awk -F ' ' '{print $2}')
#sig=$(iw dev ${WIFI_NAME} link | grep signal |awk -F ' ' '{print $2,$3}')
# Current session
#TX=$(( $(cat /sys/class/net/${IDEV}/statistics/tx_bytes) / 1000000 ))
#RX=$(( $(cat /sys/class/net/${IDEV}/statistics/rx_bytes) / 1000000 ))
# Needs vnstat
#TXT=$(($(vnstat --json --limit 1 | jq '.interfaces |.[]| select(.name=="enp4s0")|.traffic|.total|.tx') / 1000000000 ))
#RXT=$(($(vnstat --json --limit 1 | jq '.interfaces |.[]| select(.name=="enp4s0")|.traffic|.total|.rx') / 1000000000 ))

# Volume
vol=$(pamixer --get-volume)

# Memory usage in percent
MemT=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
MemA=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
ram=$(awk "BEGIN {printf \"%.f\n\", 100*(1- $MemA/$MemT)}")

# CPU load
mn01=$(awk '{print $1}' /proc/loadavg)
mn10=$(awk '{print $2}' /proc/loadavg)
mn15=$(awk '{print $3}' /proc/loadavg)

# CPU load total in percent, substitute last digit with your number of cores
mn401=$(awk "BEGIN {printf \"%.f\n\", 100*$mn01/${CORE_COUNT}}")
mn410=$(awk "BEGIN {printf \"%.f\n\", 100*$mn10/${CORE_COUNT}}")
mn415=$(awk "BEGIN {printf \"%.f\n\", 100*$mn15/${CORE_COUNT}}")

# Uptime 
upt=$(awk '{printf("%dd %02dh %02dm\n",($1/60/60/24),($1/60/60%24),($1/60%60))}' /proc/uptime)


# Brightness
#br1=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
#brm=$(cat /sys/class/backlight/intel_backlight/max_brightness)
#brp=$(awk " BEGIN { printf \"%.f\n\", $br1/$brm*100 } ")

# Print status-bar

#if [ $PC_TYPE = "desktop" ]
#	then
#		echo  "Up $upt | CPU $mn401%-$mn410%-$mn415% | RAM $ram% | Vol $vol% |  $dat | $hor:$min $tiz    "
#	else
#		echo  "Up $upt | CPU $mn401%-$mn410%-$mn415% | RAM $ram% | wlan $net $sig | Vol $vol% | Brightness $brp% | $bat| $dat | $hor:$min $tiz"
fi
echo  "Up $upt | CPU $mn401%-$mn410%-$mn415% | RAM $ram% | Vol $vol% |  $(date +"%a %d. %b %Y %H:%M")    "
