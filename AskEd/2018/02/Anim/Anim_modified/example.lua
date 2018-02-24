display.setStatusBar( display.HiddenStatusBar )

-- Sequence Definitions
local sequenceData1 = {
    {
        name = "loop",
        start = 1,
        count = 10,
        time = 2400,
        loopCount = 1,
    },
}

local sequenceData2 = {
	{name='rest0', frames = {1},  time = 80, 		loopCount = 1, },
	{name='etc1',  frames = {8},  time = 200, 	loopCount = 1, },
	{name='E2',    frames = {5},  time = 240, 	loopCount = 1, },
	{name='rest3', frames = {1}, 	time = 480, 	loopCount = 1, },
	{name='MBP4',  frames = {10}, time = 80,		loopCount = 1, },
	{name='E5',    frames = {5},  time = 80, 		loopCount = 1, },
	{name='MBP6',  frames = {10}, time = 120, 	loopCount = 1, },
	{name='L7',    frames = {3},  time = 160, 	loopCount = 1, },
	{name='rest8', frames = {1},  time = 40, 		loopCount = 1, },
}

-- Sheet Options
local sheetOptions = {
	width = 250,
	height = 250,
	numFrames = 10
}

-- Image Sheet
local imageSheet = graphics.newImageSheet( "mouths_sheet.png", sheetOptions )

-- Locals
local w, h = display.contentWidth, display.contentHeight
local cx, cy = display.contentCenterX, display.contentCenterY
local curGroup

-- The Module
local example = {}

function example.destroy()
	display.remove( curGroup )
	curGroup = nil	
end


function example.create( sceneGroup )

	example.destroy()

	group = display.newGroup()

	sceneGroup:insert( group )

	local bg = display.newRect( group, w/2, h/2, 1.25*w, 1.25*h )
	bg:setFillColor( 0 )

	-- 
	-- This animation plays by itself all the way through, one time.
	--
   local label = display.newText( group, 'Simple loop', cx - w/3, cy - h/3 )
   --
	local anim = display.newSprite( group, imageSheet, sequenceData1 )
	anim.x = label.x
	anim.y = label.y + 150
	anim:setSequence("loop")
	anim:play()

	-- 
	-- This animation steps by one frame each time you click the bg
	-- Starts over after 10th frame
	--
	local label = display.newText( group,'Click To Advance: 1', cx + w/4, cy - h/3 )
	local anim = display.newSprite( group, imageSheet, sequenceData1 )
	anim.x = label.x
	anim.y = label.y + 150
	anim:setSequence("loop")
	anim:pause()
	--

	--
	function bg.touch( self, event )
		if( event.phase ~= "began" ) then return false end
		
		if( anim.frame == sheetOptions.numFrames ) then
		   anim:setFrame( 1 )
		else
			anim:setFrame( anim.frame + 1 )
		end

		label.text = "'Click To Advance: " .. anim.frame

		return false
	end
	bg:addEventListener( "touch" )


	-- 
	-- This animation uses sequenceData2 and steps over the animations in turn.
	-- Note: The timings cannot be what you want because the code can't change frames,
	-- except on a frame.
	--
	-- The only way to get timing perfect animations is to animate them that way when you 
	-- make the art.
	--
	-- Still, you might find this is 'good enough'
	--
	local nextSeq = {}
	nextSeq.rest0 	= "etc1"
	nextSeq.etc1 	= "E2"
	nextSeq.E2 		= "rest3"
	nextSeq.rest3 	= "MBP4"
	nextSeq.MBP4 	= "E5"
	nextSeq.E5 		= "MBP6"
	nextSeq.MBP6 	= "L7"
	nextSeq.L7 		= "rest8"
	nextSeq.rest8 	= nil
	--
	local curSeq = "rest0"
	--
	local label = display.newText( group,'Custom-Stepped', cx, cy + 100 )
	local anim = display.newSprite( group, imageSheet, sequenceData2 )
	anim.x = label.x
	anim.y = label.y + 150
	anim:setSequence("rest0")	
	-- 
	function anim.sprite( self, event )
		-- uncomment to print frame info
		--[[
		for k,v in pairs(event) do
			print(k,v)
		end
		print("---------------")
		--]]
		
		if( event.phase == "ended" ) then
			local nextSeqToPlay = nextSeq[self.sequence]

			if( nextSeqToPlay == nil ) then
				self:pause()
			else
				label.text = 'Custom-Stepped: ' .. nextSeqToPlay
				self:setSequence( nextSeqToPlay )
				self:play()
			end
		end
	end
	anim:addEventListener( "sprite" )
	--
	anim:play()





end


return example