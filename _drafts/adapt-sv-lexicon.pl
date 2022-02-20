#!/usr/bin/perl
# Processes the openslr lexicon: https://www.openslr.org/resources/29/lexicon-sv.tgz
# Simple filter: reads stdin, writes stdout
# - Removes stress marks and lowercases the word
# - Skips kaldi tokens (<UNK>, !SIL)
# - Repairs some broken entries (missing/incorrect number of tabs)

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

while(<>) {
    chomp;
    my @pieces = split/\t/;
    my $word;
    my $pron;
    if($#pieces == 1) {
        $word = $pieces[0];
        $pron = $pieces[1];
    } elsif($#pieces == 0) {
        my @tmp = split/ /;
        $word = shift @tmp;
        $pron = join(" ", @tmp);
    } elsif($#pieces == 2) {
        if($pieces[1] eq '') {
            $word = $pieces[0];
            $pron = $pieces[2];
        } else {
            $word = $pieces[0] . $pieces[1];
            $pron = $pieces[2];
        }
    }
    if($word eq '!SIL' || $word eq '<UNK>' || $word eq '&') {
        next;
    }
    $word = lc($word);
    $pron =~ s/["%]//g;

    print "$word\t$pron\n";
}