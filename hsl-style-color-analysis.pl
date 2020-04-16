use strict;
use POSIX  qw(floor ceil);
my $start = time;
print $start;
print  "\n---------------------------\n";

my @allfile = glob "*.json";

my %results = ();
my %perlcode = ();
my %colorlist = ();
 

sub calcsl {
	my ($max, $min) = @_;
	my $l = ($max + $min)/(2*255);
	my $total = $max + $min;
	my $s=($max - $min)/255;
	if(($total <= 0) || ($total >= 510)){
		$s = 0;
	}elsif( $total < 255){
		$s = ($max-$min)/($total);
	}else{
		$s = ($max-$min)/(255*2-$total);
	}
	my $sl = {s => $s, l => $l};
	return $sl;
}

sub rgb2hsl {
	my ($r, $g, $b) = @_;
	my $max=0; my $middle=0; my $min = 0; 
	my $h=0; my $s=0; my $l=0; 
	if(($r == $g) && ($r == $b)){
		$max = $r; $middle=$b; $min = $g; 
		$h = 0;
		my $sl = calcsl($max, $min);
		$s = $sl->{s};
		$l = $sl->{l};
	}elsif(($r <= $g) && ($r < $b)){
		$min = $r;
		if($g < $b){
			$middle=$g; $max = $b; 
		}else{ 
			$middle=$b; $max = $g; 
		}
		$h = 60*(($b-$g)/($max-$min))+180;
		my $sl = calcsl($max, $min);
		$s = $sl->{s};
		$l = $sl->{l};
	}elsif(($g <= $b) && ($g < $r)){
		$min = $g; 
		if($r < $b){
			$middle=$r; $max = $b; 
		}else{ 
			$middle=$b; $max = $r; 
		} 
		$h = 60*(($r-$b)/($max-$min))+300;
		my $sl = calcsl($max, $min);
		$s = $sl->{s};
		$l = $sl->{l};
	}else{
		$min = $b; 
		if($g < $r){
			$middle=$g; $max = $r; 
		}else{ 
			$middle=$r; $max = $g; 
		}
		$h = 60*(($g-$r)/($max-$min))+60;
		my $sl = calcsl($max, $min);
		$s = $sl->{s};
		$l = $sl->{l};
	}
	
	if($h >360){
		$h = $h - 360;
	}
	
	my $hsl = {h => $h, s => $s*100, l => $l*100};
	return $hsl;
}


foreach my $filename (@allfile) {
	my @outfile = ();
	my $outline = "";
	open(FH, $filename) or die "$!";
	my @lines = <FH>;
	foreach my $d (@lines) {
		if($d =~ /(rgba)\((\d+),\s*(\d+),\s*(\d+),\s*(\d?\.?\d+)\)/){
			my $color = $filename."\t".$1."\t".$2."\t".$3."\t".$4."\t".$5;
			
			my $hsl = rgb2hsl($2, $3, $4);
			my $H = floor($hsl->{h});
			my $S = floor($hsl->{s});
			my $L = floor($hsl->{l});

			
			print($2.",".$3.",".$4." -> ".$H.",".$S.",".$L."\n");
			

			# $2 R 赤; $3 G 緑; $4 B 青 ######################################
			my $red = $2; 
			my $green = $3;
			my $blue = $4;
			my $r = $red;
			my $g = $green;
			my $b = $blue;
			my $class = 0;
			
			if(($red == $green) && ($red == $blue) ){ #モノクロ系統
				if($d =~ /text-/){ #注記（text-color, text-halo-color）
					$r = $red;
					$g = $red;
					$b = $red;
					$class = 100;
				}elsif($red > 254){ #白部分
					$r = $red;
					$g = $red;
					$b = $red;
					$class = -100;
				}elsif($red > 169){ #薄い部分
					$r = $red;
					$g = $red;
					$b = $red;
					$class = -100;
				}else{
					$r = $red;
					$g = $red;
					$b = $red;
					$class = -100;
				}
			}elsif( ($red >= $green) && ($red > $blue) ){ #赤系統（r=gの黄色系統含む）
				if($red == 200){ #rgba(200,160,60,1) --- 地下・トンネル、等高線の色は印象が大きいので、指定してもよいかもしれない
					$r = $red;
					$g = $green;
					$b = $blue;
					$class = -102;
				}else{
					$r = $red;
					$g = $green;
					$b = $blue;
					$class = 1;
				}
			}elsif( ($green >= $red) && ($green > $blue) ){ #緑系統（g=bの蛍光っぽい水色系統含む）
				if($d =~ /text-/){ #注記（text-color, text-halo-color） --- 緑系統のtextは1色だけなので、決め打ちでもよい
					$r = $red;
					$g = $green;
					$b = $blue;
					$class = 101;
				}else{
					$r = $red;
					$g = $green;
					$b = $blue;
					$class = 1;
				}
			}else{ #青～紫系統
				if($red == 190){ #rgba(190,210,255,1) --- 水域の色は印象が大きいので、指定してもよいかもしれない。
					$r = $red;
					$g = $green;
					$b = $blue;
					$class = -103;
				}else{
					$r = $red;
					$g = $green;
					$b = $blue;
					$class = 1;
				}
			}
			#memo
			# $r = $red > 150 ? $red : 150;
			# 255 - ceil(($red + $green + $blue)/3);
			# floor(($red + $green + $blue)/3);
			###############################################################
			
			
			my $code = "\$d =~ s/".$1."\\(".$2.",\\s*".$3.",\\s*".$4.",?\\s*".$5."\\)/hsla\\(".$H.",".$S."%,".$L."%,".$5."\\)/g;print OutFH \$d;next;";
			if($class > 99){
				$code = "if\( \( \$d =~ /text-/\ \) && \( \$d =~ /".$1."\\(".$2.",\\s*".$3.",\\s*".$4.",?\\s*".$5."\\)/\ \) \)\{".$code."\}\n";
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
foreach my $key (sort{$b cmp $a} keys(%colorlist)){
	print OutFH $key;
}
print OutFH "</table>\n";
close(OutFH);


my $outfilecode = "tmp_perlcode.txt";
open (OutFH, ">", $outfilecode) or die "$!";
foreach my $key (sort{$b cmp $a} keys(%perlcode)){
	$key =~ s/next/last/;
	print OutFH $key;
}
close(OutFH);


print  "\n---------------------------\n";
print  "\n";
print time;
print  "\n";
print time -  $start;  # 経過時間を出力
