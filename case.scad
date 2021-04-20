/*  RASPBERRY PI4 case

multiple layer case

- base: mimic alu. case-C (might be replaced by the WaveShare passive cooling box)
- cover: top part (3D printed)

*/

///use library.scad
//see https://github.com/coupdair/library.scad
use <../library.scad/raspberrypi.scad>

///Version
version="v0.0.8f";

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
module lemo(l=17.5,r=3.5,b=7, x=9,y=16,z=33, dx=0,dy=0)
{
  translate([x,y+dy,z+dx]) rotate([0,90,0]) cylinder(r=r, h=l);
  translate([x,y-b/2+dy,z-b/2+dx]) cube([b,b,b]);
}//lemo

//button
/*
  l: length
  h: height
*/
module button(l=10,r=3,b=5,h=2.54,bh=1.23, x=-16,y=-12,z=33.5, dx=0,dy=0)
{
  translate([x+dx,y+dy,z+h+bh]) cylinder(r=r, h=l-h-bh);
  translate([x-b/2+dx,y-b/2+dy,z]) cube([b,b,h]);
}//button

//LED
/*
  r: radius
*/
module led(r=1.5,h=9, x=-16,y=0,z=43, dx=0,dy=0, space=0.123)
{
  translate([x+dx,y+dy,z])
  {
    sphere(r=r);
    translate([0,0,-h-space]) cylinder(r=1.23*r, h=h);
  }
}//led

//UART
/*
  l: length
  h: height
*/
module serial(w=3*2.5,h=2.5,d=14, space=-0.3, x=7.5+2*2.5-42.5,y=24.5,z=34.5)
{
  color("gray") translate([x,y,z+space]) cube([w,h,d]);
}//serial

//I2C header driver
/*
  l: length
  h: height
*/
module i2c_header(pins=3, rows=2, x=19,y=4.25,z=34.5+1)
{
  translate([x,y,z]) rotate([90,0,90]) header(pins, rows);
}//i2c_header

//I2C header software
/*
  l: length
  h: height
*/
module i2c_headerS(pins=4, rows=1, x=-12,y=4.25,z=34.5-2.5)
{
  translate([x,y,z]) rotate([270,0,90]) header(pins, rows);
}//i2c_headerS

///lower box
module box_lower(tx=34,ty=14,tz=2-0.25)
{
  translate([0,0,16.4]) 
  {
    //bb
    bbox(d=7);
    ///PoE
    color("Violet") translate([tx,ty,tz]) rotate([0,0,0])
      cube([10,10,0.5]);//bb
//      linear_extrude(height = 0.5) text(text="PoE");
  }
}//box_lower

///upper box
module box_upper(tx=36-0.25,ty=-7/2,tz=5)
{
  translate([(72-92)/2,0,16.4+7+2.5])
  {
    //bb
    obox(w=72,d=12);
    //labels
    ///I2C//data/clock
    color("Violet") translate([tx,ty,tz]) rotate([0,90,0])
      cube([10,16+2*(7/2),0.5]);//bb
//      linear_extrude(height = 0.5) text(text="I2C\ndata clock");
    ///reset
    color("Violet") translate([tx,ty-16-4,tz]) rotate([0,90,0])
      cube([5,16,0.5]);//bb
//    linear_extrude(height = 0.5) text(text="reset");
  }
}//box_upper



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
LEMO_HAT(withHeader=true);

//case
///base box
bbox(d=16.4);
///lower box
box_lower();
///middle box
translate([(72-92)/2,0,16.4+7]) bbox(w=72, d=2.5);
///upper box
%box_upper();
///cover box
%translate([(72-92)/2,0,16.4+7+2.5+12]) obox(w=72,d=10);

module devices()
{

//UART
serial();

//I2C#1 header
i2c_header();

//I2C#3 header
i2c_headerS();

//lemo
color("gray")
{
//lemo();
lemo(dx=5,dy=0);
lemo(dx=5,dy=-16);
lemo(dx=5,dy=-32);
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

//power led
color("orange")
{
//led();
led(dx=-22, dy=16);
led(dx=-22, dy=8);
}//led

}//devices

!projection(){// // // // //
devices();
translate([100,0,0]) LEMO_PCB();
}//projection// // // // //
