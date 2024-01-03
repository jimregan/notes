#!/usr/bin/perl

my $last_empty = 1;
my $desc = '';
my $url = '';

while(<>) {
	chomp;
	if(/^$/) {
		$last_empty = 1;
		print "[$desc]($url)\n\n";
		$repo = $desc = $url = '';
	} else {
		if($last_empty == 1) {
			$last_empty = 0;
			$desc = $_;
		} else {
			$url = $_;
		}
	}
}
