-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- string.* - Extension(s)
-- =============================================================

local strLen = string.len

function string.truncate( str, maxLen, appendMe )
  if not str then return "" end
  appendMe = appendMe or ""
  local out = str
  maxLen = maxLen
  if(out:len() > maxLen) then
    out = out:sub(1,maxLen-appendMe:len()) .. appendMe
  end
  return out
end


-- ==
--    string:split( tok ) - Splits token (tok) separated string into integer indexed table.
-- ==
function string:split(tok)
	local str = self
	local t = {}  -- NOTE: use {n = 0} in Lua-5.0
	local ftok = "(.-)" .. tok
	local last_end = 1
	local s, e, cap = str:find(ftok, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(ftok, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	return t
end


-- ==
--    string:merge( t ) - Merge all entries in an indexed table into a string.
-- ==
function string.merge(t)
	local tmp = ""
	for i = 1, #t do
		tmp = tmp .. tostring( t[i] )
	end
	return tmp
end


-- ==
--    string:getWord( index ) - Gets indexed word from string, where words are separated by a single space (' ').
-- ==
function string:getWord( index )
	local index = index or 1
	local aTable = self:split(" ")
	return aTable[index]
end

-- ==
--    string:getWordCount( ) - Counts words in a string, where words are separated by a single space (' ').
-- ==
function string:getWordCount( )
	local aTable = self:split(" ")
	return #aTable
end

-- ==
--    Words are separated by a single space (' ') - Gets indexed words from string, starting at index and ending at endindex or end of line if not specified.  
-- ==
function string:getWords( index, endindex )
	local index = index or 1
	local offset = index - 1
	local aTable = self:split(" ")
	local endindex = endindex or #aTable

	if(endindex > #aTable) then
		endindex = #aTable
	end

	local tmpTable = {}

	for i = index, endindex do
		tmpTable[i-offset] = aTable[i]
	end

	local tmpString = table.concat(tmpTable, " ")

	return tmpString
end

-- ==
--    string:setWord( index , replace ) - Replaces indexed word in string with replace, where words are separated by a single space (' ').
-- ==
function string:setWord( index, replace )
	local index = index or 1
	local aTable = self:split(" ")
	aTable[index] = replace
	local tmpString = table.concat(aTable, " ")
	return tmpString
end


-- ==
--    string:getField( index ) - Gets indexed field from string, where fields are separated by a single TAB ('\t').
-- ==
function string:getField( index )
	local index = index or 1
	local aTable = self:split("\t")
	return aTable[index]
end

-- ==
--    string:getFieldCount( ) - Counts fields in a string, where fields are separated by a single TAB ('\t').
-- ==
function string:getFieldCount( )
	local aTable = self:split("\t")
	return #aTable
end

-- ==
--    string:getFields( index [, endIndex ] ) - Gets indexed fields from string, starting at index and ending at endindex or end of line if not specified.  
-- ==
function string:getFields( index, endindex )
	local index = index or 1
	local offset = index - 1
	local aTable = self:split("\t")
	local endindex = endindex or #aTable

	if(endindex > #aTable) then
		endindex = #aTable
	end

	local tmpTable = {}

	for i = index, endindex do
		tmpTable[i-offset] = aTable[i]
	end

	local tmpString = table.concat(tmpTable, "\t")

	return tmpString
end

-- ==
--    string:setField( index , replace ) - Replaces indexed field in string with replace, where fields are separated by a single TAB ('\t').
-- ==
function string:setField( index, replace )
	local index = index or 1
	local aTable = self:split("\t")
	aTable[index] = replace
	local tmpString = table.concat(aTable, "\t")
	return tmpString
end

-- ==
--    string:getRecord( index ) - Gets indexed record from string, where records are separated by a single NEWLINE ('\n').
-- ==
function string:getRecord( index )
	local index = index or 1
	local aTable = self:split("\n")
	return aTable[index]
end

-- ==
--    string:getRecordCount( ) - Counts records in a string, where records are separated by a single NEWLINE ('\n').
-- ==
function string:getRecordCount( )
	local aTable = self:split("\n")
	return #aTable
end

-- ==
--    string:getRecords( index [, endIndex ] ) - Gets indexed records from string, starting at index and ending at endindex or end of line if not specified.  
-- ==
function string:getRecords( index, endindex )
	local index = index or 1
	local offset = index - 1
	local aTable = self:split("\n")
	local endindex = endindex or #aTable

	if(endindex > #aTable) then
		endindex = #aTable
	end

	local tmpTable = {}

	for i = index, endindex do
		tmpTable[i-offset] = aTable[i]
	end

	local tmpString = table.concat(tmpTable, "\n")

	return tmpString
end

-- ==
--    string:setRecord( index , replace ) - Replaces indexed record in string with replace, where records are separated by a single NEWLINE ('\n').
-- ==
function string:setRecord( index, replace )
	local index = index or 1
	local aTable = self:split("\n")
	aTable[index] = replace
	local tmpString = table.concat(aTable, "\n")
	return tmpString
end

-- ==
--    string:spaces2underbars( ) - Replaces all instances of spaces with underbars.
-- ==
function string:spaces2underbars( )
	return self:gsub( "%s", "_" )
end

-- ==
--    string:underbars2spaces( ) - Replaces all instances of underbars with spaces.
-- ==
function string:underbars2spaces( )
	return self:gsub( "_", " " )
end

-- ==
--    string:printf( ... ) - Replicates C-language printf().
-- ==
function string:printf(...)
	return io.write(self:format(...))
end -- function

-- ==
--    string:lpad( len, char ) - Places padding on left side of a string, such that the new string is at least len characters long.
-- ==
function string:lpad (len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return string.rep(char, len - #theStr) .. theStr
end

-- ==
--    string:rpad( len, char ) - Places padding on right side of a string, such that the new string is at least len characters long.
-- ==
function string:rpad(len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
end

-- ==
--    Sergey Stuff - Nice bits from Sergey's code: https://gist.github.com/Lerg
-- ==
function string.trim(s)
    local from = s:match"^%s*()"
    return from > #s and "" or s:match(".*%S", from)
end

-- Note: Retaining case till release 2017.008 or later
--    startsWith( s, piece ) 
function string.startswith(s, piece)
    return string.sub(s, 1, strLen(piece)) == piece
end
string.startsWith = string.startswith

-- Note: Retaining case till release 2017.008 or later
--    endsWith( s, piece )
function string.endswith(s, send)
    return #s >= #send and s:find(send, #s-#send+1, true) and true or false
end
string.endsWith = string.endswith

string.url_encode = function(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])", function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str  
end

string.url_decode = function( str )
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)", function(h) return string.char( tonumber(h,16) ) end )
  str = string.gsub (str, "\r\n", "\n")
  return str
end
 
string.clean = function( str, debugEn )
   local s = ""
   for i = 1, str:len() do
      if str:byte(i) >= 32 and str:byte(i) <= 126 then
         s = s .. str:sub(i,i)
		elseif( str:byte(i) == 133 ) then -- Elipses
			s = s .. '...'
		elseif( str:byte(i) == 146 ) then -- Single-quote
			s = s .. "'"
		elseif( str:byte(i) == 147 ) then -- Left double-quote
			s = s .. '"'
		elseif( str:byte(i) == 148 ) then -- Right double-quote
			s = s .. '"'
		elseif( debugEn ) then
			print( str:sub(i,i), str:byte(i), str ) 
      end
   end
   return s
end

string.strip_Control_and_Extended_Codes = function( str )
   local s = ""
   for i = 1, str:len() do
      if str:byte(i) >= 32 and str:byte(i) <= 126 then
         s = s .. str:sub(i,i)
      end
   end
   return s
end

-- Replaced with truncate
--[[
string.shorten = function( text, maxLen, appendMe )
  if not text then return "" end
  --print( text, maxLen, appendMe )
  appendMe = appendMe or ""
  local outText = text
  if(outText:len() > maxLen) then
    outText = outText:sub(1,maxLen) .. appendMe
  end
  return outText
end
--]]

-- ==
--    comma_value(val, n) - Converts a number to a comma separated string. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to convert to comma separated string.
-- ==
function string.comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

-- ==
--    first_upper() - Make first (and only first) letter of string.uppercase
-- ==
function string.first_upper(str)
	return str:gsub("^%l", string.upper)
end


-- ==
--    containsToken() - EFM
-- ==
function string.containsToken( line, token )
	line = string.lower(line or "")
	token = string.lower(token or "")
	return string.match( line, token ) ~= nil
end

-- ==
--    getParts() - EFM
-- ==
function string.getParts( line, startAt )
	local parts = string.split( line, " " )
	startAt = tonumber(startAt)
	if(startAt) then
		local parts2 = {}
		for i = startAt, #parts do
			parts2[#parts2+1] = parts[i]
		end
		return parts2
	end
	return parts
end

-- ==
--    extractRemainder() - EFM
-- ==
function string.extractRemainder( line, startAt )
	startAt = startAt or 2
	local parts = string.split( line, " " )
	local remainder = ""
	for i = startAt, #parts do
		remainder = remainder .. " " .. parts[i]
	end
	remainder = string.trim( remainder )
	return remainder
end

-- ==
--    extractPairs() - EFM
-- ==
function string.extractPairs( line, startAt )
	startAt = startAt or 2
	local parts = string.split( line, " " )
	local pairsTable = {}
	for i = startAt, #parts, 2 do
		local k = parts[i]
		local v = parts[i+1]
		if( v == "true" ) then
			v = true
		elseif( v == "false" ) then
			v = false
		elseif( tonumber(v) ) then 
			v = tonumber(v)
		end
		pairsTable[k] = v	
	end
	return pairsTable
end





