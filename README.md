## msoMonitoring
### Getting a script together for better MSO checks

Right now the script is very barebones, however, this is being written to be future proof.  I want to be able to add any modules we'd like.  Right now I've got a 'system' module working (Kinda), and I plan on adding specific application tests.  


The current disk check is barebones and only will calculate out the root partition's space.  Need to make this easier to monitor all of the SAN mounts we use often.  



# Requirements
[DateTime.pm](https://github.com/houseabsolute/DateTime.pm)

`cpan DateTime` Or `yum install perl-DateTime` Or Compile the above

Cpan has been weird lately on Cent 6.X, so I'd use the Yum option...Haven't test on Debain/Ubuntu...Wont test on anything other than RHEL/Cent.  You can do what'd you'd like however.
