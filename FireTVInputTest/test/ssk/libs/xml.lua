-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- xml.lua - XML parser for use with the Corona SDK.
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================
--
-- version: 1.1 (modified to sit under ssk)
--
-- CHANGELOG:
--
-- 1.1 - Fixed base directory issue with the loadFile() function.
--
-- NOTE: This is a modified version of Alexander Makeev's Lua-only XML parser
-- found here: http://lua-users.org/wiki/LuaXml
--
-- =============================================================

local xml
if( not _G.ssk.xml ) then
	_G.ssk.xml = {}
end
xml = _G.ssk.xml


function _G.ssk.xml.new()

	XmlParser = {};
	
	function XmlParser:toXMLString(value)
		value = string.gsub (value, "&", "&amp;");		-- '&' -> "&amp;"
		value = string.gsub (value, "<", "&lt;");		-- '<' -> "&lt;"
		value = string.gsub (value, ">", "&gt;");		-- '>' -> "&gt;"
		value = string.gsub (value, "\"", "&quot;");	-- '"' -> "&quot;"
		value = string.gsub(value, "([^%w%&%;%p%\t% ])",
			function (c) 
				return string.format("&#x%X;", string.byte(c)) 
			end);
		return value;
	end
	
	function XmlParser:fromXMLString(value)
		value = string.gsub(value, "&#x([%x]+)%;",
			function(h) 
				return string.char(tonumber(h,16)) 
			end);
		value = string.gsub(value, "&#([0-9]+)%;",
			function(h) 
				return string.char(tonumber(h,10)) 
			end);
		value = string.gsub (value, "&quot;", "\"");
		value = string.gsub (value, "&apos;", "'");
		value = string.gsub (value, "&gt;", ">");
		value = string.gsub (value, "&lt;", "<");
		value = string.gsub (value, "&amp;", "&");
		return value;
	end
	   
	function XmlParser:parseArgs(s)
	  local arg = {}
	  string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
			arg[w] = self:fromXMLString(a);
		end)
	  return arg
	end
	
	function XmlParser:parseXMLTest(xmlText)
	  local stack = {}
	  local top = {name=nil,value=nil,properties={},child={}}
	  table.insert(stack, top)
	  local ni,c,label,xarg, empty
	  local i, j = 1, 1
	  while true do
		ni,j,c,label,xarg, empty = string.find(xmlText, "<(%/?)([%w:]+)(.-)(%/?)>", i)
		if not ni then break end
		local text = string.sub(xmlText, i, ni-1);
		if not string.find(text, "^%s*$") then
		  top.value=(top.value or "")..self:fromXMLString(text);
		end
		if empty == "/" then  -- empty element tag
		  table.insert(top.child, {name=label,value=nil,properties=self:parseArgs(xarg),child={}})
		elseif c == "" then   -- start tag
		  top = {name=label, value=nil, properties=self:parseArgs(xarg), child={}}
		  table.insert(stack, top)   -- new level
		else  -- end tag
		  local toclose = table.remove(stack)  -- remove top
		  top = stack[#stack]
		  if #stack < 1 then
			error("XmlParser: nothing to close with "..label)
		  end
		  if toclose.name ~= label then
			error("XmlParser: trying to close "..toclose.name.." with "..label)
		  end
		  table.insert(top.child, toclose)
		end
		i = j+1
	  end
	  local text = string.sub(xmlText, i);
	  if not string.find(text, "^%s*$") then
		  stack[#stack].value=(stack[#stack].value or "")..self:fromXMLString(text);
	  end
	  if #stack > 1 then
		error("XmlParser: unclosed "..stack[stack.n].name)
	  end
	  return stack[1].child[1];
	end
	
	function XmlParser:loadFile(xmlFilename, base)
		if not base then
			base = system.ResourceDirectory
		end
			
		local path = system.pathForFile( xmlFilename, base )
		local hFile, err = io.open(path,"r");
		
		if hFile and not err then
			local xmlText=hFile:read("*a"); -- read file content
			io.close(hFile);
			return self:parseXMLTest(xmlText),nil;
		else
			print( err )
			return nil
		end
	end
	
	return XmlParser
end
