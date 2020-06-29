BIN=openscad
VIEW_SIZE=256,256

all: top

%.stl: %.scad
	$(BIN) -o $@ $<

%.png: %.scad
	$(BIN) --render --imgsize=$(VIEW_SIZE) -o $@ $<

top: rasppi2.stl rasppi2.png
	mv rasppi2.stl rasppi2_TOP.stl
	mv rasppi2.png rasppi2_TOP.png
	display rasppi2_TOP.png &

bottom: rasppi2.stl
	ls

box: rasppi2.stl
	ls

design:
	openscad rasppi2.scad &
