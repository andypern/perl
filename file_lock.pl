#!/usr/bin/perl -w
#7/25/2014
#Andy Pernsteiner
#MapR 
#name: file_lock.pl
#purpose: to test file locking/unlocking, and provide time delay between lock/ul
use strict;


unless (defined($ARGV[0] && $ARGV[1] && $ARGV[2])) {
	useage ();
}
my $file = $ARGV[0];
my $repeat = $ARGV[1];
my $wait_time = $ARGV[2];
my $lock_failures = 0;
my $ulock_failures = 0;
my $prelock_time;
my $postlock_time;
my $lockdiff;
my $preul_time;
my $postul_time;
my $uldiff;

for (1 ... $repeat) {
	open (FILE, $file) or die "couln't open file\n";
	$prelock_time = time;
	if (flock FILE, 2) {
		$postlock_time = time;
		$lockdiff = ($postlock_time - $prelock_time);
		print "locked $file in $lockdiff secs\n";
	} else {
		warn "couldn't lock $file $!\n";
		$lock_failures = $lock_failures +1;
		next #this is probly brokey
	}
	
	sleep $wait_time;
	$preul_time = time;
	if (flock FILE, 8) {
		$postul_time = time;
		$uldiff = ($postul_time - $preul_time);
		print "unlocked $file in $uldiff secs\n";
	} else {
		warn "couldn't unlock $file $!\n";
		$ulock_failures = $ulock_failures +1
	}
	close (FILE);
	print "closed $file\n";
}

if ($lock_failures > 0 || $ulock_failures > 0) {
	print "there were $lock_failures lock failes and $ulock_failures unlock fails\n";
}


sub useage {
	print "\nformat is:\n\n";
	print "$0 [filename] [repeatcount] [wait_time]\n";
	print "all options required, repeatcount is number of times file will be\n";
	print "locked/unlocked, wait_time is delay between lock/unlock, 0 = no wait\n\n";
	exit;
}

