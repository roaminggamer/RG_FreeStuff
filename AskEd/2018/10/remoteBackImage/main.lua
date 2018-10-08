io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
-- =====================================================

local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2

-- Display groups for easy layering of content
local backgroundGroup 	= display.newGroup()
local contentGroup 		= display.newGroup()

-- Create an initial backround image so you can see what is happening
local initialBack = display.newImageRect( backgroundGroup, "protoBackX.png", 720, 1386 )
initialBack.x = cx
initialBack.y = cy
if( display.contentWidth > display.contentHeight ) then
	initialBack.rotation = 90
end


-- Add some other content in our 'contentGroup'
local tmp1 = display.newImageRect( contentGroup, "rg256.png", 256,256  )
local tmp2 = display.newImageRect( contentGroup, "corona256.png", 256,256  )
tmp1.x = cx
tmp1.y = cy - 200
tmp2.x = cx
tmp2.y = cy + 200

--
-- Code to download an image and make it the new background image
--

-- YOUR URL IS INVALID??  USING MINE FOR DEMO
--local imageURL = "http://www.mywebsite/image.png"
local imageURL = "https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs2.png"
local allowStretching = false

local function networkListener( event )
	--table.print_r(event)

	if ( event.isError ) then
		print ( "Network error - download failed" )
		initialBack:setFillColor(1,0,0)
	else
		-- remove old background  image
		display.remove( initialBack )
		initialBack = nil 

		-- Place new background  image in proper group
		local newBackground = event.target
		backgroundGroup:insert( newBackground )

		-- Scale it up to fully cover the screen
		local ratioW = fullw/newBackground.contentWidth
		local ratioH = fullh/newBackground.contentHeight

		if( allowStretching ) then
			newBackground:scale( ratioW, ratioH )
		else
			if( ratioW > ratioH ) then
				newBackground:scale( ratioW, ratioW )
			else
				newBackground:scale( ratioH, ratioH )
			end
		end
	end
	print ( "event.response.fullPath: ", event.response.fullPath )
	print ( "event.response.filename: ", event.response.filename )
	print ( "event.response.baseDirectory: ", event.response.baseDirectory )
end


-- Delay this for 2 seconds for the purpose of slowing this demo down
timer.performWithDelay( 2000, 
	function() 
		display.loadRemoteImage( imageURL, "GET", networkListener, "image.png", system.TemporaryDirectory, cx, cy )
	end )
