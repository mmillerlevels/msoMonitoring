#!/bin/sh

#Get date within license
licenseDate=$(grep '^Expiration' license.lic | sed 's/^Expiration=//')
licenseDateUnix=$(date -d $licenseDate +%s)
todayDate=$(date +%s)

if [ $todayDate -ge $licenseDateUnix ];
then
	echo Fail
	echo 'Your ReachEngine license has expired! Please reach out to support@Customer.com!' | mail -s "License Alert" -r "reachengine@customerName.com" mmiller@levelsbeyond.com
fi
