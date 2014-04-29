-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Prototyping Objects
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================
-- Adapted from: http://developer.coronalabs.com/code/chains
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

-- Create the display class if it does not yet exist
--
local displayExtended
if( not _G.ssk.display ) then
	_G.ssk.display = {}
end
displayExtended = _G.ssk.display

-- ==
--    func() - what it does
-- ==
function displayExtended.chain( parentGroup, linkWidth, points, linkImage )

	local links = display.newGroup()
	parentGroup:insert(links)
        
	for i=2, points.numChildren do
		local a, b = points[i-1], points[i]
                
		local pt  = { (a.x+b.x)/2 , (a.y+b.y)/2 }
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
		link.linearDamping = linearDamping
		link.angularDamping = angularDamping
		link.alpha = alpha
                
		local c, d = links[ links.numChildren-1 ], link
                
		if (c and d) then
			c.nextjoint = physics.newJoint( "pivot", c, d, a.x, a.y )
		end
	end
        
	links.first = links[1]
	links.last = links[links.numChildren]
        
	return links
end

