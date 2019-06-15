--
-- This file should be the same for ALL games.
--
local mapper = {}
local map = {} -- input keys for player (buttons and joysticks)
mapper.map = map 
--
local specialKeys = {} -- beer sensors, DIP switches, etc.
mapper.specialKeys = specialKeys

-- RAY ONLY EDIT BELOW HERE *********************************************
-- RAY ONLY EDIT BELOW HERE *********************************************
-- RAY ONLY EDIT BELOW HERE *********************************************
specialKeys.kill = 'escape'

map[1] = {  right = "a", 		left = "b", 	up = "!", 			down = "c", 	button = "d" } 
map[2] = {  right = "g", 		left = "h", 	up = "@", 			down = "i", 	button = "j" }
map[3] = {  right = "m", 		left = "n", 	up = "#", 			down = "o", 	button = "p" }
map[4] = {  right = "s", 		left = "t", 	up = "$", 			down = "u", 	button = "v" }

if( _G.testingModes ) then
	map[1] = {  right = "right",  left = "left",    up = "up",     down = "down",    button = "buttonA" }
end

for i = 1, 4 do
	map[i].start = "y" -- RAY DON'T FORGET THIS !!!
end
--
specialKeys.beer = {}
specialKeys.beer[1] = "e"
specialKeys.beer[2] = "k"
specialKeys.beer[3] = "q"
specialKeys.beer[4] = "w"
--
specialKeys.dip = {}
specialKeys.dip[1] = "1" -- THESE CONFLICT WITH JOYSTICK!!
specialKeys.dip[2] = "2" -- THESE CONFLICT WITH JOYSTICK!!
specialKeys.dip[3] = "3" -- THESE CONFLICT WITH JOYSTICK!!
specialKeys.dip[4] = "4" -- THESE CONFLICT WITH JOYSTICK!!
--
specialKeys.warning = {}
specialKeys.warning[1] = "f"
specialKeys.warning[2] = "l"
specialKeys.warning[3] = "r"
specialKeys.warning[4] = "x"
--
specialKeys.coin = "z"

-- RAY ONLY EDIT ABOVE HERE ********************************************* 
-- RAY ONLY EDIT ABOVE HERE *********************************************
-- RAY ONLY EDIT ABOVE HERE *********************************************

-- FOR ED ONLY ==>>
-- FOR ED ONLY ==>>
-- FOR ED ONLY ==>>
if( _G.edMode ) then -- For Ed to test on Windows Machine	
	specialKeys.kill = 'escape'

	map[1] = {  right = "a", 		left = "b", 	up = "!", 			down = "c", 	button = "d" } 
	map[1] = {  right = "right",  left = "left",    up = "up",     down = "down",    button = "buttonA" }
	--map[2] = {  right = "e", 		left = "f", 	up = "@", 			down = "g", 	button = "h" }
	--map[3] = {  right = "i", 		left = "j", 	up = "#", 			down = "k", 	button = "l" }
	--map[4] = {  right = "m", 		left = "n", 	up = "$", 			down = "o", 	button = "p" }
	--map[4] = {  right = "right",  left = "left",    up = "up",     down = "down",    button = "buttonA" }

	map[2] = {  right = "g", 		left = "h", 	up = "@", 			down = "i", 	button = "buttonB" }
	map[3] = {  right = "m", 		left = "n", 	up = "#", 			down = "o", 	button = "buttonX" }
	map[4] = {  right = "s", 		left = "t", 	up = "$", 			down = "u", 	button = "buttonY" }


	for i = 1, 4 do
		map[i].start = "y" 
	end
	--
	specialKeys.beer[1] = "1"
	specialKeys.beer[2] = "2"
	specialKeys.beer[3] = "3"
	specialKeys.beer[4] = "4"
	--
	specialKeys.dip[1] = "insert"
	specialKeys.dip[2] = "delete"
	specialKeys.dip[3] = "home"
	specialKeys.dip[4] = "end"
	--
	specialKeys.warning[1] = "f"
	specialKeys.warning[2] = "l"
	specialKeys.warning[3] = "r"
	specialKeys.warning[4] = "x"
	--
	specialKeys.coin = "z"

end
-- <<== FOR ED ONLY

function mapper.key( self, event )
	local phase 	= (event.phase == "down") and "began" or "ended"
	local key 		= string.lower(event.keyName)	
	--print('key', key, event.keyName, specialKeys.coin )
	for i = 1, #self.map do
		local pnum = i
		local pmap = self.map[pnum]
		for k, v in pairs( pmap ) do
			if( key == string.lower(v) ) then
				post("onRowdyKey", { pnum = pnum, key = k, phase = phase, time = system.getTimer() } )
				return false
			end
		end
	end
	for k,v in pairs( specialKeys.beer ) do
		local pnum = tonumber(k)
		if( key == v ) then
			post("onBeerKey", { pnum = pnum, key = v, phase = phase, time = system.getTimer() } )
			return false
		end
	end

	local gameMode = ssk.persist.get("special.json","gameMode")
	if(gameMode == "Drinking Game") then		
		for k,v in pairs( specialKeys.warning ) do
			local pnum = tonumber(k)
			if( key == v ) then
				post("onPlayerWarning", { pnum = pnum, key = v, phase = phase, time = system.getTimer() } )
				return false
			end
		end
	end
	for k,v in pairs( specialKeys.dip ) do
		local pnum = tonumber(k)
		if( key == v ) then
			post("onDIP", { pnum = pnum, key = v, phase = phase, time = system.getTimer() } )
			return false
		end
	end
	if( key == specialKeys.coin ) then
		--print("Clink!")
		post("onCoinDrop", { pnum = pnum, key = specialKeys.coin, phase = phase, time = system.getTimer() } )
		return false
	end
	if( key == specialKeys.kill ) then
		local tmp = display.newRect( 0, 0, 10000, 10000 )
		tmp:setFillColor(1,0,0)
		--native.requestExit()
		os.exit()
	end
	return false
end
timer.performWithDelay( 100, function () listen( "key", mapper ) end )

function mapper.getKeyMap( pnum, keyName )
	return map[pnum][keyName]
end


return mapper