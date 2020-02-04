-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- game.lua - Game Module
-- =============================================================
local common 		= require "scripts.common"
--local physics 		= require "physics"

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
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
local RGTiled = ssk.tiled
local files = ssk.files

-- =============================================================
-- Locals
-- =============================================================
local rbGradientPaint = { type="gradient", color1=_RED_, color2=_BLUE_ }	
local brGradientPaint = { type="gradient", color1=_BLUE_, color2=_RED_ }	
local rgGradientPaint = { type="gradient", color1=_RED_, color2=_GREEN_ }	
local grassPaint = { type="image", filename = "images/grass.png" }	
local mudPaint = { type="image", filename = "images/mud.png" }	
local grassmudPaint = { type="image", filename = "images/grassmud.png" }	

local hex = require "scripts.hex"

local game = {}

function game.test1()
	local tmp = hex.draw( nil, centerX - 50, centerY - 100 ) 
	local tmp = hex.draw( nil, centerX + 50, centerY - 100, { orientation = 2 } ) 

	local tmp = hex.draw( nil, centerX - 100, centerY, 
								{ fill = rbGradientPaint, stroke = _Y_, strokeWidth = 1, orientation = 2 } ) 
	local tmp = hex.draw( nil, centerX, centerY, 
								{ fill = brGradientPaint, stroke = _Y_, strokeWidth = 1, orientation = 2 } ) 
	local tmp = hex.draw( nil, centerX + 100, centerY, 
								{ fill = rgGradientPaint, stroke = _Y_, strokeWidth = 1, orientation = 2 } ) 
	
	local tmp = hex.draw( nil, centerX - 100, centerY + 100, 
								{ fill = grassPaint, stroke = _Y_, strokeWidth = 1, orientation = 2 } ) 
	local tmp = hex.draw( nil, centerX, centerY + 100, 
								{ fill = mudPaint, stroke = _Y_, strokeWidth = 1, orientation = 2 } ) 
	local tmp = hex.draw( nil, centerX + 100, centerY + 100, 
								{ fill = grassmudPaint, stroke = _Y_, strokeWidth = 1, orientation = 2 } ) 
end

function game.test2()
	local gridGroup = hex.drawGridGroup( nil, centerX, centerY, 
							{ 	orientation = 2, edgeLen = 32, debugEn = true, centerGrid = true,
							   rows = 10, cols = 18, 
								fill = grassmudPaint, stroke = _B_, strokeWidth = 2 } )

	local function onTap( self )
		self:setStrokeColor(1,1,0)		
		self.strokeWidth = 4
		timer.performWithDelay( 500, 
			function() 
				self:setStrokeColor(0,0,1) 
				self.strokeWidth = 2
			end  )
		self:toFront()
		if( self.label ) then 
			self.label:toFront()
		end
	end

	local pieces = gridGroup.pieces
	for i = 1, #pieces do
		local piece = pieces[i]
		piece.tap = onTap
		piece:addEventListener("tap")
	end

end

function game.test3()
	local gridGroup = hex.drawGridGroup( nil, centerX, centerY, 
							{ 	orientation = 1, edgeLen = 64, debugEn = true, centerGrid = true,
							   rows = 6, cols = 8,  
								fill = mudPaint, stroke = _B_, strokeWidth = 2 } )

	local function onTap( self )
		self:setStrokeColor(1,1,0)		
		self.strokeWidth = 4
		timer.performWithDelay( 500, 
			function() 
				self:setStrokeColor(0,0,1) 
				self.strokeWidth = 2
			end  )
		self:toFront()
		if( self.label ) then 
			self.label:toFront()
		end
	end

	local pieces = gridGroup.pieces
	for i = 1, #pieces do
		local piece = pieces[i]
		piece.tap = onTap
		piece:addEventListener("tap")
	end

end

return game



