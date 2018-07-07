-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 
-- =============================================================
--
--
--
local pinkyInfo 	= require "pinky"
local pinkySheet 	= graphics.newImageSheet("pinky.png", pinkyInfo:getSheet() )
local pinkySeqData = 
	{
		{ name = "idle", frames = {2}, time = 1000, loopCount = 0, loopDirection = "forward"}, 
		{ name = "jump", frames = {1}, time = 1000, loopCount = 0, loopDirection = "forward"}, 
		{ name = "rightwalk", frames = {3,4,5,6,7,8,9,10,11,12,13 }, time = 500, loopCount = 0, loopDirection = "forward"}, 
		{ name = "leftwalk", frames = {3,4,5,6,7,8,9,10,11,12,13 }, time = 500, loopCount = 0, loopDirection = "forward"}, 
	}


-- NORMAL ANIMATION
local tmp = display.newSprite( pinkySheet, pinkySeqData )
tmp.x = display.contentCenterX - 150
tmp.y = display.contentCenterY
tmp:setSequence( "rightwalk" )
tmp:play()
display.newText(  "rightwalk", tmp.x, tmp.y + 70, native.systemFontBold, 30 )
display.newText(  "normal animation", tmp.x, tmp.y + 100, native.systemFontBold, 20 )



-- ANIMATION via transtion.to()
local tmp = display.newSprite( pinkySheet, pinkySeqData )
tmp.x = display.contentCenterX  + 150
tmp.y = display.contentCenterY
tmp:setSequence( "rightwalk" )
tmp._dummyAnimationFrame = 1

function tmp.enterFrame( self )
	local frameNum = math.floor(self._dummyAnimationFrame)
	--print(frameNum)

	local frames = pinkySeqData[3].frames
	if( frameNum > #frames ) then
		frameNum = #frames
	end
	self:setFrame( frameNum )

end; Runtime:addEventListener("enterFrame", tmp)

function tmp.touch( self, event  )
	if( event.phase == "ended" ) then
		transition.cancel( self )
		self._dummyAnimationFrame = 1
		transition.to( self, { _dummyAnimationFrame = #pinkySeqData[3].frames, time = 1500, transition = easing.outBack } )
	end
end; tmp:addEventListener("touch")

display.newText(  "rightwalk", tmp.x, tmp.y + 70, native.systemFontBold, 30 )
display.newText(  "transition animation", tmp.x, tmp.y + 100, native.systemFontBold, 20 )
