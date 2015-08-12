-- =============================================================
-- pngLib (Credits to Danny @ anscamobile.com and David Manura)
-- =============================================================
-- Derived from code supplied by Danny @ anscamobile.com, which was in turn 
-- based on code by David Manura. Licensed under the same terms as Lua (MIT license).
-- Downloaded from this link: http://www.infuseddreams.com/apps/pngLib.zip
-- Found in this thread: http://developer.coronalabs.com/forum/2012/05/16/pnglib-extract-data-png-files-width-height-color-depth-etc
-- =============================================================
--
-- =============================================================

local pngLib = {}

-- Unpack 32-bit unsigned integer (most-significant-byte, MSB, first)
-- from byte string.
local function unpackMsbUint32(s)
 	local a,b,c,d = s:byte(1,#s)
  	local num = (((a*256) + b) * 256 + c) * 256 + d
	return num
end

-- Read 32-bit unsigned integer (most-significant-byte, MSB, first) from file.
local function readMsbUint32(fh)
	return unpackMsbUint32(fh:read(4))
end

-- Read unsigned byte (integer) from file
local function readByte(fh)
  	return fh:read(1):byte()
end

function pngLib.getPngInfo(fh, path)
	local filePath = path or nil
	local theFile = nil
	
	if filePath == nil then
		theFile = system.pathForFile(fh, system.ResourceDirectory)
	else
		theFile = system.pathForFile(fh, path)
	end
	
	local fileHandle = assert(io.open(theFile, 'rb'))
	
  	local self = {}
  	
  	local fileHeader = fileHandle:read(4)
	 assert(fileHeader == string.char(137).."PNG", "pngLib only works on PNG files")
  
	while 1 do
	  	local stype = fileHandle:read(4)
	  	
		if stype == 'IHDR' then
		  	self.width = readMsbUint32(fileHandle)
			self.height = readMsbUint32(fileHandle)
			self.bitDepth = readByte(fileHandle)
			self.colorType = readByte(fileHandle)
			self.filterMethod = readByte(fileHandle)
			self.interlaceMethod = readByte(fileHandle)
			
			assert( stype ~= nil, "Reached EOF without finding PNG IHDR chunk" )
		 
		 	--close the file
  			io.close(fileHandle)
  			fileHandle = nil
		 
		 	return self
	  	end
  	end
  	
  	
end

return pngLib
