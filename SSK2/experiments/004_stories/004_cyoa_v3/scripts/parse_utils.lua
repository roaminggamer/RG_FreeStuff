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


function public.removeMarkers( word, cap )
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

function public.isNavigationWord( str )
	return string.find( str, "%#") ~= nil
end

function public.isNavigationPhraseEnd( str )
	return string.find( str, "%]") ~= nil
end

function public.isNavigationPhraseBegin( words, index )
	local str = words[index]
	local isBegin = string.find( str, "%[") ~= nil
	local phrase
	local endIndex 
	if( isBegin ) then	
		local i = index + 1
		while ( (i <= #words) and not endIndex ) do
			if( public.isNavigationPhraseEnd(words[i]) ) then
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

			phrase = public.removeMarkers( phrase, true )
			--print("Navigation phrase == " .. phrase )
		end
	end

	return isBegin, phrase
end

function public.isActionWord( str )
	return string.find( str, "%@") ~= nil
end

function public.isActionPhraseEnd( str )
	return string.find( str, "%}") ~= nil
end


function public.isActionPhraseBegin( words, index )
	local str = words[index]
	local isBegin = string.find( str, "%{") ~= nil
	local phrase
	local endIndex 
	if( isBegin ) then	
		local i = index + 1
		while ( (i <= #words) and not endIndex ) do
			if( public.isActionPhraseEnd(words[i]) ) then
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

			phrase = public.removeMarkers( phrase, true )
			print("Action phrase == " .. phrase )
		end
	end

	return isBegin, phrase
end


function public.isNewline( str )
	return string.find( str:lower(), "<br>") ~= nil
end

function public.hasPeriod( str )
	return string.find( str, "%.") ~= nil
end

function public.hasComma( str )
	return string.find( str, "%,") ~= nil
end

function public.hasSemicolon( str )
	return string.find( str, "%;") ~= nil
end

function public.hasColon( str )
	return string.find( str, "%:") ~= nil
end

function public.hasDoubleQuote( str )
	return string.find( str, '%"') ~= nil
end

function public.hasSingleQuote( str )
	return string.find( str, "%'") ~= nil
end

function public.hasSingleQuote2( str )
	return string.find( str, "%`") ~= nil
end	

return public