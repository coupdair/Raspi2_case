BIN=openscad
VIEW_SIZE=512,512
DESIGN=case.scad

all: stl

#%.stl: %.scad
#	$(BIN) -o $@ $<

#need 2015.03
%.png:
	$(BIN) --render --imgsize=$(VIEW_SIZE) -D 'BOX="$(basename $@)"' -o box_$@ $(DESIGN)
	@echo "display box_$@ &"

version:
	grep version case.scad | head -n 1 | cut -d'=' -f2 | sed "s/\"//g;s/;//g" | tee VERSION
	openscad --version 2>&1 | cut -d' ' -f3 | tee -a VERSION

cover: version cover.png
	$(BIN) -D 'BOX="$@"' -o box_$@.stl $(DESIGN)
	@echo "display $@.png &"
	@echo "blender box.stl  &"

upper: version upper.png
	$(BIN) -D 'BOX="$@"' -o box_$@.stl $(DESIGN)
	@echo "display $@.png &"
	@echo "blender box.stl  &"

middle: version middle.png
	$(BIN) -D 'BOX="$@"' -o box_$@.stl $(DESIGN)
	@echo "display $@.png &"
	@echo "blender box.stl  &"

lower: version lower.png
	$(BIN) -D 'BOX="$@"' -o box_$@.stl $(DESIGN)
	@echo "display $@.png &"
	@echo "blender box.stl  &"

stl: cover upper middle lower
	make version

projection: version
	$(BIN) -D 'BOX="$@"' -o box_$@.stl $(DESIGN)

box: version full.png
	mv box_full.png $@.png
	$(BIN) -D 'BOX="full"' -o box.stl $(DESIGN)
	@echo "display $@.png &"
	@echo "blender box.stl  &"

design:
	openscad case.scad &
