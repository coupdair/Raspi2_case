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
	openscad --version 2>&1 | cut -d' ' -f3 | tee -a VERSION

#cover: case.stl case.png
cover: version
	$(BIN) -D 'BOX="cover"' -o box_cover.stl case.scad
#	mv case.png case_cover.png
#	display case_cover.png &

upper: version
	$(BIN) -D 'BOX="upper"' -o box_upper.stl case.scad

middle: version
	$(BIN) -D 'BOX="middle"' -o box_middle.stl case.scad

lower: version
	$(BIN) -D 'BOX="lower"' -o box_lower.stl case.scad

stl: cover upper middle lower
	make version

box: version case.png
	$(BIN) -D 'BOX="all"' -o box.stl case.scad

design:
	openscad case.scad &
