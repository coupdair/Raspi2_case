/*  RASPBERRY PI4 case

multiple layer case

- base: mimic alu. case-C (might be replaced by the WaveShare passive cooling box)
- cover, upper, middle and lower box: each is a part of the stack (3D printed)

- case_* is enclosure with holes for components
- box_* is box hull
- bbox is bounding box

*/

///use library.scad
//see https://github.com/coupdair/library.scad
use <../library.scad/raspberrypi.scad>

///Version
version="v0.2.2e";

///bounding box
bbox=false;
//bbox=true;

//resolution
PRINT=false;
//PRINT=true;
$fn=23;
//$fn=75;

///Box output (e.g. on CLI: -D 'BOX="bottom"')
//BOX="buttons";
BOX="cover";
//BOX="upper";
//BOX="middle";
//BOX="lower";
//BOX="projection";
//BOX="full";

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
module lemo(l=17.5,r=3.5,b=7, x=9,y=16,z=33, dx=0,dy=0, dr=0)
{
  r=r+dr;
  translate([x,y+dy,z+dx]) rotate([0,90,0]) cylinder(r=r, h=l);
  translate([x,y-b/2+dy,z-b/2+dx]) cube([b,b,b]);
}//lemo

//button
/*
  l: length
  h: height
*/
module button(l=10,r=3,b=5,h=2.54,bh=1.23, x=-16,y=-12,z=33.5, dx=0,dy=0, dr=0,dz=0)
{
  r=r+dr;
  translate([x+dx,y+dy,z+h+bh]) cylinder(r=r, h=l-h-bh);
  translate([x-b/2+dx,y-b/2+dy,z+dz]) cube([b,b,h]);
}//button

//LED
/*
  r: radius
*/
module led(r=1.5,h=9, x=-16,y=0,z=43, dx=0,dy=0, space=0.123, dr=0)
{
  r=r+dr;
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
module serial(w=3*2.5,h=2.5,d=14, space=-0.3, x=7.5+2*2.5-42.5,y=24.5,z=34.5, margin=0)
{
  translate([x-margin,y-margin,z+space-margin]) cube([w+margin*2,h+margin*2,d+margin*2]);
}//serial

//I2C header driver
/*
  l: length
  h: height
*/
module i2c_header(pins=3, rows=2, x=19,y=4.25-16,z=34.5+1-10, bbox=false, margin=0)
{
  translate([x,y,z]) rotate([90,0,90]) header(pins, rows, bbox=bbox, margin=0);
}//i2c_header

//I2C header software
/*
  l: length
  h: height
*/
module i2c_headerS(pins=4, rows=1, x=-12,y=4.25,z=34.5-2.5, bbox=false, margin=0)
{
  translate([x,y,z]) rotate([270,0,90]) header(pins, rows, bbox=bbox, margin=0);
}//i2c_headerS

///lower box
module box_lower(w=92,h=62,d=7, t=2, tx=43,ty=11,tz=-2.5, bbox=true)
{
  dx=(72-92)/2;
  sx=-2*dx;
  translate([0,0,16.4]) 
  {
    difference()
    {
	union()
	{
      //USB/RJ45 top
      translate([92/2+dx,0,-5+d-t/2]) box_plane(-sx/2-t,sx/2-t,-h/2+t,h/2-t);
      //USB/RJ45 sides
      translate([92/2+dx-t/2,0,-5]) box_sides(w=sx+t,d=d-t/2);
      //PCB sides
      translate([dx,0,-5]) box_sides(d=d);
      //colomns
      translate([dx,0,-5]) box_columns(d=d);
      //handles
      box_handles(east=-w/2,ouest=w/2,south=-h/2,north=h/2, d=d);
    }//box union
    //text
    color("Violet") translate([tx,ty,tz]) rotate([0,0,90])
    {
//      cube([10,10,0.5]);//bb
      ///PoE
      linear_extrude(height=-2*tz) text(text="PoE",size=6);
      translate([9,1.5,0]) rotate([0,0,180]) linear_extrude(height=-2*tz) text(text="^",size=4);
      ///reset
      translate([0.5,11,0]) linear_extrude(height=-2*tz) text(text="rêset",size=5);
      ///I2C
      translate([-38,11,0]) linear_extrude(height=-2*tz) text(text=" I2C",size=5);
      translate([-38,5,0]) linear_extrude(height=-2*tz) text(text="datâ  clôck",size=5);
    }//text color
    }//text difference
    //bounding box
    if(bbox==true) %bbox(d=d);
  }
}//box_lower
module case_lower()
{
difference()
{
  box_lower(bbox=bbox);
  pi4_Eth(bbox=true,margin=0.25,plug=12);
  pi4_USB23(bbox=true,margin=0.25,plug=12);
}//difference
}//case_lower

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

//handle for box
/*
  d: box depth
  c: column diameter
  s: screw hole diameter
*/
module box_handle(d=2.5, c=12,s=6)
{
  epsilon=0.123;
  difference()
  {
    hull()
    {
      translate([-c/2,0,0])cube([c,c,d]);
      cylinder(r=c/2,h=d);
    }
    translate([0,0,-epsilon]) cylinder(r=s/2,h=d+2*epsilon);
  }//difference
}//box_handle
//4 handles for box corners
/*
  east:  east  bbox position (x0)
  ouest: ouest bbox position (x1)
  south: south bbox position (y0)
  north: north bbox position (y1)

  d: box depth
  c: column diameter
  s: screw hole diameter
*/
module box_handles(east=-30,ouest=30,south=-30,north=30, d=2.5,c=12)
{
  dx=c+1.0+3;
  dy=c+0.5-21;
  east=east+dx;
  ouest=ouest-dx;
  south=south+dy;
  north=north-dy;
//  box_handle(d=d);
  translate([-10,0,-5])
  {
    translate([east ,south,0]) rotate([0,0,0])   box_handle(d=d);
    translate([ouest,south,0]) rotate([0,0,0])  box_handle(d=d);
    translate([ouest,north,0]) rotate([0,0,180]) box_handle(d=d);
    translate([east ,north,0]) rotate([0,0,180]) box_handle(d=d);
  }
}//box_handles

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
}//box_side
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
module case_middle()
{
  box_middle(bbox=bbox);
}//case_middle

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
  }
}//box_upper
module case_upper()
{
difference()
{
  box_upper(bbox=bbox);
  i2c_header(bbox=true,margin=0.25);
  translate([(65-85)/2  ,0,21]) minkowski(){WS_PoE_PCB(minkowski=true);sphere(r=0.4,center=true);}
}//difference
}//case_upper

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
module case_cover()
{
difference()
{
  box_cover(bbox=bbox);
  translate([(72-92)/2,0,16.4+7+2.5+12-5]) minkowski(){LEMO_PCB(minkowski=true);sphere(r=0.4,center=true);}
  //devices();
  serial(margin=0.25);
  buttons(dr=0.25);
  lemos(dr=0.25);
  leds_soft(dr=0.25);
  leds_hard(dr=0.25);
}//difference
}//case_cover

//devices
module buttons(dr=0,dz=0)
{
//button();
  button(dx=5,   dr=dr,dz=dz);
  button(dx=-5,  dr=dr,dz=dz);
  button(dx=15,  dr=dr,dz=dz);
  button(dx=-15, dr=dr,dz=dz);
}//buttons

module lemos(dr=0)
{
  //lemo();
  lemo(dx=5,dy=0,   dr=dr);
  lemo(dx=5,dy=-16, dr=dr);
  lemo(dx=5,dy=-32, dr=dr);
}//lemos

module leds_soft(dr=0)
{
  //led();
  led(dx=5,   dr=dr);
  led(dx=-5,  dr=dr);
  led(dx=15,  dr=dr);
  led(dx=-15, dr=dr);
}//leds_soft

module leds_hard(dr=0)
{
  //led();
  led(dx=-22, dy=16, dr=dr);
  led(dx=-22, dy=8,  dr=dr);
}//leds_hard

module devices()
{
//UART
color("gray") serial();
//I2C#1 header
i2c_header();
//I2C#3 header
i2c_headerS();
//lemo
color("gray") lemos();
//button
color("red") buttons();
//led
color("green") leds_soft();
//power led
color("orange") leds_hard();
}//devices

if(BOX=="projection")
{
  projection()
  {
    devices();
    translate([100,0,0]) LEMO_PCB();
  }//projection
}//projection render

if( BOX=="cover" || BOX=="full" )
{//cover layer
//  devices();
//cover box
if(PRINT==true) translate([0,0,42.9]) rotate([180,0,0]) case_cover();
else case_cover();
}//cover layer

if( BOX=="upper" || BOX=="full" )
{//upper layer
if(PRINT==true) translate([0,0,32.90]) rotate([180,0,0]) case_upper();
else case_upper();
}//upper layer

if( BOX=="middle" || BOX=="full" )
{//middle layer
if(PRINT==true) translate([0,0,-18.5]) case_middle();
else case_middle();
}//middle layer

if( BOX=="lower" || BOX=="full" )
{//lower layer
if(PRINT==true) translate([0,0,18.5]) rotate([180,0,0]) case_lower();
else  case_lower();
}//lower layer

if( BOX=="full" )
{//base box, RPi and PCBs
///base box (alu. material)
difference()
{
  bbox(d=16.4);
  pi4_Eth(bbox=true,margin=0.25,plug=12);
  pi4_USB23(bbox=true,margin=0.25,plug=12);
}//base box

///Devices
devices();
///PoE HAT
translate([(65-85)/2,0,21]) WS_PoE_PCB();
///LEMO HAT
LEMO_HAT(withHeader=true);
///RPi4
pi4();
}//base box, RPi and PCBs

if( BOX=="buttons")
{//lower layer
if(PRINT==true) translate([0,0,-37.3]) buttons(dz=3.75);
else buttons(dz=3.75);
}//lower layer
