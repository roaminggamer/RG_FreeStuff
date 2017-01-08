-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
-- ==
--    Localizations
-- ==
-- Corona & Lua
--
local mAbs = math.abs;local mRand = math.random;local mDeg = math.deg;
local mRad = math.rad;local mCos = math.cos;local mSin = math.sin;
local mAcos = math.acos;local mAsin = math.asin;local mSqrt = math.sqrt;
local mCeil = math.ceil;local mFloor = math.floor;local mAtan2 = math.atan2;
local mPi = math.pi
local pairs = pairs;local getInfo = system.getInfo;local getTimer = system.getTimer
local strFind = string.find;local strFormat = string.format;local strFormat = string.format
local strGSub = string.gsub;local strMatch = string.match;local strSub = string.sub
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
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
-- Forward Declarations
local RGFiles = ssk.files
-- =============================================================
-- =============================================================
-- =============================================================
local util 			= require "scripts.util"
local settings 		= require "scripts.settings"
local projectMgr 	= require "scripts.projectMgr"
local vscroller 	= require "scripts.vscroller"

-- == Forward Declarations
local editPane_manage = {}

-- Map Redraw Method
editPane_manage.redraw = function( self )
	--print("editPane_manage.redraw() ")

	local content = self.content
	while ( content.numChildren > 0 ) do
		display.remove( content[1] )
	end

	-- List all projects in scroller
	--
	local projects = projectMgr.getProjectsList( )


	local function scrollListener( event )
	    --table.dump(event)
	    return false
	end


	local scroller = vscroller.new( content, left, top + settings.menuBarH, fullw, fullh - settings.menuBarH, 
		                       { listener = scrollListener, hideBackground = true  } )

	local function onTouch( self, event )
	    if( event.phase == "began" ) then
	        self.isFocus = true
	        self:setFillColor(unpack(hexcolor("#00aeef")))
	        --self.alpha = 0.8
	    elseif( self.isFocus ) then 
	        if( event.phase == "ended" ) then
	            self.isFocus = false
	            --self.alpha = 1
	            if( event.isClick ) then                                
	                if( self.clickAction ) then
	                	self:clickAction()
	                end
	            end
	            self:setFillColor(unpack(hexcolor("#00703c")))
	            transition.to( self, { alpha = 1, time = 100 } )
	        end            
	    end
	    return false
	end

	local gap = 10
	local buttonW = 80
	local buttonH = 30
	local curY = gap + buttonH/2

	local function onDelete( self )
		print("Delete: " .. self.name .. "?", self.uid )
		local function doit()
	   		projectMgr.deleteProject( self.uid )
	   		post( "onNewProject" )
	   		if(projectMgr.getCount() > 0 ) then
	   			post( "onManageProjects" )
	   		end
		end
   		easyAlert("Delete", "Are you sure you want to delete this project?", 
   			{
   				{"Yes", doit }, 
   				{ "No", nil }
   			})

	end

	local function onExport( self )
		print("Export ", self.uid )
   		--projectMgr.load( self.uid )
   		--nextFrame( function() post( "onConfigureBasic" ) end )
   		projectMgr.export( self.uid )
   		--easyAlert("Export", "Not currently supported.  Coming in next release.\n\n- The Roaming Gamer", {{"OK"}})
	end

	local function onLoad( self )
		print("Edit ", self.uid )
   		projectMgr.load( self.uid )
   		nextFrame( function() post( "onConfigureBasic" ) end )
	end

	for i = 1, #projects do
	    local deleteB = newRect( nil, gap/2 + buttonW/2 + gap * 0 + buttonW * 0, curY,  { w = buttonW, h = buttonH, fill = hexcolor("#00703c") } )
		scroller.addTouch( deleteB, onTouch )
		deleteB.clickAction = onDelete
	    scroller:insert( deleteB )
	    deleteB.uid = projects[i].uid
	    deleteB.name = projects[i].name
	    deleteB.label = easyIFC:quickLabel( nil, "Delete", deleteB.x, deleteB.y , nil, 20, _W_ ) 
	    scroller:insert( deleteB.label )

	    local loadB = newRect( nil, gap/2 + buttonW/2 + gap * 1 + buttonW * 1, curY,  { w = buttonW, h = buttonH, fill = hexcolor("#00703c") } )
		scroller.addTouch( loadB, onTouch )
		loadB.clickAction = onLoad
	    scroller:insert( loadB )
	    loadB.uid = projects[i].uid
	    loadB.label = easyIFC:quickLabel( nil, "Edit", loadB.x, loadB.y , nil, 20, _W_ ) 
	    scroller:insert( loadB.label )

	    local label = easyIFC:quickLabel( content, projects[i].name, loadB.x + gap + buttonW/2, curY, nil, 20, _W_, 0) 
	    scroller:insert( label )
    
	    curY = curY + buttonH + gap
	    
	end

end

-- ==
--
-- ==
function editPane_manage.tmp(  )
end

return editPane_manage 