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

local function strTrim(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end

local strGSub = string.gsub
local strSub = string.sub
local strFind = string.find
local strLen = string.len


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

function public.isNewline( str )
	return string.find( str, "<br>") ~= nil
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

function public.isPunctuation( str )
	local isPunctuation = 	
		(strSub( str, 1, 1 ) == ".") or
		(strSub( str, 1, 1 ) == ",") or
		(strSub( str, 1, 1 ) == ";") or
		(strSub( str, 1, 1 ) == ":") 

	return isPunctuation
end

function public.navTarget( str )
	local isNav = (strSub( str, 1, 2 ) == "[[")

	local target
	if( isNav ) then
		str = str:gsub("%[", "")
		str = str:gsub("%]", "")
		str = str:split("%|")
		target = str[2] or str[1]
		table.dump( str )
	end

	return target
end


function public.createStory( data )
	local story = {}
	local words = {}
	story.raw = data
	story.words = words
	for k, v in pairs( data ) do
		words[string.lower(k)] = public.getWords( story , k )
	end
	return story
end


function public.extractTwineData( fileName, base )
	base = base or system.ResourceDirectory 
	local data = io.readFileTable( fileName, base )

	local passageTable = {}
	local curPassage


	local foundStart = false

	for i = 1, #data do
		local isStart = strFind( data[i], ":: Start")
		local isNewPassage = strSub( data[i], 1, 2 ) == "::"

		if( foundStart or isNewPassage and isStart ) then
			foundStart = true

			-- Start new passage?
			if(  isNewPassage  ) then
				local name = string.lower(string.trim(strSub( data[i], 3 )))
				curPassage = {}
				passageTable[name] = curPassage

				curPassage.name = strSub( data[i], 3 )
				curPassage.name = strTrim( curPassage.name )

				curPassage.content = ""

				--print("New Passage:", curPassage.name)

			-- Add content to current passage
			elseif( curPassage ~= nil ) then
				if(strLen(curPassage.content) == 0 ) then
					curPassage.content = data[i]
				else
					curPassage.content = curPassage.content .. "<br>" .. data[i]	 			
				end

				--print(data[i])
				--print(curPassage.content)

			-- Huh?  Ignore leading junk
			else
				print( " -------------------------------------------------- " )
				print( "Warning!!, line " .. i .. ". Not in passage yet?  Ignoring line"  )
				print( " -------------------------------------------------- " )
				print( data[i] )
				print( " -------------------------------------------------- \n" )
			end
		end
	end

	return passageTable
end

function public.getWords( story, page  )
	page = page or "start"
	page = string.lower( page )
	local content = story.raw[page].content

	content = string.gsub( content, "<br>", " <br> " )

	content = string.gsub( content, "  ", " " )
	content = string.gsub( content, "  ", " " )
	content = string.gsub( content, "%. ", "." )
	content = string.gsub( content, "%.", " . " )
	content = string.gsub( content, "%, ", " , " )
	content = string.gsub( content, "%;", " ; " )


	local words = content:split( " " )
	return words
end


function public.indexNames( data )
	local namesIndex = {}
	for i = 1, #data do
		--print(data[i].name)
		namesIndex[string.lower(data[i].name)] = i
	end
	return namesIndex
end

function public.setStory( story )
	public.__curPage = nil
	public.__story = story
end


function public.displayPage( pageName, oldPageGroup, keepGroup )
	--print( pageName, oldPageGroup, keepGroup )

	--pageName = string.lower(pageName)

	local lastPage = public.__curPage
	 public.__curPage = pageName

	 --local words = public.getWords( public.__story, pageName )
	 local words = public.__story.words[string.lower(pageName)]

	if( keepGroup == true ) then
		-- Nothing
	else
		display.remove( oldPageGroup )
	end

	local group

	if( keepGroup == true ) then		
		group = oldPageGroup
	else
		group = display.newGroup()
	end	

	if( lastPage ) then
		post("didExitPage", { target = lastPage } )
	end
	post("willEnterPage", { target = public.__curPage } )

	local function onTouch( self, event )
		if( event.phase == "ended" ) then
			if( self.target ) then 
				--print("Navigate to: " .. self.target )
				post("willExitPage", { target = public.__curPage } )
				post("onNavigate", { target = self.target } )							
			end
		end
		return true
	end

	local fontSize 	= 42
	local xSep		= 14
	local ySep		= 5
	local minX 		= left + 10
	local maxX 		= right - 10
	local startX 	= minX
	local startY 	= top + 20
	local punctOffset = -fontSize/3

	if( keepGroup == true ) then
		startY = group.y + group.contentHeight + fontSize/2
	end

	local curX 		= startX
	local curY 		= startY


	for i = 1, #words do
		--print(words[i], curX)
		if( public.isNewline(words[i]) ) then
			curY = curY + fontSize + ySep
			curX = startX
		else
			local tmp 
			local word = words[i]

			word = word:gsub("%[", "")
			word = word:gsub("%]", "")

			if( false ) then
				tmp = display.newText( group, "|"..word.."|", curX, curY, gameFont, fontSize )			
			else
				tmp = display.newText( group, word, curX, curY, gameFont, fontSize )			
			end
			tmp.anchorX = 0
			tmp.anchorY = 0


			tmp.target = public.navTarget( words[i] )
			if( tmp.target ) then

				tmp.touch = onTouch
				tmp:addEventListener( "touch" )
				tmp:setFillColor(unpack(_B_))
			end

			if( tmp.x + tmp.contentWidth >= maxX ) then
				curY = curY + fontSize + ySep
				curX = startX
				tmp.x = curX
				tmp.y = curY
			end
			
			
			if( public.isPunctuation(words[i]) ) then
				tmp.x = tmp.x + punctOffset
			end

			-- Adjust to new X position
			curX = tmp.x + tmp.contentWidth + xSep
		end
	end
	--table.dump(words)

	post("didEnterPage", { target = public.__curPage } )

	return group
end


return public