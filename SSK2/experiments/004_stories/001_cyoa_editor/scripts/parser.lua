-- =============================================================
-- parser.lua
-- =============================================================
-- Sans Interfaces - i.e. Without a framework.
-- =============================================================
local pu = require "scripts.parse_utils"
local values = require "scripts.values"
local public = {}
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


local story 
public.loadStory = function( data )
	story = {}
	story.data = data
	story.namesIndex = pu.indexNames( data )
	return story
end

public.gotoPage = function( pageName, oldPageGroup )
	local currentPage = story[pageName]
	if( currentPage.words ) then
		print("SIMPLE PAGE", getTimer())
		-- SIMPLE PAGE
		return public.displayPage( currentPage, oldPageGroup, false )
	else
		print("EXPRESSION PAGE")
		-- EXPRESSION BASED PAGES
		-- EFM Need default page rule/concept for all false case
		local pagesToShow = {}
		for i = 1, #currentPage do
			local subPage = currentPage[i]
			if( values.evaluate( subPage.expression ) ) then
				pagesToShow[#pagesToShow+1] = subPage
			end
		end
		table.dump(pagesToShow,nil,"pts")

		local group 
		for i = 1, #pagesToShow do
			if( i == 1 ) then
				group = public.displayPage( pagesToShow[i], oldPageGroup )
			else
				public.displayPage( pagesToShow[i], group, true )
			end
		end
		print("returning", group)
		return group
	end
end


public.displayPage = function ( pageData, oldPageGroup, keepGroup )
	if( keepGroup == true ) then
		-- Nothing
	else
		display.remove( oldPageGroup )
	end

	local words 	= pageData.words
	local tokens 	= pageData.tokens
	local group

	if( keepGroup == true ) then		
		group = oldPageGroup
	else
		group = display.newGroup()
	end	

	local function onTouch( self, event )
		if( event.phase == "ended" ) then
			if( self.navigationWord ) then 
				print("Navigate to: " .. self.navigationWord )
				post("onNavigate", { token = self.navigationWord, target = self.target } )
			
			
			elseif( self.navigationPhrase ) then 
				print("Navigate to: " .. self.navigationPhrase )			
				post("onNavigate", { token = self.navigationPhrase, target = self.target } )

			elseif( self.actionWord ) then 
				print("Action: " .. self.actionWord )
				post("onAction", { token = self.actionWord, target = self.target } )
			
			elseif( self.actionPhrase ) then 
				print("Action: " .. self.actionPhrase )
				post("onAction", { token = self.actionPhrase, target = self.target } )
			end
		end
		return true
	end

	local fontSize = 42
	local xSep		= 14
	local ySep		= 5
	local minX 		= left + 10
	local maxX 		= right - 10
	local startX 	= minX
	local startY 	= top + 20

	if( keepGroup == true ) then
		startY = group.y + group.contentHeight + fontSize/2
	end

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
				tmp = display.newText( group, "|"..words[i].word.."|", curX, curY, gameFont, fontSize )			
			else
				tmp = display.newText( group, words[i].word, curX, curY, gameFont, fontSize )			
			end
			tmp.anchorX = 0
			tmp.anchorY = 0

			if( words[i].navigationWord ~= nil ) then
				tmp:setFillColor(unpack(_B_))
				tmp.navigationWord = words[i].navigationWord
				if( tokens[tmp.navigationWord] ) then
					tmp.target = tokens[tmp.navigationWord].target
				end
				tmp.touch = onTouch
				tmp:addEventListener( "touch" )
			
			elseif( words[i].navigationPhrase ~= nil ) then
				tmp:setFillColor(unpack(_C_))
				tmp.navigationPhrase = words[i].navigationPhrase				
				if( tokens[tmp.navigationPhrase] ) then
					tmp.target = tokens[tmp.navigationPhrase].target
				end
				tmp.touch = onTouch
				tmp:addEventListener( "touch" )

			elseif( words[i].actionWord ~= nil ) then
				tmp:setFillColor(unpack(_O_))
				tmp.actionWord = words[i].actionWord
				if( tokens[tmp.actionWord] ) then
					tmp.target = tokens[tmp.actionWord].target
				end
				tmp.touch = onTouch
				tmp:addEventListener( "touch" )
			
			elseif( words[i].actionPhrase ~= nil ) then
				tmp:setFillColor(unpack(_Y_))
				tmp.actionPhrase = words[i].actionPhrase
				if( tokens[tmp.actionPhrase] ) then
					tmp.target = tokens[tmp.actionPhrase].target
				end				
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
				tmp = display.newText( group, ". ", tmp.x + tmp.contentWidth, curY, gameFont, fontSize )
				tmp.anchorX = 0
				tmp.anchorY = 0
			end

			if( words[i].hasComma ) then
				tmp = display.newText( group, ",", tmp.x + tmp.contentWidth, curY, gameFont, fontSize )
				tmp.anchorX = 0
				tmp.anchorY = 0
			end


			-- Adjust to new X position
			curX = tmp.x + tmp.contentWidth  + xSep
		end
	end
	--table.dump(words)

	return group
end


return public