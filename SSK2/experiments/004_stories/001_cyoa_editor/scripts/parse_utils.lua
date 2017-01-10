local parse_utils = {}
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

local function strTrim(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end

local strGSub = string.gsub
local strSub = string.sub
local strFind = string.find
local strLen = string.len


function parse_utils.removeMarkers( word, cap )
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

function parse_utils.isNewline( str )	
	if( type(str) ~= "string" ) then return false end
	return string.find( str:lower(), "<br>") ~= nil
end

function parse_utils.isPunctuation( str )
	if( type(str) ~= "string" ) then return false end
	local isPunctuation = 	
		(strSub( str, 1, 1 ) == ".") or
		(strSub( str, 1, 1 ) == ",") or
		(strSub( str, 1, 1 ) == ";") or
		(strSub( str, 1, 1 ) == ":") 

	return isPunctuation
end

function parse_utils.extractPassages( data )

	local passageTable = {}
	local curPassage

	for i = 1, #data do
		local page = data[i]._data
		--table.print_r(page)

		local isStart = fnn( page.isStart, false )

		local name = string.lower(page.title)
		curPassage = {}
		passageTable[name] = curPassage

		curPassage.name = page.title

		curPassage.content = page.body
		curPassage.content = string.gsub( curPassage.content, "\n", "<br>" )
	end

	return passageTable
end


function parse_utils.createStory( data )
	local story = {}
	local words = {}
	story.raw = data
	story.words = words
	for k, v in pairs( data ) do
		words[string.lower(k)] = parse_utils.getWords( story , k )
	end
	return story
end

function parse_utils.getWords( story, page  )
	page = page or "start"
	page = string.lower( page )
	local body = story.raw[page].content

	local body = string.gsub( body, "<br>", "\r<br>\r" )

	body = string.split( body, "\r")		

	local list2 = {}

	local maxIndex = #body
	for i = 1, #body do
		--print(i, body[i])	
		if( string.find( body[i], "%[%[" ) ~= nil ) then
			local list = string.split( body[i], "%[%[")		
			local maxIndex = #list
			local j = 1
			while( j <= maxIndex ) do
			--for j = 1, #list do
				--print(j)
				if( string.find( list[j], "%]%]" ) ~= nil ) then
					local entry = list[j]
					--print("============> " .. tostring(j) .. " " ..  tostring(maxIndex) .. " : " .. tostring(entry), string.find(entry, "%]%]"), string.len( entry ) )
					if( string.find(entry, "%]%]") < string.len( entry ) ) then
						local endCap = string.find(entry, "%]%]") or string.len( entry )
						local trimmed = string.sub(entry, endCap + 2, string.len(entry) )
						--print("DO INSERT!", #list)
						table.insert(list,j+1,trimmed)
						maxIndex = maxIndex + 1
						--print("DID INSERT!", #list)
						entry = string.sub(entry, 1, endCap - 1)
					end
					entry = string.gsub( entry, "%]%]", "" )
					entry = string.gsub( entry, "\n", "" )
					entry = string.gsub( entry, "\r", "" )				
					list2[#list2+1] = { isLink = true , link = entry }
				else
					list2[#list2+1] = list[j]
				end
				j = j + 1
			end
			--table.print_r(list2)
		else 
			list2[#list2+1] = body[i]
		end
	end
	--print("LIST2")
	--table.print_r(list2)

	local list3 = {}

	for i = 1, #list2 do
		--print(i, list2[i])
		if( type(list2[i]) == "string"  ) then
			local content  = string.gsub( list2[i], "<br>", " <br> " )
			content = string.gsub( content, "  ", " " )
			content = string.gsub( content, "  ", " " )
			content = string.gsub( content, "%. ", "." )
			content = string.gsub( content, "%.", " . " )
			content = string.gsub( content, "%, ", " , " )
			content = string.gsub( content, "%;", " ; " )
			local words = content:split( " " )
			for j = 1, #words do
				list3[#list3+1] = words[j]
			end
		elseif( type(list2[i]) == "table" and list2[i].isLink  ) then
			local content = string.gsub( list2[i].link, "<br>", "\r<br>\r" )
			local words = content:split( "\r" )
			for j = 1, #words do
				if( string.find(words[j], "|") ~= nil ) then
					words[j] = string.split( words[j], "|" )
				else
					words[j] = { words[j], words[j] }
				end
			end

			for j = 1, #words do
				list3[#list3+1] = words[j]
			end
		end
	end
	return list3
end

--[[
function parse_utils.getWords_OLD( story, page  )
	page = page or "start"
	page = string.lower( page )
	local body = story.raw[page].content

	--local body = string.gsub( body, "<br>", " <br> " )


	--print(body)
	local list2 = {}
	if( string.find( body, "%[%[" ) ~= nil ) then
		--print(body)
		local list = string.split( body, "%[%[")		
		for i = 1, #list do
			if( string.find( list[i], "%]%]" ) ~= nil ) then
				local entry = list[i]
				--print(entry)
				local endCap = string.find(entry, "%]%]") or string.len( entry )
				entry = string.sub(entry, 1, endCap - 1)
				entry = string.gsub( entry, "%]%]", "" )
				entry = string.gsub( entry, "\n", "" )
				entry = string.gsub( entry, "\r", "" )				
				list2[#list2+1] = { isLink = true , link = entry }
			else
				list2[#list2+1] = list[i]
			end
		end
		--table.print_r(list2)
	end

	--table.print_r(list2)

	local list3 = {}

	for i = 1, #list2 do
		--print(i, list2[i])
		if( type(list2[i]) == "string"  ) then
			local content  = string.gsub( list2[i], "<br>", " <br> " )
			content = string.gsub( content, "  ", " " )
			content = string.gsub( content, "  ", " " )
			content = string.gsub( content, "%. ", "." )
			content = string.gsub( content, "%.", " . " )
			content = string.gsub( content, "%, ", " , " )
			content = string.gsub( content, "%;", " ; " )
			local words = content:split( " " )
			for j = 1, #words do
				list3[#list3+1] = words[j]
			end
		elseif( type(list2[i]) == "table" and list2[i].isLink  ) then
			local content = string.gsub( list2[i].link, "<br>", "\r<br>\r" )
			local words = content:split( "\r" )
			for j = 1, #words do
				if( string.find(words[j], "|") ~= nil ) then
					words[j] = string.split( words[j], "|" )
				else
					words[j] = { words[j], words[j] }
				end
			end

			for j = 1, #words do
				list3[#list3+1] = words[j]
			end
		end
	end
	return list3
end
--]]


function parse_utils.indexNames( data )
	local namesIndex = {}
	for i = 1, #data do
		--print(data[i].name)
		namesIndex[string.lower(data[i].name)] = i
	end
	return namesIndex
end

function parse_utils.setStory( story )
	parse_utils.__curPage = nil
	parse_utils.__story = story
end


function parse_utils.displayPage( pageName, oldPageGroup, keepGroup )
	--print( "parse_utils.displayPage() ", pageName, oldPageGroup, keepGroup )

	--pageName = string.lower(pageName)

	local lastPage = parse_utils.__curPage
	 parse_utils.__curPage = pageName

	 --local words = parse_utils.getWords( parse_utils.__story, pageName )
	 local words = parse_utils.__story.words[string.lower(pageName)]

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
	post("willEnterPage", { target = parse_utils.__curPage } )

	local function onTouch( self, event )
		if( event.phase == "ended" ) then
			if( self.target ) then 
				--print("Navigate to: " .. self.target )
				post("willExitPage", { target = parse_utils.__curPage } )
				post("onNavigate", { target = self.target } )							
			end
		end
		return true
	end

	local fontSize 	= 42
	local xSep		= 14
	local ySep		= 5
	local minX 		= left + 20
	local maxX 		= right - 20
	local startX 	= minX
	local startY 	= top + 60
	local punctOffset = -fontSize/3

	if( keepGroup == true ) then
		startY = group.y + group.contentHeight + fontSize/2
	end

	local curX 		= startX
	local curY 		= startY


	for i = 1, #words do
		--print(words[i], curX)
		if( parse_utils.isNewline(words[i]) ) then
			curY = curY + fontSize + ySep
			curX = startX
		else
			local tmp 
			local word = words[i]

			if( type( word ) == "string" ) then
				if( false ) then
					tmp = display.newText( group, "|"..word.."|", curX, curY, gameFont, fontSize )			
				else
					tmp = display.newText( group, word, curX, curY, gameFont, fontSize )			
				end
				tmp.anchorX = 0
				tmp.anchorY = 0
			else
				if( false ) then
					tmp = display.newText( group, "|"..word[1].."|", curX, curY, gameFont, fontSize )			
				else
					tmp = display.newText( group, word[1], curX, curY, gameFont, fontSize )			
				end
				tmp.anchorX = 0
				tmp.anchorY = 0
			end

			if( type( word ) == "table" ) then
				tmp.target = string.lower(word[2]) 
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
			
			
			if( parse_utils.isPunctuation(words[i]) ) then
				tmp.x = tmp.x + punctOffset
			end

			-- Adjust to new X position
			curX = tmp.x + tmp.contentWidth + xSep
		end
	end
	--table.dump(words)

	post("didEnterPage", { target = parse_utils.__curPage } )

	return group
end


return parse_utils