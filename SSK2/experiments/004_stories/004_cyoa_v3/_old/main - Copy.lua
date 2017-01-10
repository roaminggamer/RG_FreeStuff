-- =============================================================
-- main.lua
-- =============================================================
-- =============================================================
_G.gameFont = "AdelonSerial"
_G.isLandscape = false

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
local composer = require "composer"
require "ssk.loadSSK"

----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------

-- SSK 
local isInBounds		= ssk.easyIFC.isInBounds
local newCircle 		= ssk.display.circle
local newRect 			= ssk.display.rect
local newImageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local ternary			= _G.ternary
local quickLayers  		= ssk.display.quickLayers

local angle2Vector 		= ssk.math2d.angle2Vector
local vector2Angle 		= ssk.math2d.vector2Angle
local scaleVec 			= ssk.math2d.scale
local addVec 			= ssk.math2d.add
local subVec 			= ssk.math2d.sub
local getNormals 		= ssk.math2d.normals

-- Lua and Corona
local mAbs 				= math.abs
local mPow 				= math.pow
local mRand 			= math.random
local getInfo			= system.getInfo
local getTimer 			= system.getTimer
local strMatch 			= string.match
local strFormat 		= string.format


----------------------------------------------------------------------
-- 4. Experiments
----------------------------------------------------------------------
local test1
local test2
local test3
local extractPhrases

local text = "This is a some sample text.<BR><br>  Go #north.  See an @apple.<br><br>  "
 .. "You see a [winding road]. Look at a @sign.  {Look north}."

local function run()
	--test1(text)
	--test2(text)
	local words = extractPhrases(text)
	test3(words)
end

extractPhrases = function( text )

	local tc = text
	tc = string.gsub( tc, "<br>", " <br> " )

	tc = string.gsub( tc, "  ", " " )
	tc = string.gsub( tc, "  ", " " )
	tc = string.gsub( tc, "%. ", "." )
	tc = string.gsub( tc, "%.", ". " )

	local function removeMarkers( word, cap )
		word = string.gsub( word, "%.", "" )
		word = string.gsub( word, "%,", "" )
		word = string.gsub( word, "%;", "" )
		word = string.gsub( word, "%:", "" )
		word = string.gsub( word, "%#", "" )
		word = string.gsub( word, "%@", "" )	
		word = string.gsub( word, "%]", "" )
		word = string.gsub( word, "%[", "" )
		word = string.gsub( word, "%{", "" )
		word = string.gsub( word, "%}", "" )
		word = string.gsub( word, "<br>", "" )
		word = string.trim( word )
		if( cap ) then
			word = string.upper( word )
		end
		return word
	end

	--[[
	tc = string.gsub( tc, "%{", "" )
	tc = string.gsub( tc, "%}", "" )
	tc = string.gsub( tc, "%[", "" )
	tc = string.gsub( tc, "%]", "" )
	tc = string.gsub( tc, "%#", "" )
	tc = string.gsub( tc, "%@", "" )
	--]]

	local words = tc:split( " " )

	local function isNavigationWord( str )
		return string.find( str, "%#") ~= nil
	end

	local function isNavigationPhraseEnd( str )
		return string.find( str, "%]") ~= nil
	end


	local function isNavigationPhraseBegin( words, index )
		local str = words[index]
		local isBegin = string.find( str, "%[") ~= nil
		local phrase
		local endIndex 
		if( isBegin ) then	
			local i = index + 1
			while ( (i <= #words) and not endIndex ) do
				if( isNavigationPhraseEnd(words[i]) ) then
					endIndex = i
				end
				i = i + 1
			end

			endIndex = endIndex or index
			phrase = ""
			for i = index, endIndex do
				phrase = phrase .. words[i] .. " "
			end
			if( phrase ) then

				phrase = removeMarkers( phrase, true )
				--print("Navigation phrase == " .. phrase )
			end
		end

		return isBegin, phrase
	end

	local function isActionWord( str )
		return string.find( str, "%@") ~= nil
	end

	local function isActionPhraseEnd( str )
		return string.find( str, "%}") ~= nil
	end


	local function isActionPhraseBegin( words, index )
		local str = words[index]
		local isBegin = string.find( str, "%{") ~= nil
		local phrase
		local endIndex 
		if( isBegin ) then	
			local i = index + 1
			while ( (i <= #words) and not endIndex ) do
				if( isActionPhraseEnd(words[i]) ) then
					endIndex = i
				end
				i = i + 1
			end

			endIndex = endIndex or index
			phrase = ""
			for i = index, endIndex do
				phrase = phrase .. words[i] .. " "
			end
			if( phrase ) then

				phrase = removeMarkers( phrase, true )
				print("Action phrase == " .. phrase )
			end
		end

		return isBegin, phrase
	end


	local function isNewline( str )
		return string.find( str:lower(), "<br>") ~= nil
	end

	local function hasPeriod( str )
		return string.find( str, "%.") ~= nil
	end

	local function hasComma( str )
		return string.find( str, "%,") ~= nil
	end

	local function hasSemicolon( str )
		return string.find( str, "%;") ~= nil
	end

	local function hasColon( str )
		return string.find( str, "%:") ~= nil
	end

	local function hasDoubleQuote( str )
		return string.find( str, '%"') ~= nil
	end

	local function hasSingleQuote( str )
		return string.find( str, "%'") ~= nil
	end

	local function hasSingleQuote2( str )
		return string.find( str, "%`") ~= nil
	end

	local _
	local navigationPhrase
	local actionPhrase
	for i = 1, #words do
		local tmp = { word = words[i] }

		-- Is this a navigation word (single-word navigation link)
		if( isNavigationWord(words[i]) ) then
			tmp.navigationWord = words[i]
			tmp.navigationWord = string.gsub( tmp.navigationWord, "%#", "" )
			tmp.navigationWord = string.gsub( tmp.navigationWord, "%.", "" )
			tmp.navigationWord = string.upper(tmp.navigationWord)
		
		elseif( isNavigationPhraseBegin( words, i ) ) then
			_,navigationPhrase = isNavigationPhraseBegin( words, i )						

		elseif( isActionWord(words[i]) ) then
			tmp.actionWord = words[i]
			tmp.actionWord = string.gsub( tmp.actionWord, "%@", "" )
			tmp.actionWord = string.gsub( tmp.actionWord, "%.", "" )
			tmp.actionWord = string.upper(tmp.actionWord)
		
		elseif( isActionPhraseBegin( words, i ) ) then
			_,actionPhrase = isActionPhraseBegin( words, i )						

		end		


		-- Assign any continuting 'navigation phrase'
		tmp.navigationPhrase = navigationPhrase

		-- Assign any continuting 'action phrase'
		tmp.actionPhrase = actionPhrase

		if( isNewline(tmp.word) ) then
			tmp.isNewline = true
		end


		-- Check for punctuation.  Note that it is there, then remove it.
		if( hasPeriod(tmp.word) ) then
			tmp.hasPeriod = true
			tmp.word = string.gsub( tmp.word, "%.", "" )
		
		elseif( hasComma(tmp.word) ) then
			tmp.hasComma = true
			tmp.word = string.gsub( tmp.word, "%,", "" )
		
		elseif( hasSemicolon(tmp.word) ) then
			tmp.hasSemicolon = true
			tmp.word = string.gsub( tmp.word, "%;", "" )
		
		elseif( hasColon(tmp.word) ) then
			tmp.hasColon = true
			tmp.word = string.gsub( tmp.word, "%:", "" )
		
		elseif( hasDoubleQuote(tmp.word) ) then
			tmp.hasDoubleQuote = true
			tmp.word = string.gsub( tmp.word, '%"', "" )
		
		elseif( hasSingleQuote(tmp.word) ) then
			tmp.hasSingleQuote = true
			tmp.word = string.gsub( tmp.word, "%'", "" )
		
		elseif( hasSingleQuote2(tmp.word) ) then
			tmp.hasSingleQuote = true
			tmp.word = string.gsub( tmp.word, "%`", "" )
		end

		-- Clean the word
		tmp.word = string.gsub( tmp.word, "%{", "" )
		tmp.word = string.gsub( tmp.word, "%}", "" )
		tmp.word = string.gsub( tmp.word, "%[", "" )
		tmp.word = string.gsub( tmp.word, "%]", "" )
		tmp.word = string.gsub( tmp.word, "%#", "" )
		tmp.word = string.gsub( tmp.word, "%@", "" )

		if(navigationPhrase and isNavigationPhraseEnd(words[i])) then
			--print("Closing navigation phrase: ", navigationPhrase )
			navigationPhrase = nil
		end

		if(actionPhrase and isActionPhraseEnd(words[i])) then
			print("Closing action phrase: ", actionPhrase )
			actionPhrase = nil
		end

		words[i] = tmp
	end

	--table.print_r(words)

	return words
end



test3 = function ( words )

	local function onTouch( self, event )
		if( event.phase == "began" ) then
			if( self.navigationWord ) then 
				print("Navigate to: " .. self.navigationWord )
			
			elseif( self.navigationPhrase ) then 
				print("Navigate to: " .. self.navigationPhrase )
			
			elseif( self.actionWord ) then 
				print("Action: " .. self.actionWord )
			
			elseif( self.actionPhrase ) then 
				print("Action: " .. self.actionPhrase )
			end
		end
		return true
	end

	local fontSize = 42
	local xSep		= 10
	local ySep		= 5
	local minX 		= left + 10
	local maxX 		= right - 10
	local startX 	= minX
	local startY 	= top + 20
	local curX 		= startX
	local curY 		= startY
	for i = 1, #words do
		--print(words[i].word, curX)
		if( words[i].isNewline ) then
			curY = curY + fontSize + ySep
			curX = startX
		else
			local tmp 
			if( false ) then
				tmp = display.newText( "|"..words[i].word.."|", curX, curY, gameFont, fontSize )			
			else
				tmp = display.newText( words[i].word, curX, curY, gameFont, fontSize )			
			end
			tmp.anchorX = 0
			tmp.anchorY = 0

			if( words[i].navigationWord ~= nil ) then
				tmp:setFillColor(unpack(_B_))
				tmp.navigationWord = words[i].navigationWord
				tmp.touch = onTouch
				tmp:addEventListener( "touch" )
			
			elseif( words[i].navigationPhrase ~= nil ) then
				tmp:setFillColor(unpack(_C_))
				tmp.navigationPhrase = words[i].navigationPhrase
				tmp.touch = onTouch
				tmp:addEventListener( "touch" )

			elseif( words[i].actionWord ~= nil ) then
				tmp:setFillColor(unpack(_O_))
				tmp.actionWord = words[i].actionWord
				tmp.touch = onTouch
				tmp:addEventListener( "touch" )
			
			elseif( words[i].actionPhrase ~= nil ) then
				tmp:setFillColor(unpack(_Y_))
				tmp.actionPhrase = words[i].actionPhrase
				tmp.touch = onTouch
				tmp:addEventListener( "touch" )
			end

			if( tmp.x + tmp.contentWidth >= maxX ) then
				curY = curY + fontSize + ySep
				curX = startX
				tmp.x = curX
				tmp.y = curY
			end
			

			-- Add punctuation late to avoid wrapping issues
			if( words[i].hasPeriod ) then
				tmp = display.newText( ". ", tmp.x + tmp.contentWidth, curY, gameFont, fontSize )
				tmp.anchorX = 0
				tmp.anchorY = 0
				
			end


			-- Adjust to new X position
			curX = tmp.x + tmp.contentWidth  + xSep
		end
	end
	--table.dump(words)
end


test2 = function ( text )
	local tc = text

	--tc = string.gsub( tc, "<br><br>", " <br2> " )
	tc = string.gsub( tc, "<br>", " <br> " )

	tc = string.gsub( tc, "  ", " " )
	tc = string.gsub( tc, "  ", " " )
	tc = string.gsub( tc, "%. ", "." )
	tc = string.gsub( tc, "%.", ". " )

	tc = string.gsub( tc, "%{", "" )
	tc = string.gsub( tc, "%}", "" )
	tc = string.gsub( tc, "%[", "" )
	tc = string.gsub( tc, "%]", "" )
	tc = string.gsub( tc, "%#", "" )
	tc = string.gsub( tc, "%@", "" )

	local words = tc:split( " " )

	for i = 1, #words do
		words[i] = string.trim(words[i])
	end

	local fontSize = 42
	local xSep		= 15
	local ySep		= 5
	local minX 		= left + 10
	local maxX 		= right - 10
	local startX 	= minX
	local startY 	= top + 20
	local curX 		= startX
	local curY 		= startY
	for i = 1, #words do
		print(words[i], curX)
		if( words[i] == "<br>" ) then
			curY = curY + fontSize + ySep
			curX = startX
		elseif( words[i] == "<br2>" ) then
			curY = curY + (fontSize + ySep) * 1.5
			curX = startX
		else
			local tmp 
			if( false ) then
				tmp = display.newText( "|"..words[i].."|", curX, curY, gameFont, fontSize )			
			else
				tmp = display.newText( words[i], curX, curY, gameFont, fontSize )			
			end
			tmp.anchorX = 0
			tmp.anchorY = 0

			if( tmp.x + tmp.contentWidth >= maxX ) then
				curY = curY + fontSize + ySep
				curX = startX
				tmp.x = curX
				tmp.y = curY
			end
			curX = tmp.x + tmp.contentWidth  + xSep
		end
	end
	--table.dump(words)
end

test1 = function ( text )

	local tc = text
	tc = string.gsub( tc, "  ", " " )
	tc = string.gsub( tc, "  ", " " )
	tc = string.gsub( tc, "%. ", "." )	
	tc = string.gsub( tc, "%.", ". " )

	local words = tc:split( " " )

	for i = 1, #words do
		words[i] = string.trim(words[i])
	end

	local fontSize = 42
	local curX = 10
	local curY = 20
	for i = 1, #words do
		local tmp = display.newText( i .. " :" .. words[i] .. ":", curX, curY, gameFont, fontSize )	
		tmp.anchorX = 0
		curY = curY + fontSize
	end
	table.dump(words)
end


run()