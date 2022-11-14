#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $prev = '';

while(<>) {
    chomp;
    my @p = split/_/;
    #my $fh;
    if ($prev eq '' || $prev ne $p[0])  {
        my $file = "outdir/" . $p[0] . ".txt";
        if ($prev ne '') {
            close FH;
        }
        open(FH, ">", $file);
        $prev = $p[0];
    }
    print FH "$_\n";
}