#!/usr/bin/perl -w
##2018 LevelsBeyond
##Mike Miller @mmiller

package properProps;
use strict;
use Tie::File;

our $DEBUG;
*DEBUG = \$main::DEBUG;

sub noMoMongo {
	my $fileName   = 'myProps.prop';
	my $searchStr  = 'mongo.enabled=true';
	my $replaceStr = 'mongo.enabled=false';

	tie my @fcont, "Tie::File", $fileName;

	my $count;
	for (@fcont) {
    		$count++ if s/\Q$searchStr/$replaceStr/;
	}

	push @fcont, $replaceStr if ! $count;
	print "Confirmed Mogno is no 'mo!\n" if $DEBUG;
}
1;
