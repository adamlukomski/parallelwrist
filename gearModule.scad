module tooth(width, thickness, height)
{
    scale([width/5,thickness/5,height/10])
    {
        difference()
        {
            translate([-2.5,0,0])
                cube([5,5,10]);
            translate([5+1.25-2.5,0-1,0])
                rotate([0,-14.0362434,0])
                    cube([5,5+2,12]);
            translate([0-1.25-2.5,0+5+1,0])
                rotate([0,-14.0362434,180])
                    cube([5,5+2,12]);
        }
    }
}

module gear(toothNo, toothWidth, toothHeight, thickness)
{
    radius = (toothWidth*1.7*toothNo)/3.141592653589793238/2;
    rotate([-90,0,0])
        union()
        {
            for(i=[0:toothNo])
                rotate([0,(360/toothNo)*i,0])
                    translate([0,0,radius-0.5])
                        tooth(toothWidth,thickness,toothHeight);
            translate([0,thickness,0])
                rotate([90,0,0])
                    cylinder(r=radius, h=thickness);
        }
}
