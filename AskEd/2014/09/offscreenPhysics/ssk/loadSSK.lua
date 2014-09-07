-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Reduced Version of SSK
-- =============================================================
-- =============================================================
-- ==
-- TheSSKCorona super object; Most libraries will be attached to this.
-- ==
require "ssk.RGGlobals"
require "ssk.RGExtensions"

require "ssk.RGAndroidButtons" -- Conflicts with CoronaViewer
require "ssk.RGCamera"
require "ssk.RGCC"
require "ssk.RGDisplay"
require "ssk.RGEasyInterfaces"
require "ssk.RGEasyKeys"
require "ssk.RGEasyPush"
require "ssk.RGMath2D"
require "ssk.RGAutoLocalization"

require "ssk.fixes.finalize"


ssk.getVersion = function() return "Reduced Version: 07 SEP 2014" end
