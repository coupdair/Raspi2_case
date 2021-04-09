/*  RASPBERRY PI4 case

multiple layer case

- base: mimic alu. case-C (might be replaced by the WaveShare passive cooling box)
- cover: top part (3D printed)

*/

///use library.scad
//see https://github.com/coupdair/library.scad
use <../library.scad/raspberrypi.scad>

///Version
version="v0.0.5s";

///Box output (e.g. on CLI: -D 'BOX="bottom"')
//BOX="top";
//BOX="bottom";
BOX="full";

//boundary box
/*
  w: width
  h: height
  d: depth
*/
module bbox(w=92,h=62,d=16.4)
{
  translate([-w/2,-h/2,-5]) cube([w,h,d]);
}

//oLED box
/*
  w: width
  h: height
  d: depth
  o: oLED
  m: margin
*/
module obox(w=92,h=62,d=16.4, wo=26,ho=11, m=1,hm=3)
{
  translate([-w/2,-h/2,-5])
  difference()
  {
    //box
    cube([w,h,d]);
    //oLED hole
    translate([18-m,-m,-m]) cube([wo+2*m,ho+2*m+hm,d+2*m]);
  }
}

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
%bbox(d=16.4);
///lower box
%translate([0,0,16.4]) bbox(d=7);
///middle box
%translate([(72-92)/2,0,16.4+7]) bbox(w=72, d=2.5);

///upper box
%translate([(72-92)/2,0,16.4+7+2.5]) obox(w=72,d=12);
///cover box
%translate([(72-92)/2,0,16.4+7+2.5+12]) obox(w=72,d=10);
