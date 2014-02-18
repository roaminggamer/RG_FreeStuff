-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Game Logic Modules
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

local action

if( not _G.ssk.action ) then
	_G.ssk.action = {}
end

action = _G.ssk.action

local fnn = fnn
local angle2Vector = ssk.math2d.angle2Vector
local vector2Angle = ssk.math2d.vector2Angle
local scaleVector  = ssk.math2d.scale


-- ===============================================
-- ==           FOLLOW PATH
-- ===============================================
-- dps => degrees per second
function action.pathFollowingattach( obj, points, pathSmoothing, easing )
	obj.myPath = table.deepCopy( points )
	setmetatable(obj.myPath, getmetatable(points) )
end

function action.pathFollowingstart( obj )
end

function action.pathFollowingpause( obj )
end

function action.pathFollowingreset( obj )
end

function action.pathFollowingstop( obj )
end

function action.pathFollowingdetach( obj )
end
