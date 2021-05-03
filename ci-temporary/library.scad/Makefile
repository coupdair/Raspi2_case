BIN=openscad
VIEW_SIZE=512,512
DESIGN=raspberrypi.scad

# ex.: "make pi3" will do:
# openscad --render --imgsize=512,512 -D 'part="pi3"' -o pi3.png raspberrypi.scad
# openscad -D 'part="pi3"' -o pi3.stl raspberrypi.scad

all: zero pi3 pi4

%.stl:
	$(BIN) -D 'part="$(basename $@)"'  -o $@ $(DESIGN)

#need 2015.03
%.png: %.scad
	$(BIN) --render --imgsize=$(VIEW_SIZE) -D 'part="$(basename $@)"' -o $@ $(DESIGN)

version:
	@grep version $(DESIGN) | head -n 1 | cut -d'=' -f2 | sed "s/\"//g;s/;//g" | tee VERSION
	@openscad --version 2>&1 | cut -d' ' -f3 | tee -a VERSION

zero: version zero.png zero.stl
	@echo "display $@.png &"
	@echo "blender $@.stl &"

pi3: version pi3.png pi3.stl
	@echo "display $@.png &"
	@echo "blender $@.stl &"

pi4: version pi4.png pi4.stl
	@echo "display $@.png &"
	@echo "blender $@.stl &"

clean:
	rm *.png *.stl

design:
	openscad $(DESIGN) &
