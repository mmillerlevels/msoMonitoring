#!/usr/bin/perl -w
##2018 LevelsBeyond
##Mike Miller @mmiller
#Mike's printer

package mPrint;
use strict;
use Term::ANSIColor qw(:constants);

sub statusPrinter ($$$) {
	my ($name, $status, $notes) = @_;
	print GREEN, $name . ": " . "$status\n", RESET if $status eq "PASS";
	print GREEN, $name . ": " . "$status\n", RESET if $status eq "N/A";
	print RED,   $name . ": " . "$status\n", RESET if $status eq "FAIL";
	print BLUE,  $name . ": " . "$status\n", RESET if $status eq "UNKNOWN";
}

1;
