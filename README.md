# VSDIAT_PV_Sky130_3
VSDIAT Sky130 Physical Verification workshop labs

Heading
=======

Sub-heading
-----------

Paragraphs are separated 
by a blank line.

Bullet lists nested within numbered list:

  1. fruits
     * apple
     * banana
  2. vegetables
     - carrot
     - broccoli

<img src="https://user-images.githubusercontent.com/95447782/150603283-da6dd32f-88cf-4e4b-9ccf-1e624c2ce868.png" alt="drawing" style="width:400px;"/>

Day 1:
=======
Basic DRC/LVS design flow

Theory from Day 1:
-----------
TBA

Labs from Day 1:
-----------
Inverter in xschem and simulated with ngspice: (pre-layout)

<img src="https://user-images.githubusercontent.com/95447782/150603791-181a6382-8a1a-405f-9ae9-a790e39a80c6.png" alt="drawing" style="width:400px;"/>





Prelayout sim result:
![image](https://user-images.githubusercontent.com/95447782/150604088-31b7ce3c-79f4-46e1-99cd-17cb042fdd4b.png)




This is the layout:
![image](https://user-images.githubusercontent.com/95447782/150604126-b504da36-8436-44b3-8eba-ccb192ea77e4.png)



LVS clean:
![image](https://user-images.githubusercontent.com/95447782/150604143-a3a54bac-88e1-41e0-8492-992f902414a5.png)



Result of post-layout extracted sim:
![image](https://user-images.githubusercontent.com/95447782/150604153-10b6d863-19dd-462d-b674-de670486300c.png)






DAY 2:
===

Theory from Day 2:
-----
TBA

Labs from Day 2:
-----
GDS of an AND2 gate standard cell, read in from the PDK standard cell GDSs available that come with the PDK from the foundry:
![image](https://user-images.githubusercontent.com/95447782/150604215-17ca0748-4f82-4df4-bab2-ef0739e45959.png)



We played with cif istyle etc to see the effect.

Then we looked at port index number that Magic arbitrarily assigns to each pin after reading in the GDS.

For example for VPWR Magic says that the port index is 1.
![image](https://user-images.githubusercontent.com/95447782/150604223-00b95240-af0c-44b9-bd24-3bd8df420149.png)



But then we checked the .spice netlist for that AND2_1 gate from the PDK and we noticed the port order in the .spice netlist of it doesn’t match the order in the GDS read in by Magic.
![image](https://user-images.githubusercontent.com/95447782/150604238-4bea3442-b9fe-4073-9146-bedc3d6a5fa7.png)



Everything that you need to know about a cell is contained in the GDS, the spice file and the LEF file of that cell. Magic uses info from these 3 places when reading in the GDS, to make most sense of it.

We read in the LEF data for the cell in Magic:
lef read /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

After reading the LEF, now Magic has the info to know the actual use and class of each port in the cell:
![image](https://user-images.githubusercontent.com/95447782/150604246-2e666941-9183-4cb0-a4b0-f5bf4e9ab3c1.png)

With this TCL script Magic can also know the right port order, from the .spice file:
readspice /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice

Now after running this, Magic knows the correct port order, matching the .spice file:
![image](https://user-images.githubusercontent.com/95447782/150604272-8d05036f-4db1-47ef-803f-006a7416196c.png)


**Abstract views:**
![image](https://user-images.githubusercontent.com/95447782/150604282-4380659c-fb49-4d87-ba43-5fe9d756bcb3.png)


But abstract views don’t have the transistors in them. They are more concerned with placing and routing.


Trying to write an abstract view to a GDS is not a good idea and Magic will warn you that it’s not likely a good idea.
![image](https://user-images.githubusercontent.com/95447782/150604357-ca419234-b450-4a3c-b0f6-3717954466a5.png)

Reading back a GDS written from a LEF will produce layers that don’t make sense.
![image](https://user-images.githubusercontent.com/95447782/150604371-264e84d2-36bd-4fa1-9381-a5e1b65c2d15.png)

However there is this trick where we can put in a LEF standard cell in our GDS layout, save the GDS, then reopen it, and Magic then pulls the actual layout (not abstract) for the standard cell, because it knows the path to where to find the layout from the libraries path.
![image](https://user-images.githubusercontent.com/95447782/150604388-91281e7f-3094-4b17-9c39-78ea4cae0ac6.png)

![image](https://user-images.githubusercontent.com/95447782/150604405-e68d7c07-242f-4cbb-81b0-2d9db4dc8272.png)

To descend into the layout of a cell: select it with i and press greater than key > .
If we type property inside the standard cell we have descended into, we see its an abstraction:
![image](https://user-images.githubusercontent.com/95447782/150604417-be87bb1e-3278-4250-b80d-195397e8ce5c.png)

To return back up to the cell above, type the less than key < .


Now we try to replicate a standard cell layout like the one in the PDK, but we are going to try to build it up from the vendor GDS, annotate it with the LEF and SPICE information, and get a .mag layout that looks exactly the same as the one in Magic’s search path.

For that we do:
`gds readonly true
gds rescale false
gds read /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds
load sky130_fd_sc_hd__and2_1`

Annotate it with LEF:
`lef read /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef`

Annotate it with SPICE:
`readspice /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice`

The result is:
![image](https://user-images.githubusercontent.com/95447782/150604458-ce2b9dd5-33e9-4b76-aaaa-a3e7aa10b80d.png)

Note the cell name above is my_sky130_fd_sc_hd__and2_1.

Comparing both layouts ensures they are both the same:
`tkdiff my_sky130_fd_sc_hd__and2_1.mag /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/mag/sky130_fd_sc_hd__and2_1.mag`



**Basic extraction:**
After running
`extract all
ext2spice lvs
ext2spice`

We get .ext (intermediate file) and .spice file.
We can compare this extracted spice file and it’s the same as the spice subcircuit given in the PDK.

This is the spice extracted:
![image](https://user-images.githubusercontent.com/95447782/150604749-cbd60349-69fb-4b33-8e49-4f274ea65f19.png)


This is the spice in the PDK:
![image](https://user-images.githubusercontent.com/95447782/150604756-9780026e-8ab7-4952-9bcf-b3650c318f57.png)


If we extract with C, then the parasitic caps get inserted in the netlist:

`ext2spice cthresh 0
ext2spice`
![image](https://user-images.githubusercontent.com/95447782/150604776-3e4ebd60-a953-4480-a56f-909e01151052.png)


**RC extraction (in development):**
`ext2sim labels on
ext2sim`

We get 2 new files, .nodes and .sim:
![image](https://user-images.githubusercontent.com/95447782/150604799-4cc88bd3-9909-423b-9836-d801f7784813.png)



Now we extract resistances:
`extresist tolerance 10
extresist`

Now we get a new file, .res.ext:
![image](https://user-images.githubusercontent.com/95447782/150604809-eaccceea-d48b-43c8-9829-59c13fbfe105.png)

That .res.ext has the resistance info that has to be inserted into the .spice netlist.

Now we run ext2spice again and we finally get the .spice with R and C:

`ext2spice lvs`
`ext2spice cthresh 0.01`
**ext2spice extresist on**
`est2spice`

Now the .spice file has the Rs and Cs:
![image](https://user-images.githubusercontent.com/95447782/150604879-68988756-b24e-4848-8af8-48d7774e2ab2.png)

![image](https://user-images.githubusercontent.com/95447782/150604888-f2ebd6f2-39d1-4efb-864f-055f03106f59.png)


**DRC:**
Script to run DRC on a layout:
`usr/local/share/pdk/sky130A/libs.tech/magic/run_standard_drc.py /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/mag/sky130_fd_sc_hd__and2_1.mag`

We get the DRC result in a text file:
`sky130_fd_sc_hd__and2_1_drc.txt`

We see that the standard cell has DRC errors but that’s because the standard cell needs cap cells around it to close well and substrate connections.
![image](https://user-images.githubusercontent.com/95447782/150604958-98cbb81c-c38b-43e0-8c08-bd2edad33781.png)

While we are working with the layout in Magic, if we have the DRC style set to “fast” (for fast interactive DRC) then it will not check all DRCs, just some, so we may get a green DRC tickmark while doing layout, but when we run DRC with drc style set to “full” it will show all the DRCs.
![image](https://user-images.githubusercontent.com/95447782/150604968-bd05d3ce-4888-44ec-9066-1c7e5237963d.png)

![image](https://user-images.githubusercontent.com/95447782/150604976-be717a6f-bff6-4c5d-88a3-12adfa0b105f.png)



If we set DRC style to full and run drc check, we will see the DRCs in Magic.
![image](https://user-images.githubusercontent.com/95447782/150604987-5ea3b1cd-436b-4b14-9e7f-22d46d3b2568.png)

With drc why and drc find, it will highlight where the DRCs are and the reason.
![image](https://user-images.githubusercontent.com/95447782/150605001-5064b890-c044-481c-bbac-a4beed265939.png)

Notice how if we add the cap / tap cells around the standard cell then the DRCs go away.
![image](https://user-images.githubusercontent.com/95447782/150605029-9025c9da-dd27-40af-a548-7c3e5b610403.png)

**LVS:**
First of all, in /netgen directory, remember to copy the setup.tcl file!!! (how intuitive)

`cp /usr/local/share/pdk/sky130A/libs.tech/netgen/sky130A_setup.tcl ./setup.tcl` (unintuitive but it has to be done)


We extract a simple LVS netlist again from the layout with:
`ext2spice lvs
extspice`

Then we run LVS from /netgen dir:
`netgen -batch lvs "../mag/my_sky130_fd_sc_hd__and2_1.spice my_sky130_fd_sc_hd__and2_1" "/usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice sky130_fd_sc_hd__and2_1"`

Notice that we are LVS’ing against this huge schematic mega-netlist that is in this big  sky130_fd_sc_hd.spice file of the PDK which contains all the netlists for all the cells, so that’s why we give it also the name of the cell in particular,  sky130_fd_sc_hd__and2_1.

We get LVS clean:
![image](https://user-images.githubusercontent.com/95447782/150605118-1460611b-0a96-412d-8b42-5a4d0985ecb6.png)


**XOR comparison:**
To test this functionality we load up our AND2 gate, we make a small mod to it (cut a small stripe of LI on the side).

Then we save it as another cell for comparison, then flatten it, call it xor_test, then reload the non-altered AND2 layout, and then run the XOR comparison of the non-altered AND2 layout against the altered AND2 layout, like this:
![image](https://user-images.githubusercontent.com/95447782/150605131-b9596572-48ec-4e00-8cdf-6ebba4db2b57.png)

Then we load the result xor_test, and we see it has correctly found that the XOR difference is in the stripe that we cut out before.
![image](https://user-images.githubusercontent.com/95447782/150605162-249f6941-9dc3-4099-8fce-68bc0e1b984e.png)

A more realistic example of using the XOR test: we open our AND2 gate with the tap cell from before, and we shift the AND2 gate a tiny amount to the side, so it’s misplaced over the tap cell, almost unnoticeable, something that could happen during a chip design.
![image](https://user-images.githubusercontent.com/95447782/150605183-0d56d30e-f377-42d4-b942-83c5f559689a.png)


Then we XOR this versus our original AND2 gate plus tap cell.
And we see that the XOR catches the difference clearly.
![image](https://user-images.githubusercontent.com/95447782/150605198-8930fdf3-6ae2-47d9-aa49-0fb72ba68bf1.png)

![image](https://user-images.githubusercontent.com/95447782/150605209-5a7860b1-7d45-4c8a-b014-e1b7ae2eb2f8.png)







