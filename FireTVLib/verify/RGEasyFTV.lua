-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
-- Note: Modify code below if you put libraries in alternate folder.
-- =============================================================
local getTimer  = system.getTimer

local debugLevel = 0
local onOSX = system.getInfo("platformName") == "Mac OS X"
local onWin = system.getInfo("platformName") == "Win"
local onFTV = (system.getInfo ( "model" ) == "AFTB")


if( not table.dump ) then
	function string:rpad(len, char)
		local theStr = self
	    if char == nil then char = ' ' end
	    return theStr .. string.rep(char, len - #theStr)
	end

	function table.dump(theTable, padding ) -- Sorted

		local theTable = theTable or  {}

		local tmp = {}
		for n in pairs(theTable) do table.insert(tmp, n) end
		table.sort(tmp)

		local padding = padding or 30
		print("\nTable Dump:")
		print("-----")
		if(#tmp > 0) then
			for i,n in ipairs(tmp) do 		

				local key = tostring(tmp[i])
				local value = tostring(theTable[key])
				local keyType = type(key)
				local valueType = type(value)
				local keyString = key .. " (" .. keyType .. ")"
				local valueString = value .. " (" .. valueType .. ")" 

				keyString = keyString:rpad(padding)
				valueString = valueString:rpad(padding)

				print( keyString .. " == " .. valueString ) 
			end
		else
			print("empty")
		end
		print("-----\n")
	end
end

if( not _G.post ) then
	_G.listen = function( name, listener ) Runtime:addEventListener( name, listener ) end
	_G.ignore = function( name, listener ) Runtime:removeEventListener( name, listener ) end
	_G.post = function( name, params, debuglvl )
	   local params = params or {}
	   local event = { name = name }
	   for k,v in pairs( params ) do
	      event[k] = v
	   end
	   if( not event.time ) then event.time = getTimer() end
	   if( debuglvl and debuglvl >= 2 ) then table.dump(event) end
	   Runtime:dispatchEvent( event )
	   if( debuglvl and debuglvl >= 1 ) then print("post( '" .. name .. "' )" ) end   
	end
end

local function keyCleaner( event )

 	local code = event.nativeKeyCode
 	local codes = {}

 	-- FTV code mappings
 	if(onFTV) then
	 	codes[19] 	= 'up'
	 	codes[20] 	= 'down'
	 	codes[21] 	= 'left'
	 	codes[22] 	= 'right'
	 	codes[23]   = 'select'
	 	codes[4] 	= 'back'
	 	codes[82] 	= 'menu'
	 	codes[89] 	= 'mediaRewind'
	 	codes[90] 	= 'mediaFastForward'
	 	codes[85] 	= 'mediaPlayPause'

 	-- Windows code mappings
 	elseif( onWin ) then
	 	codes[38] 	= 'up'
	 	codes[40] 	= 'down'
	 	codes[37] 	= 'left'
	 	codes[39] 	= 'right'
	 	codes[83]   = 'select' -- s
	 	codes[66] 	= 'back' -- b
	 	codes[77] 	= 'menu' -- m
	 	codes[82] 	= 'mediaRewind' -- r
	 	codes[70] 	= 'mediaFastForward' --f
	 	codes[80] 	= 'mediaPlayPause' -- p

 	elseif( onOSX ) then
	 	-- OS X code mappings
	 	codes[126] 	= 'up'
	 	codes[125] 	= 'down'
	 	codes[123] 	= 'left'
	 	codes[124] 	= 'right'
	 	codes[1]  	= 'select' -- s
	 	codes[11] 	= 'back' -- b
	 	codes[46] 	= 'menu' -- m
	 	codes[15] 	= 'mediaRewind' -- r
	 	codes[3] 	= 'mediaFastForward' --f
	 	codes[35] 	= 'mediaPlayPause' --p
	 end


	event.keyName = codes[code]

	return event 
end

local onKey 

-- =======================
-- onKey() - Event listener for keyboard inputs.
-- =======================
onKey = function( event )

	local event = keyCleaner( event )

	local key = event.keyName
	local keyCode = event.nativeKeyCode
	local phase = event.phase

	if( key == nil ) then return false end

	if( phase == "down") then 
		event.phase = "began"
	else
		event.phase = "ended"
	end
	phase = event.phase

	-- Remove unused bits from event
	event.isAltDown = nil
	event.isCommandDown = nil
	event.isCtrlDown = nil
	event.isShiftDown = nil
	event.descriptor = nil

	if( debugLevel >= 1) then
		print( tostring(key) .. " :" .. tostring(keyCode) .. " :" .. tostring(phase) )
	end

	event.name = nil

	if( debugLevel >= 2) then
		post( "onFTVKey", event, 2 )
	else
		post( "onFTVKey", event)
	end

    return true
end

timer.performWithDelay(100, function() Runtime:addEventListener( "key", onKey ) end )
