-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
-- =============================================================
local group = display.newGroup()

local saved_fields = table.load('saved_fields.json') or {}

local listener = function( self, event )
	--[[
	table.dump(event)
	if( event.phase == "ended" ) then
		self:setSelection( 1,1 )
	end
	--]]
	saved_fields[self.myNum] = self.text 
	table.save( saved_fields, 'saved_fields.json') 
end
 
for i = 1 , 7 do 
	local tmp = native.newTextField( display.contentCenterX, 
		display.contentCenterY - display.actualContentHeight/4 + i * 60, 200, 55 )
	group:insert(tmp)

	tmp.myNum = i
	tmp.text = saved_fields[i] or ""
	tmp.id = i
	tmp.font = native.newFont( native.systemFontBold, 36 )
	tmp.align = "left"
	tmp.isEditable = true
	tmp.userInput = listener
	tmp:addEventListener( "userInput" )		
end

