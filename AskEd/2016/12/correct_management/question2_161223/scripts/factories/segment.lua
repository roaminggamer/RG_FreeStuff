-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Hallway Segment Factory
-- =============================================================
local common 	= require "scripts.common"
local myCC 		= require "scripts.myCC"
local physics 	= require "physics"

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert

-- =============================================================
-- Locals
-- =============================================================
local initialized 	= false
local lastX
local count 			= 1
local hasCeiling 		= true
local hasFloor 		= true
local ceilingPosition	= 0
local floorPosition		= 0
-- =============================================================
-- Forward Declarations
-- =============================================================
local onSegmentTriggered

-- =============================================================
-- Factory Module Begins
-- =============================================================
local factory = {}

-- ==
--    init() - One-time initialization only.
-- ==
function factory.init( params )
	params = params or {}
	if(initialized) then return end

	--
	-- Initialize 'Ceiling & Floor' settings.
	--
	hasCeiling 			= params.hasCeiling or hasCeiling
	hasFloor 			= params.hasFloor or hasFloor
	ceilingPosition	= params.ceilingPosition or top
	floorPosition		= params.floorPosition or bottom

	initialized = true
end

-- ==
--    reset() - Reset any per-game logic/settings.
-- ==
function factory.reset( params )
	lastX 	= nil
	count = 1
end

-- ==
--    new() - Create new instance(s) of this factory's object(s).
-- ==
function factory.new( group, x, y, params )
	params = params or { preTrigger = false, segmentWidth = w/4, debugEn = false }

	-- Catch case where we enter, but group was just removed
	--
	if( not isValid( group ) ) then return end

	--
	-- Ensure there is a params value 'segmentWidth'
	--
	params.segmentWidth = params.segmentWidth or w/4
	
	--
	-- Calculate next x if needed.
	--
	x = x or lastX + params.segmentWidth

	--
	-- Track lastX
	--
	lastX = x	

	--
	-- Create a group to represent this segment and insert all parts to it.
	--
	local segment = display.newGroup()
	group:insert( segment )

	--
	-- Custom 'collision' listener to throw event 'onSegmentTriggered', and
	-- to create next segment.
	--
	local function onCollision ( self, event )
		if( event.phase == "began" ) then
			if( self.isTriggered ) then return true end
			self.isTriggered = true
			self:setFillColor(unpack(_C_))
			nextFrame( function() factory.new( group, nil, self.y, params ) end )
			post( "onSegmentTriggered", { x = self.x, segmentWidth = params.segmentWidth }  )
		end
		return true
	end

	-- 
	-- Create a ceiling, floor, and segment trigger
	--
	segment.trigger = newRect( segment, x, y,
		{ w = params.segmentWidth, h = fullh, fill = _Y_, 
		  alpha = (params.debugEn) and 0.05 or 0, stroke = _Y_, 
		  collision = onCollision, isTriggered = params.preTrigger }, 		
		{ bodyType = "static", bounce = 0, friction = 0, isSensor = true ,
		  calculator = myCC, colliderName = "trigger" } )


	--
	-- Add Label (if debuEn == true)
	--
	if( params.debugEn ) then
		segment.label = easyIFC:quickLabel( segment, count, x, y, ssk.gameFont(), 48 )
		segment.label.alpha = 0.5
	end

	-- 
	-- Create bottom and top wall segments
	--
	if( hasCeiling ) then
		newRect( segment, x, ceilingPosition,
			{ w = params.segmentWidth, h = 40, fill = _G_, 
			  alpha = 1, anchorY = 1, }, 
			{ bodyType = "static", bounce = 0, friction = 0, 
			  calculator = myCC, colliderName = "wall" } )
	end

	if( hasFloor ) then
		newRect( segment, x, floorPosition,
			{ w = params.segmentWidth, h = 40, fill = _G_, 
			  alpha = 1, anchorY = 0, }, 
			{ bodyType = "static", bounce = 0, friction = 0, 
			  calculator = myCC, colliderName = "wall" } )
	end

	--
	-- Dispatch a Created Trigger event for other game logick
	--
	post( "onNewSegment", { x = x, y = y, count = count }  )

	--
	-- Attach shared 'onSegmentTriggered' listener to this segment.
	--	
	segment.onSegmentTriggered = onSegmentTriggered
	listen( "onSegmentTriggered", segment )

	--
	-- Attach a finalize event to the segment so it cleans it self up
	-- when removed.
	--	
	segment.finalize = function( self )
		ignoreList( { "onSegmentTriggered" }, self )
	end; segment:addEventListener( "finalize" )

	--
	-- Handle the 'preTriggered' special case
	--
	if( segment.trigger.isTriggered == true ) then
		segment.trigger:setFillColor(unpack(_C_))
		segment.trigger:removeEventListener("collision")
	end

	--
	-- Increment Count
	--
	count = count + 1

end

-- =============================================================
-- Local Function Definitions
-- =============================================================

--
-- Shared 'onSegmentTriggered' listener - Cleans up segments that are 
-- 	too far left automatically.
--
onSegmentTriggered = function( self, event )
	local dx = mAbs( self.trigger.x - event.x )
	if( dx > fullw ) then
		display.remove( self )
	end
end
	--table.dump(event)

return factory