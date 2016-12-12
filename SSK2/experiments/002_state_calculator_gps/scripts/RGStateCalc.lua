-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  RGStateCalc.lua (comments/code)
-- =============================================================

local public = {}

-- This flag will be true as soon as the utility has 
-- Guessed your location(s).
public.ready = false 
function public.isReady() return public.ready end 

-- Table to store guesses in.
--
local myState = {} 
function public.getMyState() return myState end 

-- GPS Lat/Lng coordinates for each state and an approximate radius covering that state
--
local geoData = {}
geoData.AL = {32,50,5,"N",86,38,0,"W", 500} -- Alabama 
geoData.AK = {64,43,54,"N",152,28,12,"W", 1200} -- Alaska 
geoData.AZ = {34,34,6,"N",112,27,41,"W", 500} -- Arizona 
geoData.AR = {34,44,10,"N",92,19,52,"W", 500} -- Arkansas 
geoData.CA = {37,9,58,"N",119,26,58,"W", 750} -- California 
geoData.CO = {39,0,0,"N",105,32,50,"W", 500} -- Colorado 
geoData.CT = {41,48,36,"N",72,43,48,"W", 500} -- Conneticut 
geoData.DE = {39,09,43,"N",75,31,36,"W", 500} -- Delaware 
geoData.DC = {38,54,15,"N",77,0,58,"W", 500} -- District of Columbia 
geoData.FL = {28,40,53,"N",82,27,36,"W", 500} -- Florida 
geoData.GA = {32,39,43.6,"N",83,26,17.9,"W", 500} -- Georgia 
geoData.HI = {20,50,0,"N",156,56,0,"W", 500} -- Hawaii 
geoData.ID = {44,30,15,"N",114,13,42,"W", 500} -- Idaho 
geoData.IL = {39,44,21.5,"N",89,30,13.1,"W", 500} -- Illinois 
geoData.IN = {39,45,57.7,"N",86,26,28.6,"W", 500} -- Indiana 
geoData.IA = {42,02,05,"N",93,37,12,"W", 500} -- Iowa 
geoData.KS = {38,21,52,"N",98,45,53,"W", 500} -- Kansas 
geoData.KY = {37,34,14,"N",85,15,23,"W", 500} -- Kentucky 
geoData.LA = {31,07,36,"N",92,03,58,"W", 500} -- Louisiana 
geoData.ME = {45,11,10,"N",69,13,13,"W", 500} -- Maine 
geoData.MD = {38,55,22,"N",76,37,42,"W", 500} -- Maryland 
geoData.MA = {42,22,37.62,"N",71,55,30.93,"W", 500} -- Massachusetts
geoData.MI = {44,15,0,"N",85,24,0,"W", 500} -- Michigan
geoData.MN = {46,21,29,"N",94,12,03,"W", 500} -- Minnesota 
geoData.MS = {32,44,29,"N",89,32,6,"W", 500} -- Mississippi  
geoData.MO = {38,34,36,"N",92,10,25,"W", 500} -- Missouri 
geoData.MT = {47,3,53,"N",109,25,48,"W", 600} -- Montana 
geoData.NE = {41,24,17,"N",99,38,29,"W", 500} -- Nebraska 
geoData.NV = {39,29,31,"N",117,4,13,"W", 500} -- Nevada 
geoData.NH = {43,41,42,"N",71,37,54,"W", 500} -- New Hampshire 
geoData.NJ = {40,08,23.1,"N",74,22,34.5,"W", 500} -- New Jersey 
geoData.NM = {34,35,47,"N",106,1,59,"W", 500} -- New Mexico 
geoData.NY = {43,5,48,"N",75,13,55,"W", 500} -- New York 
geoData.NC = {35,28,33,"N",79,10,32,"W", 500} -- North Carolina 
geoData.ND = {47,29,3,"N",10,26,32,"W", 500} -- North Dakota 
geoData.OH = {39,59,0,"N",82,59,0,"W", 500} -- Ohio 
geoData.OK = {35,28,56,"N",97,32,6,"W", 500} -- Oklahoma 
geoData.OR = {44,18,14,"N",120,50,46,"W", 500} -- Oregon
geoData.PA = {40,54,53,"N",77,46,29,"W", 500} -- Pennsylvania 
geoData.RI = {41,40,18,"N",71,34,36,"W", 500} -- Rhode Island 
geoData.SC = {34,0,3,"N",81,02,7,"W", 500} -- South Carolina 
geoData.SD = {44,22,5,"N",10,20,11,"W", 500} -- South Dakota 
geoData.TN = {35,50,46,"N",86,23,31,"W", 500} -- Tennessee 
geoData.TX = {31,7,56,"N",99,20,29,"W", 750} -- Texas 
geoData.UT = {39,15,53,"N",111,38,20,"W", 500} -- Utah 
geoData.VT = {44,4,20,"N",72,43,42,"W", 500} -- Vermont 
geoData.VA = {37,33,0,"N",78,33,20,"W", 500} -- Virginia 
geoData.WA = {47,25,24,"N",120,19,31,"W", 500} -- Washington 
geoData.WV = {38,39,52,"N",80,42,37,"W", 500} -- West Virgina 
geoData.WI = {44,40,0,"N",90,11,0,"W", 500} -- Wisconsin 
geoData.WY = {42,49,59,"N",108,43,57,"W", 500} -- Wyoming 

-- Utility functions to manipulate and examine GPS coordinates
--
local function dms2float( deg, min, sec, pm )
	local tmp = deg + (min * 60 + sec)/ 3600	
	if( (pm:lower() == "s") or (pm:lower() == "w") ) then
		tmp = -1 * tmp
	end
	return tmp
end
local function getLat( rec )
	return dms2float( rec[1], rec[2], rec[3], rec[4] ) 
end
local function getLng( rec )
	return dms2float( rec[5], rec[6], rec[7], rec[8] ) 
end

-- A function to calculate the approximate distance between two GPS positions.
--
local function haversine(lat1, lon1, lat2, lon2)
    local R = 6372.8
    local  function torad(n)
        return n * math.pi / 180
    end 
    local dLat = torad(lat2 - lat1)
    local dLon = torad(lon2 - lon1) 
    local lat1 = torad(lat1)
    local lat2 = torad(lat2) 
    local sin = math.sin
    local cos = math.cos
    local a = sin(dLat/2)^2 + sin(dLon/2)^2 * cos(lat1) * cos(lat2) 
    local c = 2 * math.asin(math.sqrt(a)) 
    return R * c
end

-- GPS 'location' listener.  Executes once to fill in state(s) guess.
-- 
local function onLocation( event ) 
	--print("Determining where I am...........\n\n\n\n")
	Runtime:removeEventListener( "location", onLocation )

	--
	-- Check to see if we got a lat/long
	--
	if(event and event.latitude ) then 
		latitude  = string.format( '%.4f', event.latitude )
		longitude = string.format( '%.4f', event.longitude )
	else
		print( "WARNING! Failed to get Lat/Long!?" )
		return
	end

	--print( "    Current Latitude: " .. latitude .. "\n" )
	--print( "   Current Longitude: " .. longitude .. "\n\n" )	

	-- Compare the current GPS position to the states list and if we are within a state's 
	-- radius, add it to the myState table as a possibility
	--
	for k,v in pairs( geoData ) do
		local rad = v[9]
		local dist = math.haversine_dist( latitude, longitude, getLat(v), getLng(v) )
		if ( dist <= rad ) then
			myState[#myState+1] = k
		end
	end

	public.ready = true
end
Runtime:addEventListener( "location", onLocation )
return public