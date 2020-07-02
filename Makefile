BIN=openscad
VIEW_SIZE=256,256

all: version top bottom

#%.stl: %.scad
#	$(BIN) -o $@ $<

%.png: %.scad
	$(BIN) --render --imgsize=$(VIEW_SIZE) -o $@ $<
version:
	grep version rasppi2.scad | head -n 1 | cut -d'=' -f2 | sed "s/\"//g;s/;//g" | tee VERSION

#top: rasppi2.stl rasppi2.png
top: version
	$(BIN) -D 'BOX="top"' -o box_TOP.stl rasppi2.scad
#	mv rasppi2.png rasppi2_TOP.png
#	display rasppi2_TOP.png &

bottom: version
	$(BIN) -D 'BOX="bottom"' -o box_bottom.stl rasppi2.scad

box: version
	$(BIN) -o box.stl rasppi2.scad

design:
	openscad rasppi2.scad &
