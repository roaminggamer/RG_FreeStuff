
local proxy = require "proxy"

-- create a display object (any kind--can also be a sprite, rect, etc.)
local aCircle = display.newCircle(50, 50, 20 )

-- convert 'aCircle' to a proxy-based display object
aCircle = proxy.get_proxy_for( aCircle )

-- next, let's set up a listener for property updates
function aCircle:propertyUpdate( event )

	-- listen to updates on x/y properties
	if event.key == "x" or event.key == "y" then
		print( "Changed " .. event.key .. " to " .. event.value )
	end
end
aCircle:addEventListener( "propertyUpdate" )


aCircle.x = display.contentCenterX
-- Terminal output: "Changed x to 160"

aCircle.y = display.contentCenterY
-- Terminal output: "Changed y to 240"

transition.to( aCircle, { x = 200, time = 1000 } )


local scoreLabel = display.newText( "", 240, 40 )
scoreLabel = proxy.get_proxy_for( scoreLabel )
function scoreLabel:propertyUpdate( event )
	-- listen to updates on x/y properties
	if event.key == "score" then
		self.text = math.round(event.value)
	end
end
scoreLabel:addEventListener( "propertyUpdate" )
scoreLabel.score = 0

transition.to( scoreLabel, { score = 10000, time = 10000 } )