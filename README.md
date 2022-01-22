# VSDIAT_PV_Sky130_3
VSDIAT Sky130 Physical Verification workshop labs

* Day 1 - Introduction to SkyWater SKY130
* Day 2 -DRC/LVS Theory and labs
* Day 3 - Front-end and back-end DRC
* Day 4 - Understanding PNR and physical verification (Bonus Videos)
* Day 5 - Running LVS

Introduction to SkyWater SKY130:
=======
The SkyWater Open Source PDK is a collaboration between Google and SkyWater Technology Foundry to provide a fully open source Process Design Kit and related resources, which can be used to create manufacturable designs at SkyWater’s facility. This PDK is targeting the SKY130 process node.

Open source EDA tools can be used with the Sky 130 PDK:

<img src="https://user-images.githubusercontent.com/95447782/150655987-01d3fb50-207c-45d2-aaf9-7d7453ff6f1b.png" alt="drawing" style="width:420px;"/>

Libraries in the Sky 130 PDK:

<img src="https://user-images.githubusercontent.com/95447782/150656014-8c55369b-270c-469c-ba18-0aa16d7fa728.png" alt="drawing" style="width:420px;"/>

This is the layer stack in the Sky 130 process.
The Local Interconnect, made of TiN, is quite characteristic of this process, and is only used for very short distance interconnects on devices.

<img src="https://user-images.githubusercontent.com/95447782/150656149-0dda54f5-3ff2-4a4b-b902-a52cdf0a519b.png" alt="drawing" style="width:420px;"/>

Deep N well is available for noise isolation:

<img src="https://user-images.githubusercontent.com/95447782/150656257-8d9f2e63-47ce-4df4-af7e-9f903cae3afd.png" alt="drawing" style="width:420px;"/>

There are 5 levels of metal:

<img src="https://user-images.githubusercontent.com/95447782/150656197-a4094ecc-1350-4417-b68f-8148e7d07a60.png" alt="drawing" style="width:420px;"/>

Some layers are generated automatically by the Magic layout software. For example, the NPC or nitride poly cut layer, is generated automatically by Magic from the position of other layers, like the poly and the contacts.

<img src="https://user-images.githubusercontent.com/95447782/150656239-8067a9b6-cb7b-4bdc-81c2-b6590df35e91.png" alt="drawing" style="width:420px;"/>

The RDL is done separately:

<img src="https://user-images.githubusercontent.com/95447782/150656283-7fcfe552-398e-4758-8d92-a6462c1f84c3.png" alt="drawing" style="width:420px;"/>



Labs from Day 1:
-----------
Inverter in xschem and simulated with ngspice: (pre-layout)

<img src="https://user-images.githubusercontent.com/95447782/150603791-181a6382-8a1a-405f-9ae9-a790e39a80c6.png" alt="drawing" style="width:420px;"/>





Prelayout sim result:

<img src="https://user-images.githubusercontent.com/95447782/150604088-31b7ce3c-79f4-46e1-99cd-17cb042fdd4b.png" alt="drawing" style="width:420px;"/>




This is the layout:

<img src="https://user-images.githubusercontent.com/95447782/150604126-b504da36-8436-44b3-8eba-ccb192ea77e4.png" alt="drawing" style="width:420px;"/>



LVS clean:

<img src="https://user-images.githubusercontent.com/95447782/150604143-a3a54bac-88e1-41e0-8492-992f902414a5.png" alt="drawing" style="width:420px;"/>



Result of post-layout extracted sim:

<img src="https://user-images.githubusercontent.com/95447782/150604153-10b6d863-19dd-462d-b674-de670486300c.png" alt="drawing" style="width:420px;"/>






DRC/LVS Theory and labs:
===

Physical Verification is aimed at ensuring that we don't manufacture "very expensive glass".

It consists of a number of routines to ensure the manufactured devices will be functional and will perform as expected. As part of Physical Verification we will need to run checks such as:

* Design Rule Check (DRC)
* Layout vs Schematic (LVS)
* XOR comparison of layouts
* Antenna Checks
* Electrical Rule Checks (ERC)
* Aging, etc.

Two critical steps of Physical Verification are:

DRC (Design Rule Checks):
These are required to make sure the design layout can be fabricated at the foundry without issues.
LVS (Layout vs Schematic):
This is key to ensure that the circuit we are sending for fabrication matches the design schematics.

Otherwise we may be manufacturing very expensive glass.

Labs from Day 2:
-----
We start with a GDS of an AND2 gate standard cell, read in from the PDK standard cell GDSs available that come with the PDK from the foundry:

<img src="https://user-images.githubusercontent.com/95447782/150604215-17ca0748-4f82-4df4-bab2-ef0739e45959.png" alt="drawing" style="width:420px;"/>



We played with cif istyle etc to see the effect.

Then we looked at port index number that Magic arbitrarily assigns to each pin after reading in the GDS.

For example for VPWR Magic says that the port index is 1.

<img src="https://user-images.githubusercontent.com/95447782/150604223-00b95240-af0c-44b9-bd24-3bd8df420149.png" alt="drawing" style="width:420px;"/>



But then we checked the .spice netlist for that AND2_1 gate from the PDK and we noticed the port order in the .spice netlist of it doesn’t match the order in the GDS read in by Magic.

<img src="https://user-images.githubusercontent.com/95447782/150604238-4bea3442-b9fe-4073-9146-bedc3d6a5fa7.png" alt="drawing" style="width:420px;"/>



Everything that you need to know about a cell is contained in the GDS, the spice file and the LEF file of that cell. Magic uses info from these 3 places when reading in the GDS, to make most sense of it.

We read in the LEF data for the cell in Magic:
lef read /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

After reading the LEF, now Magic has the info to know the actual use and class of each port in the cell:

<img src="https://user-images.githubusercontent.com/95447782/150604246-2e666941-9183-4cb0-a4b0-f5bf4e9ab3c1.png" alt="drawing" style="width:420px;"/>

With this TCL script Magic can also know the right port order, from the .spice file:
readspice /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice

Now after running this, Magic knows the correct port order, matching the .spice file:

<img src="https://user-images.githubusercontent.com/95447782/150604272-8d05036f-4db1-47ef-803f-006a7416196c.png" alt="drawing" style="width:420px;"/>


**Abstract views:**

<img src="https://user-images.githubusercontent.com/95447782/150604282-4380659c-fb49-4d87-ba43-5fe9d756bcb3.png" alt="drawing" style="width:420px;"/>


But abstract views don’t have the transistors in them. They are more concerned with placing and routing.


Trying to write an abstract view to a GDS is not a good idea and Magic will warn you that it’s not likely a good idea.

<img src="https://user-images.githubusercontent.com/95447782/150604357-ca419234-b450-4a3c-b0f6-3717954466a5.png" alt="drawing" style="width:420px;"/>

Reading back a GDS written from a LEF will produce layers that don’t make sense.

<img src="https://user-images.githubusercontent.com/95447782/150604371-264e84d2-36bd-4fa1-9381-a5e1b65c2d15.png" alt="drawing" style="width:420px;"/>

However there is this trick where we can put in a LEF standard cell in our GDS layout, save the GDS, then reopen it, and Magic then pulls the actual layout (not abstract) for the standard cell, because it knows the path to where to find the layout from the libraries path.

<img src="https://user-images.githubusercontent.com/95447782/150604388-91281e7f-3094-4b17-9c39-78ea4cae0ac6.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150604405-e68d7c07-242f-4cbb-81b0-2d9db4dc8272.png" alt="drawing" style="width:420px;"/>

To descend into the layout of a cell: select it with i and press greater than key > .
If we type property inside the standard cell we have descended into, we see its an abstraction:

<img src="https://user-images.githubusercontent.com/95447782/150604417-be87bb1e-3278-4250-b80d-195397e8ce5c.png" alt="drawing" style="width:420px;"/>

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

<img src="https://user-images.githubusercontent.com/95447782/150604458-ce2b9dd5-33e9-4b76-aaaa-a3e7aa10b80d.png" alt="drawing" style="width:420px;"/>

Note the cell name above is my_sky130_fd_sc_hd__and2_1.

Comparing both layouts ensures they are both the same:

`tkdiff my_sky130_fd_sc_hd__and2_1.mag /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/mag/sky130_fd_sc_hd__and2_1.mag`



**Basic extraction:**
After running

`extract all`
`ext2spice lvs`
`ext2spice`

We get .ext (intermediate file) and .spice file.
We can compare this extracted spice file and it’s the same as the spice subcircuit given in the PDK.

This is the spice extracted:

<img src="https://user-images.githubusercontent.com/95447782/150604749-cbd60349-69fb-4b33-8e49-4f274ea65f19.png" alt="drawing" style="width:420px;"/>


This is the spice in the PDK:

<img src="https://user-images.githubusercontent.com/95447782/150604756-9780026e-8ab7-4952-9bcf-b3650c318f57.png" alt="drawing" style="width:420px;"/>


If we extract with C, then the parasitic caps get inserted in the netlist:

`ext2spice cthresh 0`
`ext2spice`

<img src="https://user-images.githubusercontent.com/95447782/150604776-3e4ebd60-a953-4480-a56f-909e01151052.png" alt="drawing" style="width:420px;"/>


**RC extraction (in development):**

`ext2sim labels on`
`ext2sim`

We get 2 new files, .nodes and .sim:

<img src="https://user-images.githubusercontent.com/95447782/150604799-4cc88bd3-9909-423b-9836-d801f7784813.png" alt="drawing" style="width:420px;"/>



Now we extract resistances:

`extresist tolerance 10`
`extresist`

Now we get a new file, .res.ext:

<img src="https://user-images.githubusercontent.com/95447782/150604809-eaccceea-d48b-43c8-9829-59c13fbfe105.png" alt="drawing" style="width:420px;"/>

That .res.ext has the resistance info that has to be inserted into the .spice netlist.

Now we run ext2spice again and we finally get the .spice with R and C:

`ext2spice lvs`
`ext2spice cthresh 0.01`
**ext2spice extresist on**
`est2spice`

Now the .spice file has the Rs and Cs:

<img src="https://user-images.githubusercontent.com/95447782/150604879-68988756-b24e-4848-8af8-48d7774e2ab2.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150604888-f2ebd6f2-39d1-4efb-864f-055f03106f59.png" alt="drawing" style="width:420px;"/>


**DRC:**
Script to run DRC on a layout:

`usr/local/share/pdk/sky130A/libs.tech/magic/run_standard_drc.py /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/mag/sky130_fd_sc_hd__and2_1.mag`

We get the DRC result in a text file:

`sky130_fd_sc_hd__and2_1_drc.txt`

We see that the standard cell has DRC errors but that’s because the standard cell needs cap cells around it to close well and substrate connections.

<img src="https://user-images.githubusercontent.com/95447782/150604958-98cbb81c-c38b-43e0-8c08-bd2edad33781.png" alt="drawing" style="width:420px;"/>

While we are working with the layout in Magic, if we have the DRC style set to “fast” (for fast interactive DRC) then it will not check all DRCs, just some, so we may get a green DRC tickmark while doing layout, but when we run DRC with drc style set to “full” it will show all the DRCs.

<img src="https://user-images.githubusercontent.com/95447782/150604968-bd05d3ce-4888-44ec-9066-1c7e5237963d.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150604976-be717a6f-bff6-4c5d-88a3-12adfa0b105f.png" alt="drawing" style="width:420px;"/>



If we set DRC style to full and run drc check, we will see the DRCs in Magic.

<img src="https://user-images.githubusercontent.com/95447782/150604987-5ea3b1cd-436b-4b14-9e7f-22d46d3b2568.png" alt="drawing" style="width:420px;"/>

With drc why and drc find, it will highlight where the DRCs are and the reason.

<img src="https://user-images.githubusercontent.com/95447782/150605001-5064b890-c044-481c-bbac-a4beed265939.png" alt="drawing" style="width:420px;"/>

Notice how if we add the cap / tap cells around the standard cell then the DRCs go away.

<img src="https://user-images.githubusercontent.com/95447782/150605029-9025c9da-dd27-40af-a548-7c3e5b610403.png" alt="drawing" style="width:420px;"/>

**LVS:**
First of all, in /netgen directory, remember to copy the setup.tcl file!!! (how intuitive)

`cp /usr/local/share/pdk/sky130A/libs.tech/netgen/sky130A_setup.tcl ./setup.tcl` (unintuitive but it has to be done)


We extract a simple LVS netlist again from the layout with:
`ext2spice lvs`
`extspice`

Then we run LVS from /netgen dir:
`netgen -batch lvs "../mag/my_sky130_fd_sc_hd__and2_1.spice my_sky130_fd_sc_hd__and2_1" "/usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice sky130_fd_sc_hd__and2_1"`

Notice that we are LVS’ing against this huge schematic mega-netlist that is in this big  sky130_fd_sc_hd.spice file of the PDK which contains all the netlists for all the cells, so that’s why we give it also the name of the cell in particular,  sky130_fd_sc_hd__and2_1.

We get LVS clean:

<img src="https://user-images.githubusercontent.com/95447782/150605118-1460611b-0a96-412d-8b42-5a4d0985ecb6.png" alt="drawing" style="width:420px;"/>


**XOR comparison:**
To test this functionality we load up our AND2 gate, we make a small mod to it (cut a small stripe of LI on the side).

Then we save it as another cell for comparison, then flatten it, call it xor_test, then reload the non-altered AND2 layout, and then run the XOR comparison of the non-altered AND2 layout against the altered AND2 layout, like this:

<img src="https://user-images.githubusercontent.com/95447782/150605131-b9596572-48ec-4e00-8cdf-6ebba4db2b57.png" alt="drawing" style="width:420px;"/>

Then we load the result xor_test, and we see it has correctly found that the XOR difference is in the stripe that we cut out before.

<img src="https://user-images.githubusercontent.com/95447782/150605162-249f6941-9dc3-4099-8fce-68bc0e1b984e.png" alt="drawing" style="width:420px;"/>

A more realistic example of using the XOR test: we open our AND2 gate with the tap cell from before, and we shift the AND2 gate a tiny amount to the side, so it’s misplaced over the tap cell, almost unnoticeable, something that could happen during a chip design.

<img src="https://user-images.githubusercontent.com/95447782/150605183-0d56d30e-f377-42d4-b942-83c5f559689a.png" alt="drawing" style="width:420px;"/>


Then we XOR this versus our original AND2 gate plus tap cell.
And we see that the XOR catches the difference clearly.

<img src="https://user-images.githubusercontent.com/95447782/150605198-8930fdf3-6ae2-47d9-aa49-0fb72ba68bf1.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150605209-5a7860b1-7d45-4c8a-b014-e1b7ae2eb2f8.png" alt="drawing" style="width:420px;"/>





Front-end and back-end DRC:
=====

Skywater 130 DRC rules:
https://skywater-pdk--136.org.readthedocs.build/en/136/rules.html

**Local interconnect (LI)**
Made of TiN (titanium). Look at the resistances.

<img src="https://user-images.githubusercontent.com/95447782/150606185-45e714a4-ce3b-4fe3-97db-0a70c2fc53e1.png" alt="drawing" style="width:420px;"/>


Magic has **parameterized devices** (like pcells in commercial tools).

<img src="https://user-images.githubusercontent.com/95447782/150606194-6c0c43b7-d77d-4715-9fad-2b86be313260.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150606338-c05953b2-f92a-4dc6-b38b-1cc8790af1f7.png" alt="drawing" style="width:420px;"/>


Magic generates appropriate implant masks based on device type specified in Magic, but in Magic you won’t see implant masks.

But you will see device ID layers, which tell Magic what type of device you are trying to create, and then when Magic exports GDS it will create the appropriate implant masks, based on those device ID layer.

 <img src="https://user-images.githubusercontent.com/95447782/150606355-b54ff906-03fa-4ad8-9bbc-5ad71a77b26f.png" alt="drawing" style="width:420px;"/>


**Wells and taps are important**
If you put down a standard cell you need to then put down somewhere an appropriate tap cell so all wells are biased correctly.

<img src="https://user-images.githubusercontent.com/95447782/150606480-e9e67e7c-3bd6-4d3c-8883-e57844a803a2.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150606541-637a346e-3980-4900-89a5-acb24ffc1080.png" alt="drawing" style="width:420px;"/>

 

 

**Deep N wells in Sky 130**
For noise isolation mainly.

<img src="https://user-images.githubusercontent.com/95447782/150606594-2365cd6e-714f-4bcf-9f0e-f686000eb4d9.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150606599-59988308-febe-44f4-9ff2-9e77a5c3c2da.png" alt="drawing" style="width:420px;"/>


 
 
 
Deep N wells do take quite a lot of space and they require to be well far apart:

<img src="https://user-images.githubusercontent.com/95447782/150606650-11001fbb-8e28-4edd-8e32-26cf523e3cf2.png" alt="drawing" style="width:420px;"/>


 

**High Voltage rules: Use of the HVI layer**

<img src="https://user-images.githubusercontent.com/95447782/150606711-d8b0b82d-b491-4de5-bab3-d5ca15ecdcd3.png" alt="drawing" style="width:420px;"/>
 
In high voltage regions, poly, diffusions etc has different spacing rules.
 
<img src="https://user-images.githubusercontent.com/95447782/150606721-200fdacd-8ddf-4ba5-ac6a-a6df3bce1042.png" alt="drawing" style="width:420px;"/>

Mvdiff is for making high voltage devices around 3.0V and 5.0V.

There is yet another even higher voltage layer, called UHV, which is for really high voltages like 20V etc.


**Resistors:**
You have p diffusion resistors and poly resistors. Better to stick to poly resistors whenever possible.

<img src="https://user-images.githubusercontent.com/95447782/150606753-e7640383-d30e-4dbe-bff2-56bea10550b6.png" alt="drawing" style="width:420px;"/>

Most of the time in analog you will use pcell type resistors rather than custom layout resistors.

**Caps:**
You have these types in Sky130:

<img src="https://user-images.githubusercontent.com/95447782/150606765-091dd458-097e-4e32-b54c-53205bac34fe.png" alt="drawing" style="width:420px;"/>

**Varactors:**
Varactors are formed like MOSFET transistors EXCEPT USING A TAP LAYER FOR DRAIN AND SOURCE, INSTEAD OF REGULAR DIFFUSION

And a “TAP LAYER” means a well like an NWELL with a diffusion of the same sign like an N+ diffusion, that’s a TAP LAYER, it’s like when you put down a well and you add the tapping point on it.

Like, this are the usual well tap points or well ties:

<img src="https://user-images.githubusercontent.com/95447782/150606849-e40d00d1-0ccd-4b6a-b588-8c907b4e1fe1.png" alt="drawing" style="width:420px;"/>


So, in the varactor you have Gate (poly) over NWELL with N+ diffusion, and on the MOSCAP you have a Gate (poly) over PWELL (or PSUB) with N+ diffusion.

And at the end of the day it all translates into a different C-V curve where V is the voltage difference between the 2 terminals.
So the varactor is more used for like LC oscillators etc, and the MOSCAP is more for the likes of supply decoupling caps but can be used in many other applications.

It’s a 2 terminal device where the change in capacitance is achieved by just the voltage difference between Gate and Source.
Capacitor is formed at the intersection between Gate (poly) and channel (Nwell / N difusion below it). The 2 cap plates are the gate and the source, and the dielectric is the gate oxide.

This is a cross-section of a single-finger NMOS varactor. Note the diffusion is N+ and the well is also NWELL.

<img src="https://user-images.githubusercontent.com/95447782/150606972-0981ca5e-a2c0-4532-bf4e-0a55c9a2fa56.png" alt="drawing" style="width:420px;"/>

Another varactor cross section:

<img src="https://user-images.githubusercontent.com/95447782/150607077-c7b158a4-da38-4ce0-9805-481bc8e001ed.png" alt="drawing" style="width:420px;"/>

Varactor layers layout view in Magic:

<img src="https://user-images.githubusercontent.com/95447782/150608279-b53c7766-5b57-4bf6-9e75-500d84653246.png" alt="drawing" style="width:420px;"/>


**MOSCAPs:**
It's a transistor with S, D and Bulk connected together.

<img src="https://user-images.githubusercontent.com/95447782/150607148-2ee6d0d1-b53e-41d0-8b6f-d2913acb5601.png" alt="drawing" style="width:420px;"/>


**VPP cap**
Vertical parallel plate, MOM cap.
Notice the inter-digitated structure.
Reminds of the crazy TSMC65 “rotating” RT-MOMcap.

<img src="https://user-images.githubusercontent.com/95447782/150607183-de10556d-c199-4b3e-84a8-6c8fdb06f073.png" alt="drawing" style="width:420px;"/>

 
Determining the Cap value of a MOM cap by extraction is tricky, and ends up being a poor approximation of the actual value.

THERE IS ALMOST NO REASON TO REASON TO USE MOM CAPS IN A PROCESS THAT HAS MIM CAPS AVAILABLE.

In other processes like 65nm we may not have a MIM cap so we may stick to MOM caps. Let alone 28nm.

**MIMcaps**
MIMcaps can have much more C per unit area, due to the dielectric, they can be much more dense.

<img src="https://user-images.githubusercontent.com/95447782/150607346-4f4bd42c-4170-4af8-844f-c49ee5e68e15.png" alt="drawing" style="width:420px;"/>

Rules around the MiM cap from above:

<img src="https://user-images.githubusercontent.com/95447782/150607364-c2a16d4d-d6b4-46b2-bc3c-d95d3d5e033b.png" alt="drawing" style="width:420px;"/>


 
Most MiM cap DRC rules are not so much to avoid breaking it in manufacturing but mostly to ensure the Cap per unit area comes out as the “advertised 1fF per um2”.

You also have “dual layer” MiM caps to be able to stack MiM caps over each other with different metal layers, so you get double capacitance in the same area, although you loose routing capability over it, but if you can route elsewhere then ok.

MiM caps are also subject to antenna rules due to the chunky areas of metal that can accumulate charge during manufacturing.

**Diodes:**

<img src="https://user-images.githubusercontent.com/95447782/150607416-6ad10b90-945f-4392-ab46-089a65c71ec5.png" alt="drawing" style="width:420px;"/>

 
These are parasitic junction diodes, they are usually unwanted, but in case you actually want a diode by design as a component of your circuit, then you draw it in layout and you put an ID layer over it so that you tell Magic that that is a diode that you have put there on purpose, you want that to be a diode, otherwise Magic may flag it as an unwanted parasitic diode that is not supposed to be in the circuit.

Other than that, you can put down pcell type diodes that come pre-made or parameterized with the PDK, and those are used for like antenna rules etc.

**Bipolars**:
These are fixed layout devices given by the PDK.

Like this PNP bipolar.
They are guaranteed to be DRC clean out of the box. Just need to not violate spacing rules around them.
 
 <img src="https://user-images.githubusercontent.com/95447782/150607451-54d229ab-daf8-42c8-87c6-a48e6e33e2af.png" alt="drawing" style="width:420px;"/>

Some layers in Skywater 130 are only ever used in devices that have a fixed layout and the user can never draw anything custom with those layers.

For Skywater 130 that includes layers like the UHV (Ultra High Voltage layer, for those 20V devices), high voltage Extended Drain devices, bipolars, special RF transistors, photodiodes, SRAM core cells, NVRAM cells and other special devices.

These devices are in the skywater130_fd_pr library and have their fixed layouts as GDS. As a designer you just instantiate them with their pre-made fixed layouts and don’t worry about DRC rules for them.


**Miscellaneous DRCs:**
All data must be on 0.005um grid.

<img src="https://user-images.githubusercontent.com/95447782/150607504-d3d20c02-a86d-40e8-b7c2-03bae95d997c.png" alt="drawing" style="width:420px;"/>

Angle limitations: just 90 or 45 degrees.

<img src="https://user-images.githubusercontent.com/95447782/150607525-37f00083-da1b-4ed4-bb72-3334a8c7fe7e.png" alt="drawing" style="width:420px;"/>

**Seal ring:**
Seal ring is treated as a fixed layout device, even though the outer seal ring size grows or shrinks depending on die size.
But essentially it’s a bunch of fixed layout that are tiled and stretched to form the outer seal ring.
 
 <img src="https://user-images.githubusercontent.com/95447782/150607556-a70a8fdb-309c-497d-85b0-a7faf3f7bb02.png" alt="drawing" style="width:420px;"/>


**Latch up rules:**
Avoid PN and PNP junctions to be forward biased.

 <img src="https://user-images.githubusercontent.com/95447782/150607578-41ad9015-9869-417f-b9d1-fa145e684a33.png" alt="drawing" style="width:420px;"/>

To avoid this, there are tap to diff distance rules.

<img src="https://user-images.githubusercontent.com/95447782/150607597-89cf16f4-55a8-4e7c-be04-e3f06ee47c56.png" alt="drawing" style="width:420px;"/>

**Antenna rules:**
These are to avoid charge accumulation in long metal tracks during manufacturing that would break transistor gates.

<img src="https://user-images.githubusercontent.com/95447782/150607622-735d4b58-ef0a-44a5-b415-c227821ad8c6.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150607650-086e3028-4e13-4455-80ae-374c0399d23b.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150607682-13302ab8-b26a-4ee1-b677-047acb1943e0.png" alt="drawing" style="width:420px;"/>

 
To fix antenna violations, you can place diodes which are called “antenna diodes” but which can be really just a simple parasitic junction diode attached to the wire on one end and grounded on the other.

<img src="https://user-images.githubusercontent.com/95447782/150607714-9b125922-4191-4be9-b4bf-dfc0337971ee.png" alt="drawing" style="width:420px;"/>

Ideally you could have diodes built into cells. In fact sometimes antenna diodes are put at gates of differential pairs etc.

<img src="https://user-images.githubusercontent.com/95447782/150607724-c14f6ffd-0606-4a44-b7bd-ad8c7df2a575.png" alt="drawing" style="width:420px;"/>

Another way to avoid antenna violations is to break the metal routing.

<img src="https://user-images.githubusercontent.com/95447782/150607741-1f32a2ff-7fd2-4ba3-9aec-f18492ab7af2.png" alt="drawing" style="width:420px;"/>

**Stress avoidance and Slotting rules:**

<img src="https://user-images.githubusercontent.com/95447782/150607784-54efdc26-5caf-4789-9600-f5724280b14c.png" alt="drawing" style="width:420px;"/>


 
Corners are subject to stress. But essentially these corners of the chip are fixed layout areas, because in the chip corner we usually have fixed layout cells like pad cells which are fixed layout cells and hence are DRC clean by design and the designer doesn’t need to worry about them.

<img src="https://user-images.githubusercontent.com/95447782/150607812-89c11455-de15-40d2-96d2-2b99c79de30d.png" alt="drawing" style="width:420px;"/>

 
**Density rules:**
Some of these are to ensure the required flatness of the internal chip surfaces.

<img src="https://user-images.githubusercontent.com/95447782/150607858-aab096ef-a8e8-4897-b79e-d7ccb9033b6a.png" alt="drawing" style="width:420px;"/>

 
To meet these rules, we do fill insertion. This is done automatically via fill insertion scripts. After running one of these scripts, you are pretty much guaranteed to have all your density rules correctly covered.

<img src="https://user-images.githubusercontent.com/95447782/150607874-f9cac7bd-4431-4dc4-8cae-f091a2c990c9.png" alt="drawing" style="width:420px;"/>

However these inserted fill patterns can add extra capacitance and coupling down to analog circuits underneath and can therefore degrade their performance or even break their functionality.

To avoid this, it is possible to insert blocking layers (“fill block”) in the layout which tell the fill generator script not to put any fill patterns over specific sensitive areas. An example of this is large spiral inductors, or parasitic sensitive VCOs, etc. When you add “fill block” areas, if these areas are large, you could then break the minimum density rule, and then you have to work around that or see if it can be waived or not, etc.

<img src="https://user-images.githubusercontent.com/95447782/150607908-372bd24f-eca0-4d9d-a9d9-e72de381f9a1.png" alt="drawing" style="width:420px;"/>



Sometimes you may get a situation in layout where some areas are such that even the fill insertion script can’t insert fill patterns well enough to cover the density rule. Then you may have to tweak the layout in that area.

<img src="https://user-images.githubusercontent.com/95447782/150607936-73595533-2020-4d43-995e-e7c8685fa3c9.png" alt="drawing" style="width:420px;"/>

Also you may break the density rule by having areas with too much metal, scripts can only add fill shapes but not substract, so in this situation you may have to tweak the design manually.

<img src="https://user-images.githubusercontent.com/95447782/150607959-f0247b6c-d1d9-4446-9113-426fee8e65f4.png" alt="drawing" style="width:420px;"/>

**Recommended rules (RR):**
These are recommendations for improving yield, important for going to production with the chip, not so much for test chips or shuttle runs, but try to cover as many of them as possible.

<img src="https://user-images.githubusercontent.com/95447782/150607990-4fcaa26f-305b-4f62-9147-6e562bfdd04b.png" alt="drawing" style="width:420px;"/>

Your chip won’t be rejected for production due to violating these rules, nor will you be required a waiver for them.
 
**Manufacturing rules vs Test rules:**
Manufacturing rules are more stringent than test rules.

<img src="https://user-images.githubusercontent.com/95447782/150608019-052f7e60-305c-4777-858b-825085a07756.png" alt="drawing" style="width:420px;"/>



**Rule waivers:**
You acknowledge the risk of producing your chip with certain rules violated.

<img src="https://user-images.githubusercontent.com/95447782/150608043-bfaef5a6-7a0a-4d0a-8d28-53e38a7f0db5.png" alt="drawing" style="width:420px;"/>

 
**ERC (Electrical rule checks):**
Your design may be DRC clean from the point of view of manufacturability but you still need to check you don’t have ERC problems like electromigration, overvoltage conditions, etc.



Labs from Day 3:
----------
Excercise 1:
Here we practiced fixing DRC violations related to width, spacing, wide spacing and notches in metals and other layers.

<img src="https://user-images.githubusercontent.com/95447782/150619077-94ca0c90-f665-4f47-a02b-060ba0f62532.png" alt="drawing" style="width:420px;"/>
 

Excercise 2:
We practiced fixing rules around Via Size, Multiple Vias, Via Overlap and Autogenerated Vias created by Magic when routing from one metal layer to the metal above or below.

We also learned to use `cif see MCON` to see the generated contacts that Magic generates in the via areas.

<img src="https://user-images.githubusercontent.com/95447782/150619083-70fc4f0c-d045-4f79-9c77-90ea2f49f7d3.png" alt="drawing" style="width:420px;"/>


Excercise 3:
We practiced fixing DRC violations around minimum area and minimum hole size. Minimum area violations come out in standard cells because their terminals, like gates, are supposed to be connected with metal at the next level above, where they are instantiated.

<img src="https://user-images.githubusercontent.com/95447782/150619088-b9f6d4fc-fd54-4289-a164-fe95d13fab0e.png" alt="drawing" style="width:420px;"/>

Excercise 4:
We practiced fixing DRCs around wells, NWELLs, well taps and Deep NWELLs. We also learned about the automatic generation of a Deep Nwell area with guardring around it in Magic.

<img src="https://user-images.githubusercontent.com/95447782/150619091-b99c89a7-b794-42c6-83ea-d14a58377b62.png" alt="drawing" style="width:420px;"/>


Excercise 5:
We learned how Magic automatically generates layers when it detects overlaps between drawn layers like diffusion and poly to create transistors and other devices. These are called generated layers. These are layers like NSDM, PSDM, etc. which we can see with `cif see NSDM`,  `cif see PSDM`, `cif see LVTN`, `cif see HVI`, etc. If we want to create Low VT devices we need to put down the corresponding LVT layer on the transistor channel so Magic knows we want an LVT device. Same goes for high voltage devices.
<img src="https://user-images.githubusercontent.com/95447782/150619100-0df055a7-b32b-49c0-bb5a-c1e7ab9512b6.png" alt="drawing" style="width:420px;"/>



Excercise 6:
When we instantiate parameterized devices, these may not be DRC clean by themselves, even though they are library cells. This is because they are expected to be made DRC clean at the level above by connecting their ports through metal tracks to other parts of the hierarchy. This is normal and these DRCs go away as soon as we add metal on top of these ports.

<img src="https://user-images.githubusercontent.com/95447782/150619105-2fab9235-679b-43f2-a5db-0fb369b5b145.png" alt="drawing" style="width:420px;"/>

 
Excercise 7:
There may be DRCs related to angle errors if angles are not exactly 45 or 90 degrees. Sometimes an angle may look like 45 degrees but in reality it’s not, we can debug this by looking at box dimensions by querying a selected box size.

There may be DRCs also if overlapping via or contact arrays (which are autogenerated by Magic) are coming from different cells in the hierarchy. In such cases we may have to do careful alignment of the vias.

<img src="https://user-images.githubusercontent.com/95447782/150619114-47e6d6af-6eba-4053-b2fb-6acf86c8f207.png" alt="drawing" style="width:420px;"/>




Excercise 8:
The seal ring is a fixed layout with some special characteristics and layer usage.
In case Magic can’t read a specific cell, because it can’t find it in the filesystem, it may be because the filepath that it is pointing to is different than what we have in our system so Magic can’t find it.

A useful command in Magic is to be able to change the filepath from which Magic tries to find a cell. After selecting the cell in Magic:
`select cell: seal_ring_corner_abstract_0`
We read the current filepath where Magic is trying to find the cell:
`cellname filepath seal_ring_corner_abstract
/usr/share/pdk/sky130A/libs.tech/magic/seal_ring_generator`
Then we give it a new filepath, the correct one in this case:
`cellname filepath seal_ring_corner_abstract /usr/local/share/pdk/sky130A/libs.tech/magic/seal_ring_generator`

<img src="https://user-images.githubusercontent.com/95447782/150619122-50f4acb1-c634-4576-9d30-093c81eebdc5.png" alt="drawing" style="width:420px;"/>



The seal ring is generated procedurally via a script and then read into Magic. It makes a very non-standard use of the layers. So, what we visualize in Magic is an abstract view of the seal ring that is DRC clean but that does not really look like the real-life seal ring at all, it’s more like a cell with various blockage layers that prevent the user from putting diffusions over it, etc.

We run the seal ring generator script:

`usr/local/share/pdk/sky130A/libs.tech/magic/seal_ring_generator/sky130_gen_sealring.py 2000 2000 seal_test`

where 2000 x 2000 is the outer chip dimensions and seal_test is the target directory.

<img src="https://user-images.githubusercontent.com/95447782/150619128-f82806ea-7aea-47c8-bd9e-2d18be96c4bd.png" alt="drawing" style="width:420px;"/>


The seal ring is generated:

<img src="https://user-images.githubusercontent.com/95447782/150619133-48911984-7a06-4f1c-ab5b-c926e0eaec7e.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150619136-a9be0eba-05de-416c-9735-86e05b1f2853.png" alt="drawing" style="width:420px;"/>

 
Now we can open this seal ring in Magic. We need to add the path to the seal_test directory so Magic can see it and load it, `addpath seal_test` and then `load advSeal_6um_gen`.

<img src="https://user-images.githubusercontent.com/95447782/150619141-70fe529a-a79f-4163-be88-bd5c533b9a23.png" alt="drawing" style="width:420px;"/>

To be able to actually see the seal ring layers, we need to launch Magic with a new techfile configuration which is set up to display the process layers from a GDS much more realistically but without DRC information, so then Magic becomes more like a GDS viewer like Klayout.

This is done with the “gds_magic” launch script which is just launching Magic with a different tech file, as seen below:

<img src="https://user-images.githubusercontent.com/95447782/150619153-a07174d6-877d-4eb8-9a3a-f96a148d7d7d.png" alt="drawing" style="width:420px;"/>

Then we read the seal ring GDS with `gds read seal_test/advSeal_6um_gen`
Now we can see the seal ring.

<img src="https://user-images.githubusercontent.com/95447782/150619157-5ede5785-273a-44e9-82f4-977a4b392d4d.png" alt="drawing" style="width:420px;"/>



Exercise 9:
Importance of tap cells. We expand cells and query them to see the violations report:

<img src="https://user-images.githubusercontent.com/95447782/150619161-8991d9cb-93da-4367-9170-4b0e8e461c18.png" alt="drawing" style="width:420px;"/>

These violations are because these are standard cells, are supposed to be handled by place and route tools and tap cells are supposed to be abutted around them.

As soon as we add the appropriate tap cell, with `getcell sky130_fd_sc_hd__tapvpwrvgnd_1`, the DRCs go away.

<img src="https://user-images.githubusercontent.com/95447782/150619172-1869cba3-8fd2-4e25-8686-5e14473f706c.png" alt="drawing" style="width:420px;"/>



Now, regarding the antenna rules.
Since this is an electrical rule check, it requires an extraction first, to gain knowledge of the circuit.
`extract do local`
`extract all`
Then:
`antennacheck`

But that doesn’t give many details, so we run:
`antennacheck debug`
`antennacheck`

Now we get details, in particular about the ratio of tracks that caused the violation.

<img src="https://user-images.githubusercontent.com/95447782/150619173-7910f548-7499-4f3a-8849-257a5657ee93.png" alt="drawing" style="width:420px;"/>

To fix the antenna violation, we can tie down the route to a diffusion through a diode.
By doing this and running the antenna check again, we see the antenna violation is fixed.

<img src="https://user-images.githubusercontent.com/95447782/150619178-5348a9fa-7ff9-4712-9cd6-473affc1f455.png" alt="drawing" style="width:420px;"/>

With `see no via2,m3` we can hide layers to see where the problematic antenna tracks are.

Excercise 11:
With `cif cover MET1` (or MET2, MET3…) we get the percentage coverage of that metal over the whole layout.

<img src="https://user-images.githubusercontent.com/95447782/150619185-a40dd5ea-a3d1-4a03-a4cf-3687bddd37bb.png" alt="drawing" style="width:420px;"/>

The density checking script looks at a GDS. In Magic we generate a GDS:
`gds write excercise_11`

Then in a terminal we run the script:
`/usr/local/share/pdk/sky130A/libs.tech/magic/check_density.py ./excercise_11.gds`

That runs the density checking script:

<img src="https://user-images.githubusercontent.com/95447782/150619191-41467e4b-5634-427e-a76f-ee7e9a9d358c.png" alt="drawing" style="width:420px;"/>

We now run the “generate_fill.py” script to generate the fill that will fix the density errors.
`/usr/local/share/pdk/sky130A/libs.tech/magic/generate_fill.py ./excercise_11.mag`

<img src="https://user-images.githubusercontent.com/95447782/150619201-38da2b08-586b-4b91-acbc-feda3fbe3d3c.png" alt="drawing" style="width:420px;"/>

 
We open the filled GDS in Magic:
`gds read exercise_11_fill_pattern.gds`.

<img src="https://user-images.githubusercontent.com/95447782/150619205-77244309-37b5-45b1-a7ac-c952f38b7d6f.png" alt="drawing" style="width:420px;"/>

 
To see the fill patterns we hide all layers with `see no *` and then show the metal 2 fill with `see m2fill`.

<img src="https://user-images.githubusercontent.com/95447782/150619213-96c020dc-41fe-49b0-bb63-31ea72804903.png" alt="drawing" style="width:420px;"/>

Then we load the fill onto the original layout:
`box values 0 0 0 0` (this is important, it’s to put the cursor box exactly at the origin)
`getcell excercise_11_fill_pattern child 0 0` (this is also important, to ensure the origin of the imported fill pattern aligns with the origin of the original layout)

<img src="https://user-images.githubusercontent.com/95447782/150619219-711f31ca-73bc-4fbe-8166-f3a1c53cf8ac.png" alt="drawing" style="width:420px;"/>


Understanding PNR and physical verification:
====
**The OpenLane Flow.**
OpenLane is an automated RTL to GDSII flow based on several components including OpenROAD, Yosys, Magic, Netgen, Fault and custom methodology scripts for design exploration and optimization. The flow performs full ASIC implementation steps from RTL all the way down to GDSII.

**OpenLane Design Flow Stages:**

1. **Synthesis:** RTL is converted to Gate level netlist and STA is done.
* RTL synthesis is done with Yosis
* Technology mapping is done with ABC
* Static Timing Analysis is done with OpenSTA.

2. **Floorplanning:** macros are organized in rows as well as routing tracks, then PDN gets generated and well taps and decap cells are inserted.

3. **Placement:** macros and cells are placed.

4. **CTS:** Clock Tree Synthesis is done with TritonCTS.

5. **Routing:** FastRoute does the global routing, then TritonRoute does the detailed routing and SPEF-Extractor does the SPEF extraction.

6. **GDSII** generation is done with Magic to stream out the final GDS from the routed def, Klayout is also used.

7. **Checks** like DRC & Antenna Checks are done in Magic, LVS is done with netgen and CVC is used for circuit validity checks.

**Interactive Vs Non-Interactive modes for OpenLane**
The Openlane flow can be run in Interactive or Non-Interactive modes.

The Non interactive method uses scripts which are run in batch from the terminal in sequence to perform all the stages mentioned above. It is more automated but there is less control at each stage.

The Interactive method lets the user intervene at each stage,  verifying the output of each stage and allowing to make any changes if required.



Running LVS:
====

LVS is the process of comparing two netlists, one from layout and one from schematic.
This is a good summary of LVS extraction options:

<img src="https://user-images.githubusercontent.com/95447782/150654615-67796891-acdd-473f-8e3c-f00067b3a23c.png" alt="drawing" style="width:420px;"/>


Netgen LVS shell command:

<img src="https://user-images.githubusercontent.com/95447782/150654676-a46e0b4c-cdb3-4f9d-af82-2cc97bc18a0f.png" alt="drawing" style="width:420px;"/>

 
Ideally we would like to run a hierarchical LVS where a schematic hierarchy matches exactly the layout hierarchy. But that is not always the case.

<img src="https://user-images.githubusercontent.com/95447782/150654689-391a55ce-8953-473e-b36c-3a035a30bdb5.png" alt="drawing" style="width:420px;"/>

 
In fact, parameterized devices in layout have a wrapper around them so that alone means a difference in hierarchy between schematic and layout.

<img src="https://user-images.githubusercontent.com/95447782/150654692-948d5abd-d7ae-40fb-b53e-56c26608caa8.png" alt="drawing" style="width:420px;"/>

So, netgen will “flatten” the hierarchy by including the contents of the cell below into the cell above, and then do the comparison, if the comparison matches then the two hierarchies are equivalent.
 
 <img src="https://user-images.githubusercontent.com/95447782/150654722-e6c1583f-ac10-40f8-94b0-b720b9191c4a.png" alt="drawing" style="width:420px;"/>

Example of this:

<img src="https://user-images.githubusercontent.com/95447782/150654731-e2ce1ffc-4245-4d8a-8d6f-2bdb7db2822c.png" alt="drawing" style="width:420px;"/>

To deal with this type of scenario (quite common), netgen creates a queue of subcircuits, from bottom most to top most, comparing them in order from the bottom up.

The problem with this is that if there is a mismatch in a low level cell, netgen will flatten it up into the next level, which will again not match, and that will get flatten again up to the next level, which will not match, and so on, so we get a report where nothing matches, from top to bottom, and we don’t know where the specific mismatch is (in this example it’s in the low level cell C, but we don’t know from the report).

 <img src="https://user-images.githubusercontent.com/95447782/150654732-e1444d38-4719-4ff0-ad08-ec990bd08a60.png" alt="drawing" style="width:420px;"/>


To aid in debugging this kind of situation, tt is possible to tell netgen not to flatten certain cells, by telling it `-noflatten=cell_c` likely at the lower levels of the hierarchy, so that if those lower level cells don’t match, but the cells above do match, then we have isolated that we have a mismatch at the lower level cell, so we know where to look and where the error needs fixed.
 
 <img src="https://user-images.githubusercontent.com/95447782/150654744-015d2bfc-16a5-4df2-b895-ae57f5a10bde.png" alt="drawing" style="width:420px;"/>

This is how netgen gets told that, for a certain device type, parallel devices can be lumped together into a single device, and that some of its terminals are permutable, etc.

<img src="https://user-images.githubusercontent.com/95447782/150654755-b9c3eea3-0556-42a6-b092-d2dc5767e594.png" alt="drawing" style="width:420px;"/>

Netgen won’t do network simplification so it must not be assumed that netgen will simplify networks from layout and consider them equivalent to the schematic, because it won’t.

<img src="https://user-images.githubusercontent.com/95447782/150654760-29e97256-ac7b-46ea-951e-b14bb69c08e2.png" alt="drawing" style="width:420px;"/>

However for resistors we do want netgen to combine them in series/parallel.
So, we tell netgen which devices can be combined in series/parallel and with which parameters.

In netgen we can also insert 0V voltage sources or 0 Ohm resistors in the schematic and netgen will still work fine (it will ignore them).

Dummy devices: if netgen sees a device in layout that has all its terminals tied together, then it will consider it’s a dummy device and will ignore it, i.e. you don’t need to have it in the schematic to get a LVS match.


<img src="https://user-images.githubusercontent.com/95447782/150654766-15ddf613-87e2-4dfe-8c77-a3e2b0ae2ba5.png" alt="drawing" style="width:420px;"/>

But if a dummy device doesn’t have all terminals tied together, like a transistor with S, D and B tied together but not the gate, then that’s acting as a MOSCAP and hence you need to backannotate it into the schematic.


<img src="https://user-images.githubusercontent.com/95447782/150654768-925786e7-ecaa-428d-8bf2-d35ffe95b6f7.png" alt="drawing" style="width:420px;"/>

When it comes to analyzing the LVS results, the output format allows a side by side comparison:

<img src="https://user-images.githubusercontent.com/95447782/150654772-3877a476-e46f-4e97-9902-84336d1fdc94.png" alt="drawing" style="width:420px;"/>

Prior to doing any comparison, netgen will dump a list of which cells it flattened because it couldn’t find any circuit in the opposing netlist to match it to (we talked about this before, things like those wrappers around parameterized devices, etc).
  <img src="https://user-images.githubusercontent.com/95447782/150654779-8c7e8005-a4e4-4690-9807-c55f5b49e429.png" alt="drawing" style="width:420px;"/>

Then netgen will do an attempt to do parallel/series combinations of devices, you will see this in the log here:


<img src="https://user-images.githubusercontent.com/95447782/150654781-03f43f59-2469-4dfe-a3c3-8e1c2ea8a9a3.png" alt="drawing" style="width:420px;"/>

Then you get the side by side report. Watch for device counts that have been reduced due to parallel/series combining.

<img src="https://user-images.githubusercontent.com/95447782/150654794-f79839c7-7a78-43dd-b076-395b3e6e1d3a.png" alt="drawing" style="width:420px;"/>

At the end you will see a final sanity check of total number of devices and nets of each side. This is a good place to start when debugging LVS errors.

After that summary, netgen gives you the result of pre-match analysis. Remember the pre-match stage is iterative, it will contain a few iterations, each one with its summary of results in the log, so the first iterations may have errors and that is normal, then on next iteration netgen flattens some cells to see if it can get a better pre-match and run the iteration again, and maybe some of the previous errors are gone in the next iteration, so keep this in mind when visually scanning the log. Erros in some of the initial stages of this pre-match iterative process may be just normal and may not be LVS errors at all, just that netgen was trying to find the good amount of flattening the match both netlists as best as possible.

<img src="https://user-images.githubusercontent.com/95447782/150654820-e91063c7-faec-422f-ad88-769d8f2df45c.png" alt="drawing" style="width:420px;"/>

After that, netgen will present the matching results, it will distinguish between “match” and “unique match”, where match means there were symmetries and matched after breaking those symmetries.

<img src="https://user-images.githubusercontent.com/95447782/150654830-47bdc3e0-cdc9-44fd-b659-fb601a6a7372.png" alt="drawing" style="width:420px;"/>

If topology matching succeeds, then you get the result of property matching. Again it may try more parallel/series combinations to try to get the property matching (width of parallel devices, etc).

<img src="https://user-images.githubusercontent.com/95447782/150654843-c5575dff-5de7-4f4c-8fbe-7ba556302e93.png" alt="drawing" style="width:420px;"/>

If the topology and property matching checks both succeed, then netgen does the pin matching check. Always in that order.

<img src="https://user-images.githubusercontent.com/95447782/150654869-c6d0ebcd-7b3e-4612-9088-39404cadf28e.png" alt="drawing" style="width:420px;"/>

If topology matching fails, netgen will dump a list of failing partitions, that gives you a hint of where the mismatch comes from.

<img src="https://user-images.githubusercontent.com/95447782/150654880-9d8bb732-4135-4439-b733-8373aacf0683.png" alt="drawing" style="width:420px;"/>
 
General debugging rule of thumb: check DEVICE mismatches first, and if all devices are matching ok, then look at NET mismatches, but ONLY look at NET mismatches after you have all DEVICES matching. This is because if there are DEVICE mismatches, that will produce a long list of NET mismatches as a result, which will go away once the DEVICE mismatch is fixed. So go in that order.

Rule of thumb 2 is that LVS debugging is iterative by nature, so fix the easy and obvious errors first, run LVS again, that will remove many other incomprehensible errors, but will still leave some other errors tackling first the ones that are easy to solve, but go in that order until all LVS errors are gone.


<img src="https://user-images.githubusercontent.com/95447782/150654887-60b0d812-1e2e-44e1-820a-30aea87bf72b.png" alt="drawing" style="width:420px;"/>

Another important LVS debug skill is to understand where to find the info that will guide you to successfully finding the source of your LVS errors to be able to fix them. That means understanding the run-time output from netgen is not the same as the full log output. The run-time output is just a summary, useful for a quick look, but should not be used for debugging. The full log (comp.out) has the key details and is what you need to use for debugging.

<img src="https://user-images.githubusercontent.com/95447782/150654901-15f61199-7436-4e34-a3d7-800f976fa9fd.png" alt="drawing" style="width:420px;"/>

 
Netgen has a GUI for debug, you can get it running netgen with `netgen -gui`. The GUI is written in python and it takes the netgen output in json format.

<img src="https://user-images.githubusercontent.com/95447782/150654912-48050803-98ee-4e24-9791-a16372ab83f8.png" alt="drawing" style="width:420px;"/>

The GUI may be handy for debug sometimes, it’s a bit more visual and it doesn’t truncate circuit names (the log output does).


Labs for Day 5:
----
First quick tests with netgen LVS.
We have 2 simple netlists, they are initially the same, we run LVS on them and we get a match. We inspect the log and the comp.out.

Here we run netgen lvs with
`netgen lvs netA.spice netB.spice`

<img src="https://user-images.githubusercontent.com/95447782/150654923-fc3fbd18-4abf-4818-9674-a97fa845552a.png" alt="drawing" style="width:420px;"/>

 
Then we modify one of the netlists to make them mismatch, we run LVS again and we inspect output logs to see how things look like in case of a mismatch like this.
 <img src="https://user-images.githubusercontent.com/95447782/150654927-ce4f80b7-3d31-4c7d-8cae-6278f07b7d04.png" alt="drawing" style="width:420px;"/>

 

If the two netlists have .subckt definitions inside them but no subcircuit instantiations, netgen lvs will not run, unless we, along with the two netlist names, give it also the name of the subcircuit to be compared.

<img src="https://user-images.githubusercontent.com/95447782/150654929-e553b256-eb25-4dc1-a918-8a5b9ae9981b.png" alt="drawing" style="width:420px;"/>


<img src="https://user-images.githubusercontent.com/95447782/150654932-376e16bd-4a54-4d75-867c-b7991b3e7dbe.png" alt="drawing" style="width:420px;"/>


For this scenario, we run netgen lvs like this, giving it the name of the subcircuit to be compared:
`netgen lvs “netA.spice test” “netB.spice test”`
Then the lvs runs and we see the match:

<img src="https://user-images.githubusercontent.com/95447782/150654937-5857c0dc-042e-40ef-8af1-2b04f7c8b3fb.png" alt="drawing" style="width:420px;"/>


We also see the comp.out circuits and pins are the same:

<img src="https://user-images.githubusercontent.com/95447782/150654950-afda815e-4b0d-4dd3-a1e8-73c1bd7befbc.png" alt="drawing" style="width:420px;"/>

Pins of the test subcircuit are matching.

Now we modify the pins order in the test subcircuit, and we see that it’s still a exact match, because netgen doesn’t care that the pins are ordered differently as long as internal connectivity is the same between netlists.

<img src="https://user-images.githubusercontent.com/95447782/150654954-d43fe26e-0fce-4239-b8c6-2e40e7ea63e9.png" alt="drawing" style="width:420px;"/>

But if we now change the internal order of the connections, now netgen sees a mismatch and reports that top level pins are mismatching.

<img src="https://user-images.githubusercontent.com/95447782/150654959-40cc7be3-36cf-46f4-8928-a31667cde56d.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150654962-e4a3b6f4-fdd5-4084-9da9-5b24385690eb.png" alt="drawing" style="width:420px;"/>
 
Also here we prepare our run_lvs.sh script which looks like this:

<img src="https://user-images.githubusercontent.com/95447782/150654967-fa6b64fb-6c50-4417-bf11-ab8736abd4db.png" alt="drawing" style="width:420px;"/>


This will produce the json output which is used by the “count_lvs.py” python script and it will append the output of that script to the log, an lvs count summary that looks like this: 

<img src="https://user-images.githubusercontent.com/95447782/150654968-53732d23-0afe-48b9-9cc4-8e0faae49e83.png" alt="drawing" style="width:420px;"/>



Now we deal with empty subcircuit definitions which can be treated as black boxes by netgen.

<img src="https://user-images.githubusercontent.com/95447782/150654972-2fdbf54c-5149-4739-8155-afabda19f4fc.png" alt="drawing" style="width:420px;"/>

Initially all cells have matching pins.

<img src="https://user-images.githubusercontent.com/95447782/150654977-795d0a0c-737d-4f32-882d-bb2a9418491c.png" alt="drawing" style="width:420px;"/>

But if we change on cell1 the order of pins from A B C to C B A
Now we get a mismatch. 
 
 <img src="https://user-images.githubusercontent.com/95447782/150654982-34cf366c-f9ae-4e5c-b68a-7de665456033.png" alt="drawing" style="width:420px;"/>

Here we see it has treated pin names as meaningful:
 
 <img src="https://user-images.githubusercontent.com/95447782/150654983-e7b8d273-e2fd-48c2-aed1-178e8ca6765b.png" alt="drawing" style="width:420px;"/>

Now if we change pin names on cell1 to be A B D instead of A B C, then it finds that D is missing on cell1 in netlistB and C is missing on cell1 in netlistA.

<img src="https://user-images.githubusercontent.com/95447782/150654987-43c08aa4-2aff-4193-8b3e-fa81781cb226.png" alt="drawing" style="width:420px;"/>

Now, if we change the cell name from cell1 to cell4 in netlistA (leaving pins as A B C), both in the definition and in the instantiation, now we get a unique match again. This is because the cell name is cell4 in netlistA and cell1 in netlisB, but other than that the connectivity is exactly the same in both netlists, so netgen understands that cell4 on netlistA is equivalent to cell1 in netlistB.

<img src="https://user-images.githubusercontent.com/95447782/150654991-0e2ad9c7-428d-46b4-8862-d9e6aa656613.png" alt="drawing" style="width:420px;"/>

In fact, we see it achieves this because first it notices that there is not cell4 in netlisB so it goes ahead and flattens cell4, and then both netlists are equivalent.

<img src="https://user-images.githubusercontent.com/95447782/150654994-614045ce-210f-45e3-80d4-b3f462c66cac.png" alt="drawing" style="width:420px;"/>

If we run lvs with the `-blackbox` option, it forces netgen to treat cell1 to cell4 as blackboxes, and therefore cell4 is one particular blackbox and cell1 is a different blackbox, so then the lvs shows a mismatch, as now cell4 cannot be flattened or considered equivalent to cell1.

<img src="https://user-images.githubusercontent.com/95447782/150654998-07e2b27b-3047-43a2-901c-91dcb686b86b.png" alt="drawing" style="width:420px;"/>


Now we have a netlist with SPICE components (R, C, Diode…) as opposed to just subcircuits (which start by X).

<img src="https://user-images.githubusercontent.com/95447782/150655003-5754109a-7191-4e6f-b298-8a26c9ab27a7.png" alt="drawing" style="width:420px;"/>

In cell1, we swap out the pins from A B C to C B A. Inside cell1 we only have 2 resistors attached to A B and B C respectively, and resistor terminals are swappable, but netgen still sees a mismatch due to the swapped pins A and C.

That’s because we have not told netgen that for cell1 pins A and C are permutable. We need to tell it so in the setup.tcl file, as follows:
At the bottom of the setup.tcl file:

<img src="https://user-images.githubusercontent.com/95447782/150655010-95293191-3a75-4155-b544-da67a27494ed.png" alt="drawing" style="width:420px;"/>

Inside the .sh run script, use the new .tcl:

<img src="https://user-images.githubusercontent.com/95447782/150655013-d4e59abd-b100-44d4-9c35-7d479df6f0b8.png" alt="drawing" style="width:420px;"/>


Now we get a match.

<img src="https://user-images.githubusercontent.com/95447782/150655015-c7b5e65c-d40f-40b4-b4c6-95856e36c541.png" alt="drawing" style="width:420px;"/>

That’s because in cell1 there are resistors which are swappable, but in cell3 we have diodes which aren’t swappable, so if we swap pin names on cell3 (while at the same time swapping internal net connections to keep overall connectivity in cell3) and run that past lvs, it passes lvs this time.

Then we move to an example POR circuit from Caravel analog project.

<img src="https://user-images.githubusercontent.com/95447782/150655019-fe7b32ed-d6a8-442a-a425-3d3b09863b2a.png" alt="drawing" style="width:420px;"/>

If we netlist directly from xschem by pressing Netlist buttom directly, we get a netlist but it’s not proper for lvs, since it has a top level subcircuit definition commented out at the top.

<img src="https://user-images.githubusercontent.com/95447782/150655021-c8fbfe80-53bb-413a-aa69-ea1a731a2c74.png" alt="drawing" style="width:420px;"/>

So in xschem we need to enable Simulation → “LVS netlist: Top level is a .subckt”, then we can Netlist.
 
 <img src="https://user-images.githubusercontent.com/95447782/150655026-25d10718-9852-4050-a3c2-9cd477adccb1.png" alt="drawing" style="width:420px;"/>

Now the top level .subckt is not commented out:

<img src="https://user-images.githubusercontent.com/95447782/150655027-304c50ce-6b74-497f-8635-da9d0f4ce658.png" alt="drawing" style="width:420px;"/>

In this netlist, transistors and also resistors are not simple SPICE primitives but subcircuits, this is standard practice in PDKs.

In order to tell netgen to treat these particular subcircuits as if they were low level primitives, we need to tell it to do so, and we do that in the setup.tcl file that netgen uses.

For example, that file contains some Tcl loops to inform netgen that it is fine to do some pin permutations, parallel/series combinations, etc, for certain subcircuits that we want netgen to treat as a low level primitives.

<img src="https://user-images.githubusercontent.com/95447782/150655030-21f6dd35-0b5a-4941-9a16-716f71fe508f.png" alt="drawing" style="width:420px;"/>

Now we open the circuit layout and we extract the netlist from the layout, for LVS.
`extract do local`
`extract all`
`ext2spice lvs`
`ext2spice`

<img src="https://user-images.githubusercontent.com/95447782/150655033-138b5a6b-456f-475f-9420-f471bace35bf.png" alt="drawing" style="width:420px;"/>

 
We then run netgen LVS with the provided run_lvs_wrapper.sh:
 
 <img src="https://user-images.githubusercontent.com/95447782/150655037-cf4f3683-3558-43d9-baec-38fec657d839.png" alt="drawing" style="width:420px;"/>

We get some mismatches.
 
 <img src="https://user-images.githubusercontent.com/95447782/150655044-b2531b9b-368f-4757-9126-0cb9fd872a55.png" alt="drawing" style="width:420px;"/>

Inside the comp.out we see the cause of the LVS mismatch is due to the standard cells:
 
 <img src="https://user-images.githubusercontent.com/95447782/150655048-75b14c7d-0ec4-487e-b7a6-fa39c7033919.png" alt="drawing" style="width:420px;"/>

Standard cells are not included in the schematic netlist, and without a proper subcircuit definition netgen just names the standard cell pins as 1, 2, 3, … 6, whereas in the layout standard cells appear as proper subcircuits with their pins named with sensible names, and netgen considers they are not necessarily the same thing on both sides, so it propagates the pin name mismatch to the top level and thus the LVS ends up not being clean.

So we need to provide a proper subcircuit definition for the standard cells.

We will get that from the corresponding testbench that is supposed to test this schematic.

<img src="https://user-images.githubusercontent.com/95447782/150655053-29fe3a34-af2f-4db5-8812-5625368d6553.png" alt="drawing" style="width:420px;"/>

From that TB we see it has a block of code with includes for the standard cell libraries.
We netlist this TB (no need to enable the Simulation LVS blabla option this time) and therefore we get those standard cell include lines printed into the netlist.

<img src="https://user-images.githubusercontent.com/95447782/150655054-b1ad23cd-b7e1-4265-8b7f-d9aaefad9bcd.png" alt="drawing" style="width:420px;"/>

We will LVS the layout agains this netlist now.

<img src="https://user-images.githubusercontent.com/95447782/150655057-4752ccd4-5e4f-4aea-abb3-8cfa098fdd98.png" alt="drawing" style="width:420px;"/>

Now we get the LVS match, except for some unmatched pins.

<img src="https://user-images.githubusercontent.com/95447782/150655060-b6462b19-3fa8-4462-a836-19609aee2546.png" alt="drawing" style="width:420px;"/>

Now we run the netgen LVS with a run script that tells netgen to compare the LVS not of the top level but of the “example_por” cell that is instantiated in the schematic.

<img src="https://user-images.githubusercontent.com/95447782/150655064-0ef1b056-9bf5-42b9-8c56-dab43b84bf26.png" alt="drawing" style="width:420px;"/>

And we see the “example_por” cells are LVS clean.
 
 <img src="https://user-images.githubusercontent.com/95447782/150655065-3d566239-12d5-4e88-acde-24ef78c58f6c.png" alt="drawing" style="width:420px;"/>

These are the pin mismatches in the wrapper:

<img src="https://user-images.githubusercontent.com/95447782/150655066-2d328f09-3f7b-41bd-9f9d-8fba9fc9bca2.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150655070-fa535c1e-8b1e-4c02-9f75-00fc0bf6e8bb.png" alt="drawing" style="width:420px;"/>

 
Important shortcut key in Magic, `s s s` to select a whole net, important for tracing through the layout along various layers.

We find that io_analog[4] is tied to io_clamp_high[0], not an error but two pins on same metal track, so let’s split them by a metal 3 resistor shortcircuit (paint rmetal3).

<img src="https://user-images.githubusercontent.com/95447782/150655077-748f56e0-5674-42df-b5ea-162fb7e1b0ca.png" alt="drawing" style="width:420px;"/>

<img src="https://user-images.githubusercontent.com/95447782/150655078-b87c930a-2abc-4c8a-b05d-68d582fb89bf.png" alt="drawing" style="width:420px;"/>

 
The same resistor must be added to the schematic in xschem:

<img src="https://user-images.githubusercontent.com/95447782/150655082-1987f2cf-0784-4ce8-a7ff-26dec718bdcd.png" alt="drawing" style="width:420px;"/>

Then we can netlist again and run LVS again. Still there are 9 pins mismatching due to being shorted to vssa1 and vssd1 in the layout, and therefore need resistors added to separate the two nets as well. Again, we need to add equivalent resistors in xschem, then run netgen lvs again will get it LVS clean.

Another important command in Magic is `goto {io_oeb[11]}` (name of the desired pin between brackets) and that will let us zoom into the right pin. Once that is selected, we can type `getnode` and that will tell us what net that pin is connected to, and se can see the shorts to vssd1.

Excercise 6:
We are going to LVS a layout against a verilog netlist, in this case a digital PLL.
First we extract the layout netlist and we run LVS agains the verilog netlist “digital_pll.v” which is a verilog netlist (i.e. not behavioural verilog but a netlist).
LVS fails and upon looking at the log we see missing fill cells and tap cells in the layout:

<img src="https://user-images.githubusercontent.com/95447782/150655086-4b835906-b995-4cb7-9e28-8e5161227702.png" alt="drawing" style="width:420px;"/>

We see that the fill cells in the verilog netlist are called FILLER_0_11, we search for any of those in the extracted layout netlist to see if they are there or not, but it’s not there.

We go back to Magic to see if that FILLER_0_11 is there or not, we search for it with (important Magic command):
`select FILLER_0_11`
And indeed it’s there.

<img src="https://user-images.githubusercontent.com/95447782/150655094-e660aaef-10e9-4860-8cbf-345e8289b6c1.png" alt="drawing" style="width:420px;"/>

If we push (descend) into the cell with > key, we see it’s a quite simple thing so what happens is that the extractor has optimized it out because it doesn’t have any active device or anything “circuit-like”.

To fix this, we edit the netgen setup.tcl file. We find the section where it talks about fill.

<img src="https://user-images.githubusercontent.com/95447782/150655097-53235a34-c927-4962-b6cb-8c6fb10576b6.png" alt="drawing" style="width:420px;"/>

We are going to assume that this layout (for digital_pll.v or similar placed-and-routed layout) comes from a PNR tool, rather than from a human. Hence we are going to assume the PNR tool is fine enough that we can trust it will never put fill and tap cells in any wrong place, or upside down, or overlapping something else causing a short, or an open, etc… So we are going to make it so that netgen completely ignores these fill cells.
For that, we set this environment variable MAGIC_EXT_USE_GDS. We put it inside netgen’s setup.tcl file.

<img src="https://user-images.githubusercontent.com/95447782/150655140-77289bdc-df66-4067-b804-82c3b2ccae7a.png" alt="drawing" style="width:420px;"/>

And that way we get a match!

<img src="https://user-images.githubusercontent.com/95447782/150655143-b7ba6794-86d3-4c35-9991-8f826837e567.png" alt="drawing" style="width:420px;"/>

Excercise 9:
LVS with property errors.
After extracting the layout and netlisting the schematic, we run LVS and see property errors in some devices.

<img src="https://user-images.githubusercontent.com/95447782/150655357-c355f0d9-f849-4502-b7e8-7f0c421c34a0.png" alt="drawing" style="width:420px;"/>

We use this information to see exactly what caps, resistors and transistors we need to edit, in this case in the schematic, to get the LVS match again.

For the resistors and caps, we change their properties in the schematic.

<img src="https://user-images.githubusercontent.com/95447782/150655362-86138425-d863-4afd-a1a8-ac5b3c7504fe.png" alt="drawing" style="width:420px;"/>

For the transistor, we change it in the layout from 2 fingers to 1 finger.
For this, we first locate the specific transistor which is sky130_fd_pr__nfet_g5v0d10v5_8KW54N_0.


<img src="https://user-images.githubusercontent.com/95447782/150655365-aecbee23-d69c-48b3-9c63-428f6f6d217c.png" alt="drawing" style="width:420px;"/>

And we get an LVS match.

<img src="https://user-images.githubusercontent.com/95447782/150655368-fbf7da65-77ea-4f39-8b6a-7265a870be5f.png" alt="drawing" style="width:420px;"/>


References
===
Skywater 130 PDK: https://github.com/google/skywater-pdk

Open_PDKS: http://www.opencircuitdesign.com/open_pdks/

Xschem: http://repo.hu/projects/xschem/xschem_man/xschem_man.html

VSD Physical Verification using SKY130: https://www.vlsisystemdesign.com/physical-verification-using-sky130/



