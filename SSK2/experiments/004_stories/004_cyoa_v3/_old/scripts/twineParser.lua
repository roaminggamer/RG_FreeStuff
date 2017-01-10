-- trim implementations

function trim1(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
-- from PiL2 20.4

function trim2(s)
  return s:match "^%s*(.-)%s*$"
end
-- variant of trim1 (match)

function trim3(s)
  return s:gsub("^%s+", ""):gsub("%s+$", "")
end
-- two gsub's

function trim4(s)
  return s:match"^%s*(.*)":match"(.-)%s*$"
end
-- variant of trim3 (match)

--local function


local function readTwine( fileName )

	local twineData = io.readFileTable( fileName, system.ResourceDirectory)

	-- Remove empty lines and clean odd characters off first line
	--
	local twineData2 = {}
	for i = 1, #twineData do
		local newRoom = string.find( twineData[i], "::" )
		local curLine = twineData[i]		
		if( newRoom ~= nil ) then
			curLine = string.sub( curLine, newRoom, curLine:len() )
		end
		if(curLine:len() > 0 ) then 			
			twineData2[#twineData2+1] = curLine
		end
	end
	twineData = twineData2
	--table.dumpu(twineData)


	-- Parse Room Data
	local roomName 
	local roomTitle
	local tags


	for i = 1, #twineData do
		local newRoom = string.find( twineData[i], "::" ) ~= nil
		local curLine = twineData[i]
		
		if( newRoom ) then
			print "NEW ROOM"
		end

		print( curLine )
	end

	local tmp = twineData[1]
end


public = {}

public.readTwine = readTwine

return public