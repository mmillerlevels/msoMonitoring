#!/usr/bin/perl
use strict;
use warnings;
use Term::ANSIColor qw(:constants);

use constant EXIT_GOOD => 2;
use constant EXIT_BAD => 1;
my $DEBUG = 1;


my $path_to_file = 'myTSV.tsv'; #This to be cheanged to a csv
open my $handle, '<', $path_to_file;
chomp(my @lines = <$handle>);
close $handle;

foreach my $line (@lines) {
	my ($group,$name,$func,$param1,$param2,$param3) = split("\t", $line); #Change me to support csv brah
	if ($group eq "system") {
		if (!$param2) { $param2 = '0'};
		if (!$param3) { $param3 = '0'};
		&system_check($name,$func,$param1,$param2,$param3);
		print MAGENTA . $group . " " . $name . " " . $func . " " . $param1 . " " . $param2 . " " . $param3 . RESET . "\n" if $DEBUG;
	}
	else {
		print "Looks like you're trying a module I haven't built yet!\n";
		print "...Or you should do a git pull to update.\n";
		exit (EXIT_BAD);
	}
}

##############################################################

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
		#Need to fix his up, calculaton is a bit off...
		my ($drive,$drive_size,$drive_used) = split(/,/, $df);
		print GREEN . "/bin/df -h / | /bin/grep -A1 dev | grep \/$ | /usr/bin/awk '{print \$1","\$2","\$3}'" . RESET . "\n" if $DEBUG;
		$status = "PASS" if (($drive_used/$drive_size) * 100) < $param1;
		$status = "FAIL" if (($drive_used/$drive_size) * 100) >= $param1;
		$notes = "Drive usage is " . int(($drive_used/$drive_size) * 100) . "%, the threshold is " . $param1 . "%";
	}
	#Coming soon
	#elsif ( $function eq "interfaceErrors" ) {
	#	($status, $notes) = interfaceErrors($param1);
	#}

	elsif ( $function eq "memUsage" ) {
		my %regexs = (
			mem  => qr/cache:\s+(?<used>\d+)\s+(?<free>\d+)/s,
			swap => qr/Swap:\s+\d+\s+(?<used>\d+)\s+(?<free>\d+)/s,
		);

		`/usr/bin/free -b` =~ m/$regexs{ $param1 }/s;
		print GREEN . "/usr/bin/free -b" . RESET . "\n" if $DEBUG;

		my $used = `free - | awk '/^Mem:/ {print \$3}'`;
		my $free = `free  | awk '/^Mem:/ {print \$4}'`;
		my $total = $used + $free;

		if (defined($total)) {
			if ($total > 0) {
				my $percent_used = $used / $total * 100;
				$status = $percent_used < $param2 ? "PASS" : "FAIL";
				$notes = uc($param1) . " utilization is currently at " . int( $percent_used ) . "%, the threshold is " . $param2 . "%";
			}
		}
		else {
			$status = "FAIL";
			$notes = "divide by zero prevented.";
		}
	}
	my $group = 'system';
	#&PrintStatus($group,$name,$status,$notes);
	print $group . " " . $name . " " . $status . " " . $notes . "\n";;
}

#Will be making the output nicer
#print GREEN, $name . ": " . "$status\n", RESET if $status eq "PASS";
#print GREEN, $name . ": " . "$status\n", RESET if $status eq "N/A";
#print RED,   $name . ": " . "$status\n", RESET if $status eq "FAIL";
#print BLUE,  $name . ": " . "$status\n", RESET if $status eq "UNKNOWN";
