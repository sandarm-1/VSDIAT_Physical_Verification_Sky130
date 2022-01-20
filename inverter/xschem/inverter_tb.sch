v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N -180 -30 -40 -30 { lab=in}
N -180 -30 -180 -0 { lab=in}
N 260 -30 310 -30 { lab=#net1}
N 260 10 310 10 { lab=GND}
N 310 10 310 90 { lab=GND}
N 110 90 310 90 { lab=GND}
N -180 60 -180 90 { lab=GND}
N -180 90 110 90 { lab=GND}
N 90 90 90 140 { lab=GND}
N -290 -30 -290 0 { lab=#net1}
N -290 60 -290 90 { lab=GND}
N -290 90 -180 90 { lab=GND}
N -290 -90 -290 -30 { lab=#net1}
N -290 -90 310 -90 { lab=#net1}
N 310 -90 310 -30 { lab=#net1}
N -180 -60 -160 -60 { lab=in}
N -180 -60 -180 -30 { lab=in}
N 260 -10 340 -10 { lab=out}
N 340 -10 340 0 { lab=out}
N 340 -0 370 0 { lab=out}
N 370 -30 370 0 { lab=out}
N 370 -30 380 -30 { lab=out}
C {inverter.sym} 110 -10 0 0 {name=x1}
C {vsource.sym} -180 30 0 0 {name=V1 value="pwl (0 0 20n 0 900n 1.8)"}
C {vsource.sym} -290 30 0 0 {name=V_DD value=1.8}
C {gnd.sym} 90 140 0 0 {name=l1 lab=GND}
C {opin.sym} 380 -30 0 0 {name=p1 lab=out}
C {opin.sym} -160 -60 0 0 {name=p3 lab=in}
C {code_shown.sym} -190 -160 0 0 {name=s1 only_toplevel=false value=".lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt"}
C {code_shown.sym} -210 190 0 0 {name=s2 only_toplevel=false value=".control
tran 1n 1u
plot V(in) V(out)
.endc"}
