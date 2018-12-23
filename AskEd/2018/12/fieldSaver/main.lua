io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--
-- https://roaminggamer.github.io/RGDocs/pages/SSK2

--
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================

--
-- This example uses SSK2 'persist' because it is specifically
-- made to accomodate frequent updates and to auto-save those 
-- changes/updates.
--
-- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/persist/
--

--
-- This example assume 'text' fields.  You need to add additional logic on your own
-- to handle saving and restoring 
--

--
-- This code is 'helper' code made to simplify and homogenize making multiple fields
-- that auto-save changes and auto-restore them on next-load.
--

local persist = ssk.persist

local fields = {}

local function userInput( self, event )
	if ( event.phase == "began" ) then
	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		persist.set( "fieldValues.json", self._id, self.text )
	elseif ( event.phase == "editing" ) then
		persist.set( "fieldValues.json", self._id, self.text )
	end
	return false
end

local function makeField( x, y, w, h, id, params )
	params = params or {}
	--
	local field = native.newTextField( x, y, w, h )
	field._id = "field_" .. id
	field.userInput = userInput
	field:addEventListener( "userInput" )
	for k,v in pairs(params) do
		field[k] = v
	end
	
	-- Restore prior value for this field if it exists
	--
	local restoreValue = persist.get( "fieldValues.json", field._id ) or ""
	field.text = restoreValue
	--
	return field
end

--
-- Now use the helper from above to make some fields
--
local label = display.newText( "User Name:", centerX - 160, centerY - 30, nil, 20)
label.anchorX = 1
local userName = makeField( centerX, label.y, 300, 40, 'userName' )


local label = display.newText( "Password:", centerX - 160, centerY + 30, nil, 20)
label.anchorX = 1
local password = makeField( centerX, label.y, 300, 40, 'password', { isSecure = true } )
