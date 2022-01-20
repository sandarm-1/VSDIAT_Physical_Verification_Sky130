v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 1440 -570 1440 -520 { lab=GND}
N 1440 -520 1960 -520 { lab=GND}
N 1960 -600 1960 -520 { lab=GND}
N 1920 -600 1960 -600 { lab=GND}
N 1710 -520 1710 -490 { lab=GND}
N 1540 -570 1540 -520 { lab=GND}
N 1440 -680 1440 -630 { lab=#net1}
N 1440 -680 1960 -680 { lab=#net1}
N 1960 -680 1960 -640 { lab=#net1}
N 1920 -640 1960 -640 { lab=#net1}
N 1920 -620 1990 -620 { lab=out}
N 1540 -640 1540 -630 { lab=in}
N 1540 -640 1620 -640 { lab=in}
N 1540 -670 1560 -670 { lab=in}
N 1540 -670 1540 -640 { lab=in}
C {inverter_new.sym} 1770 -620 0 0 {name=x1}
C {opin.sym} 1990 -620 0 0 {name=p1 lab=out}
C {opin.sym} 1560 -670 0 0 {name=p2 lab=in}
C {gnd.sym} 1710 -490 0 0 {name=l1 lab=GND}
C {vsource.sym} 1540 -600 0 0 {name=V1 value="pwl (0 0 20n 0 900n 1.8)"}
C {vsource.sym} 1440 -600 0 0 {name=V2 value=1.8}
C {code_shown.sym} 1670 -750 0 0 {name=s1 only_toplevel=false value=".lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt"}
C {code_shown.sym} 1750 -450 0 0 {name=s2 only_toplevel=false value=".control
tran 1n 1u
plot V(in) V(out)
.endc"}
