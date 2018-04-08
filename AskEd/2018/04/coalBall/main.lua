io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================


local getTimer = system.getTimer
local isAndroid = (system.getInfo("platform") == "android")
local debugEn   = true


local coal = 0
local pauseDuration = 1000

local ball = display.newCircle( 100, 100, 50 )
ball._waitTill = getTimer() - pauseDuration -- Ensure it can move immediately
ball.isMoving = true
ball.allowResume = false

function ball.finalize( self )
	Runtime:removeEventListener( "enterFrame", self )	
end; ball:addEventListener( "finalize" )

function ball.enterFrame( self )
	print( self.isMoving, self.allowResume )
	if( self.isMoving == false ) then
		if( self.allowResume == false ) then
			return false
	   end
	   if( getTimer() < self._waitTill ) then 
	   	return false
	   end	   
	end
   --
   self.x = self.x + 1
end; Runtime:addEventListener("enterFrame", ball)

local coalLabel = display.newText( coal, 300, 300 )

if( isAndroid or debugEn ) then
   ball.key = function( self, event )
   	for k,v in pairs(event) do
   		print(k,v)
   	end
      if( event.phase=="up" and 
      	 ( event.keyName == "back" or event.keyName == "space") ) then
         coal = coal + 1
         coalLabel.text = coal .. " : " .. tostring(coal % 2)

         if( coal % 2 == 0 ) then
         	self.isMoving = false
         	self.allowResume = true
            self._waitTill = getTimer() + pauseDuration            
         else
         	self.isMoving = false
         	self.allowResume = false
         end
      end
      return true
   end; Runtime:addEventListener( "key", ball )
end



