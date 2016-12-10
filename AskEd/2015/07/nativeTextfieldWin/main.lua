-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"1. Run this in the Windows version of the Corona Simulator.", 
	"2. Select an Android device from the View menu or you won't get keyboard input.",
	"3. Try Tab, Shift + Tab, Enter, and Shift + Enter to see what happens."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


-- =============================================================
-- Variables and goodies to make example easier to code and read.
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") -- Don't use buffer for console messages
local w = display.contentWidth; local h = display.contentHeight; 
local centerX = display.contentCenterX; local centerY = display.contentCenterY
local fullw	= display.actualContentWidth; local fullh	= display.actualContentHeight
local left = 0 - (fullw - w)/2; local right = w + (fullw - w)/2
local top = 0 - (fullh - h)/2; local bottom = h + (fullh - h)/2

-- Table dumper
local function rpad(str, len, char)
	local theStr = str; if char == nil then char = ' ' end; return theStr .. string.rep(char, len - #theStr)
end
table.dump = table.dump or function (theTable, padding, marker )
	marker = marker or "";local theTable = theTable or {};
	local function compare(a,b) return tostring(a) < tostring(b) end
	local tmp = {};  for n in pairs(theTable) do table.insert(tmp, n) end;  table.sort(tmp,compare)
	local padding = padding or 30; print("\Table Dump:"); print("-----")
	if(#tmp > 0) then 
		for i,n in ipairs(tmp) do
			local key = tmp[i]; local value = tostring(theTable[key]);local keyType = type(key)
			local valueType = type(value);local keyString = tostring(key) .. " (" .. keyType .. ")";
			local valueString = tostring(value) .. " (" .. valueType .. ")";
			keyString = rpad(keyString,padding); valueString = rpad(valueString,padding);
			print( keyString .. " == " .. valueString );
		end
	else print("empty") end; print( marker .. "-----\n")
end
-- =============================================================
--
-- EXAMPLE STARTS BELOW
--
-- =============================================================

-- 1. Require 'RGEasyTextField' lib
local RGEasyTextField	= require "RGEasyTextField"

-- 2. Create a display group to put our text fields in.
local group = display.newGroup()
group.y = group.y + 200
--group.x = -fullw
--transition.to( group, { x = 0, delay = 500, time = 250 } )

-- 3. Create some indicators labels to show what the listener is seeing
--
local userNameLabel = display.newText( group, "", left + 120, 20, native.systemFont, 14 )
userNameLabel.anchorX = 0
userNameLabel:setFillColor( 1, 0, 1 )

local passWordLabel = display.newText( group, "", left + 120, 90, native.systemFont, 14 )
passWordLabel.anchorX = 0
passWordLabel:setFillColor( 0, 1, 0 )

local emailLabel = display.newText( group, "", left + 120, 160, native.systemFont, 14 )
emailLabel.anchorX = 0
emailLabel:setFillColor( 0, 1, 1 )


-- 4. Create listeners for each of the upcoming text fields
--
local function nameInput( self, event )
	--table.dump( event )
	if( not event.text or string.len(event.text) == 0) then
		print( event.phase, "<blank>" )
		userNameLabel.text = event.phase .. " : " .. "<blank>"
	else
		print( event.phase, event.text )
		userNameLabel.text = event.phase .. " : " .. event.text
	end	
	return true
end

local function passwordInput( self, event )
	--table.dump( event )
	if( not event.text or string.len(event.text) == 0) then
		print( event.phase, "<blank>" )
		passWordLabel.text = event.phase .. " : " .. "<blank>"
	else
		print( event.phase, event.text )
		passWordLabel.text = event.phase .. " : " .. event.text
	end	
	return true
end

local function emailInput( self, event )
	--table.dump( event )
	if( not event.text or string.len(event.text) == 0) then
		print( event.phase, "<blank>" )
		emailLabel.text = event.phase .. " : " .. "<blank>"
	else
		print( event.phase, event.text )
		emailLabel.text = event.phase .. " : " .. event.text
	end	
	return true
end


-- 5. Create some text fields
-- Username
local label = display.newText( group, "User Name", left + 10, 20, native.systemFont, 18 )
label.anchorX = 0
local nameField = RGEasyTextField.create( group, centerX, label.y + 30, fullw-20, 30, 
	                                    { placeholder = "<name>", fill = {1,1,1}, 
	                                      fontColor = {1, 0, 1}, fontSize = 10,
	                                      selStroke = { 1, 0 , 1 }, selStrokeWidth = 4,
	                                      listener = nameInput } )

-- Password
local label = display.newText( group, "Password", left + 10, nameField.y + 40, native.systemFont, 18 )
label.anchorX = 0
local passwordField = RGEasyTextField.create( group, centerX, label.y + 30, fullw-20, 30, 
	                                        { fill = {1,1,1}, fontColor = {0, 1, 0}, 
	                                          selStroke = { 0, 1 , 0 }, selStrokeWidth = 4,
	                                          listener = passwordInput } )
passwordField.placeholder = "<password>"
passwordField.isSecure = true

-- Email
local label = display.newText( group, "e-mail", left + 10, passwordField.y + 40, native.systemFont, 18 )
label.anchorX = 0
local emailField  = RGEasyTextField.create( group, centerX, label.y + 30, fullw-20, 30, 
	                                     { fill = {1,1,1}, fontColor = {0, 1, 1}, fontSize = 22,
	                                       selStroke = { 0, 1 , 1 }, selStrokeWidth = 4,
  	                                       listener = emailInput } )

-- 6. Tell the fields which field is next in sequence for tab or shift-tab
nameField:setNextField( passwordField )
passwordField:setNextField( emailField )
emailField:setNextField( nameField )

nameField:setPrevField( emailField )
passwordField:setPrevField( nameField )
emailField:setPrevField( passwordField )

-- 7. Select the first field
native.setKeyboardFocus( nameField )
