#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $prev = '';
my $counter = 0;

while(<>) {
    chomp;
    my @p = split/_/;
    if ($prev eq '' || $prev ne $p[0])  {
        my $file = "outdir/" . $p[0] . ".txt";
        if ($prev ne '') {
            close FH;
        }
        open(FH, ">", $file);
        binmode(FH, ":utf8");
        $prev = $p[0];
        $counter = 0;
    }
    my @parts = split/ /;
    shift(@parts);

    print FH $prev . "_" . $counter . " " . join(" ", @parts) . "\n";
    $counter++;
}