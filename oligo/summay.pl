#!/usr/bin/perl
use warnings;
use strict;
#tongji
if (@ARGV !=3 ) {
	print "perl $0 <p_value><expression><summay.txt>\n";
	exit 0;
}
my ($in1,$in2,$out)=@ARGV;
if($in1=~/.gz/) {open IN1,"zcat $in1|" or die $!;}  else{open IN1,$in1 or die $!;}
if($in2=~/.gz/) {open IN2,"zcat $in2|" or die $!;}  else{open IN2,$in2 or die $!;}

open OUT,'>',"$out" or die $!;
my %Pvalue=();
#while(<IN1>){
#    chomp;
#    s/"//g;
#    my @s=split(/\,/,$_);
#    my ($probesetid,$mrnaassignment,$level)=(@s)[1,11,16];
#    my $key="$probesetid";
#    $hash{$key}="$mrnaassignment\t$level";
#}
#close IN1; 
my @sam=();
while(<IN1>){
    chomp;
    s/"//g;
    my @s=split(/\,/,$_);
    my $num=scalar@s;my$i=1;
    if(/GSM/){
        while($i<$num){$sam[$i]=$s[$i];$i++;}
        next;
    }
    my ($probesetid)=(@s)[0];
    next if($probesetid eq 'NA');
    while($i<$num){
        my $p=$s[$i];
        if($p<0.01){$p='P';} else{$p='A';}
        $Pvalue{$sam[$i]}{$probesetid}=$p;
        $i++;
    }    
}
close IN1;
my @ordersam=();
while(<IN2>){
    chomp;
    s/"//g;
    my @s=split(/\t/,$_);
    my ($probesetid,$mrnaassignment,$level)=(@s)[0,1,2];
    next if($probesetid eq 'NA');
    my $num=scalar@s;my$i=3;
    if(/probesetID/){
        while($i<$num){$ordersam[$i]=$s[$i];$i++;}
        print OUT "$_\n";
        next;
    }
    my $sum="$probesetid\t$mrnaassignment\t$level";
    my ($A_num,$total)=(0,0);
    while($i<$num){
        my $value=$s[$i];
        my $bool=$Pvalue{$ordersam[$i]}{$probesetid};
        if($bool){
            if($bool eq 'A' || $bool eq 'P' ){;} else{die "$bool\t$_\n$ordersam[$i]\t$probesetid\t$value\n";}
        }
        else{die "$ordersam[$i]\t$probesetid\tNovalue\n$_\n$value\n";}
        if($bool eq 'A') {$sum.="\tNA";$A_num++;} else{$sum.="\t$value";}
        $total++;
        $i++;
    }
    my $P_num=$total-$A_num;
    my $P_freq=($total-$A_num)/$total;
    print "$probesetid\t$mrnaassignment\t$level\t$total\t$P_num\t$P_freq\n";
    print OUT "$sum\n";
}
close OUT;
close IN2;   
