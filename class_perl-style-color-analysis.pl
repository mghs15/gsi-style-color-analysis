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
			
			if(($red == $green) && ($red == $blue) ){ #モノクロ系統
			$class = 0;
				if($red == 0){ #黒
					$r=0;$g=0;$b=0;
				}elsif($red == 255){
					$r=255;$g=255;$b=255;
				}else{
					$r = $red;
					$g = $green;
					$b = $blue;
				}
			}elsif( ($red >= $green) && ($red > $blue) ){ #赤系統（r=gの黄色系統含む）
				$class = 1;
				$r = floor(($red + $green + $blue)/3);
				$g = floor(($red + $green + $blue)/3);
				$b = floor(($red + $green + $blue)/3);
			}elsif( ($green >= $red) && ($green > $blue) ){ #緑系統（g=bの蛍光っぽい水色系統含む）
				$class = 2;
				$r = floor(($red + $green + $blue)/3);
				$g = 100;
				$b = floor(($red + $green + $blue)/3);
			}else{ #青～紫系統
				$class = 3;
				$r = 100;
				$g = 100;
				$b = $blue > 150 ? $blue : 150;
			}
			#memo
			# $r = $red > 150 ? $red : 150;
			# 255 - ceil(($red + $green + $blue)/3);
			# floor(($red + $green + $blue)/3);
			###############################################################
			
			
			my $code = "\$d =~ s/".$1."\\(".$2.",\\s*".$3.",\\s*".$4.",?\\s*".$5."\\)/rgba\\(".$r.",".$g.",".$b.",".$5."\\)/g;"."\n";
			
			my $rgba = "<tr><td>".$class."</td><td>rgba(".$2.",".$3.",".$4.",".$5.")"."</td><td><span style='background:rgba(".$2.",".$3.",".$4.",".$5.");'>"."_______________"."</span></td><td></td></tr>"."\n";
			$results{$color}++;
			$perlcode{$code}++;
			$colorlist{$rgba}++;
		}
		if($d =~ /(rgb)\((\d+),\s*(\d+),\s*(\d+)\)/){
			my $color = $filename."\t".$1."\t".$2."\t".$3."\t".$4."\t"."1";
			

			# $2 R 赤; $3 G 緑; $4 B 青 ######################################
			my $red = $2; 
			my $green = $3;
			my $blue = $4;
			my $r = $red;
			my $g = $green;
			my $b = $blue;
			
			if(($red == $green) && ($red == $blue) ){ #モノクロ系統
				if($red == 0){ #黒
					$r=0;$g=0;$b=0;
				}elsif($red == 255){
					$r=255;$g=255;$b=255;
				}else{
					$r = $red;
					$g = $green;
					$b = $blue;
				}
			}elsif( ($red >= $green) && ($red > $blue) ){ #赤系統（r=gの黄色系統含む）
				$r = floor(($red + $green + $blue)/3);
				$g = floor(($red + $green + $blue)/3);
				$b = floor(($red + $green + $blue)/3);
			}elsif( ($green >= $red) && ($green > $blue) ){ #緑系統（g=bの蛍光っぽい水色系統含む）
				$r = floor(($red + $green + $blue)/3);
				$g = 50;
				$b = floor(($red + $green + $blue)/3);
			}else{ #青～紫系統
				$r = 100;
				$g = 100;
				$b = $blue > 150 ? $blue : 150;
			}
			#memo
			# $r = $red > 150 ? $red : 150;
			# 255 - ceil(($red + $green + $blue)/3);
			# floor(($red + $green + $blue)/3);
			###############################################################
			
			my $code = "\$d =~ s/".$1."\\(".$2.",\\s*".$3.",\\s*".$4."\\)/rgba\\(".$r.",".$g.",".$b.",1\\)/g;"."\n";
			
			my $rgba = "<tr><td>"."rgb(".$2.",".$3.",".$4.")"."</td><td><span style='background:rgba(".$2.",".$3.",".$4.");'>"."_______________"."</span></td></tr>"."\n";
			$results{$color}++;
			$perlcode{$code}++;
			$colorlist{$rgba}++;
		}
	}
	close(FH);
}

my $outfilename = "results/results2_".time."\.txt";
open (OutFH, ">", $outfilename) or die "$!";
foreach my $key (sort{$a cmp $b} keys(%results)){
	print OutFH $key."\t".$results{$key}."\n";
}
close(OutFH);

my $outfilecode = "results/perlcode_".time."\.txt";
open (OutFH, ">", $outfilecode) or die "$!";
foreach my $key (sort{$a cmp $b} keys(%perlcode)){
	print OutFH $key;
}
close(OutFH);

my $outfileclist = "results/colorlist_".time."\.html";
open (OutFH, ">", $outfileclist) or die "$!";
print OutFH "<table>\n";
foreach my $key (sort{$a cmp $b} keys(%colorlist)){
	print OutFH $key;
}
print OutFH "</table>\n";
close(OutFH);


my $outfilecode = "tmp_perlcode.txt";
open (OutFH, ">", $outfilecode) or die "$!";
foreach my $key (sort{$a cmp $b} keys(%perlcode)){
	print OutFH $key;
}
close(OutFH);


print  "\n---------------------------\n";
print  "\n";
print time;
print  "\n";
print time -  $start;  # 経過時間を出力
