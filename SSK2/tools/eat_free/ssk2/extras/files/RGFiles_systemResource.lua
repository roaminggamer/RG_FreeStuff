-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local lfs         = require "lfs"
local json        = require "json"

local strGSub     = string.gsub
local strSub      = string.sub
local strFormat   = string.format
local strFind     = string.find

local pathSep =  "/"

local RGFiles

local systemResource = {}

--
-- Get path to systemResource root.
--
function systemResource.getRoot()
   return RGFiles.resourceRoot
end
--
-- Create full systemResource path.
--
function systemResource.getPath( path )
	local fullPath = RGFiles.resourceRoot .. path
	fullPath = RGFiles.util.repairPath( fullPath )
	return fullPath
end

function systemResource.getPath( path )
	local fullPath
	if( _G.onAndroid ) then
		fullPath = path
	else
		fullPath = RGFiles.resourceRoot .. path
	end
	fullPath = RGFiles.util.repairPath( fullPath )
	return fullPath
end



-- =============================================================
-- =============================================================
function systemResource.attach( module )
	RGFiles = module
	module.resource = systemResource
end
return systemResource


