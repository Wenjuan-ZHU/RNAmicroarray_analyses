#!/usr/bin/perl
use warnings;
use strict;
#tongji
if (@ARGV !=3 ) {
	print "perl $0 <in1><in2><outdir>\n";
	exit 0;
}
my ($in1,$in2,$out)=@ARGV;
if($in1=~/.gz/) {open IN1,"zcat $in1|" or die $!;}  else{open IN1,$in1 or die $!;}
if($in2=~/.gz/) {open IN2,"zcat $in2|" or die $!;}  else{open IN2,$in2 or die $!;}

open OUT,'>',"$out" or die $!;
my %hash=();
while(<IN1>){
    chomp;
    my @s=split(/\t/,$_);
    next unless(/PCDHA/);
    my ($chr,$freq)=(@s)[0,5];
    next if($freq<=0);
    my $key="$chr";
    $hash{$key}=$freq;
}
while(<IN2>){
    chomp;
    if(/probeset/){print OUT "Freq\t$_\n";next;}
    my @s=split(/\t/,$_);
    my ($chr,$pos)=(@s)[0,1];
    my $key="$chr";
    if($hash{$key}) {
        print OUT "$hash{$key}\t$_\n";
    }    
}
close IN2;
close OUT;
close IN1;   
