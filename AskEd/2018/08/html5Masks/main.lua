io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 

local tmp = display.newRect( 0, 0, 10000, 10000 )
tmp:setFillColor(0,1,1,0.2)

local genCircleMask = ssk.misc.genCircleMask

local sizes = { 32, 64, 128, 256 }
local toMask = {}


-- delayed 
for i = 1, 5 do
	local tmp = display.newImageRect( "edo.png", 250, 298 )
	tmp.x = left + i * 300
	tmp.y = centerY + 300
	toMask[i] = tmp
end

for i = 1, 4 do
	local name = "mask" .. i .. ".png"
	genCircleMask( sizes[i], name )
end

for i = 1, 4 do
	local name = "mask" .. i .. ".png"
	timer.performWithDelay( 1000 + i * 1000, 
		function()
			local mask = graphics.newMask( name, system.DocumentsDirectory  )
			toMask[i]:setMask( mask )		
		end )
end

-- fast
----[[
timer.performWithDelay( 1000,
	function()
		for i = 1, 5 do
			local tmp = display.newImageRect( "edo.png", 250, 298 )
			tmp.x = left + i * 300
			tmp.y = centerY - 300
			if( i < 5 ) then
				local name = "maski" .. i .. ".png"
				genCircleMask( sizes[i], name )
				nextFrame(
					function()
						local mask = graphics.newMask( name, system.DocumentsDirectory  )
						tmp:setMask( mask )
					end )
			end
		end
	end )
--]]
