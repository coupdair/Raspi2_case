/*  RASPBERRY PI4 case

multiple layer case

- base: mimic alu. case-C (might be replaced by the WaveShare passive cooling box)
- cover: top part (3D printed)

*/

///use library.scad
//see https://github.com/coupdair/library.scad
use <../library.scad/raspberrypi.scad>

///Version
version="v0.1.5e";

///bounding box
bbox=false;
//bbox=true;

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
module obox(w=92,h=62,d=16.4, do=17.5,wo=26,ho=11, m=0.5,hm=2.5)
{
  translate([-w/2,-h/2,-5])
  difference()
  {
    //box
    cube([w,h,d]);
    //oLED hole
    translate([do-m,-m,-m]) cube([wo+2*m,ho+2*m+hm,d+2*m]);
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
module box_lower(w=92,h=62,d=7, t=2, tx=34,ty=14,tz=2-0.25, bbox=true)
{
  dx=(72-92)/2;
  sx=-2*dx;
  translate([0,0,16.4]) 
  {
    //USB/RJ45 top
    translate([92/2+dx,0,-5+d-t/2]) box_plane(-sx/2-t,sx/2-t,-h/2+t,h/2-t);
    //USB/RJ45 sides
    translate([92/2+dx-t/2,0,-5]) box_sides(w=sx+t,d=d-t/2);
    //PCB sides
    translate([dx,0,-5]) box_sides(d=d);
    //colomns
    translate([dx,0,-5]) box_columns(d=d);
    //bounding box
    if(bbox==true) %bbox(d=d);
    ///PoE
    color("Violet") translate([tx,ty,tz]) rotate([0,0,0])
      cube([10,10,0.5]);//bb
//      linear_extrude(height = 0.5) text(text="PoE");
  }
}//box_lower

//column for screw
/*
  d: box depth
  c: column diameter
  s: screw hole diameter
*/
module screw_column(d=2.5, c=6,s=2.75)
{
  epsilon=0.123;
  difference(){hull(){cube([c,c,d]);cylinder(r=c/2,h=d);}cylinder(r=s/2,h=d+epsilon);}
}//screw_column
//4 screw columns for box corners
/*
  east:  east  bbox position (x0)
  ouest: ouest bbox position (x1)
  south: south bbox position (y0)
  north: north bbox position (y1)

  d: box depth
  c: column diameter
  s: screw hole diameter
*/
module screw_columns(east=0,ouest=0,south=0,north=0, d=2.5,c=6)
{
  dx=c+1.0;
  dy=c+0.5;
  east=east-dx;
  ouest=ouest+dx;
  south=south-dy;
  north=north+dy;
//  screw_column(d=d);
  translate([east ,south,0]) rotate([0,0,0])   screw_column(d=d);
  translate([ouest,south,0]) rotate([0,0,90])  screw_column(d=d);
  translate([ouest,north,0]) rotate([0,0,180]) screw_column(d=d);
  translate([east ,north,0]) rotate([0,0,270]) screw_column(d=d);
}//screw_columns
//4 screw columns for box corners
/*
  w: width
  h: height
  d: depth

  c: column diameter
*/
module box_columns(w=72,h=62,d=2.5, c=6)
{
  east=w/2;
  ouest=-w/2;
  south=h/2;
  north=-h/2;
  screw_columns(east,ouest,south,north, d=d,c=c);
}//box_columns

//plane for box
/*
  x0: east  bbox position
  x1: ouest bbox position
  y0: south bbox position
  y1: north bbox position

  d: depth
  t: side thickness
*/
module box_plane(x0=12,x1=23,y0=34,y1=45, d=2.5, t=2)
{
  r=t/2;
  x0=x0-r;
  x1=x1+r;
  y0=y0-r;
  y1=y1+r;
  hull()
  {
    translate([x0,y0,0]) sphere(r=r);
    translate([x1,y1,0]) sphere(r=r);
    translate([x0,y1,0]) sphere(r=r);
    translate([x1,y0,0]) sphere(r=r);
  }//hull
}//box_plane

//open plane for box
/*
  x0: east  bbox position
  x1: ouest bbox position
  y0: south bbox position
  y1: north bbox position

  d: depth
  t: side thickness
*/
module open_box_plane(east=12,ouest=23,south=34,north=45, wo=26, d=2.5, t=2)
{
  x1=east-24-t;
  y1=north+12+t;
  x2=x1-wo-3;
//  box_plane(east,ouest,south,north);
  box_plane(east,ouest,south,y1);
  box_plane(east,x1-t,south,north);
  box_plane(x2,ouest,south,north);
}//open_box_plane

//side for box
/*
  x0: east  bbox position
  x1: ouest bbox position
  y0: south bbox position
  y1: north bbox position

  d: depth
  t: side thickness
*/
module box_side(x0,x1,y0,y1, d=2.5, t=2)
{
  hull()
  {
    translate([x0,y0,0]) cylinder(d=t,h=d);
    translate([x1,y1,0]) cylinder(d=t,h=d);
  }//hull
}//box_sides
//4 sides for box
/*
  w: width
  h: height
  d: depth

  t: side thickness
*/
module box_sides(w=72,h=62,d=2.5, c=6,t=2)
{
  east=w/2-t/2;
  ouest=-w/2+t/2;
  south=h/2-t/2;
  north=-h/2+t/2;
  box_side(east,ouest,south,south,d,t);
  box_side(east,ouest,north,north,d,t);
  box_side(east,east,south,north,d,t);
  box_side(ouest,ouest,south,north,d,t);
}//box_sides
//7 sides for open box
/*
  w: width
  h: height
  d: depth

  t: side thickness
*/
module open_box_sides(w=72,h=62,d=2.5, do=17.5,wo=26,ho=11, m=0.5,hm=2.5, d1=12,d2=23, c=6,t=2)
{
  east=w/2-t/2;
  ouest=-w/2+t/2;
  south=h/2-t/2;
  north=-h/2+t/2;
  x1=east-24-t;
  y1=north+12+t;
  x2=x1-wo-3;
  //3 side box
  box_side(east,ouest,south,south,d,t);
  //box_side(east,ouest,north,north,d,t);
  box_side(east,east,south,north,d,t);
  box_side(ouest,ouest,south,north,d,t);
  //opening for oLED
  //box_side(east,ouest,north,north,d,t);
  box_side(east,x1,north,north,d,t);
  box_side(x1,x1,y1,north,d,t);
  box_side(x1,x2,y1,y1,d,t);
  box_side(x2,x2,y1,north,d,t);
  box_side(x2,ouest,north,north,d,t);
}//open_box_sides


///middle box
/*
  d: box depth
  c: column diameter
  s: screw hole diameter
*/
module box_middle(w=72,h=62,d=2.5, t=2,c=6,s=2.75, x=(72-92)/2,y=0,z=16.4+7, bbox=true)
{
  translate([x,y,z])
  {
    //sides
    translate([0,0,-5]) box_sides(w,h,d,t);
    //colomns
    translate([0,0,-5]) box_columns(w,h,d, c);
    //bounding box
    if(bbox==true) %bbox(w=w, d=d);
  }
}//box_middle

///upper box
module box_upper(w=72,h=62,d=12, tx=36-0.25,ty=-7/2,tz=5, bbox=true)
{
  east=w/2;
  ouest=-w/2;
  south=h/2;
  north=-h/2;
  translate([(72-92)/2,0,16.4+7+2.5])
  {
    //sides
    translate([0,0,-5]) open_box_sides(w,h,d,t);
    //colomns
//    !screw_column(d);
    translate([0,0,-5]) screw_columns(east,ouest,south,north,d);
//    box_columns(w,h,d, c);//debug ?!
    //bounding box
    if(bbox==true) %obox(w=72,d=12);
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

///over box
module box_cover(w=72,h=62,d=10, t=2, bbox=true)
{
  east=w/2;
  ouest=-w/2;
  south=h/2;
  north=-h/2;
  translate([(72-92)/2,0,16.4+7+2.5+12])
  {
    //top
    translate([0,0,d-5-t/2]) open_box_plane(east,ouest,south,north);
    //sides
    translate([0,0,-5]) open_box_sides(w,h,d-t/2,t);
    //colomns
    translate([0,0,-5]) screw_columns(east,ouest,south,north,d-0.123);
    //bounding box
    if(bbox==true) %obox(w=72,d=d);
  }
}//box_cover

//RPi4
pi4();

//PCB and component margins
%hull()
{
  piB_PCB();
  translate([0,0,6.54321]) piB_PCB();
}

//PoE HAT
//translate([(65-85)/2,0,21]) WS_PoE_PCB();
//LEMO HAT
LEMO_HAT(withHeader=true);

//case: stack of boxes
///base box (alu. material)
//%bbox(d=16.4);
///other boxes for 3D print
//box_lower(bbox=bbox);
//box_middle(bbox=bbox);
//upper box
/** /
difference()
{
  box_upper(bbox=bbox);
//  for(m=[-0.25,0.25]){translate([(65-85)/2+m,0,21  ]) WS_PoE_PCB();}
//  for(m=[-0.25,0.25]){translate([(65-85)/2  ,m,21  ]) WS_PoE_PCB();}
  for(m=[-0.25,0.25]){translate([(65-85)/2  ,0,21+m]) WS_PoE_PCB();}
}//upper box
/**/
//cover box
difference()
{
  box_cover(bbox=bbox);
  for(m=[-0.25,0.25]){translate([(72-92)/2  ,0,16.4+7+2.5+12+m-5]) LEMO_PCB();}
}//upper box

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

devices();

/*
!projection(){// // // // //
devices();
translate([100,0,0]) LEMO_PCB();
}//projection// // // // //
*/
