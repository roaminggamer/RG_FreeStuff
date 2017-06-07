local M = {}
local json = require("json")
local _defaultLocation = system.DocumentsDirectory
local _realDefaultLocation = _defaultLocation
local _validLocations = {
   [system.DocumentsDirectory] = true,
   [system.CachesDirectory] = true,
   [system.TemporaryDirectory] = true
}

function M.saveTable(t, filename, location)
    if location and (not _validLocations[location]) then
     error("Attempted to save a table to an invalid location", 2)
    elseif not location then
      location = _defaultLocation
    end
    
    local path = system.pathForFile( filename, location)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end
 
function M.loadTable(filename, location)
    if location and (not _validLocations[location]) then
     error("Attempted to load a table from an invalid location", 2)
    elseif not location then
      location = _defaultLocation
    end
    local path = system.pathForFile( filename, location)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        myTable = json.decode(contents);
        io.close( file )
        return myTable
    end
    return nil
end

function M.changeDefault(location)
	if location and (not location) then
		error("Attempted to change the default location to an invalid location", 2)
	elseif not location then
		location = _realDefaultLocation
	end
	_defaultLocation = location
	return true
end

function M.print_r ( t ) 
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

M.printTable = M.print_r

return M