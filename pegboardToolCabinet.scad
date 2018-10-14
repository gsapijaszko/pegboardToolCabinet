// tool cabined based on ShopNote No. 122 (vol. 21), Mar-Apr. 2012
// with modifications
// G. Sapijaszko, 2018

inch = 25.4;
eps = 0.1;
$fn = 120;

caseW = 71.75 * inch;
caseD = 8.5 * inch;
caseH = 39.25 * inch;
plyH = 18; // 3/4 * inch;
pegboardH = 6;

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

// the case

sideG_W = caseH;
sideG_D = caseD;
sideG_H = plyH;
echo("2 pcs of sides, dim:", sideG_W,"x",sideG_D,"x",sideG_H);



module sideG() {
  difference() {
    cube([sideG_W, sideG_D, sideG_H], center = false);
    translate([2*bottomH/3,sideG_D-3/4*inch-pegboardH,2/3*sideG_H]) cube([sideG_W-2/3*bottomH-2/3*topH, pegboardH, sideG_H/3+eps], center = false);
    translate([sideG_W-topH,-eps, 2/3*sideG_H]) cube([topH/3, sideG_D+2*eps,sideG_H/3+eps]);
    translate([2*bottomH/3,-eps, 2/3*sideG_H]) cube([bottomH/3, sideG_D+2*eps,sideG_H/3+eps]);
    translate([2/3*bottomH+5.75*inch, -eps, 2/3*sideG_H]) cube([fixedShelfH_H, sideG_D-3/4*inch-pegboardH+2*eps, sideG_H/3+eps], center=false); //fixedshelf
    translate([2/3*bottomH+5.75*inch+centerShelfH+8*inch,1.5*inch,sideG_H]) holesForShelfPins();
  }
}

// sideG();


bottomW = caseW - 2*2/3*sideG_H;
bottomD = caseD;
bottomH = plyH;


module  slotPlyH(slotH=plyH/3+eps) {
  cube([plyH,bottomD+2*eps, slotH], center = false);
}

//offset of longDividerB from sides = width of shelves
longDividerOffset = 17.25*inch;


module bottomA() {
  difference() {
    cube([bottomW, bottomD, bottomH], center = false);  
    translate([-2/3*sideG_H, -eps, -eps]) slotPlyH(slotH=2/3*bottomH+eps);
    translate([bottomW-sideG_H/3, -eps, -eps]) slotPlyH(slotH=2/3*bottomH+eps);
    translate([longDividerOffset, -eps, 2/3*bottomH]) slotPlyH(slotH=bottomH/3+eps);
    translate([bottomW-longDividerOffset-longDividerH, -eps, plyH-plyH/3]) slotPlyH();
    translate([(bottomW-plyH)/2, -eps, 2/3*bottomH]) cube([plyH,bottomD-3/4*inch-pegboardH+eps, 2/3*bottomH+eps], center = false);
    translate([0,bottomD-3/4*inch-pegboardH,2/3*bottomH])cube([bottomW, pegboardH, bottomH/3+eps], center=false);
  }
}

//bottomA();

module centerDividerD() {
  color("gray") cube([plyH, 7.5*inch, 6*inch], center=false); 
}

// projection(cut=false) rotate([0,90,0]) centerDividerD();


topW = bottomW;
topD = bottomD;
topH = plyH;

module topA() {
  difference(){
    cube([topW, topD, topH], center = false);
    translate([-2*plyH/3,-eps,plyH/3]) slotPlyH(slotH=2*plyH/3+eps);
    translate([topW-plyH/3,-eps,plyH/3]) slotPlyH(slotH=2*plyH/3+eps); 
    translate([longDividerOffset, -eps, -eps]) slotPlyH();
    translate([bottomW-longDividerOffset-plyH, -eps, -eps]) slotPlyH();
    translate([-eps,topD-3/4*inch-plyH/3,-eps]) cube([bottomW+2*eps, plyH/3, plyH/3+eps], center = false);
  }
}

//topA();

// projection(cut=true)rotate([180,0,0]) topA();


longDividerW = caseH-2/3*topH - 2/3*bottomH;
longDividerD = caseD;
longDividerH = plyH;

// holesForShelfPins use to create holes in longDividerB and sideG
row2rowDistance = longDividerD - (1.5+1.75) * inch;
hole2holeUp = 2 * inch;
module holesForShelfPins() {
  holeBitDia = 6;
  holeDepth = 1/2 * inch;

  for (i = [0:1]) {
    for (j = [0:8]) {
      translate([j*hole2holeUp, i*row2rowDistance, -holeDepth+eps]) cylinder(d=holeBitDia, h=holeDepth+eps, center=false);
    }
  }
}


module longDividerB() {
 color("red") rotate([0,90,0]) translate([-longDividerW,0,0])
  difference() {
    cube([longDividerW, longDividerD, longDividerH], center = false);
    translate([longDividerW-5.75*inch-plyH, -eps, 2*plyH/3])slotPlyH();
    translate([longDividerW-5.75*inch-plyH, -eps, -eps])slotPlyH();
    translate([-eps, longDividerD-3/4*inch-plyH/3, 2*plyH/3])
      cube([longDividerW+2*eps, plyH/3, plyH/3+eps], center = false);
    translate([-eps, longDividerD-3/4*inch-plyH/3, -eps])
      cube([longDividerW+2*eps, plyH/3, plyH/3+eps], center = false);
    translate([longDividerW-5.75*inch-plyH-8*inch,row2rowDistance+1.5*inch, longDividerH]) rotate([0,0,180]) holesForShelfPins();
  }
}

// projection(cut=true) translate([longDividerW,0,-plyH+eps]) rotate([0,-90,0]) longDividerB();

centerShelfW = bottomW - 2*(longDividerOffset+plyH)+2*plyH/3;
centerShelfD = bottomD;
centerShelfH = plyH;

module centerShelfC() {
  color("pink") 
  difference() {
    cube([centerShelfW,centerShelfD,centerShelfH], center=false);
    translate([(centerShelfW-plyH)/2, -eps, -eps]) slotPlyH();
    translate([-eps, centerShelfD-3/4*inch-plyH/3, 2*plyH/3]) cube([centerShelfW+2*eps, plyH/3, plyH/3+eps], center=false);
    translate([-eps, centerShelfD-3/4*inch-plyH/3, -eps]) cube([centerShelfW+2*eps, plyH/3, plyH/3+eps], center=false);

  }
}

//centerShelfC();




fixedShelfH_H = plyH;
fixedShelfH_W = 1/3*sideG_H+17*inch+1/3*longDividerH;
module fixedShelfH() {
  cube([fixedShelfH_W, 7.5*inch, fixedShelfH_H], center=false);
}

// assembly

bottomA();
translate([(bottomW-plyH)/2, 0, 2*plyH/3]) centerDividerD();
translate([longDividerOffset+longDividerH,0,2*plyH/3]) mirror([1,0,0]) longDividerB();
translate([bottomW-longDividerOffset-plyH,0,2*plyH/3]) longDividerB();
translate([longDividerOffset+2*plyH/3, 0, 5.75*inch+2*plyH/3])centerShelfC();

translate([0,0,longDividerW+plyH/3])topA();
translate([bottomW+2*sideG_H/3, 0, 0]) rotate([0,-90,0]) color("orange") sideG();
translate([-2*sideG_H/3,0,0]) mirror([1,0,0]) rotate([0,-90,0]) color("orange") sideG();

color("brown")translate([0, 0, 5.75*inch+2*plyH/3])fixedShelfH();
color("brown")translate([bottomW-fixedShelfH_W, 0, 5.75*inch+2*plyH/3])fixedShelfH();

//drawerFor8mmBits();

