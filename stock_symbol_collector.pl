#!/usr/bin/perl -w
use strict;

my @files = glob "*companylist.csv";
my $outfile = "processed.csv";

if(-e $outfile){
	system("rm -f $outfile");
	system("touch $outfile");
}else{
	system("touch $outfile");
}

 if(-d "stocks"){
	 system("rm -rf stocks");
 }


open (OUTPUT, ">>", $outfile) or die "couldn't open $outfile: $!\n";
print OUTPUT "Exchange,Symbol,Date,Open,High,Low,Close,Volume,Adj Close\n";

foreach my $file(@files){
	my $exchange = $file;
	$exchange =~ s/\-companylist\.csv//;
	system("mkdir -p stocks/$exchange");
	

	open (CSV, "<", $file) or die "couldn't open $file: $!\n";
	my @lines = <CSV>;
	close(CSV);
	
	foreach my $line(@lines){
		chomp($line);
		my @row = split ',', $line;
		my $symbol = $row[0];
		if($symbol =~ /\s+$/){
			print "$symbol had spaces\n";
			$symbol =~ s/\s+//g;
		}
		if($symbol =~ /\//){
			$symbol =~ s/\///g;
		}
		unless(-e "stocks/$exchange/$symbol.csv"){
			system("wget -O stocks/$exchange/$symbol.csv http://ichart.finance.yahoo.com/table.csv?s=$symbol");
			my $symfile = "stocks/$exchange/$symbol.csv";
			open(SYM, "<", $symfile) or die "couldn't open $symfile: $!\n";
			my @tickdata = <SYM>;
			close(SYM);
			foreach my $tick(@tickdata){
				unless($tick =~ /Date,Open,High,Low,Close,Volume,Adj Close/){
					$tick =~ s/^/$exchange,$symbol,/;
					print OUTPUT $tick;
				}
			}
		}
	}
}
		
close(OUTPUT);		
	
