io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2

-- =====================================================
-- EXAMPLE BELOW
-- =====================================================
local keyTracking = {}

local function count()
	local sum = 0
	for k,v in pairs( keyTracking ) do
		sum = sum + 1
	end
	return sum
end

local group = display.newGroup()

local output = display.newText( group, "", cx, cy, native.systemFont, 40 )

local function key( event )
   local phase = event.phase
   local keyName = event.keyName
   print(keyName, phase, count())
   if( phase == "down" ) then
   	if( count() == 0 ) then
   		
   		if( keyName == "deleteBack" ) then
   			local len = string.len( output.text ) 
   			if( len == 1 ) then
					output.text = ""
				elseif( len > 1 ) then
					output.text = string.sub( output.text, 1, len-1 )
				end
   		else   			
   			output.text = output.text .. keyName
   		end
   	end
   	keyTracking[keyName] = true
   elseif( phase == "up" ) then
   	keyTracking[keyName] = nil
   end
end

Runtime:addEventListener("key", key)

