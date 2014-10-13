-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- SSKCorona Loader 
-- =============================================================
-- =============================================================

-- ==
-- TheSSKCorona super object; Most libraries will be attached to this.
-- ==
require "ssk.RGGlobals"
require "ssk.RGExtensions"

require "ssk.RGAndroidButtons" -- Conflicts with CoronaViewer
require "ssk.RGCC"
require "ssk.RGDisplay"
require "ssk.RGEasyInterfaces"
require "ssk.RGEasyKeys"
require "ssk.RGEasyPush"
require "ssk.RGInputs"
require "ssk.RGMath2D"

require "ssk.presets.bluegel.presets"
require "ssk.presets.gel.presets"
require "ssk.presets.superpack.presets"

-- Modified version of GlitchGames' GGFile
ssk.GGFile = require( "ssk.external.GGFile" )

-- Modified version of Bjorn's OOP-ing code
ssk.object = require "ssk.external.object"

require "ssk.fixes.finalize"

ssk.randomlua = require "ssk.external.randomlua"

ssk.getVersion = function() return "MODIFIED FOR EXAMPLE" end
