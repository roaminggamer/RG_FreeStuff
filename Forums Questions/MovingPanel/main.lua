
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function onTouch( self, event )
    local phase = event.phase

    if( phase == "began" ) then 
        self.alpha = 0.2
    elseif( phase == "ended") then
        self.alpha = 1
        transition.to( self.parent, { x = self.toX, y = self.toY, time = 250 } )
    end
    return true
end


local function makePanel( x, y )
    local group = display.newGroup()

    -- WHITE BUTTON
    local tmp = display.newCircle( group, 0, 0, 20 )    
    tmp.toX = centerX
    tmp.toY = centerY
    tmp.touch = onTouch
    tmp:addEventListener( "touch" )
    
    -- RED BUTTON
    local tmp = display.newCircle( group, 40, 0, 20 )
    tmp:setFillColor(1,0,0)
    tmp.toX = centerX + 100
    tmp.toY = centerY
    tmp.touch = onTouch
    tmp:addEventListener( "touch" )

    -- YELLOW BUTTON
    local tmp = display.newCircle( group, -40, 0, 20 )
     tmp:setFillColor(1,1,0)
    tmp.toX = centerX - 100
    tmp.toY = centerY
    tmp.touch = onTouch
    tmp:addEventListener( "touch" )

    -- PINK BUTTON
    local tmp = display.newCircle( group, 0, 40, 20 )
    tmp:setFillColor(1,0,1)
    tmp.toX = centerX
    tmp.toY = centerY + 100
    tmp.touch = onTouch
    tmp:addEventListener( "touch" )

    -- CYAN BUTTON
    local tmp = display.newCircle( group, 0, -40, 20 )
    tmp:setFillColor(0,1,1)
    group.x = x
    group.y = y
    tmp.toX = centerX
    tmp.toY = centerY - 100
    tmp.touch = onTouch
    tmp:addEventListener( "touch" )

    return group
end


makePanel( centerX, centerY )

