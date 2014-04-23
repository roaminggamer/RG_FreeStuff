
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function makeGroupSet( x, y )
    local group = display.newGroup()
    local tmp = display.newCircle( group, 0, 0, 20 )    
    local tmp = display.newCircle( group, 40, 0, 20 )
    tmp:setFillColor(1,0,0)
    local tmp = display.newCircle( group, -40, 0, 20 )
    tmp:setFillColor(1,1,0)
    local tmp = display.newCircle( group, 0, 40, 20 )
    tmp:setFillColor(1,0,1)
    local tmp = display.newCircle( group, 0, -40, 20 )
    tmp:setFillColor(0,1,1)
    group.x = x
    group.y = y
    return group
end


local set1 = makeGroupSet( centerX - centerX/2 - 40, centerY )
local set2 = makeGroupSet( centerX, centerY )
local set3 = makeGroupSet( centerX + centerX/2 + 40, centerY )

-- xScale/yScale
set1.xScale = 0.5
set1.yScale = 0.5

-- obj:scale()
set2:scale( 0.5, 0.5 )


-- Transitions
local upScale
local downScale
upScale = function ( set )
    transition.to( set, { xScale = 1.5, yScale = 1.5, time = 500, onComplete=downScale })
end
downScale = function( set )
    transition.to( set, { xScale = 0.1, yScale = 0.1, time = 500, onComplete=upScale })
end
downScale( set3 )
