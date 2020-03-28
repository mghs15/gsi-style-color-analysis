use strict;
my $start = time;
print $start;
print  "\n---------------------------\n";

my @allfile = glob "std.json";

my %results = ();
 

foreach my $filename (@allfile) {
	my @outfile = ();
	my $outline = "";
	open(FH, $filename) or die "$!";
	my @lines = <FH>;
	foreach my $d (@lines) {
		if($d =~ /(rgba)\((\d+),\s*(\d+),\s*(\d+),\s*(\d?\.?\d+)\)/){
			my $color = $filename."\t".$1."\t".$2."\t".$3."\t".$4."\t".$5;
			$results{$color}++;
		}
		if($d =~ /(rgb)\((\d+),\s*(\d+),\s*(\d+)\)/){
			my $color = $filename."\t".$1."\t".$2."\t".$3."\t".$4."\t"."";
			$results{$color}++;
		}
	}
	close(FH);
}

my $outfilename = "results2_".time."\.txt";
open (OutFH, ">", $outfilename) or die "$!";
foreach my $key (keys(%results)){
	print OutFH $key."\t".$results{$key}."\n";
}
close(OutFH);


print  "\n---------------------------\n";
print  "\n";
print time;
print  "\n";
print time -  $start;  # Œo‰ßŠÔ‚ğo—Í
