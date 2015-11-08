-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
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
-- Adapted from: http://developer.coronalabs.com/code/chains
-- =============================================================
local physics = require "physics"


-- Create the display class if it does not yet exist
--
local displayExtended = {}

-- ==
--    func() - what it does
-- ==
function displayExtended.newChain( parentGroup, linkWidth, points, linkImage )

	local links = display.newGroup()
	parentGroup:insert(links)
        
	for i=2, #points do
		local a, b = points[i-1], points[i]

		a.rotation = a.rotation or 0
		b.rotation = b.rotation or 0
                
		local pt  = { (a.x+b.x)/2 , (a.y+b.y)/2  }
		local rot = ssk.math2d.tweenAngle( a, b )

		local delta  = ssk.math2d.sub(b,a)
		local length = ssk.math2d.length(delta)
			                
		local link 
		if(linkImage) then
			link = display.newImageRect( links, linkImage, length, linkWidth )
		else
			link = display.newRect( links, 0, 0, length, linkWidth )
		end
		link.x, link.y, link.rotation = pt.x, pt.y, rot
                
		physics.addBody( link, { density=density } )
		link.linearDamping = 1
		link.angularDamping = 1
		link.alpha = 1
                
		local c, d = links[ links.numChildren-1 ], link
                
		if (c and d) then
			c.nextjoint = physics.newJoint( "pivot", c, d, a.x, a.y )
		end
	end
        
	links.first = links[1]
	links.last = links[links.numChildren]
        
	return links
end

return displayExtended