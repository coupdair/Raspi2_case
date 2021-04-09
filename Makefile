BIN=openscad
VIEW_SIZE=256,256

#all: version top bottom
all: version

#%.stl: %.scad
#	$(BIN) -o $@ $<

%.png: %.scad
	$(BIN) --render --imgsize=$(VIEW_SIZE) -o $@ $<
version:
	grep version case.scad | head -n 1 | cut -d'=' -f2 | sed "s/\"//g;s/;//g" | tee VERSION

#top: case.stl case.png
top: version
	$(BIN) -D 'BOX="top"' -o box_TOP.stl case.scad
#	mv case.png case_TOP.png
#	display case_TOP.png &

bottom: version
	$(BIN) -D 'BOX="bottom"' -o box_bottom.stl case.scad

box: version
	$(BIN) -o box.stl case.scad

design:
	openscad case.scad &
