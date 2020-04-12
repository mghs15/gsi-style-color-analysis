use strict;
my $start = time;
print $start;
print  "\n---------------------------\n";

my @allfile = glob "*.json";

my %results = ();

foreach my $filename (@allfile) {
	my $outfilename = "results/routput_".time.$filename;
	open (OutFH, ">", $outfilename) or die "$!";

	open(FH, $filename) or die "$!";
	my @lines = <FH>;
	foreach my $d (@lines) {
	
#insert here ----------------------


if( ( $d =~ /rgba\(0,\s*0,\s*0,?\s*0\)/ ) ){$d =~ s/rgba\(0,\s*0,\s*0,?\s*0\)/rgba\(0,0,255,0\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(0,\s*0,\s*0,?\s*1\)/ ) && ( $d =~ /text-/ ) ){$d =~ s/rgba\(0,\s*0,\s*0,?\s*1\)/rgba\(0,0,0,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(0,\s*0,\s*0,?\s*1\)/ ) ){$d =~ s/rgba\(0,\s*0,\s*0,?\s*1\)/rgba\(0,0,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(100,\s*0,\s*0,?\s*1\)/ ) ){$d =~ s/rgba\(100,\s*0,\s*0,?\s*1\)/rgba\(100,0,0,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(100,\s*100,\s*100,?\s*0.75\)/ ) ){$d =~ s/rgba\(100,\s*100,\s*100,?\s*0.75\)/rgba\(100,100,255,0.75\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(100,\s*100,\s*100,?\s*0\)/ ) ){$d =~ s/rgba\(100,\s*100,\s*100,?\s*0\)/rgba\(100,100,255,0\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(100,\s*100,\s*100,?\s*1\)/ ) && ( $d =~ /text-/ ) ){$d =~ s/rgba\(100,\s*100,\s*100,?\s*1\)/rgba\(100,100,100,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(100,\s*100,\s*100,?\s*1\)/ ) ){$d =~ s/rgba\(100,\s*100,\s*100,?\s*1\)/rgba\(100,100,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(101,\s*159,\s*216,?\s*1\)/ ) ){$d =~ s/rgba\(101,\s*159,\s*216,?\s*1\)/rgba\(101,159,216,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(113,\s*113,\s*113,?\s*1\)/ ) && ( $d =~ /text-/ ) ){$d =~ s/rgba\(113,\s*113,\s*113,?\s*1\)/rgba\(113,113,113,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(113,\s*113,\s*113,?\s*1\)/ ) ){$d =~ s/rgba\(113,\s*113,\s*113,?\s*1\)/rgba\(113,113,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(120,\s*220,\s*160,?\s*0.75\)/ ) ){$d =~ s/rgba\(120,\s*220,\s*160,?\s*0.75\)/rgba\(220,220,0,0.75\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(120,\s*220,\s*160,?\s*1\)/ ) ){$d =~ s/rgba\(120,\s*220,\s*160,?\s*1\)/rgba\(220,220,0,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(123,\s*183,\s*124,?\s*1\)/ ) ){$d =~ s/rgba\(123,\s*183,\s*124,?\s*1\)/rgba\(183,183,0,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(128,\s*128,\s*128,?\s*1\)/ ) ){$d =~ s/rgba\(128,\s*128,\s*128,?\s*1\)/rgba\(128,128,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(140,\s*140,\s*140,?\s*1\)/ ) && ( $d =~ /text-/ ) ){$d =~ s/rgba\(140,\s*140,\s*140,?\s*1\)/rgba\(140,140,140,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(140,\s*140,\s*140,?\s*1\)/ ) ){$d =~ s/rgba\(140,\s*140,\s*140,?\s*1\)/rgba\(140,140,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(150,\s*150,\s*150,?\s*1\)/ ) ){$d =~ s/rgba\(150,\s*150,\s*150,?\s*1\)/rgba\(150,150,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(160,\s*160,\s*160,?\s*1\)/ ) && ( $d =~ /text-/ ) ){$d =~ s/rgba\(160,\s*160,\s*160,?\s*1\)/rgba\(160,160,160,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(160,\s*160,\s*160,?\s*1\)/ ) ){$d =~ s/rgba\(160,\s*160,\s*160,?\s*1\)/rgba\(160,160,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(170,\s*170,\s*170,?\s*1\)/ ) ){$d =~ s/rgba\(170,\s*170,\s*170,?\s*1\)/rgba\(170,170,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(173,\s*173,\s*173,?\s*0.75\)/ ) ){$d =~ s/rgba\(173,\s*173,\s*173,?\s*0.75\)/rgba\(173,173,255,0.75\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(173,\s*173,\s*173,?\s*1\)/ ) ){$d =~ s/rgba\(173,\s*173,\s*173,?\s*1\)/rgba\(173,173,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(19,\s*97,\s*69,?\s*1\)/ ) && ( $d =~ /text-/ ) ){$d =~ s/rgba\(19,\s*97,\s*69,?\s*1\)/rgba\(0,0,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(190,\s*210,\s*255,?\s*1\)/ ) ){$d =~ s/rgba\(190,\s*210,\s*255,?\s*1\)/rgba\(190,210,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(20,\s*90,\s*255,?\s*1\)/ ) ){$d =~ s/rgba\(20,\s*90,\s*255,?\s*1\)/rgba\(20,90,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(200,\s*160,\s*60,?\s*1\)/ ) ){$d =~ s/rgba\(200,\s*160,\s*60,?\s*1\)/rgba\(165,165,165,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(200,\s*200,\s*200,?\s*1\)/ ) ){$d =~ s/rgba\(200,\s*200,\s*200,?\s*1\)/rgba\(200,200,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(210,\s*210,\s*210,?\s*1\)/ ) ){$d =~ s/rgba\(210,\s*210,\s*210,?\s*1\)/rgba\(210,210,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(220,\s*220,\s*220,?\s*0.75\)/ ) ){$d =~ s/rgba\(220,\s*220,\s*220,?\s*0.75\)/rgba\(220,220,255,0.75\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(220,\s*220,\s*220,?\s*1\)/ ) ){$d =~ s/rgba\(220,\s*220,\s*220,?\s*1\)/rgba\(220,220,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(230,\s*230,\s*230,?\s*1\)/ ) ){$d =~ s/rgba\(230,\s*230,\s*230,?\s*1\)/rgba\(230,230,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(238,\s*202,\s*119,?\s*1\)/ ) ){$d =~ s/rgba\(238,\s*202,\s*119,?\s*1\)/rgba\(238,202,119,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(255,\s*220,\s*150,?\s*0.75\)/ ) ){$d =~ s/rgba\(255,\s*220,\s*150,?\s*0.75\)/rgba\(255,220,150,0.75\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(255,\s*220,\s*150,?\s*1\)/ ) ){$d =~ s/rgba\(255,\s*220,\s*150,?\s*1\)/rgba\(255,220,150,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(255,\s*255,\s*255,?\s*0\)/ ) ){$d =~ s/rgba\(255,\s*255,\s*255,?\s*0\)/rgba\(255,255,255,0\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(255,\s*255,\s*255,?\s*1\)/ ) && ( $d =~ /text-/ ) ){$d =~ s/rgba\(255,\s*255,\s*255,?\s*1\)/rgba\(255,255,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(255,\s*255,\s*255,?\s*1\)/ ) ){$d =~ s/rgba\(255,\s*255,\s*255,?\s*1\)/rgba\(255,255,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(37,\s*30,\s*28,?\s*1\)/ ) ){$d =~ s/rgba\(37,\s*30,\s*28,?\s*1\)/rgba\(37,30,28,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(43,\s*107,\s*255,?\s*1\)/ ) ){$d =~ s/rgba\(43,\s*107,\s*255,?\s*1\)/rgba\(43,107,255,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(80,\s*80,\s*80,?\s*1\)/ ) && ( $d =~ /text-/ ) ){$d =~ s/rgba\(80,\s*80,\s*80,?\s*1\)/rgba\(80,80,80,1\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(88,\s*88,\s*88,?\s*0.75\)/ ) ){$d =~ s/rgba\(88,\s*88,\s*88,?\s*0.75\)/rgba\(88,88,255,0.75\)/g;print OutFH $d;next;}
if( ( $d =~ /rgba\(88,\s*88,\s*88,?\s*1\)/ ) ){$d =~ s/rgba\(88,\s*88,\s*88,?\s*1\)/rgba\(88,88,255,1\)/g;print OutFH $d;next;}
















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
print time -  $start;  # åoâﬂéûä‘ÇèoóÕ
