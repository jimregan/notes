#!/usr/bin/perl

use warnings;
use strict;
use utf8;

my $raw_replacements = <<_HERE_;
e}_ l}el	e|l}el
e}_ d}ed	e|d}ed
e}_ d}d	e|d}d
e}iy1 e}_	e|e}iy1
i}ix o|n}n	i|o}ix n}n
r}_ t|-}r t}t	r}r t|-|t}t
-|k}n n|a}ae1	-}_ k|n}n a}ae1
a|c}ax c}k	a}ax c|c}k
c}k h}_	c|h}k
c}k q|u}w	c|q}k u}w
n}n|t c}s	n}n c}t|s
i|c}ih1 k|-}k	i}ih1 c|k}k -}_
a|k}ey1 e|-}k	a}ey1 k}k e|-}_
-|k}n n|a}ae2	-}_ k|n}n a}ae2
a|t}ax e}_ -|e}t y}ay1	a}ax t}t e}_ -}_ e|y}ay1
t|u}ch r}axr	t}ch u|r}axr
e}_ d}d	e|d}d
a}ae1 e}_	a|e}ae1
a}ih e}_	a|e}ih
-|c}ao	-}_ c}k
x}eh1|k -}s	x}eh1|k|s -}_
e}_ l|l}el	e|l|l}el
w|h}hh y}w|ay1	w|h}hh|w y}ay1
a|d}ax j|o}jh u|r}er1	a}ax d|j}jh o|u|r}er1
a|d}ae2 u}jh|uw	a}ae2 d}jh u}uw
u}y|uh a|b}b	u|a}y|uh b}b
x}k -}s	x}k|s -}_
u|r}er1 r}_	u|r|r}er1
o|r}axr r}_	o|r|r}axr
u|r}axr r}_	u|r|r}axr
e|r}axr r}_	e|r|r}axr
a|r}axr r}_ h|o}iy1 e}_	a|r|r|h}axr o|e}iy1
e|r}er r}_	e|r|r}er
i|r}er1 r}_	i|r|r}er1
u}_ a}aa1	u|a}aa1
w|h}hh i}w|er1 r}_	w|h}hh|w i|r}er1
b|o}b r}r	b}b o|r}r
e}_ a|r}er1	e|a|r}er1
q|u}k a}w|ey2	q}k u}w a}ey2
q|u}k a}w|ao1	q}k u}w a}ao1
w|h}hh a}w|ax	w|h}hh|w a}ax
t|u}ch r}axr	t}ch u|r}axr
d|u}jh a}uw|ax	d}jh u}uw a}ax
c|i}sh a}iy|ey2	c}sh i}iy a}ey2
_HERE_

my %replacements = ();
for my $rl (split('\n', $raw_replacements)) {
	next if($rl !~ /\t/);
	my @tmp = split(/\t/, $rl);
	$replacements{$tmp[0]} = $tmp[1];
}
my $regex_inner = join('|', map { quotemeta $_ } keys %replacements);

while(<>) {
	chomp;
	while(/(?:^| )($regex_inner)(?:$| )/g) {
		my $m = $1;
		my $qm = quotemeta($m);
		s/$qm/$replacements{$m}/;
	}
	my @phns = split/ /;
	my @out = ();
	for my $phn (@phns) {
		if($phn =~ /^([-'])\|/) {
			my $ch = $1;
			push @out, "$ch}_";
			push @out, substr($phn,2);
		} elsif($phn =~ /^([^\|])\|([-'])\}(.*)$/) {
			my $ch1 = $1;
			my $ch2 = $2;
			my $ch3 = $3;
			push @out, "$ch1}$ch3";
			push @out, "$ch2}_";
		} elsif($phn eq 'c}ao') {
			if($phns[0] eq 'n}n') {
				push @out, 'c}s';
			} else {
				push @out, 'c}k';
			}
		} else {
			push @out, $phn;
		}
	}
	print join(' ', @out) . "\n";
}