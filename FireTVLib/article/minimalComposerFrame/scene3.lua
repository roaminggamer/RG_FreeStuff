local composer 		= require( "composer" )
local scene    		= composer.newScene()

require "RGEasyFTV"
local button 		= require "button" -- A super-minimal button builder


---------------------------------------------------------------------------------
-- Custom code for this scene
---------------------------------------------------------------------------------

local function openScene1( )
	local options =	{ effect = "fade", time = 200, }
	composer.gotoScene( "scene1", options  )	
end


local ignoreFTVInputs = true

local function onFTVKey( event )
	if(ignoreFTVInputs) then return false end

	local keyName = event.keyName
	local phase = event.phase
	if( phase ~= "ended" ) then return false end

	if( keyName == "left" ) then
		openScene1()
		return true

	else
		print( "Detected key: ", keyName, " not currently mapped in this interface.")
	end

	return false
end
Runtime:addEventListener( "onFTVKey", onFTVKey )


---------------------------------------------------------------------------------
-- Composer Code
---------------------------------------------------------------------------------
function scene:create( event )
	local screenGroup = self.view


	local label = display.newText( screenGroup, "Scene 3" , 240, 40, system.nativeFont, 34)


	-- Add buttons to take us to the next scene
	button.new( screenGroup, 240, 160, 180, 40, "Back (left)", openScene1)

end

function scene:show( event )
	local screenGroup = self.view
	local willDid 	= event.phase

	if( willDid == "did" ) then
		ignoreFTVInputs = false
	end

end

function scene:hide( event )
	local screenGroup = self.view
	local willDid 	= event.phase
	
	if( willDid == "will" ) then
		ignoreFTVInputs = true
	end
end

function scene:destroy( event )
	local screenGroup = self.view
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
