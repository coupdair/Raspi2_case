BIN=openscad
VIEW_SIZE=256,256

all: top

%.stl: %.scad
	$(BIN) -o $@ $<

%.png: %.scad
	$(BIN) --render --imgsize=$(VIEW_SIZE) -o $@ $<

top: rasppi2.stl
	mv rasppi2.stl rasppi2_TOP.stl

bottom: rasppi2.stl
	ls

box: rasppi2.stl
	ls

