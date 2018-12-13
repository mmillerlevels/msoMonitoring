#!/usr/bin/perl -w
#2018 LevelsBeyond
#Mike Miller @mmiller

use Search::Elasticsearch;

my $e = Search::Elasticsearch->new();

# Cluster requests:
my $info        = $e->cluster->info;
my $health      = $e->cluster->health;
my $node_stats  = $e->cluster->node_stats;


print "\n";
print "Here is an Elastic info request\n";
print $info . "\n";
print "The Elastic health is next\n";
print $health . "\n";
print "The Elastic node status is\n";
print $node_stauts . "\n";
