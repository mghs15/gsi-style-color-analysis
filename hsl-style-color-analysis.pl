use strict;
use POSIX  qw(floor ceil);
my $start = time;
print $start;
print  "\n---------------------------\n";

my @allfile = glob "*.json";

my %results = ();
my %perlcode = ();
my %colorlist = ();
my %hsllist = ();
 

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

sub hsl2rgb {
	my ($h, $s, $l) = @_;
	
	if( $h > 360){
		$h = $h - 360*floor($h/360);
	}elsif($h < 0){
		$h = $h - 360*ceil($h/360);
	}
	
	
	my $part = 2*$l-1;
	my $max = 0;
	my $min = 0;
	
	if($part >= 0){
		$max = $l + ($s*(1-$part)/2);
		$min = $l - ($s*(1-$part)/2);
	}else{
		$max = $l + ($s*(1+$part)/2);
		$min = $l - ($s*(1+$part)/2);
	}
	
	my $r=0; my $g=0; my $b=0; 
	
	if(($h >= 0) && ($h < 60)){
		$r = $max;
		$g = $min + ($max-$min)*($h)/60;
		$b = $min;
	}elsif($h < 120){
		$r = $min + ($max-$min)*(120-$h)/60;
		$g = $max;
		$b = $min;
	}elsif($h < 180){
		$r = $min;
		$g = $max;
		$b = $min + ($max-$min)*($h-120)/60;
	}elsif($h < 240){
		$r = $min;
		$g = $min + ($max-$min)*(240-$h)/60;
		$b = $max;
	}elsif($h < 300){
		$r = $min + ($max-$min)*($h-240)/60;
		$g = $min;
		$b = $max;
	}elsif($h < 360){
		$r = $max;
		$g = $min;
		$b = $min + ($max-$min)*(360-$h)/60;
	}else{
		$r = 1;
		$g = 1;
		$b = 1;
	}
	
	$r = floor($r*255);
	$g = floor($g*255);
	$b = floor($b*255);
	
	my $rgb = {r => $r, g => $g, b => $b};
	return $rgb;
}

foreach my $filename (@allfile) {
	my @outfile = ();
	my $outline = "";
	open(FH, $filename) or die "$!";
	my @lines = <FH>;
	foreach my $d (@lines) {
		if($d =~ /(rgba)\((\d+),\s*(\d+),\s*(\d+),\s*(\d?\.?\d+)\)/){
			my $color = $filename."\t".$1."\t".$2."\t".$3."\t".$4."\t".$5;
			
			my $red = $2;
			my $green = $3;
			my $blue = $4;
			my $alpha = $5;
			
			my $hsl = rgb2hsl($red, $green, $blue);
			my $H = floor($hsl->{h});
			my $S = floor($hsl->{s});
			my $L = floor($hsl->{l});
			
			my $rgbtest = hsl2rgb($H, $S/100, $L/100);
			my $rtest = $rgbtest->{r};
			my $gtest = $rgbtest->{g};
			my $btest = $rgbtest->{b};
			
			my $hc = $H;
			my $sc = $S;
			my $lc = $L;
			my $class = "---";
			
			# 変換式 ######################################
			
			if( $S < 1 ){ #モノクロ系統
				if($d =~ /text-/){ #注記（text-color, text-halo-color）
					$class = "text";
					$hc = $H;
					$sc = $S;
					$lc = $L;
				}elsif($L > 99){ #白部分
					$hc = $H;
					$sc = $S;
					$lc = $L;
					$class = "mono1";
				}elsif($L > 65){ #薄い部分
					$hc = $H + 60;
					$sc = $S + 50;
					$lc = $L;
					$class = "mono2";
				}else{
					$hc = $H;
					$sc = $S;
					$lc = $L;
					$class = "mono3";
				}
			}elsif( ($red == 19 ) && ($green == 97 ) && ($blue == 69 ) ){ #緑―注記
				$hc = $H + 60;
				$sc = $S;
				$lc = $L;
				$class = "text-green";
			}elsif( ($red == 190) && ($green == 210) && ($blue == 255) ){ #水域
				$hc = $H + 60;
				$sc = $S;
				$lc = $L;
				$class = "water";
			}elsif( ($red == 200) && ($green == 160) && ($blue == 60 ) ){ #等高線・トンネル
				$hc = $H + 60;
				$sc = $S;
				$lc = $L;
				$class = "contour";
			}else{ #その他の色
				$hc = $H + 60;
				$sc = $S;
				$lc = $L;
				$class = "color";
			}
			
			###############################################################
			
			my $rgb = hsl2rgb($hc, $sc/100, $lc/100);
			my $r = $rgb->{r};
			my $g = $rgb->{g};
			my $b = $rgb->{b};
			
			print($red.",".$green.",".$blue." : ".$H.",".$S."%,".$L."% : ".$rtest.",".$gtest.",".$btest." -> ".$hc.",".$sc."%,".$lc."% : ".$r.",".$g.",".$b."\n");
			
			my $code = "\$d =~ s/".$1."\\(".$red.",\\s*".$green.",\\s*".$blue.",?\\s*".$alpha."\\)/rgba\\(".$r.",".$g.",".$b.",".$alpha."\\)/g;print OutFH \$d;next;";
			if($class =~ "text"){
				$code = "if\( \( \$d =~ /text-/\ \) && \( \$d =~ /".$1."\\(".$red.",\\s*".$green.",\\s*".$blue.",?\\s*".$alpha."\\)/\ \) \)\{".$code."\}\n";
			}else{
				$code = "if\( \( \$d =~ /".$1."\\(".$red.",\\s*".$green.",\\s*".$blue.",?\\s*".$alpha."\\)/\ \) \)\{".$code."\}\n";
			}
			#のちのち、ソート順で、$d =~ /text-color/ を先に処理させる。
			
			my $rgba = "<tr><td>".$class."</td><td>rgba(".$red.",".$green.",".$blue.",".$alpha.")"."</td><td><span style='background:rgba(".$red.",".$green.",".$blue.",".$alpha.");'>"."_________"."</span></td><td>"."hsla(".$H.",".$S."%,".$L."%,".$alpha.")"."</td><td><span style='background:hsla(".$H.",".$S."%,".$L."%,".$alpha.");'>"."__________"."</span></td><td>"."hsla(".$hc.",".$sc."%,".$lc."%,".$alpha.")"."</td><td><span style='background:hsla(".$hc.",".$sc."%,".$lc."%,".$alpha.");'>"."__________"."</span></td><td>"."rgba(".$r.",".$g.",".$b.",".$alpha.")"."</td><td><span style='background:rgba(".$r.",".$g.",".$b.",".$alpha.");'>"."__________"."</span></td></tr>"."\n";
			my $hsla = "<tr><td>"."rgba(".$red.",".$green.",".$blue.",".$alpha.")"."</td><td><span style='background:rgba(".$red.",".$green.",".$blue.",".$alpha.");'>"."_________"."</span></td><td>"."hsla(".$H.",".$S."%,".$L."%,".$alpha.")"."</td><td><span style='background:hsla(".$H.",".$S."%,".$L."%,".$alpha.");'>"."__________"."</span></td></tr>"."\n";

			$results{$color}++;
			$perlcode{$code}++;
			$colorlist{$rgba}++;
			$hsllist{$hsla}++;
		}
	}
	close(FH);
}

#統計
my $outfilename = "results/results2_".time."\.txt";
open (OutFH, ">", $outfilename) or die "$!";
foreach my $key (sort{$a cmp $b} keys(%results)){
	print OutFH $key."\t".$results{$key}."\n";
}
close(OutFH);

#Perlコード（コピペ・保存用）
my $outfilecode = "results/perlcode_".time."\.txt";
open (OutFH, ">", $outfilecode) or die "$!";
foreach my $key (sort{$a cmp $b} keys(%perlcode)){
	print OutFH $key;
}
close(OutFH);

#rgb = hsl -> hsl = rgb　変換確認
my $outfileclist = "results/colorlist_".time."\.html";
open (OutFH, ">", $outfileclist) or die "$!";
print OutFH "<table>\n";
foreach my $key (sort{$b cmp $a} keys(%colorlist)){
	print OutFH $key;
}
print OutFH "</table>\n";
close(OutFH);

#Perlコード（実行用・一時的）
my $outfilecode = "tmp_perlcode.txt";
open (OutFH, ">", $outfilecode) or die "$!";
foreach my $key (sort{$b cmp $a} keys(%perlcode)){
	$key =~ s/next/last/;
	print OutFH $key;
}
close(OutFH);

#
open (OutFH, ">", "hsllist.html") or die "$!";
print OutFH "<table>\n";
foreach my $key (sort{$b cmp $a} keys(%hsllist)){
	print OutFH $key;
}
print OutFH "</table>\n";
close(OutFH);

print  "\n---------------------------\n";
print  "\n";
print time;
print  "\n";
print time -  $start;  # 経過時間を出力
print  "\n---\n";
print floor(0.55);
print  "\n";
print ceil(-0.55);
