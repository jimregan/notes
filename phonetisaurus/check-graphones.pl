#!/usr/bin/perl

use warnings;
use strict;
use utf8;

my $vphn = qw/aa aa1 aa2 ae ae1 ae2
ah ah1 ah2 ao ao1 ao2
aw aw1 aw2 ax axr
ay ay1 ay2 eh eh1 eh2
ey ey1 ey2 ih ih1 ih2
ix iy iy1 iy2
ow ow1 ow2 oy oy1 oy2
uh uh1 uh2 uw uw1 uw2/;

my $cphn = qw/b ch d dh f g 
hh jh k l m n ng p r s
sh t th v w y z zh/;

my $vcphn = qw/el em en er er1 er2/;

my $vow = "[aeiou]";
my $cons = "[bcdfghjklmnpqrstvwxz]";

while(<>) {
	chomp;
	my @graphones = split/ /;
	for my $gp (@graphones) {
		my ($g, $p) = split/\}/, $gp;
		if(grep {/^$cons$/} $g )