

$string="DB00295, DB00530, DB00586";

@ids = split(', ', $string);
for my $n (@ids) {
	my $url = `curl -s "https://www.drugbank.ca/drugs/$n"`;
	if( $url =~ /Gene\sName:<\/dt><dd>(UGT1A1)<\/dd>/) {
		#print $n."\t UGT1A1\n";
	} else {
		print $n."\n";
	}
}






