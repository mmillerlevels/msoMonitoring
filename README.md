## msoMonitoring
### Getting a script together for better MSO checks

I need to update this (Don't believe everything you see on the internet!)...And get a new list of requirements for the script.  I need to package this nicely so no internet boxes can still run without qualm.  


The current disk check is barebones and only will calculate out the root partition's space.  Need to make this easier to monitor all of the SAN mounts we use often.  

```
/msoMonitoring
├── msoChecker.pl
│   ├── elasticChecker.pm
│   ├── properProps.pm
│   └── licenseChecker.sh
└── options.csv
```


# Requirements
[DateTime.pm](https://github.com/houseabsolute/DateTime.pm)

`cpan DateTime` Or `yum install perl-DateTime` Or Compile the above

Cpan has been weird lately on Cent 6.X, so I'd use the Yum option...Haven't test on Debain/Ubuntu...Wont test on anything other than RHEL/Cent.  You can do what'd you'd like however.


This requirements section really needs to be updated, at some point.  My intention is to make this as portable as possible for Cent/RHEL/AWS.
