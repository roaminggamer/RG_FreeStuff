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

local systemTemporary = {}

--
-- Get path to systemTemporary root.
--
function systemTemporary.getRoot()
   return RGFiles.temporaryRoot
end
--
-- Create full systemTemporary path.
--
function systemTemporary.getPath( path )
	local fullPath = RGFiles.temporaryRoot .. path
	fullPath = RGFiles.util.repairPath( fullPath )
	return fullPath
end

-- =============================================================
-- =============================================================
function systemTemporary.attach( module )
	RGFiles = module
	module.temporary = systemTemporary
end
return systemTemporary


