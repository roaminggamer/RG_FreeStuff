local public = {}

-- Useful Localizations
-- SSK
--
local newImageRect 	= ssk.display.newImageRect
local easyIFC   		= ssk.easyIFC

function public.show()


	local curPage = 1
	local page = {}
	page[#page+1] = { "images/help_currentpage.png", "Current Page", "Click these buttons to select the current page."}
	page[#page+1] = { "images/help_pencolor.png", "Pen Color", "Click these buttons to change the current pen color."}
	page[#page+1] = { "images/help_backcolor.png", "Background Color", "Click these buttons to change the background color."}
	page[#page+1] = { "images/help_pensize.png", "Pen Size", "Click these buttons to select the current pen size."}
	page[#page+1] = { "images/help_undo.png", "Undo Last", "Click this button to undo the last draw(s)."}
	page[#page+1] = { "images/help_clear.png", "Clear Page", "Click this button to clear the page."}
	page[#page+1] = { "images/help_about.png", "Tip 1: Multi-finger Drawing", "Draw with multiple fingers at once for interesting effects."}
	page[#page+1] = { "images/help_about.png", "Tip 2: Screen Cast During Meetings", "Use a screen-casting app to share\nyour drawings in video meetings\n(Google Hangouts, Skype, ...)."}
	page[#page+1] = { "images/help_about.png", "Tip 3: Use A Pen", "Fingers are great, but pens are more precise."}
	page[#page+1] = { "images/help_about.png", "Thank You", "This is a very simple (and free) whiteboard app.\nIf you liked it, please see our other apps.\n\nRoaming Gamer, LLC.\n\http://roaminggamer.com"}

	local group = display.newGroup()

	-- PayPal
	local donateB = newImageRect( group, right - 140, bottom - 120, "images/paypaldonate.png", { w = 225, h = 125 } )
	function donateB.touch( self, event )
		if(event.phase ~= "ended") then return false end
		system.openURL("https://www.paypal.me/roaminggamer/10")
		return true

	end; donateB:addEventListener("touch", donateB)


	group.enterFrame = function( self )
		self:toFront()
		donateB:toFront()
	end
	listen("enterFrame",group)


	local catcher = newImageRect( group, centerX, centerY, "images/fillT.png", 
		{ w = fullw, h = fullh, fill = _O_, touch = function() return true end  } )

	catcher.fill = { type = "image", filename =  page[curPage][1] }

	local title = easyIFC:quickLabel( group, page[curPage][2], centerX, centerY - fullh/4, gameFont, 44 )
	local descr = easyIFC:quickLabel( group, page[curPage][3], centerX, centerY, gameFont, 32 )

	local function onPrev( event )
		curPage = (curPage == 1) and #page or (curPage - 1)
		catcher.fill = { type = "image", filename =  page[curPage][1] }
		title.text = page[curPage][2]
		descr.text = page[curPage][3]
	end
	local function onNext( event )
		curPage = (curPage == #page) and 1 or (curPage + 1)
		catcher.fill = { type = "image", filename =  page[curPage][1] }
		title.text = page[curPage][2]
		descr.text = page[curPage][3]
	end
	local function onDone( event )
		ignore("enterFrame", group)
		display.remove(group)
	end


	local tmp = easyIFC:presetPush( group, "default", centerX - 100, centerY + fullh/4 , 40, 40,  "<<", onPrev )
	local tmp = easyIFC:presetPush( group, "default", centerX, centerY + fullh/4 , 120, 40,  "Done", onDone )
	local tmp = easyIFC:presetPush( group, "default", centerX + 100, centerY + fullh/4, 40, 40,  ">>", onNext )

end

return public