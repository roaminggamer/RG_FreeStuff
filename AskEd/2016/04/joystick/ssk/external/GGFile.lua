-- Project: GGFile
--
-- Date: December 21, 2012
--
-- File name: GGFile.lua
--
-- Author: Graham Ranson of Glitch Games - www.glitchgames.co.uk
--
-- Comments: 
-- 
--		GGFile makes it easy to work with files and directories.	
--
-- Copyright (C) 2012 Graham Ranson, Glitch Games Ltd.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge, 
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or 
-- substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
----------------------------------------------------------------------------------------------------

local GGFile = {}
local GGFile_mt = { __index = GGFile }

local lfs = require( "lfs" )

GGFile.Attribute = {}
GGFile.Attribute.Dev = "dev"
GGFile.Attribute.Inode = "ino"
GGFile.Attribute.Mode = "mode"
GGFile.Attribute.HardLinks = "nlink"
GGFile.Attribute.UID = "uid"
GGFile.Attribute.GID = "gid"
GGFile.Attribute.RDev = "rdev"
GGFile.Attribute.LastAccess = "access"
GGFile.Attribute.LastModification = "modification"
GGFile.Attribute.LastChange = "change"
GGFile.Attribute.Size = "size"
GGFile.Attribute.Blocks = "blocks"
GGFile.Attribute.BlockSize = "blksize"
GGFile.Attribute.Permissions = "permissions"

--- Initiates a new GGFile object.
-- @return The new object.
function GGFile:new()
    
    local self = {}
    
    setmetatable( self, GGFile_mt )

    return self
    
end

--- Reads data from a file.
-- @param path The path to the file.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return The read in content.
function GGFile:read( path, baseDir )
	
	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )
	
	local file = io.open( path, "r" )
	
	if file then
		local data = file:read( "*a" )
		io.close( file )
		return data
	end
	
end

--- Reads data from a file.
-- @param path The path to the file.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return The read in content.
function GGFile:readBinary( path, baseDir )
	
	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )
	
	local file = io.open( path, "rb" )
	
	if file then
		local data = file:read( "*all" )
		io.close( file )
		--data = string.gsub(data, "\r\n", "\n")
		return data
	end
	
end


--- Retrieves the lines from a file and returns them in a list.
-- @param path The path to the file.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return A list of lines read in.
function GGFile:readLines( path, baseDir )
	
	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )
	
	local file = io.open( path, "r" )
	
	if file then
	
		local lines = {}

		for line in file:lines() do
			lines[ #lines + 1 ] = line
		end
	
		io.close( file )
		
		return lines
	
	end
	
end

--- Writes data to a file.
-- @param path The path to the file.
-- @param data The date to write.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
function GGFile:write( path, data, baseDir )
	
	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )
	
	local file = io.open( path, "w" )
	
	if file then
		file:write( data )
		io.close( file )
		file = nil
	end
	
end


--- Writes data to a file.
-- @param path The path to the file.
-- @param data The date to write.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
function GGFile:writeBinary( path, data, baseDir )
	
	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )
	
	local file = io.open( path, "wb" )
	
	if file then
		file:write( data )
		io.close( file )
		file = nil
	end
	
end


--- Appends data to a file.
-- @param path The path to the file.
-- @param data The date to write.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
function GGFile:append( path, data, baseDir )
	
	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )
	
	local file = io.open( path, "a" )
	
	if file then
		file:write( data )
		io.close( file )
		file = nil
	end
	
end

--- Deletes a file.
-- @param path The path to the file.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return True if it was removed or nil and a reason if not.
function GGFile:delete( path, baseDir )
	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )
	return os.remove( path )
end

--- Copies a file.
-- @param sourcePath The path to the source file.
-- @param sourceBaseDir The base directory for the source path, optional and defaults to system.DocumentsDirectory.
-- @param destinationPath The path to the destination file.
-- @param destinationBaseDir The base directory for the destination path, optional and defaults to system.DocumentsDirectory.
function GGFile:copy( sourcePath, sourceBaseDir, destinationPath, destinationBaseDir )
	local data = self:read( sourcePath, sourceBaseDir )
	self:write( destinationPath, data, destinationBaseDir )
end


--- Copies a file.
-- @param sourcePath The path to the source file.
-- @param sourceBaseDir The base directory for the source path, optional and defaults to system.DocumentsDirectory.
-- @param destinationPath The path to the destination file.
-- @param destinationBaseDir The base directory for the destination path, optional and defaults to system.DocumentsDirectory.
function GGFile:copyBinary( sourcePath, sourceBaseDir, destinationPath, destinationBaseDir )
	local data = self:readBinary( sourcePath, sourceBaseDir )
	self:writeBinary( destinationPath, data, destinationBaseDir )
end


--- Moves a file.
-- @param sourcePath The path to the source file.
-- @param sourceBaseDir The base directory for the source path, optional and defaults to system.DocumentsDirectory.
-- @param destinationPath The path to the destination file.
-- @param destinationBaseDir The base directory for the destination path, optional and defaults to system.DocumentsDirectory.
function GGFile:move( sourcePath, sourceBaseDir, destinationPath, destinationBaseDir )
	self:copy( sourcePath, sourceBaseDir, destinationPath, destinationBaseDir )
	self:delete( sourcePath, sourceBaseDir )
end


--- Moves a file.
-- @param sourcePath The path to the source file.
-- @param sourceBaseDir The base directory for the source path, optional and defaults to system.DocumentsDirectory.
-- @param destinationPath The path to the destination file.
-- @param destinationBaseDir The base directory for the destination path, optional and defaults to system.DocumentsDirectory.
function GGFile:moveBinary( sourcePath, sourceBaseDir, destinationPath, destinationBaseDir )
	self:copyBinary( sourcePath, sourceBaseDir, destinationPath, destinationBaseDir )
	self:delete( sourcePath, sourceBaseDir )
end


--- Renames a file.
-- @param path The path to the file.
-- @param newName The new name for the file.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return True if it was renamed or nil and a reason if not.
function GGFile:rename( path, newName, baseDir )
	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )
	newName = system.pathForFile( newName, baseDir or system.DocumentsDirectory )
	return os.rename( path, newName )
end

--- Checks if a file exists.
-- @param path The path to the file.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return True if it exists, false otherwise.
function GGFile:exists( path, baseDir )
	local mode = self:getAttributes( path, GGFile.Attribute.Mode, baseDir )
	return mode == "file" or mode == "directory"
end

--- Checks if a file is a directory.
-- @param path The path to the file.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return True if the file is a directory and false if it isn't or if it doesn't exist.
function GGFile:isDirectory( path, baseDir )
	return self:getAttributes( path, GGFile.Attribute.Mode, baseDir ) == "directory"
end

--- Returns a list of all files in a directory.
-- @param path The path to the directory.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return A list of all found files, empty if none found.
function GGFile:getFilesInDirectory( path, baseDir )

	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )

	if path then
		
		local files = {}
		
		for file in lfs.dir( path ) do
		
			if file ~= "." and file ~= ".." and file ~= ".DS_Store" then
				files[ #files + 1 ] = file
			end
			
		end

		return files
		
	end
	
end

--- Create a new directory.
-- @param path The path to the parent directory.
-- @param newDirectory The name/path of the new directory.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return True if successful and false ( or nil ) otherwise as well as a reason.
function GGFile:makeDirectory( path, newDirectory, baseDir )

	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )

	if lfs.chdir( path ) then
		local success, reason = lfs.mkdir( newDirectory )
		return success, reason
	end

	return false, "Parent directory doesn't exist."
	
end

--- Removes an existing directory.
-- @param path The path to the directory.
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return True if successful and false ( or nil ) otherwise as well as a reason.
function GGFile:removeDirectory( path, baseDir )

	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )

	return lfs.rmdir( path )
	
end

--- Gets attributes of a file.
-- @param path The path to the file.
-- @param attribute The attribute to check for, optional. Can be any value from GGFile.Attribute. See this page for explanations - http://keplerproject.github.com/luafilesystem/manual.html#reference
-- @param baseDir The base directory for the path, optional and defaults to system.DocumentsDirectory.
-- @return A list of attributes or a single value if a specific attribute is asked for.
function GGFile:getAttributes( path, attribute, baseDir )

	path = system.pathForFile( path, baseDir or system.DocumentsDirectory )
	
	if not path then
		return nil
	end
	
	return lfs.attributes( path, attribute )
	
end

--- Destroys this GGFile object.
function GGFile:destroy()

end

return GGFile
