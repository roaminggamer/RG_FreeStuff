-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
-- =============================================================
--                              License
-- =============================================================
--[[
    > SSK is free to use.
    > SSK is free to edit.
    > SSK is free to use in a free or commercial game.
    > SSK is free to use in a free or commercial non-game app.
    > SSK is free to use without crediting the author (credits are still appreciated).
    > SSK is free to use without crediting the project (credits are still appreciated).
    > SSK is NOT free to sell for anything.
    > SSK is NOT free to credit yourself with.
]]
-- =============================================================
--[[ 

-- USAGE Sample


local resizer = ssk.RGSizer
local smiley = display.newImageRect( "smiley.png", 500, 500 )
smiley.x = display.contentCenterX
smiley.y = display.contentCenterY
--smiley.strokeWidth = 4

function smiley.touch( self, event )
    if( self.myResizer ) then
        return self.myResizer:touch( event )
    end

    if( event.phase == "began" ) then
        print("OLD TOUCH - began") 
        resizer.add( self )
        return self.myResizer:touch( event )    
    else
        print("OLD TOUCH - ", event.phase) 
    end
    return false
end
smiley:addEventListener( "touch" )
--]]

local RGSizer = {}



local function removeResizer( obj )

    local myResizer = obj.myResizer
    myResizer:removeHandles()

    obj.myResizer.mObj = nil
    obj.myResizer:removeEventListener( "touch" )
    display.remove(obj.myResizer)
    obj.myResizer = nil
end


local squeezeLimit  = 35
local handleSize    = 15
local sizerColor    = {0, 0.7, 0}
local handleColor   = {0.5, 0.9, 0.5}

function RGSizer.add( obj )
    -- Proxy Dragger w/ Marching Ants Effect
    local resizer = display.newRect( obj.parent, obj.x, obj.y, 
                                    obj._originalWidth or obj.contentWidth, 
                                    obj._originalHeight or obj.contentHeight )
    resizer:setFillColor( 0, 0, 0, 0 )
    resizer.isHitTestable = true
    resizer.myObj = obj 
    obj.myResizer  = resizer 
    obj._originalWidth = obj._originalWidth or obj.contentWidth
    obj._originalHeight = obj._originalHeight or obj.contentHeight


    function resizer.touch( self, event )
        if(event.phase == "began") then
            self.x0 = resizer.x            
            self.y0 = resizer.y
            self:removeHandles()
        else
            local dx        = event.x - event.xStart
            local dy        = event.y - event.yStart
            self.x          = self.x0 + dx
            self.y          = self.y0 + dy
            self.myObj.x    = self.x
            self.myObj.y    = self.y

            if( self.rr ) then
                self.rr.x = self.x + self.contentWidth/2
                self.rr.y = self.y
            end
            if( self.lr ) then
                self.lr.x = self.x - self.contentWidth/2
                self.lr.y = self.y
            end
            if( self.tr ) then
                self.tr.x = self.x
                self.tr.y = self.y - self.contentHeight/2
            end
            if( self.br ) then
                self.br.x = self.x
                self.br.y = self.y + self.contentHeight/2
            end

            if( event.phase == "ended" ) then

                if( resizer.strokeWidth ~= 4 ) then
                    resizer.strokeWidth = 4
                    resizer:setStrokeColor( unpack(sizerColor) ) 
                    resizer.stroke.effect = "generator.marchingAnts"
                end

                self:addHandles()

                if( not self.isSelected ) then
                    self.isSelected = true
                elseif( math.abs(dx) < 10 and math.abs(dy) < 10 ) then
                    removeResizer( obj )
                end               
            end
        end
        return true
    end
    resizer:addEventListener( "touch" ) 

    function resizer.removeHandles( self )
        if( self.rr ) then
            Runtime:removeEventListener("enterFrame", self.rr)
            self.rr:removeEventListener("touch")
            display.remove( self.rr )
            self.rr = nil
        end
        if( self.lr ) then
            Runtime:removeEventListener("enterFrame", self.lr)
            self.lr:removeEventListener("touch")
            display.remove( self.lr )
            self.lr = nil
        end
        if( self.tr ) then
            Runtime:removeEventListener("enterFrame", self.tr)
            self.tr:removeEventListener("touch")
            display.remove( self.tr )
            self.tr = nil
        end
        if( self.br ) then
            Runtime:removeEventListener("enterFrame", self.br)
            self.br:removeEventListener("touch")
            display.remove( self.br )
            self.br = nil
        end
    end
    function resizer.addHandles( theResizer )
        --
        -- Right Resizer Handle
        local handle = display.newRect( obj.parent, obj.x + obj.contentWidth/2, obj.y, handleSize, handleSize )
        theResizer.rr = handle
        handle:setFillColor(unpack(handleColor))
        function handle.touch( self, event )
            if( event.phase == "began" ) then
                self.x0 = self.x
                display.getCurrentStage():setFocus( self, event.id )
                self.isFocus = true
            elseif( self.isFocus ) then
                local dx        = event.x - event.xStart
                self.x          = self.x0 + dx

                local dw = math.abs(self.x - obj.x)
                local scale = dw/(obj._originalWidth/2)
                obj.xScale = scale
                obj.myResizer.xScale = scale
                if( theResizer.lr ) then 
                    theResizer.lr.x = obj.x - obj.contentWidth/2
                end

                if(self.x < obj.x + squeezeLimit) then
                    self.x = obj.x + squeezeLimit 
                end
                if( event.phase == "ended" ) then
                    display.getCurrentStage():setFocus( self, nil )
                    self.isFocus = false           
                end
            end
            return true
        end        
        handle:addEventListener( "touch" )   

        local dw = math.abs(handle.x - obj.x)
        local scale = dw/(obj._originalWidth/2)
        obj.xScale = scale
        obj.myResizer.xScale = scale


        --
        -- Left Resizer Handle
        local handle = display.newRect( obj.parent, obj.x - obj.contentWidth/2, obj.y, handleSize, handleSize )
        theResizer.lr = handle
        handle:setFillColor(unpack(handleColor))
        function handle.touch( self, event )
            if( event.phase == "began" ) then
                self.x0 = self.x
                display.getCurrentStage():setFocus( self, event.id )
                self.isFocus = true
            elseif( self.isFocus ) then
                local dx        = event.x - event.xStart
                self.x          = self.x0 + dx

                local dw = math.abs(self.x - obj.x)
                local scale = dw/(obj._originalWidth/2)
                obj.xScale = scale
                obj.myResizer.xScale = scale
                if( theResizer.rr ) then 
                    theResizer.rr.x = obj.myResizer.x + obj.myResizer.contentWidth/2
                end

                if(self.x > obj.x - squeezeLimit) then
                    self.x = obj.x - squeezeLimit 
                end
                if( event.phase == "ended" ) then
                    display.getCurrentStage():setFocus( self, nil )
                    self.isFocus = false           
                end
            end
            return true
        end
        handle:addEventListener( "touch" )   

        --
        -- Top Resizer Handle
        local handle = display.newRect( obj.parent, obj.x, obj.y - obj.contentHeight/2, handleSize, handleSize )
        theResizer.tr = handle
        handle:setFillColor(unpack(handleColor))
        function handle.touch( self, event )
            if( event.phase == "began" ) then
                self.y0 = self.y
                display.getCurrentStage():setFocus( self, event.id )
                self.isFocus = true
            elseif( self.isFocus ) then
                local dy        = event.y - event.yStart
                self.y          = self.y0 + dy

                local dh = math.abs(self.y - obj.y)
                local scale = dh/(obj._originalHeight/2)
                obj.yScale = scale
                obj.myResizer.yScale = scale

                if( theResizer.br ) then 
                    theResizer.br.y = obj.myResizer.y + obj.myResizer.contentHeight/2
                end

                if(self.y > obj.y - squeezeLimit) then
                    self.y = obj.y - squeezeLimit 
                end
                if( event.phase == "ended" ) then
                    display.getCurrentStage():setFocus( self, nil )
                    self.isFocus = false           
                end
            end
            return true
        end
        handle:addEventListener( "touch" )   

        local dh = math.abs(handle.y - obj.y)
        local scale = dh/(obj._originalHeight/2)
        obj.yScale = scale
        obj.myResizer.yScale = scale


        --
        -- Bottom Resizer Handle
        local handle = display.newRect( obj.parent, obj.x, obj.y + obj.contentHeight/2, handleSize, handleSize )
        theResizer.br = handle
        handle:setFillColor(unpack(handleColor))
        function handle.touch( self, event )
            if( event.phase == "began" ) then
                self.y0 = self.y
                display.getCurrentStage():setFocus( self, event.id )
                self.isFocus = true
            elseif( self.isFocus ) then
                local dy        = event.y - event.yStart
                self.y          = self.y0 + dy

                local dh = math.abs(self.y - obj.y)
                local scale = dh/(obj._originalHeight/2)
                obj.yScale = scale
                obj.myResizer.yScale = scale

                if( theResizer.tr ) then 
                    theResizer.tr.y = obj.myResizer.y - obj.myResizer.contentHeight/2
                end

                if(self.y < obj.y + squeezeLimit) then
                    self.y = obj.y + squeezeLimit 
                end
                if( event.phase == "ended" ) then
                    display.getCurrentStage():setFocus( self, nil )
                    self.isFocus = false           
                end
            end
            return true
        end
        handle:addEventListener( "touch" )   
    end
end

if( _G.ssk ) then
    ssk.RGSizer = RGSizer
else 
    _G.ssk = { RGSizer = RGSizer }
end

return RGSizer