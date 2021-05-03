/* (c) 2016++ by Saarbastler 
**  https://github.com/saarbastler/library.scad
**
** Raspberry PI model library for generating cases etc.
*/
$fn=100;

///Version
version="v0.2.2f";

// Which one would you like to see?
part = "pi4"; // [pi3:Raspberry PI3,hifiberryDacPlus:HifiBerry DAC+,pi3_hifiberryDacPlus:Raspberry PI3 & HifiBerry DAC+,piZero:Raspberry PI Zero,speakerPhat:Pimoroni Speaker pHAT,pi4:Raspberry PI4]

// Show Header
header = true; // true:Show Header;false:Don't show Header

// Header Up/Down for Pi Zero
headerDown = false; //true: Header down (Only Zero): false Header up
//header by 2.54mm step 
module header(pins, rows, bbox=false, margin=0)
{
  if(bbox==false)
  {
    color("darkgrey") cube([2.54*pins,2.54*rows,2.54]);
    for(x=[0:pins-1],y=[0:rows-1])
      translate([x*2.54+(1.27+.6)/2,y*2.54+(1.27+.6)/2,-3.5]) cube([0.6,0.6,11.5]);
  }
  else
  {
    translate([0,0,-3.5]) cube([2.54*pins+margin,2.54*rows+margin,11.5+margin]);
  }
}//header

//Pi B header 20x2 pins (for RPi2-4 and its HATs)
module piB_header(bbox=false, margin=0)
{
  translate([3.5-85/2+29-10*2.54,49/2-2.54,1.4])
  header(20,2, bbox, margin);
}//piB_header

//ShareWave PoE HAT: PCB
/*
  w:  width  of plate
  h:  height of plate
  wh: width  of holes
  hh: height of holes
  wo: width  of oLED (active: 26mm, device: 31mm)
  ho: height of oLED
  fr: fan radius
*/
module WS_PoE_PCB(w=56.5,h=65, hw=49,hh=58, fr=14, wo=26,ho=11, minkowski=false)
{
  color("limegreen") difference()
  {
    //plate
    hull()
    {
      translate([-(h-6)/2,-(w-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([-(h-6)/2, (w-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (h-6)/2,-(w-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (h-6)/2, (w-6)/2,0]) cylinder(r=3, h=1.4 );
    }
    if(minkowski==false)
    {
    //screw holes
    translate([-h/2+3.5,-hw/2,-1]) cylinder(d=2.75, h=3);
    translate([-h/2+3.5, hw/2,-1]) cylinder(d=2.75, h=3);
    translate([hh-h/2+3.5,-hw/2,-1]) cylinder(d=2.75, h=3);
    translate([hh-h/2+3.5, hw/2,-1]) cylinder(d=2.75, h=3);
    //fan hole
    translate([-h/2+6+fr,2,-1]) cylinder(r=fr,3);
    }//!minkowski
  }//difference
  //oLED
  color("blue") translate([-h/2+40-wo,-w/2,0]) cube([wo,ho,2]);
}//WS_PoE_PCB

//LEMO HAT: PCB
/*
  w:  width  of plate
  h:  height of plate
  wh: width  of holes
  hh: height of holes
  wo: width  of oLED (active: 26mm, device: 31mm)
  ho: height of oLED
  mo: margin around oLED
  minkowski: set to true for fast minkowski
*/
module LEMO_PCB(w=56.5,h=65, hw=49,hh=58, wo=26,ho=11,mo=3, minkowski=false)
{
  color("limegreen") difference()
  {
    //plate
    hull()
    {
      translate([-(h-6)/2,-(w-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([-(h-6)/2, (w-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (h-6)/2,-(w-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (h-6)/2, (w-6)/2,0]) cylinder(r=3, h=1.4 );
    }
    if(minkowski==false)
    {
    //screw holes
    translate([-h/2+3.5,-hw/2,-1]) cylinder(d=2.75, h=3);
    translate([-h/2+3.5, hw/2,-1]) cylinder(d=2.75, h=3);
    translate([hh-h/2+3.5,-hw/2,-1]) cylinder(d=2.75, h=3);
    translate([hh-h/2+3.5, hw/2,-1]) cylinder(d=2.75, h=3);
    }//!minkowski
    //oLED hole
    translate([-h/2+40-wo-mo/2,-w/2-mo/2,0-mo]) cube([wo+mo,ho+mo,2+mo]);
  }//difference
}//LEMO_PCB

//LEMO HAT
module LEMO_HAT(z=21+12, withHeader=false)
{
  translate([0,0,z])
  {
    translate([(65-85)/2,0,0]) LEMO_PCB();
    if( withHeader )
      piB_header();
  }
}//LEMO_HAT

//piB PCB
module piB_PCB(w=85,h=56, minkowski=false)
{
  color("limegreen") difference()
  {
    hull()
    {
      translate([-(w-6)/2,-(h-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([-(w-6)/2, (h-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (w-6)/2,-(h-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (w-6)/2, (h-6)/2,0]) cylinder(r=3, h=1.4 );
    }
    if(minkowski==false)
    {
    //screw holes
    translate([-w/2+3.5,-49/2,-1]) cylinder(d=2.75, h=3);
    translate([-w/2+3.5, 49/2,-1]) cylinder(d=2.75, h=3);
    translate([58-w/2+3.5,-49/2,-1]) cylinder(d=2.75, h=3);
    translate([58-w/2+3.5, 49/2,-1]) cylinder(d=2.75, h=3);
    }//!minkowski
  }//difference
}//piB_PCB

module pi3()
{
  // PCB
  piB_PCB();
  
  // Header
  piB_header();
  
  translate([-85/2,-56/2,1.4])  
  {
    color("silver") 
    {
      // Ethernet
      translate([85-19,11.5-16/2,0]) cube([21,16,13.8]);
    
      // USB
      translate([85-15, 29-13/2,0]) cube([17,13,15.5]);
      translate([85-15, 47-13/2,0]) cube([17,13,15.5]);
      
      // micro USB
      translate([10.6-8/2,-1.5,0]) cube([8,6,2.6]);
      
      // HDMI
      translate([32-15/2,-1.5,0]) cube([15,11.5,6.6]);
    }
    
    color("darkgrey") 
    {
      // Audio
      translate([53.5-7/2,-2,0]) 
      {
        translate([0,2,0]) cube([7,13,5.6]);
        translate([7/2,0,5.6/2])rotate([-90,0,0]) cylinder(d=5.6,h=2);
      }
    
      // Display
      translate([1.1,(49-22)/2,0]) cube([4,22,5.5]);
      
      // Camera
      translate([45-4/2,1.1,0]) cube([4,22,5.5]);
    }
    
    // Micro SD Card
    color("silver") translate([0,22,-2.9]) cube([13,14,1.5]);    
    color("darkgrey") translate([-2.4,23.5,-2.65]) cube([2.4,11,1]);
  }
}//pi3

module hifiberryDacPlus(withHeader=false)
{  
  translate([0,0,13.4])
  {
    // PCB
    color("limegreen") difference()
    {
      translate([(65-85)/2,0,0]) hull()
      {
        translate([-(65-6)/2,-(56-6)/2,0]) cylinder(r=3, h=1.4 );
        translate([-(65-6)/2, (56-6)/2,0]) cylinder(r=3, h=1.4 );
        translate([ (65-6)/2,-(56-6)/2,0]) cylinder(r=3, h=1.4 );
        translate([ (65-6)/2, (56-6)/2,0]) cylinder(r=3, h=1.4 );
      }
      
      translate([-85/2+3.5,-49/2,-1]) cylinder(d=2.75, h=3);
      translate([-85/2+3.5, 49/2,-1]) cylinder(d=2.75, h=3);
      translate([58-85/2+3.5,-49/2,-1]) cylinder(d=2.75, h=3);
      translate([58-85/2+3.5, 49/2,-1]) cylinder(d=2.75, h=3);
    }
    
    // Header down
    translate([3.5-85/2+29-10*2.54,49/2-2.54,-8])
      color("darkgrey") cube([2.54*20,5.08,8]);
    
    // Chinch
    translate([-85/2,-56/2,1.4]) 
    {
      translate([29,0,0]) 
      {
        color("white") cube([10,10,12.5]);        
        color("silver") translate([5,-9,7.5]) rotate([-90,0,0]) cylinder(d=8,h=9);
      }
      translate([46,0,0]) 
      {
        color("red") cube([10,10,12.5]);        
        color("silver") translate([5,-9,7.5]) rotate([-90,0,0]) cylinder(d=8,h=9);
      }
    }
    
    // Header top
    if( withHeader )
      translate([3.5-85/2+29-10*2.54,49/2-2.54-2*2.54,1.4])
        header(20,2);

  }
}//hifiberryDacPlus

// header: 0 no, 1= up, -1, down
module zero( header= 0)
{
  // PCB
  color("limegreen") difference()
  {
    hull()
    {
      translate([-(65-6)/2,-(30-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([-(65-6)/2, (30-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (65-6)/2,-(30-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (65-6)/2, (30-6)/2,0]) cylinder(r=3, h=1.4 );
    }
    
    translate([-65/2+3.5,-23/2,-1]) cylinder(d=2.75, h=3);
    translate([-65/2+3.5, 23/2,-1]) cylinder(d=2.75, h=3);
    translate([65/2-3.5,-23/2,-1]) cylinder(d=2.75, h=3);
    translate([65/2-3.5, 23/2,-1]) cylinder(d=2.75, h=3);
  }

  // Header
  if( header == 1)
    translate([3.5-65/2+29-10*2.54,30/2-3.5-2.54,1.4])
      header(20,2);
  if( header == -1)
    translate([3.5-65/2+29-10*2.54,30/2-3.5-2.54,0])
      mirror([0,0,1]) header(20,2);
    
  translate([-65/2,-30/2,1.4])
  {
    // Micro SD Card
    color("silver") translate([1.5,16.9-5,0]) cube([12,10,1.4]);    
    color("darkgrey") translate([-2.5,16.9-5,0.25]) cube([4,10,1]);
    
    // micro USB
    color("silver") translate([41.4-8/2,-1.5,0]) cube([8,6,2.6]);
    color("silver") translate([54-8/2,-1.5,0]) cube([8,6,2.6]);

    // HDMI
    color("silver")  translate([12.4-11.4/2,-.5,0]) cube([11.3,7.5,3.1]);
    
    // Camera
    color("darkgrey") translate([65-3,(30-17)/2,0]) cube([4,17,1.3]);  
  }
}//zero

module speakerPhat()
{
  // PCB
  translate([0,0,12]) color("darkgreen") difference()
  {
    hull()
    {
      translate([-(65-6)/2,-(30-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([-(65-6)/2, (30-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (65-6)/2,-(30-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (65-6)/2, (30-6)/2,0]) cylinder(r=3, h=1.4 );
    }
    
    translate([-65/2+3.5,-23/2,-1]) cylinder(d=2.75, h=3);
    translate([-65/2+3.5, 23/2,-1]) cylinder(d=2.75, h=3);
    translate([65/2-3.5,-23/2,-1]) cylinder(d=2.75, h=3);
    translate([65/2-3.5, 23/2,-1]) cylinder(d=2.75, h=3);
  }
  
  //translate([3.5-85/2+29-10*2.54,49/2-2.54,-8])
  translate([3.5-65/2+29-10*2.54,30/2-3.5-2.54,3.78])
    color("darkgrey") cube([2.54*20,5.08,8.2]);
}//speakerPhat

//Ethernet RJ45 femal plug for RPi4
/*
  w: width
  h: height
  d: depth
  
  bbox: bounding box
  margin: margin around plug
  plug: male plug size
*/
module pi4_Eth(w=21,h=16,d=13.5, bbox=false, margin=0, plug=0)
{
  w=w+margin*2+plug;
  h=h+margin*2;
  d=d+margin*2;
  translate([-85/2,-56/2,1.4]) //PiB
  {
    translate([85-19-margin, 45.75-13.5/2-margin,0-margin]) cube([w,h,d]);
  }
}//pi4_Eth

//USB2 and USB3 femal plugs for RPi4
/*
  w: width
  h: height
  d: depth
  
  bbox: bounding box
  margin: margin around plug
  plug: male plug size
*/
module pi4_USB23(w=17,h=13,d=16, bbox=false, margin=0, plug=0)
{
  w=w+margin*2+plug;
  h=h+margin*2;
  d=d+margin*2;
  translate([-85/2,-56/2,1.4]) //PiB
  {
    translate([85-15-margin, 9-16/2-margin,  0-margin]) cube([w,h,d]);
    translate([85-15-margin, 27-16/2-margin, 0-margin]) cube([w,h,d]);
  }
}//pi4_USB23

module pi4()
{
  // PCB
  piB_PCB();
  
  // Header
  piB_header();

  color("silver")
  {
    // Ethernet
    pi4_Eth();
    // USB
    pi4_USB23();
  }
  translate([-85/2,-56/2,1.4])
  {
    color("silver")
    {
      // USB C
      translate([3.5+7.7-8.94/2,-1.5,0]) cube([8.94,8.75,3.16]);
      // Mini HDMI
      translate([3.5+7.7+14.8-6.5/2,-1.5,0]) cube([6.5,7.5,2.9]);
      translate([3.5+7.7+14.8+13.5-6.5/2,-1.5,0]) cube([6.5,7.5,2.9]);
    }
    color("darkgrey")
    {
      // Audio
      translate([3.5+7.7+14.8+13.5+7+7.5-7/2,-2,0])
      {
        translate([0,2,0]) cube([7,13,5.6]);
        translate([7/2,0,5.6/2])rotate([-90,0,0]) cylinder(d=5.6,h=2);
      }
      // Display
      translate([1.1,(49-22)/2,0]) cube([4,22,5.5]);
      // Camera
      translate([3.5+7.7+14.8+13.5+7-4/2,1.1,0]) cube([4,22,5.5]);
    }
    // Micro SD Card
    color("silver") translate([0,22,-2.9]) cube([13,14,1.5]);
    color("darkgrey") translate([-2.4,23.5,-2.65]) cube([2.4,11,1]);
  }
}//pi4

if( part == "pi3")
  pi3();
else if( part == "hifiberryDacPlus")
  hifiberryDacPlus(header);
else if( part == "pi3_hifiberryDacPlus")
{
  pi3();
  hifiberryDacPlus(header);
}
else if( part == "piZero")
  zero(header ? (headerDown ? -1 : 1) : 0);
else if( part == "speakerPhat")
  speakerPhat();
else if( part == "pi4")
  pi4();
