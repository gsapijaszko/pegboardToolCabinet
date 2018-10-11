// tool cabined based on ShopNote No. 122 (vol. 21), Mar-Apr. 2012
// with modifications
// G. Sapijaszko, 2018

inch = 25.4;
eps = 0.1;
plyH = 18; // 3/4 * inch;
$fn = 120;

// drawer or shelf
drawerW = 16 * inch;
drawerD = 6.5 * inch;
drawerH = 2*plyH;

module drawerBase() {
  cube([drawerW, drawerD, drawerH], center = false);
}

bitHoleDiameter=8+0.45; // bit shank + allowance
bitHoleDepth = inch;

bit2bitDistance = 1.25 * inch;
totalOnWidth = floor(drawerW/bit2bitDistance)-1;
totalOnDepth = floor(drawerD/bit2bitDistance)-1;


// drawer for bits, shank = bitHoleDiameter
module drawerForBits(bitHoleDiameter = bitHoleDiameter, bitHoleDepth = bitHoleDepth) {
  difference() {
    drawerBase();
    for (i = [0 : 1 : totalOnWidth]) {
      for (j = [0 : 1 : totalOnDepth]) {
        translate([(drawerW-totalOnWidth*bit2bitDistance)/2+i*bit2bitDistance, (drawerD-totalOnDepth*bit2bitDistance)/2+j*bit2bitDistance, drawerH-bitHoleDepth+eps]) cylinder(d=bitHoleDiameter, h=bitHoleDepth+eps, center=false);
      }
    }
  }
}


// drawer for bits with 6 mm shank + 2 pockets
//
module drawerForBitsWithPockets(bitHoleDiameter=6+0.45) {
  difference() {
    drawerBase();
    for (i = [0 : 1 : totalOnWidth]) {
      for (j = [0 : 1 : totalOnDepth]) {
        translate([(drawerW-totalOnWidth*bit2bitDistance)/2+i*bit2bitDistance, (drawerD-totalOnDepth*bit2bitDistance)/2+j*bit2bitDistance, drawerH-bitHoleDepth+eps]) cylinder(d=bitHoleDiameter, h=bitHoleDepth+eps, center=false);
      }
    }
    
    // pockets
    for (i = [0 : 1 : 1]) {
    translate([(drawerW-totalOnWidth*bit2bitDistance)/2+2*bit2bitDistance-bitHoleDiameter/2+i*5*bit2bitDistance,(drawerD-totalOnDepth*bit2bitDistance)/2+0*bit2bitDistance,drawerH-bitHoleDepth+eps]) cube([2*bit2bitDistance+bitHoleDiameter, bit2bitDistance, bitHoleDepth+eps], center=false);
    translate([(drawerW-totalOnWidth*bit2bitDistance)/2+2*bit2bitDistance+i*5*bit2bitDistance,(drawerD-totalOnDepth*bit2bitDistance)/2+0*bit2bitDistance-bitHoleDiameter/2,drawerH-bitHoleDepth+eps]) cube([2*bit2bitDistance, bit2bitDistance+bitHoleDiameter, bitHoleDepth+eps], center=false);
    }
  }
}


// special drawer for bits in plastic holders
// used for storing engraving bits
// module bitPlasticHolder creates a rectangular holes with "bone" like ears

module bitPlasticHolder( hole_width = 15.5, hole_depth = 15.5, hole_heigth = 16) {
  bit_dia = 6;

  translate([0,0,hole_heigth/2]) union() {
    cube([hole_width, hole_depth, hole_heigth+eps], center = true);
     for (i = [1:1:2]) {
      rotate([0,0,i*180]) translate([hole_width/2-sqrt(2)*bit_dia/4, hole_depth/2-sqrt(2)*bit_dia/4,0]) cylinder(d=bit_dia, h=hole_heigth+eps, center = true);
      rotate([0,0,i*180]) translate([hole_width/2-sqrt(2)*bit_dia/4, -hole_depth/2+sqrt(2)*bit_dia/4,0]) cylinder(d=bit_dia, h=hole_heigth+eps, center = true);
    }
  }
}


module drawerForBitHolders() {
  difference() {
    drawerBase();
    for (i = [0 : 1 : totalOnWidth]) {
      for (j = [0 : 1 : totalOnDepth-2]) {
        translate([(drawerW-totalOnWidth*bit2bitDistance)/2+i*bit2bitDistance, (drawerD-totalOnDepth*bit2bitDistance)/2+j*bit2bitDistance, drawerH-16+eps]) bitPlasticHolder( hole_width = 13.4, hole_depth = 13.4, hole_heigth = 16);
      }
    }

    for (i = [0 : 1 : totalOnWidth]) {
      for (j = [3 : 1 : totalOnDepth-1]) {
        translate([(drawerW-totalOnWidth*bit2bitDistance)/2+i*bit2bitDistance, (drawerD-totalOnDepth*bit2bitDistance)/2+j*bit2bitDistance, drawerH-16+eps]) bitPlasticHolder( hole_width = 14.8, hole_depth = 14.8, hole_heigth = 16);
      }
    }
    for (i = [0 : 1 : totalOnWidth]) {
      for (j = [4 : 1 : totalOnDepth]) {
        translate([(drawerW-totalOnWidth*bit2bitDistance)/2+i*bit2bitDistance, (drawerD-totalOnDepth*bit2bitDistance)/2+j*bit2bitDistance, drawerH-16+eps]) bitPlasticHolder( hole_width = 23.5, hole_depth = 23.5, hole_heigth = 16);
      }
    }
  }
}

//drawerForBitHolders();


// to create dxf files for drawer
// projection(cut=true) translate([0,0,-bitHoleDepth]) 
// drawerForBitsWithPockets();
/*
//drawerForBits();
//drawerForBitHolders();
*/

drawerForBitsWithPockets();
translate([0, drawerD+inch, 0]) drawerForBits();
translate([0, -drawerD-inch, 0]) drawerForBitHolders();

// the case

bottomW = 70.75 * inch;
bottomD = 8.5 * inch;
bottomH = plyH;

module  slotPlyH(slotH=plyH/3+eps) {
  cube([plyH,bottomD+2*eps, slotH], center = false);
}

//offset of longDividerB from sides = width of shelves
longDividerOffset = 17.25*inch;


module bottomA() {
  difference() {
    cube([bottomW, bottomD, bottomH], center = false);  
    translate([-2*plyH/3, -eps, -eps]) slotPlyH();
    translate([bottomW-plyH/3, -eps, -eps]) slotPlyH();
    translate([longDividerOffset, -eps, plyH-plyH/3]) slotPlyH();
    translate([bottomW-longDividerOffset-plyH, -eps, plyH-plyH/3]) slotPlyH();
    translate([(bottomW-plyH)/2, -eps, plyH-plyH/3]) slotPlyH();
  }
}

module centerDividerD() {
  color("gray") cube([plyH, 7.5*inch, 6*inch], center=false); 
}

longDividerW = 38.25*inch;
longDividerD = 8.5*inch;

module longDividerB() {
  color("red") rotate([0,90,0]) translate([-longDividerW,0,0])
  difference() {
    cube([longDividerW, longDividerD, plyH], center = false);
    translate([longDividerW-5.75*inch-plyH, -eps, 2*plyH/3])slotPlyH();
    translate([longDividerW-5.75*inch-plyH, -eps, -eps])slotPlyH();
    translate([-eps, longDividerD-3/4*inch-plyH/3, 2*plyH/3])
      cube([longDividerW+2*eps, plyH/3, plyH/3+eps], center = false);
    translate([-eps, longDividerD-3/4*inch-plyH/3, -eps])
      cube([longDividerW+2*eps, plyH/3, plyH/3+eps], center = false);
  }
}


module centerShelfC() {
  centerShelfW = bottomW - 2*(longDividerOffset+plyH)+2*plyH/3;
  centerShelfD = bottomD;
  color("pink") 
  difference() {
    cube([centerShelfW,centerShelfD,plyH], center=false);
    translate([(centerShelfW-plyH)/2, -eps, -eps]) slotPlyH();
    translate([-eps, centerShelfD-3/4*inch-plyH/3, 2*plyH/3]) cube([centerShelfW+2*eps, plyH/3, plyH/3+eps], center=false);
    translate([-eps, centerShelfD-3/4*inch-plyH/3, -eps]) cube([centerShelfW+2*eps, plyH/3, plyH/3+eps], center=false);

  }
}


module topA() {
  topW = bottomW;
  topD = bottomD;
  topH = plyH;
  difference(){
    cube([topW, topD, topH], center = false);
    translate([-2*plyH/3,-eps,plyH/3]) slotPlyH(slotH=2*plyH/3+eps);
    translate([topW-plyH/3,-eps,plyH/3]) slotPlyH(slotH=2*plyH/3+eps); 
    translate([longDividerOffset, -eps, -eps]) slotPlyH();
    translate([bottomW-longDividerOffset-plyH, -eps, -eps]) slotPlyH();
    translate([-eps,topD-3/4*inch-plyH/3,-eps]) cube([bottomW+2*eps, plyH/3, plyH/3+eps], center = false);
  }
}


/*
// assembly
bottomA();
translate([(bottomW-plyH)/2, 0, 2*plyH/3]) centerDividerD();
translate([longDividerOffset,0,2*plyH/3]) longDividerB();
translate([bottomW-longDividerOffset-plyH,0,2*plyH/3]) longDividerB();
translate([longDividerOffset+2*plyH/3, 0, 5.75*inch+2*plyH/3])centerShelfC();

translate([0,0,longDividerW+plyH/3])topA();

//drawerFor8mmBits();
*/