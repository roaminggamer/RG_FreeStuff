io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- =====================================================
-- YOUR CODE BELOW
-- =====================================================
local function newBall( params )
   local xpos = display.contentWidth*0.5
   local ypos = display.contentHeight*0.5
   local circle = display.newCircle( xpos, ypos, params.radius );
   circle:setFillColor( params.r, params.g, params.b, 255 );
   circle.xdir = params.xdir
   circle.ydir = params.ydir
   circle.xspeed = params.xspeed
   circle.yspeed = params.yspeed
   circle.radius = params.radius
   return circle
end

local function genRandParams() 
	return  
	{
		radius = math.random(5,30),
		xdir = (math.random(1,2) == 1) and -1 or 1,
		ydir = (math.random(1,2) == 1) and -1 or 1,
		xspeed = math.random( 5, 40)/10,
		yspeed = math.random( 5, 40)/10,
		r = math.random(),
		g = math.random(),
		b = math.random(),
   }
end
 
local params =  {}
for i = 1, 20 do
	params[i] = genRandParams()
end
 
local collection = {}
 
-- Iterate through params array and add new balls into an array
for _,item in ipairs( params ) do
   local ball = newBall( item )
   collection[ #collection + 1 ] = ball
end
 
-- Get current edges of visible screen (accounting for the areas cropped by "zoomEven" scaling mode in config.lua)
local screenTop = display.screenOriginY
local screenBottom = display.viewableContentHeight + display.screenOriginY
local screenLeft = display.screenOriginX
local screenRight = display.viewableContentWidth + display.screenOriginX
 
function collection:enterFrame( event )
   for _,ball in ipairs( collection ) do
      local dx = ( ball.xspeed * ball.xdir );
      local dy = ( ball.yspeed * ball.ydir );
      local xNew, yNew = ball.x + dx, ball.y + dy
 
      local radius = ball.radius
      if ( xNew > screenRight - radius or xNew < screenLeft + radius ) then
            ball.xdir = -ball.xdir
      end
      if ( yNew > screenBottom - radius or yNew < screenTop + radius ) then
         ball.ydir = -ball.ydir
      end
      ball:translate( dx, dy )
   end
end
 
Runtime:addEventListener( "enterFrame", collection );