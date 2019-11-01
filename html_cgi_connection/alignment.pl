#!/usr/bin/perl

use warnings;
use strict;
use CGI;

print "Content-Type: text\n\n";

my $q = CGI->new;

my $nw = $q->param('nw');
my $mode = $q->param('mode');
my $gapopen =$q->param('gapopen');
my $gapextend=$q->param('gapextend');
my $subm=$q->param('subm');
my $pairs=$q->param('pairs');
my $format=$q->param('format');
my $seqlib="";
my $dpmatrices=$q->param('dpmatrices');

my $pairSeq="../tmp/pairSeq.pairs";
my $seqlibSeq="../tmp/seqlibSeq.seqlib";

if($nw eq "nw"){
	$nw=" --nw";}
else {	$nw=""; }
#
if($mode eq "global"){
	$mode=" --mode global"; }
else {	if($mode eq "local" ) {
	$mode=" --mode local"; }
	else { $mode=" --mode freeshift"; }
}
#
$gapopen=" --go $gapopen";
if($nw eq " --nw") {
	$gapextend=""; }
else { $gapextend=" --ge $gapextend"; }
#
if($subm eq "example") {
	my $sm=$q->param('smatrix');
	
	if($sm eq "dayhoff") { $subm=" -m ../samples/dayhoff.mat" }
	else {	if($sm eq "blosum") { $subm=" -m ../samples/blosum62.mat" }
		else { if ($sm eq "pam")	{ $subm=" -m ../samples/pam250.mat" }
		else { $subm=" -m ../samples/BlakeCohenMatrix.mat" }
	} }
}


else { 
	my $fileSub = $q->param('matrix');
	open(my $fs, ">", "../tmp/$fileSub") or die "Could not open file $fileSub";
	while(<$fileSub>){
	print $fs ($_);
	}
	close $fs;
	$subm=" -m ../tmp/$fileSub";
}
#
if($pairs eq "example"){
	$pairs=" --pairs ../samples/Bsp.pairs";
	$seqlib=" --seqlib ../samples/Bsp.seqlib";  }
else { 	
	if($pairs eq "pdb") {
	my $pId1 = $q->param('pdbID1');
	my $pId2 = $q->param('pdbID2');
	my $seq1= `perl getPDBSeq $pId1`;
	my $seq2= `perl getPDBSeq $pId2`;

	open(my $fp, '>', $pairSeq) or die "Could not open file $pairSeq";
		print $fp "$pId1 $pId2";
	close $fp;

	open(my $fpd, '>', $seqlibSeq) or die "Could not open file $seqlibSeq";
		print $fpd "$pId1:$seq1\n$pId2:$seq2";
	close $fpd;
	
	$pairs=" --pairs $pairSeq";
	$seqlib=" --seqlib $seqlibSeq";
	}
	else { if($pairs eq "loaded") {
	my $fileP = $q->param('pairsEx');
	open(my $fp, ">", "../tmp/$fileP") or die "Could not open file $fileP";
	while(<$fileP>){
	print $fp ($_);
	}
	close $fp;
	$pairs=" --pairs ../tmp/$fileP";

	my $fileSeq = $q->param('seqlib');
	open(my $fp, ">", "../tmp/$fileSeq") or die "Could not open file $fileSeq";
	while(<$fileSeq>){
	print $fp ($_);
	}
	close $fp;
	$seqlib=" --seqlib ../tmp/$fileP"; }

	else {
	
	my $seq1 = $q->param('seq1');
	my $seq2 = $q->param('seq2');

	open(my $fp, '>', $pairSeq) or die "Could not open file $pairSeq";
		print $fp "seq1 seq2";
	close $fp;

	open(my $fpd, '>', $seqlibSeq) or die "Could not open file $seqlibSeq";
		print $fpd "seq1:$seq1\nseq2:$seq2";
	close $fpd;
	
	$pairs=" --pairs $pairSeq";
	$seqlib=" --seqlib $seqlibSeq";



}
} }
#
if($format eq "html") {
	$format=" --format html"; }
else{	if($format eq "ali") {
		$format=" --format ali"; }
	else { $format=" --format scores"; }
}
#
if($dpmatrices eq "no") {
	$dpmatrices=""; }
else {
	$dpmatrices=" --dpmatrices ../"; 
}

###

#my $output;
#if($pairs eq "example") {
#$output = $nw . $mode . $gapopen . $gapextend . $subm . $pairSeq . $seqlibSeq . $format . $dpmatrices; }	
#else {
my $output = $nw . $mode . $gapopen . $gapextend . $subm . $pairs . $seqlib . $format . $dpmatrices; #}
#print $output;


print `java -jar /home/proj/biocluster/praktikum/bioprakt/progprakt8/Solution3/finaljars/alignment.jar$output`; 


if( $format eq " --format html") { 
print "<html><br><br><br><br><br><br><br><br><br></html>"; } else { print "\n\n" }

print `cat ../matrices/*`;
print `rm ../matrices/*`;



