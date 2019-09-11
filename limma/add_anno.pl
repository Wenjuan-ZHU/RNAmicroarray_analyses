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
    my ($chr,$gene)=(@s)[0,5];
    my $key="$chr";
#    if(/PCDH/) {$hash{$key}=$gene;}
    $hash{$key}=$gene;
}
chomp(my $header=<IN2>);$header=~s/"//g;
my @s=split(/\,/,$header);shift@s;my$str=join"\t",@s;
print OUT "Sample_ID\t$str\n";
while(<IN2>){
    chomp;
    my @s=split(/\,/,$_);
    my $temp=(@s)[0];    
    next unless($temp);
#    if(/Sample_/) {shift@s;my$str=join"\t",@s;print OUT "$temp\t\t$str\n";next;}    
#    next if(/^!/);
    my $id=(split(/\"/,$temp))[1];
    my $key="$id";
    if($hash{$key}) {shift@s;my$str=join"\t",@s;print OUT "$id\t$hash{$key}\t$str\n";}

#    if($hash{$key}) {next;}
#        print OUT "$_\n";
    
}
close IN2;
close OUT;
close IN1;   
