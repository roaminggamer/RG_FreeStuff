
local centerX = display.contentCenterX
local centerY = display.contentCenterY


local composite_effect = {
"composite.add",
"composite.average", 
"composite.colorBurn",
"composite.colorDodge",
"composite.darken",  
"composite.exclusion",
"composite.glow",
"composite.hardLight",
"composite.hardMix",
"composite.lighten",
"composite.linearLight",
"composite.multiply",
"composite.negation",
"composite.normalMapWith1DirLight",
"composite.normalMapWith1PointLight",
"composite.overlay",
"composite.phoenix", 
"composite.pinLight", 
"composite.reflect",
"composite.screen",
"composite.softLight",
"composite.subtract",
"composite.vividLight",
}

local color2 = { 0.2, 0.2, 1, 1 }
local color1 = { 1, 1, 1, 1 }
local color3 = { 0.2, 0.2, 1, 0 }

local gradient = 
{
    type="gradient",
    color1=color1, 
    color2=color3, 
    direction="down"
}

local compositePaint =  
{     
    type="composite",     
        paint2 = { type="image", filename = "vial2.png" },     
        paint1 = gradient  
}


local backGroup = display.newGroup()
local myBack = display.newRect( backGroup, 0, 0, display.contentWidth, display.contentHeight )
myBack.x = centerX
myBack.y = centerY
myBack:setFillColor(1,1,0)

local vialGroup = display.newGroup()

local vialunder = display.newImageRect( vialGroup, "vial2.png", 219, 296)
vialunder.x = centerX
vialunder.y = centerY


local fillingVial = display.newRect( vialGroup, 0, 0, 219, 296 )
fillingVial.x = centerX
fillingVial.y = centerY

local vialover = display.newImageRect( vialGroup, "vial.png", 219, 296)
vialover.x = centerX
vialover.y = centerY



fillingVial.fill = compositePaint
fillingVial.fill.effect = composite_effect[3]

--[[
local num = 1
local function doit() 
    print("Num", num, composite_effect[num])
    fillingVial.fill.effect = composite_effect[num]
    num = num + 1

    if( num > #composite_effect ) then return end
    timer.performWithDelay( 1000, doit )
end

doit()
--]]

local rDiff = color2[1] - color1[1]
local gDiff = color2[2] - color1[2]
local bDiff = color2[3] - color1[3]
local aDiff = color2[4] - color1[4]

local steps = 100
local rDelta = rDiff / steps
local gDelta = gDiff / steps
local bDelta = bDiff / steps
local aDelta = aDiff / steps

local step = 1
local function doit2() 
    print(step, color1[1], color1[2], color1[3], color1[4])
    print(step, color3[1], color3[2], color3[3], color3[4])
    color3[1] = color1[1] + step * rDelta
    color3[2] = color1[2] + step * gDelta
    color3[3] = color1[3] + step * bDelta
    color3[4] = color1[4] + step * aDelta
    step = step + 1
    fillingVial.fill = compositePaint
    fillingVial.fill.effect = composite_effect[3]

end

timer.performWithDelay( 30, doit2, steps )
