# RPi4_case

Raspberry Pi4 case in openscad

3D printable Raspberry Pi case.

![3D view](3Dview.png)

# design

`make design`

![3D transparent view](3Dview_tranparent.png)

![cover](box_cover.png)

![upper](box_upper.png)

![middle](box_middle.png)

![lower](box_lower.png)

![commercial base](base_box.png)

# print

## all

make STL files

`make`

## stack

make only SLICE=[lower,middle,upper,cover] STL file

`make $SLICE`, e.g. `make cover`

# dev.

## TODO

- put oLED in projection (and PCB contours and hole only)
- text with OpenSCAD version higher
- check sizes: USB, Eth, hole for oLED (PCB <-> cover box)
- screwing procedure
- move code to files: box_stack.scad, HAT.scad, devices.scad, LEMO_HAT.scad, ...
- add make projection, make STL, ...

## BUG

- cover box without PCB diff. (too much objects, choose either PCB or LED difference, not both)
