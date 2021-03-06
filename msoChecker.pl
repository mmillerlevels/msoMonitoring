#!/usr/bin/perl -w
#2018 LevelsBeyond
#Mike Miller @mmiller

use strict;
use Term::ANSIColor qw(:constants);
use Getopt::Long;
use DateTime;
use elasticChecker;
use properProps;
use mPrint;
use bckMeUp;

use constant EXIT_GOOD => 0;
use constant EXIT_BAD => 1;
our $DEBUG = '';
GetOptions('debug' => \$DEBUG);

my $path_to_file = 'options.csv';
open my $handle, '<', $path_to_file;
chomp(my @lines = <$handle>);
close $handle;

foreach my $line (@lines) {
	my ($group,$name,$func,$param1,$param2,$param3) = split("\,", $line);
	if ($group eq "system") {
		if (!$param2) { ($param2,$param3) = '0'; }
		if (!$param3) { $param3 = '0'; }
		&system_check($name,$func,$param1,$param2,$param3);
		print MAGENTA . $group . " " . $name . " " . $func . " " . $param1 . " " . $param2 . " " . $param3 . RESET . "\n" if $DEBUG;
	}
	elsif ($group eq "backups") {
		#Backups logic - Just putting this here so I 'member to put this in
		bckMeUp::backupsChecker($name,$func,$param1,$param2,$param3);
	}
	elsif ($group eq "elastic") {
		#Elastictastic
		#elasticChecker->elasticGeneral;
		#print MAGENTA . "~Elastic coming soon~" . RESET . "\n";
	}
	elsif ($group eq "nomongo") {
		properProps->noMoMongo;
		properProps->vantageHost;
	}
	elsif ($group eq "license") {
	print my $licenseCheck = `sh licenseChecker.sh` . "\n";
	}
	else {
		print MAGENTA . "Looks like you're trying a module I haven't built yet!\n" . RESET;
		print MAGENTA . "...Or you should do a git pull to update.\n" . RESET;
		print MAGENTA . "This isn't available: " . $group . "\n" . RESET;
	}
}

#Subroutines Below

sub system_check ($$$$$) {
	my ($name,$function,$param1,$param2,$param3) = @_;
	my $status = "UNKNOWN";
	my $notes = "";

	if ( $function eq "CpuWarn" ) {
		my $cpu_thresh;
		my $num_cpus = `grep -c processor /proc/cpuinfo`;
		print GREEN . "grep -c processor /proc/cpuinfo" . RESET . "\n" if $DEBUG;
		chomp($num_cpus);
		if ( $param1 ) {
			$cpu_thresh = $param1;
		}
		else {
			$cpu_thresh = $num_cpus -1;
		}
		my $load = `/bin/cat /proc/loadavg | /usr/bin/awk '{print \$2}'`;
		print GREEN . "/bin/cat /proc/loadavg | /usr/bin/awk '{print \$2}" . RESET . "\n" if $DEBUG;
		chomp($load);

		$status = "FAIL" if $load >= $cpu_thresh;
		$status = "PASS" if $load < $cpu_thresh;
		$notes = "Load average for the last 5 minutes is " . $load . ", the threshold is " . $cpu_thresh;
	}
	elsif ( $function eq "driveErrors" ) {
		my $drive_errors = `/usr/bin/tail -n 10000 /var/log/messages | /bin/egrep -i -e '$param1' | /usr/bin/wc -l`;
		print GREEN . "/usr/bin/tail -n 10000 /var/log/messages | /bin/egrep -i -e '" . $param1 . "' | /usr/bin/wc -l" . RESET . "\n" if $DEBUG;
		chomp($drive_errors);

		$status = "PASS" if $drive_errors == 0;
		$status = "FAIL" if $drive_errors > 0;
		$notes = "Found " . $drive_errors . " lines matching '" . $param1 . "' in /var/log/messages";
	}
	elsif ( $function eq "DiskSpace" ) {
		my $df = `/bin/df -h / | /bin/grep -A1 dev | grep \/\$ | /usr/bin/awk '{print \$1","\$2","\$3}'`;
		$df =~ s/(\n\n\n|G)//go;
		if ($df =~ m/\/dev\/sd/){
			$df = `/bin/df -h / | /bin/grep -A1 dev | grep \/\$ | /usr/bin/awk '{print \$2","\$3","\$4}'`;
			$df =~ s/(\n\n|G)//go;
		}
		print GREEN . "/bin/df -h / | /bin/grep -A1 dev | grep \/$ | /usr/bin/awk '{print \$2","\$3","\$4}'" . RESET . "\n" if $DEBUG;
		my ($drive_size,$drive_used,$drive_avail) = split(/,/, $df);
		$status = "PASS" if (($drive_used/$drive_size) * 100) < $param1;
		$status = "FAIL" if (($drive_used/$drive_size) * 100) >= $param1;
		$notes = "Drive usage is " . int(($drive_used/$drive_size) * 100) . "%, the threshold is " . $param1 . "%";
		print GREEN, $notes . "\n" if $DEBUG;
	}
	elsif ( $function eq "memUsage" ) {
		my ($used, $free, $total) = '0';
		if ($param1 eq "mem") {
			$used = `free | awk '/^Mem:/ {print \$3}'`;
			$free = `free | awk '/^Mem:/ {print \$4}'`;
			$total = $used + $free;
		}
		else {
			$used = `free | awk '/^Swap:/ {print \$3}'`;
			$free = `free | awk '/^Swap:/ {print \$4}'`;
			$total = $used + $free;
		}
		if (defined($total)) {
			if ($total > 0) {
				my $percent_used = $used / $total * 100;
				$status = $percent_used < $param2 ? "PASS" : "FAIL";
				$notes = uc($param1) . " utilization is currently at " . int( $percent_used ) . "%, the threshold is " . $param2 . "%";
				print GREEN, $status . " " . $notes . "\n" if $DEBUG;
			}
		}
		else {
			$status = "FAIL";
			$notes = "¡Bad math!";
		}
	}
	my $group = 'system';
	mPrint::statusPrinter($name,$status,$notes);
}
