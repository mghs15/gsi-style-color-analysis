use strict;
my $start = time;
print $start;
print  "\n---------------------------\n";

my @allfile = glob "std.json";

my %results = ();
my %perlcode = ();
my %colorlist = ();
 

foreach my $filename (@allfile) {
	my @outfile = ();
	my $outline = "";
	open(FH, $filename) or die "$!";
	my @lines = <FH>;
	foreach my $d (@lines) {
		if($d =~ /(rgba)\((\d+),\s*(\d+),\s*(\d+),\s*(\d?\.?\d+)\)/){
			my $color = $filename."\t".$1."\t".$2."\t".$3."\t".$4."\t".$5;
			my $code = "\$d =~ s/".$1."\\(".$2.",\\s*".$3.",\\s*".$4.",?\\s*".$5."\\)/rgba\\(0,0,128,1\\)/g;"."\n";
			my $rgba = "<tr><td>"."rgba(".$2.",".$3.",".$4.",".$5.")"."</td><td><span style='background:rgba(".$2.",".$3.",".$4.",".$5.");'>"."_______________"."</span></td></tr>"."\n";
			$results{$color}++;
			$perlcode{$code}++;
			$colorlist{$rgba}++;
		}
		if($d =~ /(rgb)\((\d+),\s*(\d+),\s*(\d+)\)/){
			my $color = $filename."\t".$1."\t".$2."\t".$3."\t".$4."\t"."";
			my $code = "\$d =~ s/".$1."\\(".$2.",\\s*".$3.",\\s*".$4."\\)/rgba\\(0,0,128,1\\)/g;"."\n";
			my $rgba = "<tr><td>"."rgba(".$2.",".$3.",".$4.")"."</td><td><span style='background:rgba(".$2.",".$3.",".$4.");'>"."_______________"."</span></td></tr>"."\n";
			$results{$color}++;
			$perlcode{$code}++;
			$colorlist{$rgba}++;
		}
	}
	close(FH);
}

my $outfilename = "results/results2_".time."\.txt";
open (OutFH, ">", $outfilename) or die "$!";
foreach my $key (keys(%results)){
	print OutFH $key."\t".$results{$key}."\n";
}
close(OutFH);

my $outfilecode = "results/perlcode_".time."\.txt";
open (OutFH, ">", $outfilecode) or die "$!";
foreach my $key (keys(%perlcode)){
	print OutFH $key;
}
close(OutFH);

my $outfileclist = "results/colorlist_".time."\.html";
open (OutFH, ">", $outfileclist) or die "$!";
print OutFH "<table>\n";
foreach my $key (keys(%colorlist)){
	print OutFH $key;
}
print OutFH "</table>\n";
close(OutFH);

print  "\n---------------------------\n";
print  "\n";
print time;
print  "\n";
print time -  $start;  # åoâﬂéûä‘ÇèoóÕ
