use strict;
my $start = time;
print $start;
print  "\n---------------------------\n";

my @allfile = glob "*.json";

my %results = ();


#作成したPerlコードの読み込み
open (CodeFH, "tmp_perlcode.txt") or die "$!";
my @codelines = <CodeFH>;
print "loaded codes \n";
close(CodeFH);


#ベースとなるスタイルを変換
foreach my $filename (@allfile) {
	my $outfilename = "results/routput_".time.$filename;
	open (OutFH, ">", $outfilename) or die "$!";

	open(FH, $filename) or die "$!";
	my @lines = <FH>;
	foreach my $d (@lines) {
	
#insert here ----------------------

		if($d =~ /(rgba)\((\d+),\s*(\d+),\s*(\d+),\s*(\d?\.?\d+)\)/){
			foreach my $perlcode (@codelines) {
				eval $perlcode;
			}
		}

#insert end  ----------------------
	
		print OutFH $d;
	}
	close(FH);
	close(OutFH);
}




print  "\n---------------------------\n";
print  "\n";
print time;
print  "\n";
print time -  $start;  # 経過時間を出力


