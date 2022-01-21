# run_magic_drc.tcl ---
#    batch script for running DRC

crashbackups stop
drc euclidean on
drc style drc(full)
drc on
snap internal
load sky130_fd_sc_hd__and2_1 -dereference
select top cell
expand
drc catchup
set allerrors [drc listall why]
set oscale [cif scale out]
set ofile [open /home/darunix/VSDIAT_Courses/VSDIAT_PV_Sky130_3/lab2/mag/sky130_fd_sc_hd__and2_1_drc.txt w]
puts $ofile "DRC errors for cell sky130_fd_sc_hd__and2_1"
puts $ofile "--------------------------------------------"
foreach {whytext rectlist} $allerrors {
   puts $ofile ""
   puts $ofile $whytext
   foreach rect $rectlist {
       set llx [format "%.3f" [expr $oscale * [lindex $rect 0]]]
       set lly [format "%.3f" [expr $oscale * [lindex $rect 1]]]
       set urx [format "%.3f" [expr $oscale * [lindex $rect 2]]]
       set ury [format "%.3f" [expr $oscale * [lindex $rect 3]]]
       puts $ofile "$llx $lly $urx $ury"
   }
}
close $ofile
