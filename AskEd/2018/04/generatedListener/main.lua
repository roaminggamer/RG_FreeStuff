io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init()
-- =====================================================

-- =============================================
-- EXAMPLE BEGINS
-- =============================================
local baseURL = "https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles2/images/"

local function createCard( x, y, w, h, num )
	local tmp = display.newRect( x, y, w, h )

	local function networkListener( event )
		if ( event.isError ) then
			display.remove( tmp )
    	
    	elseif ( event.phase == "ended" ) then
			tmp.isVisible = true
			tmp.fill = { type = "image", filename = event.response.filename, baseDir = event.response.baseDirectory }
		end
	end

	local to 	= "cardClubs" .. num .. ".png"
	local from  = baseURL .. to	

	local params = {}
	network.download( from, "GET", networkListener, params, to, system.TemporaryDirectory )
end


local cardW = 140/2
local cardH = 190/2


local tmp = display.newRect( display.contentCenterX, display.contentCenterY, 100, 100 )
local instr = display.newText( "Touch Square To Run Example", tmp.x, tmp.y + tmp.contentHeight/2 + 30, native.systemFont, 30  )

tmp.touch = function( self, event )
	if( event.phase == "ended" ) then
		display.remove( tmp )
		display.remove( instr )

		local x = display.contentCenterX - display.actualContentWidth/2 + cardW/2
		local y = display.contentCenterY

		for i = 2, 10 do
			createCard( x, y, cardW * 0.95, cardH * 0.95, i )
			x = x + cardW
		end
	end		
	return true
end; tmp:addEventListener( "touch" )




-- =============================================
-- EXAMPLE END
-- =============================================

