use strict;
use POSIX  qw(floor ceil);
my $start = time;
print $start;
print  "\n---------------------------\n";

my @allfile = glob "*.json";

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
			

			# $2 R 赤; $3 G 緑; $4 B 青 ######################################
			my $red = $2; 
			my $green = $3;
			my $blue = $4;
			my $r = $red;
			my $g = $green;
			my $b = $blue;
			my $class = 0;
			
				if($d =~ /text-/){ #注記（text-color, text-halo-color）
					$r = floor(rand 255);
					$g = floor(rand 255);
					$b = floor(rand 255);
					$class = 100;
				}else{
					$r = floor(rand 255);
					$g = floor(rand 255);
					$b = floor(rand 255);
					$class = -100;
				}

			#memo
			# $r = $red > 150 ? $red : 150;
			# 255 - ceil(($red + $green + $blue)/3);
			# floor(($red + $green + $blue)/3);
			###############################################################
			
			
			my $code = "\$d =~ s/".$1."\\(".$2.",\\s*".$3.",\\s*".$4.",?\\s*".$5."\\)/rgba\\(".$r.",".$g.",".$b.",".$5."\\)/g;print OutFH \$d;next;";
			if($class > 99){
				$code = "if\( \( \$d =~ /".$1."\\(".$2.",\\s*".$3.",\\s*".$4.",?\\s*".$5."\\)/\ \) && \( \$d =~ /text-/\ \) \)\{".$code."\}\n";
			}else{
				$code = "if\( \( \$d =~ /".$1."\\(".$2.",\\s*".$3.",\\s*".$4.",?\\s*".$5."\\)/\ \) \)\{".$code."\}\n";
			}
			#のちのち、ソート順で、$d =~ /text-color/ を先に処理させる。
			
			my $rgba = "<tr><td>"."rgba(".$2.",".$3.",".$4.",".$5.")"."</td><td><span style='background:rgba(".$2.",".$3.",".$4.",".$5.");'>"."_________"."</span></td><td>"."rgba(".$r.",".$g.",".$b.",".$5.")"."</td><td><span style='background:rgba(".$r.",".$g.",".$b.",".$5.");'>"."__________"."</span></td></tr>"."\n";
			$results{$color}++;
			$perlcode{$code}++;
			$colorlist{$rgba}++;
		}
	}
	close(FH);
}

my $outfilename = "random/results2_".time."\.txt";
open (OutFH, ">", $outfilename) or die "$!";
foreach my $key (sort{$a cmp $b} keys(%results)){
	print OutFH $key."\t".$results{$key}."\n";
}
close(OutFH);

my $outfilecode = "random/perlcode_".time."\.txt";
open (OutFH, ">", $outfilecode) or die "$!";
foreach my $key (sort{$a cmp $b} keys(%perlcode)){
	print OutFH $key;
}
close(OutFH);

my $outfileclist = "random/colorlist_".time."\.html";
open (OutFH, ">", $outfileclist) or die "$!";
print OutFH "<table>\n";
foreach my $key (sort{$a cmp $b} keys(%colorlist)){
	print OutFH $key;
}
print OutFH "</table>\n";
close(OutFH);


my $outfilecode = "tmp_perlcode.txt";
open (OutFH, ">", $outfilecode) or die "$!";
foreach my $key (sort{$b cmp $a} keys(%perlcode)){
	print OutFH $key;
}
close(OutFH);


print  "\n---------------------------\n";
print  "\n";
print time;
print  "\n";
print time -  $start;  # 経過時間を出力
