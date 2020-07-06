io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
--ssk.easyIFC.generateButtonPresets( nil, true )
-- =====================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua & Corona Functions
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs; local mFloor = math.floor; local mCeil = math.ceil
local strGSub = string.gsub; local strSub = string.sub
-- Common SSK Features
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
local RGTiled = ssk.tiled; local files = ssk.files
local factoryMgr = ssk.factoryMgr; local soundMgr = ssk.soundMgr
--if( ssk.misc.countLocals ) then ssk.misc.countLocals(1) end

-- == Uncomment following lines if you need  physics
--local physics = require "physics"
--physics.start()
--physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

-- == Uncomment following line if you need widget library
--local widget = require "widget"
-- =====================================================
-- =====================================================
local layers = ssk.display.quickLayers( group, 
		"underlay", 
		"world", 
			{ "background", "content", "foreground" },
		"interfaces" )


local back = newImageRect( layers.underlay, centerX, centerY, "protoBackX.png", 
									{ w = 720,  h = 1386, rotation = fullw>fullh and 90 } )

W=display.contentWidth;
H=display.contentHeight;
local physics=require("physics");
physics.setDrawMode("hybrid");
physics.start();

function newGroup(parent)
	local mc = display.newGroup();
	parent:insert(mc);
	return mc
end

local bg=display.newRect(W/2,H/2,W*2,H*2);
bg:setFillColor(113/255/2, 170/255/2, 157/255/2);

local game = display.newGroup();
local face = display.newGroup();

local linemc;
local touchStarX, touchStarY;
bg:addEventListener("touch",function ( e )
	if(e.phase == "began")then
        linemc = display.newGroup();
        game:insert(linemc)
        touchStarX, touchStarY = e.x, e.y;
    elseif(e.phase == "moved")then
		local r = 4;
		local rr = r*r;
		local prev = linemc[linemc.numChildren];
		if(prev)then
			local dx, dy = prev.x - e.x, prev.y - e.y;
			local dd = dx*dx + dy*dy;
			if(dd<rr)then
				return
			end
		end
		local b = display.newCircle(linemc, e.x, e.y, 3);
		b:setFillColor(8/10);
    else
		if linemc.numChildren > 1 then
			local a1 = linemc[1];
			local b = newGroup(game);
			b.x, b.y = a1.x, a1.y;
			local chain = {};
			for i=1,linemc.numChildren do
				local p = linemc[i];
				table.insert(chain, p.x-b.x);
				table.insert(chain, p.y-b.y);
			end
			for i=linemc.numChildren, 1, -1 do
               local p = linemc[i];
               b:insert(p);
               p:translate(-b.x, -b.y)
			end
			physics.addBody(b, "dynamic",
				{
					chain = chain,
					connectFirstAndLastChainVertex = false,
					density = 1, friction = 0.1, bounce = 0.1
				}
			)
		end
    end
end);

for i=1,10 do
	local b = display.newRect(game, 100+100*i, H-100, 50, 50);
	physics.addBody(b, "static");
end