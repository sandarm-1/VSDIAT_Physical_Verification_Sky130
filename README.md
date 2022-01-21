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
`gds readonly true`
`gds rescale false`
`gds read /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds`
`load sky130_fd_sc_hd__and2_1`

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





Day 3:
=====

Theory from Day 3:
-----------
Skywater 130 DRC rules:
https://skywater-pdk--136.org.readthedocs.build/en/136/rules.html

**Local interconnect (LI)**
Made of TiN (titanium). Look at the resistances.
![image](https://user-images.githubusercontent.com/95447782/150606185-45e714a4-ce3b-4fe3-97db-0a70c2fc53e1.png)


Magic has **parameterized devices** (like pcells in commercial tools).
![image](https://user-images.githubusercontent.com/95447782/150606194-6c0c43b7-d77d-4715-9fad-2b86be313260.png)

![image](https://user-images.githubusercontent.com/95447782/150606338-c05953b2-f92a-4dc6-b38b-1cc8790af1f7.png)


Magic generates appropriate implant masks based on device type specified in Magic, but in Magic you won’t see implant masks.

But you will see device ID layers, which tell Magic what type of device you are trying to create, and then when Magic exports GDS it will create the appropriate implant masks, based on those device ID layer.

 ![image](https://user-images.githubusercontent.com/95447782/150606355-b54ff906-03fa-4ad8-9bbc-5ad71a77b26f.png)


**Wells and taps are important**
If you put down a standard cell you need to then put down somewhere an appropriate tap cell so all wells are biased correctly.
![image](https://user-images.githubusercontent.com/95447782/150606480-e9e67e7c-3bd6-4d3c-8883-e57844a803a2.png)

![image](https://user-images.githubusercontent.com/95447782/150606541-637a346e-3980-4900-89a5-acb24ffc1080.png)

 

 

**Deep N wells in Sky 130**
For noise isolation mainly.
![image](https://user-images.githubusercontent.com/95447782/150606594-2365cd6e-714f-4bcf-9f0e-f686000eb4d9.png)

![image](https://user-images.githubusercontent.com/95447782/150606599-59988308-febe-44f4-9ff2-9e77a5c3c2da.png)


 
 
 
Deep N wells do take quite a lot of space and they require to be well far apart:
![image](https://user-images.githubusercontent.com/95447782/150606650-11001fbb-8e28-4edd-8e32-26cf523e3cf2.png)


 

**High Voltage rules: Use of the HVI layer**
![image](https://user-images.githubusercontent.com/95447782/150606711-d8b0b82d-b491-4de5-bab3-d5ca15ecdcd3.png)
 
In high voltage regions, poly, diffusions etc has different spacing rules.
 
![image](https://user-images.githubusercontent.com/95447782/150606721-200fdacd-8ddf-4ba5-ac6a-a6df3bce1042.png)

Mvdiff is for making high voltage devices around 3.0V and 5.0V.

There is yet another even higher voltage layer, called UHV, which is for really high voltages like 20V etc.


**Resistors:**
You have p diffusion resistors and poly resistors. Better to stick to poly resistors whenever possible.
 ![image](https://user-images.githubusercontent.com/95447782/150606753-e7640383-d30e-4dbe-bff2-56bea10550b6.png)

Most of the time in analog you will use pcell type resistors rather than custom layout resistors.

**Caps:**
You have these types in Sky130:
 ![image](https://user-images.githubusercontent.com/95447782/150606765-091dd458-097e-4e32-b54c-53205bac34fe.png)

**Varactors:**
Varactors are formed like MOSFET transistors EXCEPT USING A TAP LAYER FOR DRAIN AND SOURCE, INSTEAD OF REGULAR DIFFUSION

And a “TAP LAYER” means a well like an NWELL with a diffusion of the same sign like an N+ diffusion, that’s a TAP LAYER, it’s like when you put down a well and you add the tapping point on it.

Like, this are the usual well tap points or well ties:
![image](https://user-images.githubusercontent.com/95447782/150606849-e40d00d1-0ccd-4b6a-b588-8c907b4e1fe1.png)


So, in the varactor you have Gate (poly) over NWELL with N+ diffusion, and on the MOSCAP you have a Gate (poly) over PWELL (or PSUB) with N+ diffusion.

And at the end of the day it all translates into a different C-V curve where V is the voltage difference between the 2 terminals.
So the varactor is more used for like LC oscillators etc, and the MOSCAP is more for the likes of supply decoupling caps but can be used in many other applications.

It’s a 2 terminal device where the change in capacitance is achieved by just the voltage difference between Gate and Source.
Capacitor is formed at the intersection between Gate (poly) and channel (Nwell / N difusion below it). The 2 cap plates are the gate and the source, and the dielectric is the gate oxide.

This is a cross-section of a single-finger NMOS varactor. Note the diffusion is N+ and the well is also NWELL.
![image](https://user-images.githubusercontent.com/95447782/150606972-0981ca5e-a2c0-4532-bf4e-0a55c9a2fa56.png)

Another varactor cross section:
![image](https://user-images.githubusercontent.com/95447782/150607077-c7b158a4-da38-4ce0-9805-481bc8e001ed.png)

Varactor layers layout view in Magic:
![image](https://user-images.githubusercontent.com/95447782/150608279-b53c7766-5b57-4bf6-9e75-500d84653246.png)


**MOSCAPs:**
It's a transistor with S, D and Bulk connected together.
![image](https://user-images.githubusercontent.com/95447782/150607148-2ee6d0d1-b53e-41d0-8b6f-d2913acb5601.png)


**VPP cap**
Vertical parallel plate, MOM cap.
Notice the inter-digitated structure.
Reminds of the crazy TSMC65 “rotating” RT-MOMcap.
![image](https://user-images.githubusercontent.com/95447782/150607183-de10556d-c199-4b3e-84a8-6c8fdb06f073.png)

 
Determining the Cap value of a MOM cap by extraction is tricky, and ends up being a poor approximation of the actual value.

THERE IS ALMOST NO REASON TO REASON TO USE MOM CAPS IN A PROCESS THAT HAS MIM CAPS AVAILABLE.

In other processes like 65nm we may not have a MIM cap so we may stick to MOM caps. Let alone 28nm.

**MIMcaps**
MIMcaps can have much more C per unit area, due to the dielectric, they can be much more dense.
![image](https://user-images.githubusercontent.com/95447782/150607346-4f4bd42c-4170-4af8-844f-c49ee5e68e15.png)

Rules around the MiM cap from above:
![image](https://user-images.githubusercontent.com/95447782/150607364-c2a16d4d-d6b4-46b2-bc3c-d95d3d5e033b.png)


 
Most MiM cap DRC rules are not so much to avoid breaking it in manufacturing but mostly to ensure the Cap per unit area comes out as the “advertised 1fF per um2”.

You also have “dual layer” MiM caps to be able to stack MiM caps over each other with different metal layers, so you get double capacitance in the same area, although you loose routing capability over it, but if you can route elsewhere then ok.

MiM caps are also subject to antenna rules due to the chunky areas of metal that can accumulate charge during manufacturing.

**Diodes:**
![image](https://user-images.githubusercontent.com/95447782/150607416-6ad10b90-945f-4392-ab46-089a65c71ec5.png)

 
These are parasitic junction diodes, they are usually unwanted, but in case you actually want a diode by design as a component of your circuit, then you draw it in layout and you put an ID layer over it so that you tell Magic that that is a diode that you have put there on purpose, you want that to be a diode, otherwise Magic may flag it as an unwanted parasitic diode that is not supposed to be in the circuit.

Other than that, you can put down pcell type diodes that come pre-made or parameterized with the PDK, and those are used for like antenna rules etc.

**Bipolars**:
These are fixed layout devices given by the PDK.

Like this PNP bipolar.
They are guaranteed to be DRC clean out of the box. Just need to not violate spacing rules around them.
 ![image](https://user-images.githubusercontent.com/95447782/150607451-54d229ab-daf8-42c8-87c6-a48e6e33e2af.png)

Some layers in Skywater 130 are only ever used in devices that have a fixed layout and the user can never draw anything custom with those layers.

For Skywater 130 that includes layers like the UHV (Ultra High Voltage layer, for those 20V devices), high voltage Extended Drain devices, bipolars, special RF transistors, photodiodes, SRAM core cells, NVRAM cells and other special devices.

These devices are in the skywater130_fd_pr library and have their fixed layouts as GDS. As a designer you just instantiate them with their pre-made fixed layouts and don’t worry about DRC rules for them.


**Miscellaneous DRCs:**
All data must be on 0.005um grid.
 ![image](https://user-images.githubusercontent.com/95447782/150607504-d3d20c02-a86d-40e8-b7c2-03bae95d997c.png)

Angle limitations: just 90 or 45 degrees.
 ![image](https://user-images.githubusercontent.com/95447782/150607525-37f00083-da1b-4ed4-bb72-3334a8c7fe7e.png)

**Seal ring:**
Seal ring is treated as a fixed layout device, even though the outer seal ring size grows or shrinks depending on die size.
But essentially it’s a bunch of fixed layout that are tiled and stretched to form the outer seal ring.
 ![image](https://user-images.githubusercontent.com/95447782/150607556-a70a8fdb-309c-497d-85b0-a7faf3f7bb02.png)


**Latch up rules:**
Avoid PN and PNP junctions to be forward biased.
 ![image](https://user-images.githubusercontent.com/95447782/150607578-41ad9015-9869-417f-b9d1-fa145e684a33.png)

To avoid this, there are tap to diff distance rules.
 ![image](https://user-images.githubusercontent.com/95447782/150607597-89cf16f4-55a8-4e7c-be04-e3f06ee47c56.png)

**Antenna rules:**
These are to avoid charge accumulation in long metal tracks during manufacturing that would break transistor gates.
 ![image](https://user-images.githubusercontent.com/95447782/150607622-735d4b58-ef0a-44a5-b415-c227821ad8c6.png)

![image](https://user-images.githubusercontent.com/95447782/150607650-086e3028-4e13-4455-80ae-374c0399d23b.png)

![image](https://user-images.githubusercontent.com/95447782/150607682-13302ab8-b26a-4ee1-b677-047acb1943e0.png)

 
To fix antenna violations, you can place diodes which are called “antenna diodes” but which can be really just a simple parasitic junction diode attached to the wire on one end and grounded on the other.

![image](https://user-images.githubusercontent.com/95447782/150607714-9b125922-4191-4be9-b4bf-dfc0337971ee.png)

Ideally you could have diodes built into cells. In fact sometimes antenna diodes are put at gates of differential pairs etc.
 ![image](https://user-images.githubusercontent.com/95447782/150607724-c14f6ffd-0606-4a44-b7bd-ad8c7df2a575.png)

Another way to avoid antenna violations is to break the metal routing.
 ![image](https://user-images.githubusercontent.com/95447782/150607741-1f32a2ff-7fd2-4ba3-9aec-f18492ab7af2.png)

**Stress avoidance and Slotting rules:**
![image](https://user-images.githubusercontent.com/95447782/150607784-54efdc26-5caf-4789-9600-f5724280b14c.png)


 
Corners are subject to stress. But essentially these corners of the chip are fixed layout areas, because in the chip corner we usually have fixed layout cells like pad cells which are fixed layout cells and hence are DRC clean by design and the designer doesn’t need to worry about them.
![image](https://user-images.githubusercontent.com/95447782/150607812-89c11455-de15-40d2-96d2-2b99c79de30d.png)

 
**Density rules:**
Some of these are to ensure the required flatness of the internal chip surfaces.
![image](https://user-images.githubusercontent.com/95447782/150607858-aab096ef-a8e8-4897-b79e-d7ccb9033b6a.png)

 
To meet these rules, we do fill insertion. This is done automatically via fill insertion scripts. After running one of these scripts, you are pretty much guaranteed to have all your density rules correctly covered.
 ![image](https://user-images.githubusercontent.com/95447782/150607874-f9cac7bd-4431-4dc4-8cae-f091a2c990c9.png)

However these inserted fill patterns can add extra capacitance and coupling down to analog circuits underneath and can therefore degrade their performance or even break their functionality.

To avoid this, it is possible to insert blocking layers (“fill block”) in the layout which tell the fill generator script not to put any fill patterns over specific sensitive areas. An example of this is large spiral inductors, or parasitic sensitive VCOs, etc. When you add “fill block” areas, if these areas are large, you could then break the minimum density rule, and then you have to work around that or see if it can be waived or not, etc.
![image](https://user-images.githubusercontent.com/95447782/150607908-372bd24f-eca0-4d9d-a9d9-e72de381f9a1.png)



Sometimes you may get a situation in layout where some areas are such that even the fill insertion script can’t insert fill patterns well enough to cover the density rule. Then you may have to tweak the layout in that area.
 ![image](https://user-images.githubusercontent.com/95447782/150607936-73595533-2020-4d43-995e-e7c8685fa3c9.png)

Also you may break the density rule by having areas with too much metal, scripts can only add fill shapes but not substract, so in this situation you may have to tweak the design manually.
 ![image](https://user-images.githubusercontent.com/95447782/150607959-f0247b6c-d1d9-4446-9113-426fee8e65f4.png)

**Recommended rules (RR):**
These are recommendations for improving yield, important for going to production with the chip, not so much for test chips or shuttle runs, but try to cover as many of them as possible.
![image](https://user-images.githubusercontent.com/95447782/150607990-4fcaa26f-305b-4f62-9147-6e562bfdd04b.png)

Your chip won’t be rejected for production due to violating these rules, nor will you be required a waiver for them.
 
**Manufacturing rules vs Test rules:**
Manufacturing rules are more stringent than test rules.
![image](https://user-images.githubusercontent.com/95447782/150608019-052f7e60-305c-4777-858b-825085a07756.png)



**Rule waivers:**
You acknowledge the risk of producing your chip with certain rules violated.
![image](https://user-images.githubusercontent.com/95447782/150608043-bfaef5a6-7a0a-4d0a-8d28-53e38a7f0db5.png)

 
**ERC (Electrical rule checks):**
Your design may be DRC clean from the point of view of manufacturability but you still need to check you don’t have ERC problems like electromigration, overvoltage conditions, etc.



Labs from Day 3:
----------
Excercise 1
Excercise 2
Excercise 3
Excercise 4
Excercise 5
Excercise 6
Excercise 7
Excercise 8
Excercise 9
Excercise 10
Excercise 11

