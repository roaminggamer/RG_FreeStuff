
local mlText = require "mltext.mltext"

-- http://lua-users.org/wiki/StringTrim
function _G.strTrim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local strGSub = string.gsub
local strSub = string.sub
local strFind = string.find
local strLen = string.len

local parentGroup

-- stage1Parser() -- Converts twine source into a table ready for further processing.
--
local function stage1Parser( twineSource )

	twineSourceTable = io.readFileTable( twineSource, system.ResourceDirectory )

	local passageTable = {}
	local curPassage

	local foundStart = false

	for i = 1, #twineSourceTable do
		-- Start new passage?
		local isNewPassage = strSub( twineSourceTable[i], 1, 2 ) == "::"
		local isStart = strFind( twineSourceTable[i], ":: Start")
		if( foundStart or isNewPassage and isStart ) then
			foundStart = true
			if(  isNewPassage  ) then
				curPassage = {}
				passageTable[#passageTable+1] = curPassage

				curPassage.name = strSub( twineSourceTable[i], 3 )
				curPassage.name = strTrim( curPassage.name )

				curPassage.content = ""

				--print("New Passage:", curPassage.name)

			-- Add content to current passage
			elseif( curPassage ~= nil ) then
				if(strLen(curPassage.content) == 0 ) then
					curPassage.content = twineSourceTable[i]
				else
					curPassage.content = curPassage.content .. "\n" .. twineSourceTable[i]				
				end

				--print(twineSourceTable[i])
				--print(curPassage.content)

			-- Huh?  Ignore leading junk
			else
				print( " -------------------------------------------------- " )
				print( "Warning!!, line " .. i .. ". Not in passage yet?  Ignoring line"  )
				print( " -------------------------------------------------- " )
				print( twineSourceTable[i] )
				print( " -------------------------------------------------- \n" )
			end
		end
	end

	return passageTable
end

-- stage2Parser() -- Converts stage 1 parsed passage table into table split as follows:
--
-- 1. TEXT   - Plain text segments (may contain ML syntax).
-- 2. CHOICE - A basic choice as defined by a statement like this [[Hallway]]. These get replaced with  statements like this: 
--             <a href = 'Hallway'>Hallway</a>
--
--              Later, if the user presses this text/button, MLText will throw a Runtime Event called 'onChoice' with a paramter called 'choice' set to 'Hallway'.
--              Ex: Runtime:dispatachEvent(  { name = "onChoice", choice = "Hallway" } )
--
--              This gets caugh buy CoronaTwine and causes the passage named 'Hallway' to be loaded.
--
-- 3. CODE - Anything encoded in a pair of '<<' / '>>'  tags gets encoded as CODE as is otherwise ignored.  You can expand this functionality as you desire.
--
-- 4. SPECIAL - Similar to code, but with these tags '{{' / '}}'
--
local function stage2Parser( passageTable )

	local newPassageTable = {}

	-- Step over the passage table and remove the trailing carriage returns added by the twine exporter.
	--
	for i = 1, #passageTable do
		local newPassage = {}
		local name = passageTable[i].name

		newPassageTable[i] = newPassage
		newPassageTable[name] = newPassage

		newPassage.name = name
		local rawContent = passageTable[i].content
		--newPassage.rawContent = rawContent

		local ignoreRest = false

		local j = 1
		local k = 1

		local curToken

		while k <= #rawContent do			
			local curLetters = strSub( rawContent, k, k+1)

			-- Is the next bit a 'choice'?
			if( curLetters == "[[" ) then
			    -- Extract the prior text if any
				if( k > j ) then
					local tmpContent = strSub( rawContent, j, k-1)
					curToken = {}
					curToken.type = "text"					
					curToken.value = tmpContent
					--print("TEXT", "||"..tmpContent.."||")
					newPassage[#newPassage+1] = curToken
				end

				-- Find the end marker for this 'choice'				
				k = k + 2
				j = k
				while k <= #rawContent do
					if( strSub( rawContent, k, k+1) == "]]" ) then
						local tmpContent = strSub( rawContent, j, k-1)
						curToken = {}
						curToken.type = "choice"
						curToken.value = tmpContent
						--print("CHOICE", "||"..tmpContent.."||")
						newPassage[#newPassage+1] = curToken
						k = k + 2
						j = k
						break
					end
					k = k + 1
				end
			end

			-- Is the next bit 'code'?
			if( curLetters == "<<" ) then
			    -- Extract the prior text if any
				if( k > j ) then
					local tmpContent = strSub( rawContent, j, k-1)
					curToken = {}
					curToken.type = "text"					
					curToken.value = tmpContent
					--print("TEXT", "||"..tmpContent.."||")
					newPassage[#newPassage+1] = curToken
				end

				-- Find the end marker for this 'choice'				
				k = k + 2
				j = k
				while k <= #rawContent do
					if( strSub( rawContent, k, k+1) == ">>" ) then
						local tmpContent = strSub( rawContent, j, k-1)
						curToken = {}
						curToken.type = "code"
						curToken.value = tmpContent
						--print("CODE", "||"..tmpContent.."||")
						newPassage[#newPassage+1] = curToken
						k = k + 2
						j = k
						break
					end
					k = k + 1
				end
			end

			-- Is the next bit 'special'?
			if( curLetters == "{{" ) then
			    -- Extract the prior text if any
				if( k > j ) then
					local tmpContent = strSub( rawContent, j, k-1)
					curToken = {}
					curToken.type = "text"					
					curToken.value = tmpContent
					--print("TEXT", "||"..tmpContent.."||")
					newPassage[#newPassage+1] = curToken
				end

				-- Find the end marker for this 'choice'				
				k = k + 2
				j = k
				while k <= #rawContent do
					if( strSub( rawContent, k, k+1) == "}}" ) then
						local tmpContent = strSub( rawContent, j, k-1)
						curToken = {}
						curToken.type = "code"
						curToken.value = tmpContent
						--print("SPECIAL", "||"..tmpContent.."||")
						newPassage[#newPassage+1] = curToken
						k = k + 2
						j = k
						break
					end
					k = k + 1
				end
			end

			k = k + 1
		end
	end


	return newPassageTable
end


-- Convert a passage into Markup Text using MLText
--
local function passage2ML( passage )

	if(not passage) then 
		print("ERROR: Bad Passage?!")
		return "ERROR: Bad Passage?!"
	end

	--local ml =  '<font face = "Arcade" size="44" color="ForestGreen">' .. passage.name .. '</font><br>'
	local ml =  '<font size="24">' .. passage.name .. '</font><br><br>'

	for i = 1, #passage do
		local cur = passage[i]
		--print(cur.value)
		
		if(cur.type == "text") then
			ml = ml .. cur.value

		elseif(cur.type == "choice") then
			ml = ml .. '<a href = "'.. cur.value .. '">' .. cur.value .. '</a>'
		end		
	end

	-- Replace ...
	ml = strGSub(ml,"\n\r","<br>") -- paired \n\r with single <br>
	ml = strGSub(ml,"\n","<br>")   -- Any remaining \n with <br>
	ml = strGSub(ml,"\r","<br>")   -- Any remaining \r with <br>

	--print(ml)
	return ml
end


-- Using the above functions, this function loads a twine story and displays it.
-- 
local function doCoronaTwine( passages, x, y, params )

	table.dump(params)

	local params = params or 
	{
		font = native.DefaultFont,
		fontSize = 14,
		fontColor = { 255, 255, 255 },
		spaceWidth = 2,
		lineHeight = 14,
		linkColor1 = { 0 , 0, 255 },
		linkColor2 = { 255, 0, 255 },
	}

	table.dump(params)


	local lastTextGroup

	local function onChoice(event)
		if(lastTextGroup) then
			lastTextGroup:removeSelf()
			lastTextGroup = nil
		end
		
		local myMLString = passage2ML( passages[event.choice] )
		lastTextGroup = mlText.newMLText( parentGroup, myMLString, x, y, params )
		return true
	end

	Runtime:addEventListener( "onChoice", onChoice )

	local myMLString = passage2ML( passages["Start"] )
	lastTextGroup = mlText.newMLText( parentGroup, myMLString, x, y, params )
end


local public = {}

public.stage1Parser = stage1Parser
public.stage2Parser = stage2Parser

public.run = function( group, twineSource, x, y, params )

	parentGroup = group or display.currentStage

	-- Stage 1 Parse
	local passageTable = stage1Parser( twineSource )
	--table.print_r( passageTable )

	-- Stage 2 Parse
	local passageTable = stage2Parser( passageTable )
	--table.print_r( passageTable )

	doCoronaTwine( passageTable, x, y, params )


end


return public