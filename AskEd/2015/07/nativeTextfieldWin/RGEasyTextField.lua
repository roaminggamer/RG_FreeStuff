-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- easyTextField - This library allows you to create a 
-- native.newTextField() on systems that support it and a 'faked'
-- native.newTextField() on systems that don't.
-- 
-- i.e. Windows users can now create a text input field.
--
-- =============================================================
-- 					License
-- =============================================================
--[[
	Unless otherwise specified, 
	
	> You may use this material in a free or commercial game.
	> You may use this material in a free or commercial non-game app.
	> You need not credit the author (credits are still appreciated).
	
	> YOU MAY NOT distribute this in any other form, period.

	If someone sees you using it, or you want to share, tell people where you
	got it and let them get a copy on their own.  Giving away my work for free
	means I make no $, which means I can't afford to make good stuff like this.

	Thank You!
	Ed Maurina (aka The Roaming Gamer)
	http://roaminggamer.com
]]

-- =============================================================
-- Helper Functions and Variables
-- =============================================================
-- Useful localizations
local getTimer  = system.getTimer

-- Colors
local color = {}
color._TRANSPARENT_ 	= {0, 0, 0, 0} 
color._WHITE_ 			= {1, 1, 1, 1} 
color._BLACK_ 			= {  0,   0,   0, 1} 
color._GREY_ 			= {0.5, 0.5, 0.5, 1} 
color._DARKGREY_ 		= { 0.25,  0.25,  0.25, 1} 
color._DARKERGREY_  	= { 0.125,  0.125,  0.125, 1}
color._LIGHTGREY_ 		= {0.753, 0.753, 0.753, 1}
color._RED_   			= {1, 0, 0, 1}
color._GREEN_ 			= {0, 1, 0, 1}
color._BLUE_  			= {0, 0, 1, 1}
color._CYAN_  			= {0, 1, 1, 1}
color._YELLOW_       	= {1, 1, 0, 1}
color._ORANGE_       	= {1, 0.398, 0, 1}
color._BRIGHTORANGE_ 	= {1, 0.598, 0, 1}
color._PURPLE_       	= {0.625, 0.125, 0.938, 1}
color._PINK_         	= {1, 0.430, 0.777, 1} 

-- Environment
local onSimulator = system.getInfo( "environment" ) == "simulator"
local oniOS = ( system.getInfo("platformName") == "iPhone OS") 
local onAndroid = ( system.getInfo("platformName") == "Android") 
local onOSX = ( system.getInfo("platformName") == "Mac OS X")
local onWin = ( system.getInfo("platformName") == "Win")

-- nextFrame( func ) - Execute func in new frame. 
-- From Sergey's code: https://gist.github.com/Lerg
--
function _G.nextFrame( func, delay )
    delay = delay or 1
    timer.performWithDelay(delay, func )
end

-- Is valid object tester
display.isValid = display.isValid or function ( obj )
	return( obj and obj.removeSelf ~= nil )
end

-- Shorthand for Runtime:*() functions
--
local pairs = _G.pairs
local listen = function( name, listener ) Runtime:addEventListener( name, listener ) end
local ignore = function( name, listener ) Runtime:removeEventListener( name, listener ) end
local autoIgnore = function( name, obj ) 
    if( not display.isValid( obj ) ) then
      ignore( name, obj )
      obj[name] = nil
      return true
    end
    return false 
end
local post = function( name, params, debuglvl )
   params = params or {}
   local event = { name = name }
   for k,v in pairs( params ) do event[k] = v end
   if( not event.time ) then event.time = getTimer() end
   Runtime:dispatchEvent( event )
end


-- Table dumper
string.rpad = string.rpad or function (self, len, char)
	local theStr = self; if char == nil then char = ' ' end; return theStr .. string.rep(char, len - #theStr)
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
			keyString = keyString:rpad(padding); valueString = valueString:rpad(padding);
			print( keyString .. " == " .. valueString );
		end
	else print("empty") end; print( marker .. "-----\n")
end

-- Stash a copy of the original 'native.setKeyboardFocus' because we are going to replace it.
local native_setKeyboardFocus = native.setKeyboardFocus

-- Handle this shift-key
local function getShifted( key )
	if( not key ) then return "" end
	local tmp = tostring(key)

	local shifts = {}
	shifts["1"] = "!"
	shifts["2"] = "@"
	shifts["3"] = "#"
	shifts["4"] = "$"
	shifts["5"] = "%"
	shifts["6"] = "^"
	shifts["7"] = "&"
	shifts["8"] = "*"
	shifts["9"] = "("
	shifts["0"] = ")"
	shifts["-"] = "_"
	shifts["="] = "+"
	shifts["`"] = "~"
	shifts["["] = "{"
	shifts["]"] = "}"
	shifts[";"] = ":"
	shifts["'"] = '"'
	shifts[","] = "<"
	shifts["."] = ">"
	shifts["/"] = "?"
	shifts["\\"] = "|"
	tmp = shifts[tmp]

	if( not tmp ) then return string.upper(key) end
	return tmp
end

-- Replacement for 'native.setKeyboardFocus' to handle faked input
local lastTextField
native.setKeyboardFocus = function( textField )
	--table.dump(textField)
	if( not textField ) then
		if( lastTextField ) then
			lastTextField:changeFocus(false)
			lastTextField = nil
		end
		native_setKeyboardFocus(nil)

    elseif( textField.fake ) then
		if( textField.externalListener ) then
			textField:externalListener( { phase = "began", 
				                          target = textField,
				                          text = textField.text } )
		end

		if( lastTextField ) then
			lastTextField:changeFocus(false)
			lastTextField = nil
		end
		textField:changeFocus(true)
		lastTextField = textField

	else
		native_setKeyboardFocus(textField)
    end

    if( textField == nil ) then
    	post("onKeyboardHide")
    else
    	post("onKeyboardShow")
    end
end

local easyTextField = {}

local getTimer = system.getTimer

function easyTextField.create( group, x, y, width, height, params   )
	-- Set up safe values
	group 		= group or display.currentStage
	params 		= params or {}
	local default 			= params.default or ""
	local fill 				= params.fill or color._LIGHTGREY_
	local selStroke 		= params.selStroke or color._GREEN_
	local selStrokeWidth 	= params.selStrokeWidth or 2
	local debugEn 			= params.debugEn
	local externalListener  = params.listener
	local fontColor 		= params.fontColor or color._BLACK_

	local textField
	-- Create a faked text input field that will work in Windows Simulator
	--
	-- 		-OR-
	--
	-- Real one for OS X Simulator and devices.
	--
	if( onWin ) then
		if( debugEn ) then print("Windows Simulator") end
		textField 					= display.newRect( group, 0, 0, width, height)
		textField.x 				= x
		textField.y 				= y
		textField:setFillColor( unpack(fill) )
		textField:setStrokeColor( unpack(fill) )
		textField.strokeWidth 		= selStrokeWidth
		textField.isFocus 			= false
		textField.fake 				= true
		textField.text 				= ""
		textField.placeholder 		= params.placeholder
		textField.isSecure 			= params.isSecure
		textField.externalListener 	= externalListener

		textField.touch = function( self, event ) 
			if( event.phase == "ended" ) then
				native.setKeyboardFocus( self )
			end
			return true
		end; textField:addEventListener("touch")

		textField.myLabel = display.newText( group, "", textField.x - width/2 + 4, textField.y,  native.systemFont, params.fontSize or math.ceil(height * 0.6) )
		
		if( default ) then 
			textField.myLabel.text = default
		end
		textField.myLabel.anchorX = 0
		textField.myLabel:setFillColor( unpack(fontColor) )

		textField.key = function( self, event )	
			if( not display.isValid( self ) ) then
				ignore( "key", self )
				return 
			end
		    if( not self.isFocus ) then return end		    
			if( event.phase == "down" ) then
				if( event.descriptor == "tab" ) then
					if(event.isShiftDown) then						
						if( self.prevField ) then 
							nextFrame( 
								function() 
									if( externalListener ) then
										externalListener( textField, 
													  { phase = "ended", 
						  								target = textField, 
						  								text = textField.text } )
									end
									native.setKeyboardFocus(self.prevField) 
								end 
							)
						end
					else
						if( self.nextField ) then 
							nextFrame( 
								function() 
									if( externalListener ) then
										externalListener( textField, 
													  { phase = "ended", 
						  								target = textField, 
						  								text = textField.text } )
									end
									native.setKeyboardFocus(self.nextField) 
								end 
							)
						end
					end

				elseif( event.descriptor == "enter" ) then
					if(event.isShiftDown) then						
						if( self.prevField ) then 
							nextFrame( 
								function() 
									if( externalListener ) then
										externalListener( textField, 
													  { phase = "ended", 
						  								target = textField, 
						  								text = textField.text } )
									end
									native.setKeyboardFocus(self.prevField) 
								end 
							)
						end
					else
						if( self.nextField ) then 
							nextFrame( 
								function() 
									if( externalListener ) then
										externalListener( textField, 
													  { phase = "ended", 
						  								target = textField, 
						  								text = textField.text } )
									end
									native.setKeyboardFocus(self.nextField) 
								end 
							)
						end
					end

				elseif( event.descriptor == "deleteBack" ) then
					if( string.len(self.text) < 2 ) then				
						self.text = ""
					else
						self.text = 
							string.sub( self.text, 1, 
								string.len(self.text) - 1)
					end

					if( externalListener ) then
						externalListener( textField, 
									  { phase = "editing", 
		  								target = textField, 
		  								text = textField.text } )
					end


				elseif( event.descriptor == "space" ) then
					self.text = self.text .. ' '

					if( externalListener ) then
						externalListener( textField, 
									  { phase = "editing", 
		  								target = textField, 
		  								text = textField.text } )
					end

				elseif( string.len( event.descriptor ) == 1 ) then
					if(event.isShiftDown) then						
						self.text = self.text .. getShifted(event.descriptor)
					else
						self.text = self.text .. event.descriptor
					end					

					if( externalListener ) then
						externalListener( textField, 
									  { phase = "editing", 
		  								target = textField, 
		  								text = textField.text } )
					end
				end
			end

			return true
		end
		nextFrame( function()  Runtime:addEventListener( "key", textField ) end , 500 )

		function textField.changeFocus( self, isFocus ) 
			if( not display.isValid(self) ) then  return end
			textField.isFocus = isFocus
			if( isFocus ) then
				textField:setStrokeColor( unpack(selStroke) )
			else
				textField:setStrokeColor( unpack(fill) )
			end
		end

		function textField.getText( self )
			return self.text
		end

		function textField.setText( self, newText )
			self.text = newText
			self.myLabel.text = newText
		end

		textField.lastUpdate = getTimer()
		textField.curLen = -1
		textField.myLabel.enterFrame = function( self )
			if( autoIgnore( "enterFrame", self ) ) then return end
			local curTime = getTimer()
			local theLen = string.len( textField.text )
			if( textField.curLen ~= theLen ) then
				if( theLen == 1 ) then
					textField.myLabel.text = textField.text
			
				elseif( theLen > 1 ) then
					if( textField.isSecure ) then
					textField.myLabel.text = string.rep("*",theLen-1) .. string.sub(textField.text,theLen,theLen)
					else
						textField.myLabel.text = textField.text
					end
				else
					textField.myLabel.text = textField.placeholder or ""
				end

				textField.curLen = theLen
				textField.lastUpdate = curTime
			end
			local dt = curTime - textField.lastUpdate
			if(dt > 500 ) then
				textField.lastUpdate = curTime
				if( textField.isSecure and theLen > 0 ) then
					textField.myLabel.text = string.rep("*",theLen)					
				end
			end
		end; listen("enterFrame", textField.myLabel )

	else
		if( debugEn ) then print("On Device or OS X Simulator") end
		--[[
		local back = display.newRect( group, 0, 0, width, height)
		back.x = x
		back.y = y
		back:setFillColor( unpack(fill) )
		back:setStrokeColor( unpack(fill) )
		back.strokeWidth = 2
		--]]

		textField = native.newTextField( x, y, width, height )
		textField.fake 			= false
		textField.placeholder 	= params.placeholder
		textField.isSecure 		= params.isSecure		
		textField.size 			= params.fontSize
		textField:setFillColor( unpack(fill) )
		textField:setFillColor( unpack(fontColor) )

		textField.userInput = function(self, event)
			if ( event.phase == "began" ) then

			elseif ( event.phase == "ended" or event.phase == "submitted" ) then
				if( self.nextField ) then 
					-- EFM is there a bug here?
					--native.setKeyboardFocus(self.nextField)
				end

			elseif ( event.phase == "editing" ) then
				textField.text = event.text
			end	
			
			if( externalListener ) then 
				return externalListener( self, event )	
			end
			return true
		end
		textField:addEventListener( "userInput" )

		textField.setText = textField.setText or function( self, newText )
			self.text = newText
		end

		group:insert(textField)
	end

	function textField.setNextField( self, nextField ) 
		textField.nextField = nextField
	end

	function textField.setPrevField( self, prevField ) 
		textField.prevField = prevField
	end

	textField.getText = textField.getText or 
		function( self )
			return self.text
		end

	textField.clear = textField.clear or 
		function( self )			
			self.text = ""
			if(textField.myLabel) then textField.myLabel.text = "" end
		end

	--native.setKeyboardFocus(textField)

	return textField
end


return easyTextField

