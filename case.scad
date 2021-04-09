/*  RASPBERRY PI4 case

multiple layer case

- base: mimic alu. case-C (might be replaced by the WaveShare passive cooling box)
- cover: top part (3D printed)

*/

///use library.scad
//see https://github.com/coupdair/library.scad
use <../library.scad/raspberrypi.scad>

///Version
version="v0.0.5";

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
}//bbox

//oLED box
/*
  w: width
  h: height
  d: depth
  o: oLED
  m: margin
*/
module obox(w=92,h=62,d=16.4, wo=26,ho=11, m=0.5,hm=2.5)
{
  translate([-w/2,-h/2,-5])
  difference()
  {
    //box
    cube([w,h,d]);
    //oLED hole
    translate([17.5-m,-m,-m]) cube([wo+2*m,ho+2*m+hm,d+2*m]);
  }
}//obox

//LEMO
/*
  l: length
  h: height
*/
module lemo(l=22,r=3.5, x=6,y=16,z=33.5, dx=0,dy=0)
{
  translate([x,y+dy,z+dx]) rotate([0,90,0]) cylinder(r=r, h=l);
}//lemo

//button
/*
  l: length
  h: height
*/
module button(l=10,r=3, x=-16,y=-12,z=33.5, dx=0,dy=0)
{
  translate([x+dx,y+dy,z]) cylinder(r=r, h=l);
}//button

//LED
/*
  r: radius
*/
module led(r=3, x=-16,y=10,z=42, dx=0,dy=0)
{
  translate([x+dx,y+dy,z]) sphere(r=r);
}//led

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
bbox(d=16.4);
///lower box
translate([0,0,16.4]) bbox(d=7);
///middle box
translate([(72-92)/2,0,16.4+7]) bbox(w=72, d=2.5);

///upper box
translate([(72-92)/2,0,16.4+7+2.5]) obox(w=72,d=12);

///cover box
translate([(72-92)/2,0,16.4+7+2.5+12]) obox(w=72,d=10);

//lemo
color("gray")
{
//lemo();
lemo(dx=5,dy=8);
lemo(dx=-5,dy=8);
lemo(dx=5,dy=-8);
lemo(dx=-5,dy=-8);

lemo(dx=5,dy=-32);
lemo(dx=-5,dy=-32);
}//lemo

//button
color("red")
{
//button();
button(dx=5);
button(dx=-5);
button(dx=15);
button(dx=-15);
}//button

//led
color("green")
{
//led();
led(dx=5);
led(dx=-5);
led(dx=15);
led(dx=-15);
}//led
