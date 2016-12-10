-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The asker wanted to make a game that allowed one to change a charcters clothes.", 
	"My first thought was of clothes changer like the one below.",
	"",
	"Drag clothes onto the girl/doll to see what happens.",
	"(Images from: http://too-much-time.com/2012/03/free-printable-paper-dolls-lots-and-lots.html )"
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- Load SSK
--require "ssk.loadSSK"


-- Create girl/doll to dress
-- 
local doll = display.newImageRect( "girl.png", 152, 364 )
doll.x = display.contentCenterX
doll.y = display.contentCenterY + 50


-- Function to check if dress is 'over' doll
--
local minOffset = 50 -- Must be within 50 pixels of center of 'doll' to be over
local function isOverDoll( dress )
	local dx = dress.x - doll.x
	local dy = dress.y - doll.y
	return (( dx * dx + dy * dy ) <= minOffset * minOffset ) 
end


-- Common dress drag and drop code
-- 
local dresses = {}
local function onTouch( self, event )
	local id = event.id
	if( event.phase == "began" ) then
		self:toFront()
		self.xScale = 1
		self.yScale = 1
		self.x1 = self.x
		self.y1 = self.y
		display.getCurrentStage():setFocus( self, id )
		self.isFocus = true
		return true

	elseif( self.isFocus ) then
		if( event.phase == "moved" ) then
			self.x = self.x1 + event.x - event.xStart
			self.y = self.y1 + event.y - event.yStart
			
		elseif( event.phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
			if( isOverDoll( self ) ) then
				for i = 1, #dresses do
					local curDress = dresses[i] 
					if( curDress ~= self ) then
						transition.to( curDress, { x = curDress.x0, y = curDress.y0, time = 250 } )
					end
				end
				transition.to( self, { x = doll.x, y = doll.y, time = 50 } )
			else 
				transition.to( self, { x = self.x1, y = self.y1, time = 250 } )
			end
		end
		return true
	end

	return false
end


-- Dress placer function
-- 
local function placeDress( x, y, num )
	local dress = display.newImageRect( "dress" .. num .. ".png", 152, 364 )
	dress.x = x
	dress.y = y
	dress.x0 = x
	dress.y0 = y
	dresses[#dresses+1] = dress
	dress.touch = onTouch
	dress:addEventListener("touch")
end


placeDress( doll.x - 200, doll.y, 1 )
placeDress( doll.x + 200, doll.y, 2 )
placeDress( doll.x + 300, doll.y, 3 )



