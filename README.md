## msoMonitoring
### Getting a script together for better MSO checks

Right now the script is very barebones, however, this is being written to be future proof.  I want to be able to add any modules we'd like.  Right now I've got a 'system' module working (Kinda), and I plan on adding specific application tests.  


The current disk check is barebones and only will calculate out the root partition's space.  Need to make this easier to monitor all of the SAN mounts we use often.  



# Pertinent Gists

[My memChecker routine](https://gist.github.com/mmillerlevels/0e0399608e6e35c928ca23da59a0c486)

[My backups checker routine](https://gist.github.com/mmillerlevels/d7cb54a5e56dbcd9b41b5046e1c417f5)
