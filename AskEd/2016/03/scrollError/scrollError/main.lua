-- EFM 1 BEGIN Added for ease of helping
local w 			= display.contentWidth
local h 			= display.contentHeight
local fullw 		= display.actualContentWidth
local fullh 		= display.actualContentHeight
local centerX 		= display.contentCenterX
local centerY 		= display.contentCenterY
local left   		= centerX - fullw/2
local right  		= centerX + fullw/2
local top    		= centerY - fullh/2
local bottom 		= centerY + fullh/2
-- EFM 1 END

local scroll = {}

local background = display.newRect( centerX, centerY, fullw, fullh)

-- I created a scroll system with layers that each have their own parallax setting. 
-- This is just a chunk of code with one layer to work with enterframe listner below



scroll.layers = {}
scroll.layers[1] = {}
layer = scroll.layers[1]
layer.objects = display.newGroup()
layer.distanceRatio = 1.2

local object = display.newImage(  "debug.png",0,0 )
layer.objects:insert(object)
layer.rightObject = object
scroll.parallaxEnabled = true
scroll.shouldMove = true

local layers = scroll.layers
local screenScrollBuffer = 20
--local rightThreshold = display.contentWidth + screenScrollBuffer  -- EFM 2  This isn't really 
local rightThreshold = right  -- EFM 2
local _speed = 5

scroll.enterFrame = function ( self, event )
	if self.shouldMove then

	    if self.parallaxEnabled and (layers ~= nil) then
	      	for i=1,#layers do

				local layer = layers[i]
	      		if layer ~= nil then

		      		-- scroll the layers according to parallax settings
					layer.objects.x = layer.objects.x - _speed * layer.distanceRatio

					local ox = layer.objects.x
					local rx = layer.rightObject.x
					local rw = layer.rightObject.contentWidth
					local redge = layer.rightObject:localToContent( 0, 0 ) + rw/2

					--print( ox, right, redge, redge <= right )

					if( redge <= right ) then
						local newRightObject = display.newImage( layer.objects, "debug.png" )
						newRightObject.x = layer.rightObject.x + rw
						newRightObject.y = layer.rightObject.y

						layer.rightObject = newRightObject

						-- Onscreen Test Marker
						local circle = display.newCircle( layer.objects, rx + rw/2, centerY, 20 ) 
						circle:setFillColor( 1,1,0 )
					end

				end
			end
	    end
	end
end

Runtime:addEventListener( "enterFrame", scroll )