#!/usr/bin/perl -w
#7/25/2014
#Andy Pernsteiner
#name: file_lock_fcntl.pl
# this just performs fcntl locks..nothing fancy
use strict;
use Fcntl;


my $file = $ARGV[0];
my $results;
fcntl($file, F_GETFL, $results) or die "can't fcntl F_GETFL: $!\n";
print "results are: $results\n";

