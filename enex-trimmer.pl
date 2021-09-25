#!/usr/bin/perl

my $printing = 1;
while(<>) {
	if($printing == 1) {
		print $_;
		if(/<content>/ || /<data/) {
			$printing = 0;
		}
	} else {
		if(m!</content>! || m!</data!) {
			print $_;
			$printing = 1;
		}
	}
}