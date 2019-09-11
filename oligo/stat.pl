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
my $total_sum=0;my$total_c=0;
while(<IN1>){
    chomp;
    my @s=split(/\t/,$_);
    my ($id,$gene)=(@s)[0,1];
    my $i=3;
    my $num=scalar@s;
    my $sum=0;
    my $d=0;
    next if(/probesetID/);
    while($i<$num){
        my ($exp)=(@s)[$i];
        if($exp ne 'NA') {$d++;$sum+=$exp;$total_c++;$total_sum+=$exp;}
        $i++;
#        if($p<0.01) {$fit++;}
#        $i+=2; $d++;
    }
    next unless($d);
    my $ave=$sum/$d;
    my $percent=$d/($num-2);
    my $total=$num-1;
    print OUT "$id\t$gene\t$total\t$d\t$percent\t$ave\n";
}
my $ave=$total_sum/$total_c;
#print "$total_sum\t$total_c\t$ave\n";
close OUT;
close IN1;
my $sd_sum=0;
if($in1=~/.gz/) {open IN1,"zcat $in1|" or die $!;}  else{open IN1,$in1 or die $!;}
while(<IN1>){
    chomp;my @s=split(/\t/,$_);my $i=3;my $num=scalar@s;next if(/probesetID/);
    while($i<$num){
        my ($exp)=(@s)[$i];
        if($exp ne 'NA') {$sd_sum+=($exp-$ave)*($exp-$ave);}
        $i++;
    }
}
my $SD=sqrt($sd_sum/$total_c);
close IN1;
my $min=$ave-0.5*$SD*2;
my $max=$ave+0.5*$SD*2;
print "$total_sum\t$total_c\t$ave\t$SD\t$min\t$max\n";
#foreach my $key (sort keys %hash){
#    print "$hash{$key}\n";
#}

#foreach my $key1 (sort keys %hash){
#    foreach my $key2 (sort keys %{$hash{$key1}}){
#        print "$hash{$key}\n";
#    }
#}
