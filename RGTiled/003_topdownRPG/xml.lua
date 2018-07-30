--====================================================================--
-- Module: xml
--====================================================================--

local M = {}
 
-- From: http://developer.anscamobile.com/code/much-improved-dump-function-and-xml-simplify 
 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--
-- xml.lua - XML parser for use with the Corona SDK.
--
-- version: 1.1
--
-- CHANGELOG:
--
-- 1.1 - Fixed base directory issue with the loadFile() function.
--
-- NOTE: This is a modified version of Alexander Makeev's Lua-only XML parser
-- found here: http://lua-users.org/wiki/LuaXml
--
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
 
function M.newParser()
 
    XmlParser = {};
 
 	function XmlParser:ToXmlString(value)
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

	function XmlParser:FromXmlString(value)
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

 
    function XmlParser:ParseArgs(s)
        local arg = {}
        string.gsub(s, "(%w+)=([\"'])(.-)%2", 
            function (w, _, a)
                arg[w] = self:FromXmlString(a);
            end)
        return arg
    end
 
    function XmlParser:ParseXmlText(xmlText)
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
                top.value=(top.value or "")..self:FromXmlString(text);
            end
            if empty == "/" then  -- empty element tag
                table.insert(top.child, {name=label,value=nil,properties=self:ParseArgs(xarg),child={}})
            elseif c == "" then   -- start tag
                top = {name=label, value=nil, properties=self:ParseArgs(xarg), child={}}
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
            stack[#stack].value=(stack[#stack].value or "")..self:FromXmlString(text);
        end
        if #stack > 1 then
            error("XmlParser: unclosed "..stack[stack.n].name)
        end
        return stack[1].child[1];
    end
 
    function XmlParser:saveFile(xmlFilename, base, rootElementName, xmltbl)
        if not base then
            base = system.TemporaryDirectory
        end

        local path = system.pathForFile( xmlFilename, base )
        local hFile, err = io.open(path, "w")

        if hFile and not err then
            hFile:write(XmlParser:toXml(rootElementName, xmltbl))
            io.close(hFile)
            return true
        else
            print( err )
            return false
        end
    end
 
    function XmlParser:loadFile(xmlFilename, base)
        if not base then
            base = system.ResourceDirectory
        end

        local path = system.pathForFile( xmlFilename, base )
        local hFile, err = io.open(path,"r")

        if hFile and not err then
            local xmlText=hFile:read("*a"); -- read file content
            io.close(hFile);
            return self:ParseXmlText(xmlText),nil;
        else
            print( err )
            return nil
        end
    end
 
    function XmlParser:toXml(wrapElementName, xmltbl)
        local function getXml(xmltbl, indent)
            -- collect tag properties
            local props = ''
            for k, v in pairs(xmltbl.properties) do
                if (k ~= 'value' and type(v) ~= 'function') then
                    props = props .. ' ' .. k .. '="' .. v .. '"'
                end
            end
            -- build element
            if (xmltbl.value ~= nil) then
                -- open with body content
                return indent .. '<' .. xmltbl.name .. props .. '>'
                    .. tostring(xmltbl.value)
                    .. '</' .. xmltbl.name .. '>'
            elseif (#xmltbl.child > 0) then
                -- open element with content
                local str = ''
                for i=1, #xmltbl.child do
                    if (type(xmltbl.child[i]) ~= 'function') then
                        str = str .. '\n' .. getXml(xmltbl.child[i], '   '..indent)
                    end
                end
                return indent .. '<' .. tostring(xmltbl.name) .. props .. '>'
                    .. str
                    .. '\n' .. indent .. '</' .. tostring(xmltbl.name) .. '>'
            else
                -- self terminating
                if (props == '') then
                    return indent .. '</' .. xmltbl.name .. '>'
                else
                    return indent .. '<' .. xmltbl.name .. props .. ' />'
                end
            end
        end

        return getXml(xmltbl, '')
    end
 
    function XmlParser:simplify( xml, tbl, indent )
        if (indent == nil) then indent = ''; else indent = indent .. '   '; end
        if (tbl == nil) then tbl = {}; end

        print(indent .. xml.name)
        for k, v in pairs(xml.properties) do
            print(indent .. '   .' .. k .. ' = ' .. v)
            tbl[k] = v
        end

        if (xml.value ~= nil) then
            print(indent .. '   "' .. xml.value .. '"')
            tbl.value = xml.value
        end

        if (#xml.child > 0) then print(indent..'{'); end
        for i=1, #xml.child do
            local name = xml.child[i].name
            local t = tbl[name]
            if (t == nil) then
                -- element name not seen yet
                tbl[name] = XmlParser:simplify( xml.child[i], nil, indent )
            elseif (#t == 0) then
                -- second sighting of element name, convert into table
                print(indent .. '   ,')
                t = { t }
                tbl[name] = t
                t[2] = XmlParser:simplify( xml.child[i], nil, indent )
            else
                -- numerous sighting of element name, add to table
                print(indent .. '   ,')
                t[#t+1] = XmlParser:simplify( xml.child[i], nil, indent )
            end
        end
        if (#xml.child > 0) then print(indent..'}'); end
        
        function tablelength(T)
            local count = 0
            for _ in pairs(T) do count = count + 1 end
            return count
        end

        local tblAttrCnt = tablelength(tbl)
        if tblAttrCnt == 0 then
            -- If an entity has no attributes/values, make it a "false" value instead of an empty table
            tbl = false
        elseif tbl.value and tblAttrCnt == 1 then
            -- If an entity has only a value, then make that the value of the entity (instead of a .value attribute)               
            tbl = tbl.value
        end

        return tbl
    end
 
    function XmlParser:desimplify( name, tbl, indent )
        if (not indent) then indent = ''; end
        local t = { name=name, properties={}, child={} }

        if (#tbl == 0) then
            for k, v in pairs(tbl) do
                if (type(v) == 'table') then
                    if (#v == 0) then
                        t.child[ #t.child+1 ] = XmlParser:desimplify(k, v, indent..'   ')
                    else
                        for i=1, #v do
                            t.child[ #t.child+1 ] = XmlParser:desimplify(k, v[i], indent..'   ')
                        end
                    end
                else
                    if (k == 'value') then
                        t.value = v
                    else
                        t.properties[k] = v
                    end
                end
            end
        end

        return t
    end

    return XmlParser
end

return M