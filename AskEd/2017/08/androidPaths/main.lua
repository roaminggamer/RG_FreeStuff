-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
-- =============================================================

local logger = require "logger"

local files = ssk.files

--local root = ssk.files.desktop.getDrivePath( "c:/" )
local root = ssk.files.desktop.getDrivePath( "/" )

local rootFiles = files.util.getFilesInFolder( root )

if( #rootFiles == 0 ) then
	rootFiles = { "No Files Found" }
end
logger.showCurrentLogs( rootFiles )
