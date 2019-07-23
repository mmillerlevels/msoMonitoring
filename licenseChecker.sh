#!/bin/sh

#2019 LevelsBeyond
#Mike Miller @mmiller

#Get date within license, convert to epoch, get one week out
licenseDate=$(grep '^Expiration' /reachengine/tomcat/lib/license.lic | sed 's/^Expiration=//')
licenseDateUnix=$(date -d $licenseDate +%s)
myDate=$(date -d "+7 days" +%s)

#Is the license going to be expiring within a week?
if [ $myDate -ge $licenseDateUnix ];
then
	#Comment out the folliwng echo if using as a cron
	#you only want the mailing piece.
	#These are for the msoCheck
	echo Your license is about to expire soon, please Reach out for continued uptime!
	#Need to tailor the following line to the particular customer's email conf (Postfix?)
	#echo 'Your ReachEngine license has expired! Please reach out to support@Customer.com!' | mail -s "License Alert" -r "reachengine@customerName.com" mmiller@levelsbeyond.com
else
	#Comment out below if using as a cron
	echo Your license is good!
fi
