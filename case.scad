/*  RASPBERRY PI4 case

multiple layer case

- base: mimic alu. case-C (might be replaced by the WaveShare passive cooling box)
- cover: top part (3D printed)

*/

///use library.scad
//see https://github.com/coupdair/library.scad
use <../library.scad/raspberrypi.scad>

///Version
version="v0.0.5k";

///Box output (e.g. on CLI: -D 'BOX="bottom"')
//BOX="top";
//BOX="bottom";
BOX="full";

//RPi4
pi4();

//PCB and component margins
%hull()
{
  piB_PCB();
  translate([0,0,6.54321]) piB_PCB();
}

//PoE HAT
translate([(65-85)/2,0,21]) WS_PoE_PCB();
//LEMO HAT
translate([(65-85)/2,0,21+12]) LEMO_PCB();

//case
///base box
%translate([-92/2,-62/2,-4.321]) cube([92,62,16.4]);
