v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 1580 -640 1640 -640 { lab=in}
N 1640 -700 1640 -640 { lab=in}
N 1640 -700 1680 -700 { lab=in}
N 1640 -640 1640 -590 { lab=in}
N 1640 -590 1680 -590 { lab=in}
N 1720 -560 1720 -500 { lab=vss}
N 1720 -500 1760 -500 { lab=vss}
N 1720 -530 1750 -530 { lab=vss}
N 1750 -590 1750 -530 { lab=vss}
N 1720 -590 1750 -590 { lab=vss}
N 1720 -670 1720 -620 { lab=out}
N 1720 -640 1860 -640 { lab=out}
N 1720 -800 1720 -730 { lab=vdd}
N 1720 -800 1760 -800 { lab=vdd}
C {sky130_fd_pr/pfet3_01v8.sym} 1700 -700 0 0 {name=M2
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
C {ipin.sym} 1580 -640 0 0 {name=p1 lab=in}
C {iopin.sym} 1760 -800 0 0 {name=p2 lab=vdd}
C {iopin.sym} 1760 -500 0 0 {name=p3 lab=vss}
C {opin.sym} 1860 -640 0 0 {name=p4 lab=out}
C {sky130_fd_pr/nfet_01v8.sym} 1700 -590 0 0 {name=M1
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
