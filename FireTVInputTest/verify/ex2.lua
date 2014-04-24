
require "RGEasyFTV"

local centerX = display.contentCenterX
local centerY = display.contentCenterY


local _GREY_ = {0.5, 0.5, 0.5}
local _GREEN_ = {0,1,0}

local function onFTVKey( self, event )
	-- Does this object's 'mapped key' match the key that was just pressed?

	-- NO!  - Abort early
	if( self.mappedKey ~= event.keyName ) then return false end

	-- YES! - Do proper highlighting based on 'phase'
	if( event.phase == "began" ) then
		self:setFillColor( unpack( _GREEN_ ) )

	elseif( event.phase == "ended" ) then
		self:setFillColor( unpack( _GREY_ ) )
	end

	return true
end


local function createButton( x, y, w, h, image, mappedKey )
	local fileName = "images/" .. image .. ".png"

	print(fileName)
	local tmp = display.newImageRect( fileName, w, h)
	tmp.anchorX = 0.5
	tmp.anchorY = 0.5
	tmp.x = x
	tmp.y = y
	tmp:setFillColor( unpack( _GREY_ ) )
	tmp.mappedKey = mappedKey
	
	-- Magic right here
	tmp.onFTVKey = onFTVKey

	Runtime:addEventListener( "onFTVKey", tmp )
	--Alternately type this ==>  listen( "onFTVKey", tmp )

	return tmp
end


createButton( 20, 20, 35, 35, "voicesearch", "voicesearch" )  -- not catchable
createButton( 20, 60, 35, 35, "back", "back" )
createButton( 20, 100, 35, 35, "home", "home" ) -- not catchable
createButton( 20, 140, 35, 35, "play_pause", "playPause" ) 
createButton( 20, 180, 35, 35, "rewind", "rewind" ) 
createButton( 20, 220, 35, 35, "fastforward", "fastForward" ) 

createButton( 255, 20, 35, 35, "menu", "menu" )
createButton( 255, 60, 45, 35, "ringup", "up" ) 
createButton( 255, 100, 45, 35, "ringdown", "down" ) 
createButton( 255, 140, 45, 35, "ringleft", "left" ) 
createButton( 255, 180, 45, 35, "ringright", "right" ) 
createButton( 255, 220, 45, 35, "select", "select" ) 
--

local archInfo = system.getInfo ( "architectureInfo" )
local model = system.getInfo ( "model" )

local tmp = display.newText( "Arch info: " .. archInfo, 0, 0, system.nativeFont, 12)
tmp.anchorX = 0
tmp.x = 10
tmp.y = 250

local tmp = display.newText( "Model: " .. model, 0, 0, system.nativeFont, 12)
tmp.anchorX = 0
tmp.x = 10
tmp.y = 270

local tmp = display.newText( "Native Resolution: " .. display.pixelWidth .. " x " .. display.pixelHeight, 0, 0, system.nativeFont, 12)
tmp.anchorX = 0
tmp.x = 10
tmp.y = 290
