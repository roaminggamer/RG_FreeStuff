
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


