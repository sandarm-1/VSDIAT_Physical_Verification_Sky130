v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 1770 -1390 1770 -1350 { lab=vdd}
N 1770 -1390 1800 -1390 { lab=vdd}
N 1770 -1290 1770 -1250 { lab=out}
N 1660 -1270 1690 -1270 { lab=in}
N 1690 -1320 1690 -1270 { lab=in}
N 1690 -1320 1730 -1320 { lab=in}
N 1690 -1220 1730 -1220 { lab=in}
N 1690 -1270 1690 -1220 { lab=in}
N 1770 -1270 1860 -1270 { lab=out}
N 1770 -1190 1770 -1140 { lab=vss}
N 1770 -1140 1780 -1140 { lab=vss}
N 1770 -1220 1800 -1220 { lab=vss}
N 1800 -1220 1800 -1170 { lab=vss}
N 1770 -1170 1800 -1170 { lab=vss}
C {sky130_fd_pr/pfet3_01v8.sym} 1750 -1320 0 0 {name=M2
L=0.18
W=3
body=vdd
nf=3
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {ipin.sym} 1660 -1270 0 0 {name=p1 lab=in}
C {opin.sym} 1860 -1270 0 0 {name=p2 lab=out}
C {iopin.sym} 1800 -1390 0 0 {name=p3 lab=vdd}
C {iopin.sym} 1780 -1140 0 0 {name=p4 lab=vss}
C {sky130_fd_pr/nfet_01v8.sym} 1750 -1220 0 0 {name=M1
L=0.2
W=4.5
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
