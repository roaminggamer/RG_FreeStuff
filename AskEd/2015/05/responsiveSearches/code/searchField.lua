-- Creates a search field that will works on devices and both simulators.
--
-- Running On Windows Simulator ?
-- ==============================
-- If you are running this example in the Windows Simulator, be sure to select one of the android devices, or the
-- 'key' event will not be detected.
--
-- This was designed specifically for this example, but may be useful to you in other cases, so 
-- feel free to lift and use the concept for your own apps.
--
-- Ed (aka The Roaming Gamer)
--
local com 		= require "common"
local wordList	= require "wordList"
local searchField = {}

searchField.searchTerm = "" -- Start with a blank searh criteria

local getTimer = system.getTimer

local foundCountLabel
local currentIndexLabel

function searchField.create()

	-- Create a faked text input field that will work in Windows Simulator
	--
	-- 		-OR-
	--
	-- Real one for OS X Simulator and devices.
	--
	if( com.onWin ) then
		print("Windows Simulator")
		local fieldBack = display.newRect( com.right - 2, com.top + 2, com.fullw - 108, 25)
		fieldBack.anchorX = 1
		fieldBack.anchorY = 0

		local currentTermLabel = display.newText( "<search term>", 
			                                      fieldBack.x - fieldBack.contentWidth + 4, 
			                                      fieldBack.y + fieldBack.contentHeight/2, 
			                                      native.systemFont, 10 )
		currentTermLabel.anchorX = 0
		currentTermLabel:setFillColor(0,0,0)

		onKey = function( event )
			if( event.phase == "down" ) then
				if( event.descriptor == "deleteBack" ) then
					if( string.len(searchField.searchTerm) < 2 ) then				
						searchField.searchTerm = ""
					else
						searchField.searchTerm = 
							string.sub( searchField.searchTerm, 1, 
								string.len(searchField.searchTerm) - 1)
					end
				else
					searchField.searchTerm = searchField.searchTerm .. event.descriptor				
				end
			    currentTermLabel.text = searchField.searchTerm
			end
		end
		Runtime:addEventListener( "key", onKey )

	else
		print("On Device or OS X Simulator")
		local width = com.fullw - 108
		local textField = native.newTextField( com.right - 2 - width/2, com.top + 2 + 25/2, com.fullw - 108, 25)
		textField.userInput = function(self, event)
			if ( event.phase == "began" ) then
			elseif ( event.phase == "ended" or event.phase == "submitted" ) then
			elseif ( event.phase == "editing" ) then
				searchField.searchTerm = event.text
			end		
		end
		textField:addEventListener( "userInput" )
	end

	-- Add counters
	--
	local wordCountlabel = display.newText( "Total: " .. #wordList, com.left + 2 , com.top + 40, native.systemFont, 10 )
	wordCountlabel.anchorX = 0	

	foundCountLabel = display.newText( "Found: 0", com.centerX - 10, wordCountlabel.y, native.systemFont, 10)
	foundCountLabel.anchorX = 1

	currentIndexLabel = display.newText( "Search Index: 0", com.centerX + 10, foundCountLabel.y, native.systemFont, 10 )
	currentIndexLabel.anchorX = 0

end

function searchField.getSearchTerm()
	return searchField.searchTerm
end

function searchField.setFoundCount( count )
	foundCountLabel.text = "Found: " .. tonumber(count)
end

function searchField.setSearchIndex( count )
	currentIndexLabel.text = "Search Index: " .. tonumber(count)
end

return searchField

