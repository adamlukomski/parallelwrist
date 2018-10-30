use <gearModule.scad>

module gear2(thick=5,flip=false) // height 15
{
    translate([0,0,0])
    intersection()
    {
        //thick = 5;
        translate([0,0,thick])
            gear(toothNo=14, toothWidth=2,
                 toothHeight=3.5, thickness=thick,
                 holeRadius=0,holeSides=4);

        union()
        {
            r1=11.5;
            r2 = 8.5;
            
            if(flip) {
            cylinder( r1=r2,r2=r1,h=thick/4);
            translate([0,0,thick/4]) cylinder( r1=r1,r2=r1,h=3*thick/4);
            //translate([0,0,3*thick/4]) cylinder( r1=r1,r2=r2,h=thick/4);
            }
            else
            {
            //cylinder( r1=r2,r2=r1,h=thick/4);
            translate([0,0,0]) cylinder( r1=r1,r2=r1,h=3*thick/4);
            translate([0,0,3*thick/4]) cylinder( r1=r1,r2=r2,h=thick/4);
            }
        }
    }
}


module spool(a=1,r1=8.5,r2=7.5,maintrackextra=0,part_length=10) {
    
    //middle
    hull() {
        translate( [0,0,0] )
            cylinder( r1=r1, r2=r2, h=a );
        translate( [0,part_length,0] )
            cylinder( r1=r1, r2=r2, h=a );
    }
    
    hull() {
        translate( [0,0,a] )
            cylinder( r1=r2, r2=r2, h=a+maintrackextra );
        translate( [0,part_length,a] )
            cylinder( r1=r2, r2=r2, h=a+maintrackextra );
    }
    hull() {
        translate( [0,0,2*a+maintrackextra] )
            cylinder( r1=r2, r2=r1, h=a );
        translate( [0,part_length,2*a+maintrackextra] )
            cylinder( r1=r2, r2=r1, h=a );
    }
}


module part1(part_length=10,twosided=true)
{
    
    translate( [0,0,0] ) {
        // lower
        /*translate([0,0,-5]) hull()
        {
            cylinder( d1=10, d2=15, h=5 );
            translate( [0,10,0] ) cylinder( d1=20, d2=15, h=5 );
        }*/
        
        for(zoffset=[0,7+5])
        {
        translate( [0,0,zoffset] ) {
                spool(1.7,7.5,7.5,part_length=part_length);
                union(){
                intersection()
                {
                    translate([-14,-12,0])
                        cube([26,12,5]);
                    gear2(5,zoffset);
                }
                }
                if( twosided )
                translate([0,part_length,0])
                {
                intersection() {
                translate([-14,-2,0])
                    cube([26,14,5]);
                rotate([0,0,360/14/2])
                    gear2(5,zoffset); // zoffset acts as true/false 1/0 modifier
                }
                }
        }
    }
        
    
    
    // inner spools    
        translate( [0,0,5]) {
        //upper
        /*translate([0,0,6]) hull()
        {
            cylinder( d1=15, d2=10, h=5 );
            translate( [0,10,0] ) cylinder( d1=15, d2=20, h=5 );
        }*/
        
        spool(a=1,r1=8.5,r2=7.3,maintrackextra=0.5,part_length=part_length);
        translate( [0,0,3+0.5] ) spool(a=1,r1=8.5,r2=7.3,maintrackextra=0.5,part_length=part_length);
        }
    }
   
 
}



module part_left()
{
    intersection()
    {
        part1();
        translate([-15,-20,0])
            cube([30,20,20]);
    }
}

module part_right(a=4)
{
    intersection()
    {
        part1(part_length=a);
        translate([-15,0,0])
            cube([30,20,20]);
    }
}



module part_mounts()
{
    mounts_placement = 20;
    
    difference()
    {
    translate([0,0,0])
        cylinder(d=80,h=4);
    for(cyclic=[0,120,240])
        rotate([0,0,cyclic])
            translate([-10.5,-12-mounts_placement,-1])
                cube([21,7,6]);
    }
    
    // //just to see the shadow:
    //projection()
    //    rotate([90,0,0])
    //        part_right();
    
    for(cyclic=[0,120,240])
        rotate([0,0,cyclic])
            translate([0,-mounts_placement,0])
                rotate([90,0,0])
                    part_right(a=5);
}


//mounts_placement = 20;
//            translate([0,-mounts_placement,0])
//                rotate([90,0,0])
//                    part_left();


module part_joint()
{
    
    translate([0,8.5,0])
    rotate([90,0,0])
        part_left();
    
    
    difference()
    {
        union()
        {
            hull()
            {
            translate([0,0,0.1/2])
            cube([17,17,0.1],center=true);
            translate([0,0,5])
            cylinder(d=17,h=1);
            }
            
            hull()
            {
            translate([0,0,5])
            cylinder(d=17,h=1);
            translate([0,0,9.9-0.02])
            cube([17,17,0.1],center=true);
            }
            
        }
    
        translate([0,0,-0.01])
        {
            linear_extrude(height = 10, center = false, convexity = 10, twist = 68)
            translate([8.5,-1.7,0])
                rotate([0,0,30])
                    circle(d=3.2,$fn=12);
            linear_extrude(height = 10, center = false, convexity = 10, twist = -68)
            translate([8.5,1.7,0])
                rotate([0,0,30])
                    circle(d=3.2,$fn=12);
            linear_extrude(height = 10, center = false, convexity = 10, twist = -68)
            translate([-8.5,-1.7,0])
                rotate([0,0,30])
                    circle(d=3.2,$fn=12);
            linear_extrude(height = 10, center = false, convexity = 10, twist = 68)
            translate([-8.5,1.7,0])
                rotate([0,0,30])
                    circle(d=3.2,$fn=12);
        }
    }
    rotate([0,0,90])
        translate([0,8.5,10])
            rotate([90,0,0])
                part_right(a=1);
}


//part_arm

mounts_placement = 20;
module arms(mounts_placement = 20)
{

    //for(cyclic=[0,120,240])
    for(cyclic=[0])
        rotate([0,0,cyclic])
            translate([0,-mounts_placement-8.5,55])
                rotate([0,0,90])
                {
                    translate([0,8.5,0])
                        rotate([90,0,0])
                            part1(twosided=false,part_length=0);
                    translate([0,0,12])
                        rotate([90,0,0])
                            cylinder( d=5, h=15, center=true );
                    for(yoffset=[6,-6])
                    hull()
                    {
                        translate([0,yoffset,0])
                            rotate([90,0,0])
                                cylinder( d=15, h=5, center=true );
                        translate([0,yoffset,20])
                            rotate([0,0,0])
                                cube([10,5,1],center=true);
                    }
                        translate([0,0,20])
                            cube([10,15,1],center=true);
                }
}
            
arms();
translate([0,0,55+20+55+20+50]) mirror([0,0,1]) rotate([0,0,180]) arms();

translate([0,0,55+20])

//for(cyclic=[0,120,240])
for(cyclic=[0])
    linear_extrude(height = 50, center = false, convexity = 10, twist = 180, slices=36)
        rotate([0,0,cyclic])
            translate([0,-mounts_placement-8.5,0])
                rotate([0,0,90])
                            square([10,10],center=true);


/*mounts_placement = 20;
for(cyclic=[0,120,240])
        rotate([0,0,cyclic])
            translate([0,-mounts_placement-8.5,25])
                rotate([0,0,0])
                    part_joint();
*/

//part_mounts();