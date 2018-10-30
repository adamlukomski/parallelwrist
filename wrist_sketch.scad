/* based on video: https://www.youtube.com/watch?v=aLaqMreVj9o
LIMS2-AMBIDEX wrist principle - the contact of two rolling spheres

(btw. this is also the basic mechanism behind all Delta printers,
but usually with ball-joints instead of 2DOF passive joints
old, printable carriages were using something similar)

M3 stock screws (4.5mm holes for them to turn freely)

*/

$fn=12;

module joint_mount(screwhole = 4.5, distance = 4, walls = 2)
{
    // walls define both wall depth and borders around holes
    holeborder = walls;
    translate([0,-walls,0]) // centered between holes, close to inner wall
    rotate([-90,0,0]) // vertical
    // 2mm walls around screwhole, 4mm in between for link's arm
    for( z=[0,distance+walls])
    {
        difference()
        {
            union()
            {
                // main wall and support
                translate([0,0,z])
                    cylinder( d=screwhole+2*holeborder, h=walls );
                translate([-(screwhole+2*holeborder)/2,0,z])
                    cube([screwhole+2*holeborder,screwhole+2*holeborder,walls]);
            }
            // holes
            translate([0,0,z-0.1]) cylinder( d=screwhole, h=walls+0.2 );
        }
    }
}

module joint_arm(screwhole = 4.5, distance = 4, walls = 2)
{
    holeborder = walls;
    rotate([-90,0,0]) // vertical
    
    difference()
        {
            union()
            {
                // main wall and support
                translate([0,0,0])
                    cylinder( d=screwhole+2*holeborder, h=distance );
                translate([-(screwhole+2*holeborder)/2,-(screwhole+2*holeborder),0])
                    cube([screwhole+2*holeborder,screwhole+2*holeborder,distance]);
            }
            // holes
            translate([0,0,-0.1]) cylinder( d=screwhole, h=distance+0.2 );
        }    
}



// //plate - ground
translate([0,0,-3-16-15]) cylinder( d=60, h=3 );
// //plate - upper
translate([0,0,50+8+15+8]) cylinder( d=60, h=3 );


// lower joints
for( angle=[0,120,240] )
{
    
    rotate([0,0,angle])
    translate([20,0,-8-15]) // push forward and lower to the ground level
    {
        //first pair
        rotate([0,0,90])
        translate([0,-8.5/2,0]) //center
        {
            joint_mount(screwhole = 4.5, distance = 8.5, walls = 2);
            joint_arm(screwhole = 4.5, distance = 8.5, walls = 2);
        }
        //second pair
        rotate([0,0,0])
        translate([0,-4.5/2,15]) //center
        {
            joint_mount(screwhole = 4.5, distance = 4.5, walls = 2);
            joint_arm(screwhole = 4.5, distance = 4.5, walls = 2);
        }
    }
}
// upper joints, +60 in phase
for( angle=[60,180,300] )
{
    
    rotate([0,0,angle])
    translate([20,0,50+8+15]) // push forward and lower to the ground level
    rotate([180,0,0])
    {
        //first pair
        rotate([0,0,90])
        translate([0,-8.5/2,0]) //center
        {
            joint_mount(screwhole = 4.5, distance = 8.5, walls = 2);
            joint_arm(screwhole = 4.5, distance = 8.5, walls = 2);
        }
        //second pair
        rotate([0,0,0])
        translate([0,-4.5/2,15]) //center
        {
            joint_mount(screwhole = 4.5, distance = 4.5, walls = 2);
            joint_arm(screwhole = 4.5, distance = 4.5, walls = 2);
        }
    }
}
// join them on the cross basis
for( angle=[0,120,240] )
    linear_extrude(height = 50, center = false, convexity = 10, twist = 180, slices=36)
        rotate([0,0,angle])
        translate([20-4,-2,0]) // push forward and lower to the ground level
        square([8,4]);


