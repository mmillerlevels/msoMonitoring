#!/usr/bin/perl -w
##2018 LevelsBeyond
##Mike Miller @mmiller

package bckMeUp;
use strict;
use DateTime;
use mPrint;
use Term::ANSIColor qw(:constants);


our $DEBUG;
*DEBUG = \$main::DEBUG;


sub backupsChecker ($$$$$) {
	my ($name,$function,$param1,$param2,$param3) = @_;
	my $status = "UNKNOWN";
	my $notes = "";
	my $BACKUPS_DIR = `grep \^BACKUP_DIR \/etc\/reachengine\/backup.conf | sed \'s\/\^BACKUP_DIR\=\/\/'`;
	chomp($BACKUPS_DIR);
	print MAGENTA . $name . " " . $function . " " . $param1 . " " . $param2 . " " . $param3 . RESET . "\n" if $DEBUG;
	print MAGENTA . "I'm looking in $BACKUPS_DIR for the $name\n" . RESET if $DEBUG;
	#Add some logic here for checking for the three? Dirrent bacup files
	#that we keep here
	#Will nedd to add this piece into a larger logic gate
	#If I add LVM snapshot checks and ElasticSearch backup checks.
	my $ls = `ls -lrt --time-style=long-iso $BACKUPS_DIR | tail -n 1 | grep $param2.tar.gz`;
	my @lsOut = split /\s+/, $ls;
	my $date = $lsOut[5];
	my $fileSize = $lsOut[4];
	if (@lsOut){
	#print $lsOut[4] . ' ' . $lsOut[5] . ' ' . $lsOut[6] . ' ' . $lsOut[7] if $DEBUG;
		my $days = DateTime->now->subtract(days => $param1)->strftime("%F");
		if ($date le $days or $fileSize == 0){
			$status = "FAIL";
		}
		else {
			$status = "PASS";
			$notes = "Your backsups are X Days old"; #I need to calculate this out
		}
	}
	mPrint::statusPrinter($name,$status,$notes);
}
1;
