#!/usr/bin/perl -w
#3/2/2006
#Andy Pernsteiner
#Isilon Systems
#name: file_lock_fcntl.pl
#purpose: to test file locking/unlocking, and provide time delay between lock/ul
use strict;
use Fcntl;


my $file = $ARGV[0];
my $results;
fcntl($file, F_GETFL, $results) or die "can't fcntl F_GETFL: $!\n";
print "results are: $results\n";

