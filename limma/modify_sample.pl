#!/usr/bin/perl
use warnings;
use strict;

if (@ARGV !=2 ) {
	print "perl $0 <in1><out>\n";
	exit 0;
}
my ($in1,$out)=@ARGV;
if($in1=~/.gz/) {open IN1,"zcat $in1|" or die $!;}  else{open IN1,$in1 or die $!;}
open OUT,'>',"$out" or die $!;
my %hash=();
while(<IN1>){
    chomp;
    if(/ID_REF/) {
        my $i=1;
        my @s=split(/\t/,$_);my$num=scalar@s;
        my $sum=$s[0];
        while($i<$num){
            my$a="Sample"."$s[$i]";
            my $b=$s[$i+1];
            $sum.="\t$a\t$b";
            $i+=2;
        }
        print OUT "$sum\n";
    }
    else{print OUT "$_\n";}

    #my @s=split(/\s+/,$_);
    #my ($sam)=(@s)[1];
    #$hash{$sam}=1;
}
close OUT;
close IN1;

#foreach my $key (sort keys %hash){
#    print "$hash{$key}\n";
#}

#foreach my $key1 (sort keys %hash){
#    foreach my $key2 (sort keys %{$hash{$key1}}){
#        print "$hash{$key}\n";
#    }
#}
