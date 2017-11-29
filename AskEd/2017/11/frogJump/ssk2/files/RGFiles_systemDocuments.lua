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

local systemDocuments = {}

--
-- Get path to systemDocuments root.
--
function systemDocuments.getRoot()
   return RGFiles.documentsRoot
end
--
-- Create full systemDocuments path.
--
function systemDocuments.getPath( path )
	local fullPath = RGFiles.documentsRoot .. path
	fullPath = RGFiles.util.repairPath( fullPath )
	return fullPath
end

-- =============================================================
-- =============================================================
function systemDocuments.attach( module )
	RGFiles = module
	module.documents = systemDocuments
end
return systemDocuments


