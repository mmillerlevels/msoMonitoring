#!/usr/bin/perl -w
#2018 LevelsBeyond
#Mike Miller @mmiller

use strict;
use LWP::Simple;
use JSON qw( decode_json );
use Data::Dumper;

my $elasticURL = "http://127.0.0.1:9200/_cluster/health";
my $return = get($elasticURL);
	die "I can't hit ElasticSearch!\n" unless defined $return;
my $decodedReturn = decode_json($return);

#Taking a dump for debugging
print "#################################################\n";
print "Taking a dump for debugging reasons - Kek\n";
print "#################################################\n";
print Dumper $decodedReturn;
print "#################################################\n";

#Just testing soem stuff before I get some logic going
print "\n";
print $decodedReturn->{'cluster_name'}."\n";
print $decodedReturn->{'active_shards'}."\n";
