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
    next if(/^#/);
    my ($chr,$gene)=(@s)[0,5];
#    /(\w+)/
#    if($gene=~/UG_GENE\=([A-Za-z0-9\-]+) \/DEF/) {$gene=$1;}
#    elsif($gene=~/GEN\=([A-Za-z0-9\-]+) \/FEA/)  {$gene=$1;}
#    elsif($gene=~/UG_GENE\=([A-Za-z0-9\-]+) \/UG_TITLE/)  {$gene=$1;}
#    else{;}
    my $key="$chr";
#    if(/PCDH/) {$hash{$key}=$gene;}
    $hash{$key}=$gene;
}
while(<IN2>){
    chomp;
    my @s=split(/\,/,$_);
    my $temp=(@s)[0];    
    my $id=(split(/\"/,$temp))[1];
    if(/GSM/) {shift@s;my$str=join"\t",@s;print OUT "Sample_ID\tGenename\t$str\n";next;}    
    my $key="$id";
    if($hash{$key}) {shift@s;my$str=join"\t",@s;print OUT "$id\t$hash{$key}\t$str\n";}
    else{shift@s;my$str=join"\t",@s;print OUT "$id\tnogene\t$str\n";}
}
close IN2;
close OUT;
close IN1;   
