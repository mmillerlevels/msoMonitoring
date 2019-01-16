#!/usr/bin/perl -w
##2018 LevelsBeyond
##Mike Miller @mmiller

package properProps;
use strict;
use Tie::File;

our $DEBUG;
*DEBUG = \$main::DEBUG;

our $props = 'myProps.prop';

sub noMoMongo {
	my $fileName   = 'myProps.prop';
	my $searchStr  = 'mongo.enabled=true';
	my $replaceStr = 'mongo.enabled=false';

	tie my @fcont, "Tie::File", $fileName;

	for (@fcont) {
    		s/\Q$searchStr/$replaceStr/;
	}

	my %exp = map { $_ => 1 } @fcont;
	if(!exists($exp{$replaceStr})) {
		push @fcont, $replaceStr if $count != '1';
	}
	print "Confirmed Mogno is no 'mo!\n" if $DEBUG;
}

sub vantageHost {
	my $line = `grep \'\^vantage.host\=\' $props |  sed \'s\/\^vantage.hostn=\/\/\'`;
	if ($line =~ /\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\b/) {
		print "You need a host name for your Vantage property!\n";
	}
	else {
            print "Your vantage.host prop looks good\n" if $DEBUG;
	}
}

1;
