
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
-- =============================================================
-- RG Files Module Library - Loader and Initializer
-- =============================================================
--                         License
-- =============================================================
--[[
   > SSK is free to use.
   > SSK is free to edit.
   > SSK is free to use in a free or commercial game.
   > SSK is free to use in a free or commercial non-game app.
   > SSK is free to use without crediting the author (credits are still appreciated).
   > SSK is free to use without crediting the project (credits are still appreciated).
   > SSK is NOT free to sell for anything.
   > SSK is NOT free to credit yourself with.
]]
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


