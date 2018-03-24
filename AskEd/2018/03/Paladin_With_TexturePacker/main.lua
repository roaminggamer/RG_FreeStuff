local Current_Animation = 1

local idleInfo1 = require "tpout.Idle_1"
local idleInfo2 = require "tpout.Idle_2"
local idleInfo3 = require "tpout.Idle_3"
local idleInfo4 = require "tpout.Idle_4"

local idleSheet1 = graphics.newImageSheet("tpout/Idle_1.png", idleInfo1:getSheet() )
local idleSheet2 = graphics.newImageSheet("tpout/Idle_2.png", idleInfo2:getSheet() )
local idleSheet3 = graphics.newImageSheet("tpout/Idle_3.png", idleInfo3:getSheet() )
local idleSheet4 = graphics.newImageSheet("tpout/Idle_4.png", idleInfo4:getSheet() )

local Knight_Animations =
{
  { name="Idle_1", sheet=idleSheet1, start=1, count=#idleInfo1.sheet.frames,  loopCount=1 },
  { name="Idle_2", sheet=idleSheet2, start=1, count=#idleInfo2.sheet.frames, loopCount=1 },
  { name="Idle_3", sheet=idleSheet3, start=1, count=#idleInfo3.sheet.frames, loopCount=1 },
  { name="Idle_4", sheet=idleSheet4, start=1, count=#idleInfo4.sheet.frames, loopCount=1 }
}

local Knight = display.newSprite( idleSheet1, Knight_Animations )

Knight.x = display.contentWidth/2
Knight.y = display.contentHeight/2

Knight:setSequence("Idle_1")
Knight:play()


local function spriteListener( event )

    local thisSprite = event.target

    if ( event.phase == "ended" ) then
        if (Current_Animation == 1) then
          print("Animation Ended - 1 @", system.getTimer())
          thisSprite:setSequence( "Idle_2" )
          thisSprite:play()
          Current_Animation = 2
        elseif (Current_Animation == 2) then
          print("Animation Ended - 2 @", system.getTimer())
          thisSprite:setSequence( "Idle_3" )
          thisSprite:play()
          Current_Animation = 3
        elseif (Current_Animation == 3) then
          print("Animation Ended - 3 @", system.getTimer())
          thisSprite:setSequence( "Idle_4" )
          thisSprite:play()
          Current_Animation = 4
        elseif (Current_Animation == 4) then
          print("Animation Ended - 4 @", system.getTimer())
          thisSprite:setSequence( "Idle_1" )
          thisSprite:play()
          Current_Animation = 1
        end
    end
end

Knight:addEventListener( "sprite", spriteListener )
