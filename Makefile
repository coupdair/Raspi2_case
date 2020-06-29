BIN=openscad
VIEW_SIZE=256,256

all: top bottom

#%.stl: %.scad
#	$(BIN) -o $@ $<

%.png: %.scad
	$(BIN) --render --imgsize=$(VIEW_SIZE) -o $@ $<

#top: rasppi2.stl rasppi2.png
top:
	$(BIN) -D 'BOX="top"' -o box_TOP.stl rasppi2.scad
#	mv rasppi2.png rasppi2_TOP.png
#	display rasppi2_TOP.png &

bottom:
	$(BIN) -D 'BOX="bottom"' -o box_bottom.stl rasppi2.scad

box:
	$(BIN) -o box.stl rasppi2.scad

design:
	openscad rasppi2.scad &
