io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- IGNORE ABOVE THIS LINE
-- =============================================
-- EXAMPLE BEGIN
-- =============================================

local scale = display.contentWidth/320

local label = display.newText( string.format( "Content: < %2.3f, %2.3f >", display.contentWidth, display.contentHeight ), display.contentCenterX, scale * 20, native.systemFont, 14 * scale)

local label = display.newText( "DRAG TO SEE <X,Y>", display.contentCenterX, scale * 40, native.systemFont, 14 * scale)

local function drag( self, event )
	if event.phase == "began" then
		self.isFocus = true 
		display.getCurrentStage():setFocus( self, event.id )
		self.x0 = self.x
		self.y0 = self.y
		label.text = string.format( "< %2.3f, %2.3f >", self.x, self.y )

	elseif( self.isFocus) then
		self.x = self.x0 + (event.x - event.xStart)
		self.y = self.y0 + (event.y - event.yStart)
		label.text = string.format( "< %2.3f, %2.3f >", self.x, self.y )
	
		if( event.phase == "ended" ) then
			self.isFocus = false 
			display.getCurrentStage():setFocus( self, nil )
			self.x0 = nil
			self.y0 = nil
		end
	end
	return true
end

local tmp = display.newRect( display.contentCenterY, display.contentCenterY, 100 * scale, 100 * scale )
tmp.touch = drag
tmp:addEventListener( "touch" )
-- =============================================
-- EXAMPLE END
-- =============================================
