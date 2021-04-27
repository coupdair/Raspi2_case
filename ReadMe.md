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

TODO

make STL files

`make`

## stack

WinP

make only SLICE=[lower,middle,upper,cover] STL file

`make $SLICE`, e.g. `make cover`

# dev.

# DONE

- v add BOX variable for projection, full, cover, ...
- v on 2015.03-2, cover box with PCB diff.
- v STL: "make cover" do "box_cover.stl" file

## TODO

### high priority

- _ add temperature probe holer on lower box
- . put oLED in projection (and PCB contours and hole only)
- _ minkowski on PCB differences (instead of for(m... )

### medium priority

- . text with OpenSCAD version higher
- _ check sizes: USB, Eth, hole for oLED (PCB <-> cover box)
- _ screwing procedure

### low priority

- _ move code to files: box_stack.scad, HAT.scad, devices.scad, LEMO_HAT.scad, ...
- _ add make projection, make STL, ...
- _ add handles on lower box for mechanical fixing, e.g. 2 M6 screws on sides close to middle box screws.

## BUG

- OpenSCAD 2015.03: after many F5 render, empty render, but F6 is ok, reload OpenSCAD !
