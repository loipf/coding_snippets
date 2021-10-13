#!/usr/bin/perl

use warnings;


$string="GOBP_LEUKOCYTE_MIGRATION, GOBP_RESPONSE_TO_INTERFERON_GAMMA";

@ids = split(', ', $string);
for my $n (@ids) {
	my $url = `curl -s "http://www.gsea-msigdb.org/gsea/msigdb/cards/$n"`;
	if( $url =~ /Exact\ssource<\/th>\n\s+<td>(.+)<\/td>/ ) {
		print $n."\t$1\n";
	} else {
		print $n."\n";
	}
}
