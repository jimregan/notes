#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode STDIN, ":utf8";
binmode STDERR, ":utf8";
binmode STDOUT, ":utf8";

my %unmwe = (
"a_lán" => [["a", "a", "Det:Poss:3P:Sg:Masc"], ["lán", "lán", "Noun:Masc:Com:Sg:Len"]],
"ar_ais" => [["ar", "ar", "Prep:Simp"], ["ais", "ais", "Subst:Noun:Sg"]],
"Ar_ais" => [["Ar", "ar", "Prep:Simp"], ["ais", "ais", "Subst:Noun:Sg"]],
"Ard_Mhacha" => [["Ard", "Ard", "Prop:Noun:Masc:Com:Sg"], ["Mhacha", "Macha", "Prop:Noun:Masc:Gen:Sg:Len"]],
"ar_feadh" => [["ar", "ar", "Prep:Simp"], ["feadh", "feadh", "Noun:Masc:Com:Sg"]],
"ar_fud" => [["ar", "ar", "Prep:Simp"], ["fud", "fud", "Subst:Noun:Sg"]],
"ar_nós" => [["ar", "ar", "Prep:Simp"], ["nós", "nós", "Noun:Masc:Com:Sg"]],
"ar_son" => [["ar", "ar", "Prep:Simp"], ["son", "son", "Subst:Noun:Sg"]],
"Átha_Cliath" => [["Átha", "Átha", "Prop:Noun:Masc:Gen:Sg:Len"], ["Cliath", "Cliath", "Prop:Noun:Fem:Gen:Weak:Pl"]],
"Áth_Cliath" => [["Áth", "Átha", "Prop:Noun:Masc:Gen:Sg:Len"], ["Cliath", "Cliath", "Prop:Noun:Fem:Gen:Weak:Pl"]],
"a_thuilleadh" => [["a", "a", "Det:Poss:3P:Sg:Masc"], ["thuilleadh", "tuilleadh", "Noun:Masc:Com:Sg:Len"]],
"Béal_Feirste" => [["Béal", "Béal", "Prop:Noun:Masc:Com:Sg"], ["Feirste", "Feirste", "Prop:Noun:Masc:Gen:Sg"]],
"Bhéal_Feirste" => [["Bhéal", "Béal", "Prop:Noun:Masc:Com:Sg:Len"], ["Feirste", "Feirste", "Prop:Noun:Masc:Gen:Sg"]],
# http://www.dil.ie/32548
"cé_is_moite" => [["cé", "cé", "Conj:Subord"], ["is", "is", "Part:Sup"], ["moite", "mór", "Adj:Comp"]],
"cés_moite" => [["cés", "cés", "Conj:Subord:Part:Sup"], ["moite", "mór", "Adj:Comp"]],
"cheana_féin" => [["cheana", "cheana", "Adv:Gn"], ["féin", "féin", "Pron:Ref"]],
"Chill_Dara" => [["Chill", "Cill", "Prop:Noun:Masc:Gen:Sg:Len"], ["Dara", "Dair", "Prop:Noun:Masc:Gen:Sg"]],
"Cill_Dara" => [["Cill", "Cill", "Prop:Noun:Masc:Gen:Sg"], ["Dara", "Dair", "Prop:Noun:Masc:Gen:Sg"]],
"chun_go" => [["chun", "chun", "Prep:Simp"], ["go", "go", "Prep:Simp"]],
"Cill_Chainnigh" => [["Cill", "Cill", "Prop:Noun:Masc:Com:Sg"], ["Chainnigh", "Cainneach", "Prop:Noun:Masc:Gen:Sg:Len"]],
"de_bharr" => [["de", "de", "Prep:Simp"], ["bharr", "barr", "Noun:Masc:Com:Sg:Len"]],
"de_dheasca" => [["de", "de", "Prep:Simp"], ["dheasca", "deasca", "Noun:Masc:Com:Sg:Len"]],
"de_dheascaibh" => [["de", "de", "Prep:Simp"], ["dheasca", "deasca", "Noun:Masc:Dat:Pl:Len"]],
"de_réir" => [["de", "de", "Prep:Simp"], ["réir", "réir", "Noun:Fem:Com:Sg:Len"]],
"De_réir" => [["De", "de", "Prep:Simp"], ["réir", "réir", "Noun:Fem:Com:Sg:Len"]],
"de_thairbhe" => [["de", "de", "Prep:Simp"], ["thairbhe", "tairbhe", "Noun:Fem:Com:Sg:Len"]],
"faoi_bhun" => [["faoi", "faoi", "Prep:Simp"], ["bhun", "bun", "Noun:Masc:Com:Sg:Len"]],
"Fianna_Fáil" => [["Fianna", "Fianna", "Prop:Noun:Masc:Com:Sg"], ["Fáil", "Fáil", "Prop:Noun:Masc:Com:Sg"]],
"Fine_Gael" => [["Fine", "Fine", "Prop:Noun:Masc:Com:Sg"], ["Gael", "Gael", "Prop:Noun:Masc:Com:Sg"]],
"go_ceann" => [["go", "go", "Prep:Simp"], ["ceann", "ceann", "Noun:Masc:Com:Sg"]],
"go_dtí" => [["go", "go", "Part:Vb:Subj"], ["dtí", "tar", "Verb:VI:PresSubj:Ecl"]],
"go_leor" => [["go", "go", "Part:Ad"], ["leor", "leor", "Adj:Base"]],
"i_dtrátha" => [["i", "i", "Prep:Simp"], ["dtrátha", "tráth", "Noun:Masc:Dat:Pl:Ecl"]],
#"i_dtrátha" => [["i", "i", "Prep:Simp"], ["dtrátha", "tráth", "Noun:Masc:Dat:Sg:Ecl"]],
#"i_dtrátha" => [["i", "i", "Prep:Simp"], ["dtrátha", "tráth", "Noun:Masc:Gen:Sg:Ecl"]],
"i_gceann" => [["i", "i", "Prep:Simp"], ["gceann", "ceann", "Noun:Masc:Com:Sg:Ecl"]],
"i_gcoinne" => [["i", "i", "Prep:Simp"], ["gcoinne", "coinne", "Noun:Fem:Com:Sg:Ecl"]],
"i_gcóir" => [["i", "i", "Prep:Simp"], ["gcóir", "cóir", "Noun:Fem:Com:Sg:Ecl"]],
"i_lár" => [["i", "i", "Prep:Simp"], ["lár", "lár", "Noun:Masc:Com:Sg:Ecl"]],
"i_láthair" => [["i", "i", "Prep:Simp"], ["láthair", "láthair", "Noun:Fem:Com:Sg:Ecl"]],
"i_mbun" => [["i", "i", "Prep:Simp"], ["mbun", "bun", "Noun:Masc:Com:Sg:Ecl"]],
"in_aghaidh" => [["in", "i", "Prep:Simp:Vow"], ["aghaidh", "aghaidh", "Noun:Fem:Com:Sg"]],
"in_aice" => [["in", "i", "Prep:Simp:Vow"], ["aice", "ann", "Noun:Fem:Com:Sg"]],
"in_ann" => [["in", "i", "Prep:Simp:Vow"], ["ann", "ann", "Subst:Noun:Sg"]],
"i_ndiaidh" => [["i", "i", "Prep:Simp"], ["ndiaidh", "diaidh", "Subst:Noun:Sg:Ecl"]],
"in_éadan" => [["in", "i", "Prep:Simp:Vow"], ["éadan", "éadan", "Noun:Masc:Com:Sg"]],
"i_rith" => [["i", "i", "Prep:Simp"], ["rith", "rith", "Noun:Masc:Com:Sg:Ecl"]],
"le_cois" => [["le", "le", "Prep:Simp"], ["cois", "cos", "Noun:Fem:Dat:Sg"]],
"le_go" => [["le", "le", "Prep:Simp"], ["go", "go", "Prep:Simp"]],
"le_hais" => [["le", "le", "Prep:Simp"], ["hais", "ais", "Subst:Noun:Sg:hPref"]],
"le_linn" => [["le", "le", "Prep:Simp"], ["linn", "linn", "Noun:Fem:Com:Sg"]],
"Loch_Garman" => [["Loch", "Loch", "Prop:Noun:Masc:Gen:Sg"], ["Garman", "Garman", "Prop:Noun:Masc:Gen:Sg"]],
"Lucht_Oibre" => [["Lucht", "Lucht", "Prop:Noun:Masc:Com:Sg"], ["Oibre", "Oibre", "Prop:Noun:Masc:Com:Sg"]],
"maidir_le" => [["maidir", "maidir", "Subst:Noun:Sg"], ["le", "le", "Prep:Simp"]],
"Maidir_le" => [["Maidir", "maidir", "Subst:Noun:Sg"], ["le", "le", "Prep:Simp"]],
"Maidir_leis" => [["Maidir", "maidir", "Subst:Noun:Sg"], ["le", "le", "Prep:Simp:DefArt"]],
"maidir_lena" => [["maidir", "maidir", "Subst:Noun:Sg"], ["le", "le", "Prep:Poss:3P:Pl"]],
"Maigh_Eo" => [["Maigh", "Maigh", "Prop:Noun:Masc:Com:Sg"], ["Eo", "Eo", "Prop:Noun:Masc:Gen:Sg"]],
"nDún_na_nGall" => [["nDún", "Dún", "Prop:Noun:Masc:Com:Sg:Ecl"], ["na", "an", "Art:Pl:Def"], ["nGall", "Gall", "Prop:Noun:Masc:Gen:Weak:Pl:Ecl"]],
"ní_ba" => [["ní", "ní", "Noun:Masc:Com:Sg"], ["ba", "is", "Cop:Cond"]],
"ó_dheas" => [["ó", "ó", "Prep:Simp"], ["dheas", "deas", "Subst:Noun:Sg:Len"]],
"os_cionn" => [["os", "os", "Prep:Simp"], ["cionn", "ceann", "Noun:Masc:Dat:Sg"]],
"os_comhair" => [["os", "os", "Prep:Simp"], ["comhair", "comhair", "Subst:Noun:Sg"]],
"ó_thuaidh" => [["ó", "ó", "Prep:Simp"], ["thuaidh", "tuaidh", "Adv:Dir:Len"]],
"Phort_Láirge" => [["Phort", "Port", "Prop:Noun:Masc:Gen:Sg:Len"], ["Láirge", "Lárag", "Prop:Noun:Masc:Gen:Sg"]],
"Sinn_Féin" => [["Sinn", "Sinn", "Prop:Noun:Masc:Gen:Sg"], ["Féin", "Féin", "Prop:Noun:Masc:Gen:Sg"]],
"tar_éis" => [["tar", "tar", "Verb:VI:Imperf:2P:Sg"], ["éis", "éis", "Subst:Noun:Sg"]],
"Tar_éis" => [["Tar", "tar", "Verb:VI:Imperf:2P:Sg"], ["éis", "éis", "Subst:Noun:Sg"]],
"thar_a_bheith" => [["thar", "thar", "Prep:Simp"], ["a", "a", "Part:Inf"], ["bheith", "bheith", "Verbal:Noun:VI:Len"]],
"thar_ceann" => [["thar", "thar", "Prep:Simp"], ["ceann", "ceann", "Noun:Masc:Com:Sg"]],
"Tiobraid_Árann" => [["Tiobraid", "Tiobraid", "Prop:Noun:Masc:Gen:Sg"], ["Árann", "Ara", "Prop:Noun:Fem:Gen:Sg"]],
"Uíbh_Fháilí" => [["Uíbh", "Uíbh", "Prop:Noun:Masc:Gen:Sg"], ["Fháilí", "Fháilí", "Prop:Noun:Masc:Gen:Sg"]],
"gach_uile" => [["gach", "gach", "Det:Qty:Def"], ["uile", "uile", "Det:Qty:Idf"]],
);

while(<>) {
	chomp;
	s/\r//g;
	print "\n" if(/^$/);
	print "\n" if(/^#/);
	my @a = split/\t/;
	if($#a != 9) {
		print "\n";
		next;
	}
	my $surface = $a[1];
	my $lemma = $a[2];
	my $tags = '';
	if($a[3]) {
            if($a[4] && ($a[3] eq $a[4] || $a[4] eq '_')) {
                    $tags = "+" . $a[3];
            } else {
                    $tags = "+" . $a[3] . "+" . $a[4];
            }
        }
	if($a[5] && $a[5] ne '_') {
		$tags .= "+$a[5]";
	}
	if($tags eq '+.') {
		$tags = '+Punct+Fin';
	}
        $tags =~ s/\+//;
        $tags =~ s/\+/:/g;
        $tags =~ s/Noun:Noun/Noun/;
        if ($surface =~ /_/) {
        print STDERR "\"$surface\"\n";
            for my $word (@{$unmwe{$surface}}) {
            print STDERR "HERE!\n";
                print "_\t$$word[0]\t$$word[1]\t$$word[2]\t_\t_\t_\t_\t_\t_\n";
            }
        } else {
            print "$a[0]\t$a[1]\t$a[2]\t$tags\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t$a[8]\t$a[9]\n";
        }
}


