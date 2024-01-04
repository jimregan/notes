#!/usr/bin/perl

my $last_empty = 1;
my $repo = '';
my $desc = '';
my $url = '';

while(<>) {
	chomp;
	if(/^$/) {
		$last_empty = 1;
		if($url ne '') {
			print "[$repo]($url) --- $desc\n\n";
		}
		$repo = $desc = $url = '';
	} else {
		if($last_empty == 1) {
			$last_empty = 0;
			if(/^([^:]*): (.*)$/) {
				$repo = $1;
				$desc = $2;
			}
		} else {
			$url = $_;
		}
	}
}
