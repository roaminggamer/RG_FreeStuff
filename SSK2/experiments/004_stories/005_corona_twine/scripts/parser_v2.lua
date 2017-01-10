-- =============================================================
-- parser.lua
-- =============================================================
-- Sans Interfaces - i.e. Without a framework.
-- =============================================================
local pu = require "scripts.parse_utils"
local values = require "scripts.values"
local public = {}

-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local mAbs = math.abs;local mPow = math.pow;local mRand = math.random
local getInfo = system.getInfo; local getTimer = system.getTimer
local strMatch = string.match; local strFormat = string.format
local strGSub = string.gsub; local strSub = string.sub

--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
--
-- Specialized SSK Features
local actions = ssk.actions

public.addTarget = function( tokens, token, target )
	token = string.upper(token)
	for k,v in pairs( tokens ) do
		if(k == token) then
			v.target = target
			return
		end
	end
end

public.identifyTokens = function( words, tokens )
	tokens = tokens or {}

	for i = 1, #words do
		if( words[i].navigationWord and not tokens[words[i].navigationWord] ) then 
			tokens[words[i].navigationWord] = { token = words[i].navigationWord, target = "", type = "navigation" } 
		end
		if( words[i].navigationPhrase and not tokens[words[i].navigationPhrase] ) then 
			tokens[words[i].navigationPhrase] = { token = words[i].navigationPhrase, target = "", type = "navigation" } 
		end

		if( words[i].actionWord and not tokens[words[i].actionWord] ) then 
			tokens[words[i].actionWord] = { token = words[i].actionWord, target = "", type = "action" } 
		end
		if( words[i].actionPhrase and not tokens[words[i].actionPhrase] ) then 
			tokens[words[i].actionPhrase] = { token = words[i].actionPhrase, target = "", type = "action" } 
		end
	end

	return tokens
end



public.decode = function( text )

	local tc = text
	tc = string.gsub( tc, "<br>", " <br> " )

	tc = string.gsub( tc, "  ", " " )
	tc = string.gsub( tc, "  ", " " )
	tc = string.gsub( tc, "%. ", "." )
	tc = string.gsub( tc, "%.", ". " )
	tc = string.gsub( tc, "%, ", "," )
	tc = string.gsub( tc, "%,", ", " )

	local words = tc:split( " " )

	local _
	local navigationPhrase
	local actionPhrase
	for i = 1, #words do
		local tmp = { word = words[i] }

		-- Is this a navigation word (single-word navigation link)
		if( pu.isNavigationWord(words[i]) ) then
			tmp.navigationWord = words[i]
			tmp.navigationWord = string.gsub( tmp.navigationWord, "%#", "" )
			tmp.navigationWord = string.gsub( tmp.navigationWord, "%.", "" )
			tmp.navigationWord = string.gsub( tmp.navigationWord, "%,", "" )
			tmp.navigationWord = string.upper(tmp.navigationWord)

		elseif( pu.isNavigationPhraseBegin( words, i ) ) then
			_,navigationPhrase = pu.isNavigationPhraseBegin( words, i )						

		elseif( pu.isActionWord(words[i]) ) then
			tmp.actionWord = words[i]
			tmp.actionWord = string.gsub( tmp.actionWord, "%@", "" )
			tmp.actionWord = string.gsub( tmp.actionWord, "%.", "" )
			tmp.actionWord = string.gsub( tmp.actionWord, "%,", "" )
			tmp.actionWord = string.upper(tmp.actionWord)
		
		elseif( pu.isActionPhraseBegin( words, i ) ) then
			_,actionPhrase = pu.isActionPhraseBegin( words, i )						

		end		

		-- Assign any continuting 'navigation phrase'
		tmp.navigationPhrase = navigationPhrase

		-- Assign any continuting 'action phrase'
		tmp.actionPhrase = actionPhrase

		if( pu.isNewline(tmp.word) ) then
			tmp.isNewline = true
		end


		-- Check for punctuation.  Note that it is there, then remove it.
		if( pu.hasPeriod(tmp.word) ) then
			tmp.hasPeriod = true
			tmp.word = string.gsub( tmp.word, "%.", "" )
		
		elseif( pu.hasComma(tmp.word) ) then
			tmp.hasComma = true
			tmp.word = string.gsub( tmp.word, "%,", "" )
		
		elseif( pu.hasSemicolon(tmp.word) ) then
			tmp.hasSemicolon = true
			tmp.word = string.gsub( tmp.word, "%;", "" )
		
		elseif( pu.hasColon(tmp.word) ) then
			tmp.hasColon = true
			tmp.word = string.gsub( tmp.word, "%:", "" )
		
		elseif( pu.hasDoubleQuote(tmp.word) ) then
			tmp.hasDoubleQuote = true
			tmp.word = string.gsub( tmp.word, '%"', "" )
		
		elseif( pu.hasSingleQuote(tmp.word) ) then
			tmp.hasSingleQuote = true
			tmp.word = string.gsub( tmp.word, "%'", "" )
		
		elseif( pu.hasSingleQuote2(tmp.word) ) then
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

		if(navigationPhrase and pu.isNavigationPhraseEnd(words[i])) then
			--print("Closing navigation phrase: ", navigationPhrase )
			navigationPhrase = nil
		end

		if(actionPhrase and pu.isActionPhraseEnd(words[i])) then
			--print("Closing action phrase: ", actionPhrase )
			actionPhrase = nil
		end

		words[i] = tmp
	end

	--table.print_r(words)

	return words
end

local story 
public.loadStory = function( data )
	story = data
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