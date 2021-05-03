BIN=openscad
VIEW_SIZE=512,512
DESIGN=case.scad

all: version cover upper middle lower

%.stl:
	$(BIN) -D 'BOX="$(basename $@)"' -D 'PRINT=true' -o box_$@ $(DESIGN)
#	$(BIN) -D 'BOX="$(basename $@)"' -D 'PRINT=true' -D '$fn=75' -o box_$@ $(DESIGN)
	@echo "blender box_$@ &"

#need 2015.03
%.png:
	$(BIN) --render --imgsize=$(VIEW_SIZE) -D 'BOX="$(basename $@)"' -o box_$@ $(DESIGN)
	@echo "display box_$@ &"

version:
	@grep version case.scad | head -n 1 | cut -d'=' -f2 | sed "s/\"//g;s/;//g" | tee VERSION
	@openscad --version 2>&1 | cut -d' ' -f3 | tee -a VERSION

cover:  version cover.png  cover.stl

upper:  version upper.png  upper.stl

middle: version middle.png middle.stl

lower:  version lower.png  lower.stl

stl: version cover.stl upper.stl middle.stl lower.stl buttons.stl

png: version cover.png upper.png middle.png lower.png

show_png:
	display box_cover.png box_upper.png box_middle.png box_lower.png &

projection: version
	$(BIN) -D 'BOX="$@"' -o box_$@.dxf $(DESIGN)
	$(BIN) -D 'BOX="$@"' -o box_$@.svg $(DESIGN)
	@echo "librecad box_$@.dxf &"
	@echo "inkscape box_$@.svg &"

box: version full.png
	mv box_full.png $@.png
	$(BIN) -D 'BOX="full"' -o box.stl $(DESIGN)
	@echo "display $@.png &"
	@echo "blender box.stl  &"

design:
	openscad case.scad &

#CI temporary
update:
	./ci-temporary.sh update
