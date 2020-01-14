#!/bin/sh

#2019 LevelsBeyond
#Mike Miller @mmiller

#Pipe to /dev/null when configured in a cron, outside of testing
#Get date within license, convert to epoch, get one week out
licenseDate=$(grep '^Expiration' /reachengine/tomcat/lib/license.lic | sed 's/^Expiration=//')
licenseDateUnix=$(date -d $licenseDate +%s)
myDate0=$(date -d "+0 days" +%s)
myDate7=$(date -d "+7 days" +%s)

#Is the license going to be expiring within a week?
if [ $myDate7 -ge $licenseDateUnix ];
then
	echo "Your license is about to expire soon, please Reach out for continued uptime! Please reach out to support@levelsbeyond.com!" | mail -s "License Alert - customerName" -r "reachengine@customerName.com"
elif [ $myDate0 -ge $licenseDateUnix ];
then
	echo "Oh Snap! Time to Shutdown! License is no good! :("
	echo "Shutting Down ReachEngine"
	#Comment whatever one you don't use
	/etc/init.d/reachengine stop
	/usr/bin/systemctl stop reachengine.service
	echo "Your ReachEngine license has expired! Please reach out to support@levelsbeyond.com!" | mail -s "License Alert - customerName" -r "reachengine@customerName.com"
else
	echo "Your license is good! Nothing to see here..."
fi
