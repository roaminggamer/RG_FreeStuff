
local scroll = {}

local background = display.newRect( display.contentCenterX,display.contentCenterY, display.contentWidth, display.contentHeight)
background:setFillColor( 1,1,1 )

-- I created a scroll system with layers that each have their own parallax setting. 
-- This is just a chunk of code with one layer to work with enterframe listner below

scroll.layers = {}
scroll.layers[1] = {}
layer = scroll.layers[1]
layer.objects = display.newGroup()
layer.distanceRatio = 1.2

local object = display.newImage(  "layer_01_2048x1546.png",0,0 )
layer.objects:insert(object)
layer.rightObject = object
scroll.parallaxEnabled = true
scroll.shouldMove = true

local layers = scroll.layers
local screenScrollBuffer = 20
local rightThreshold = display.contentWidth + screenScrollBuffer 
local _speed = 5

scroll.enterFrame = function ( self, event )
	if self.shouldMove then

	    if self.parallaxEnabled and (layers ~= nil) then
	      	for i=1,#layers do

				local layer = layers[i]
	      		if layer ~= nil then

		      		-- scroll the layers according to parallax settings
					layer.objects.x = layer.objects.x - _speed * layer.distanceRatio

					-- ########### ERROR BELOW HERE, i think #############
					-- if rightObject in layer and its near edge of screen create the next scroll image
					local rightObject = layer.rightObject
					if rightObject ~= nil then
						local rightObjectX, rightObjectY = rightObject:localToContent( 0, 0 ) -- 0,0 centre of the object
						-- local rightObjectX = rightObject.x  -- im pretty sure i need to convert the group to screen coords
						local rightMostEdge = rightObjectX + 0.5 * rightObject.contentWidth

						if rightMostEdge <= rightThreshold then
							local newRightObject = display.newImage(  "layer_01_2048x1546.png")
							
							-- position image
							newRightObject:translate( rightMostEdge + 0.5 * newRightObject.contentWidth, 0 )
							
							--[[Onscreen Test Marker]] local circle = display.newCircle( layer.objects, rightMostEdge, display.contentHeight/2, 10 ); circle:setFillColor( 1,0,0 ); circle:toFront( )
							
							-- assign right image pointer
							layer.rightObject = newRightObject

							-- self:addParallaxObject(i, newRightObject)
							layer.objects:insert(newRightObject)	-- group method
						end
					end
					-- ########### ERROR ABOVE HERE, I think #############


				end
			end
	    end
	end
end

Runtime:addEventListener( "enterFrame", scroll )