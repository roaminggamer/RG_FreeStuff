
----------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
----------------------------------------------------------------------
require "ssk2.loadSSK"
_G.ssk.init( )

----------------------------------------------------------------------
local RGFiles = ssk.files

----------------------------------------------------------------------
-- Icon Generator
----------------------------------------------------------------------

local function genIcon( src, dst, size, calibrationScale, delay, nextIcon, scaleAdjust )
  scaleAdjust = scaleAdjust or 0
  local trueScale = calibrationScale + scaleAdjust
  dst = RGFiles.util.repairPath( dst )
  delay = delay or 0

  timer.performWithDelay( delay,
    function()
      local group = display.newGroup()
      local container
      group.x = centerX
      group.y = centerY
      local baseIcon = display.newImageRect( group, src , size, size )
      baseIcon:scale( trueScale, trueScale )
      local generationSucceeded = false

    timer.performWithDelay( 50, 
      function()
        local tmp =  display.capture(group)
        container = display.newGroup()
        container.x = centerX
        container.y = centerY
        container:insert( tmp )
        generationSucceeded = (size == tmp.contentWidth/calibrationScale)

        if( not generationSucceeded   ) then
          print( "ERROR ---- " ..  (tmp.contentWidth/ calibrationScale) .. " ~= " .. size, tmp.contentWidth )
        end

        display.remove(baseIcon)
        baseIcon = nil
        end )

    timer.performWithDelay( 60, 
      function()
        display.save( container, { filename = dst, isFullResolution = true } )
        display.remove( group )
        display.remove( container )
        nextIcon( generationSucceeded )
        end )
    end )
end


local iosIcons = 
{   
   {"Icon-167.png", 167},
   {"Icon-60@3x.png", 180},
   {"Icon-Small-40@3x.png", 120},
   {"Icon-Small@3x.png", 87},
   {"Icon-60.png", 60},
   {"Icon-60@2x.png", 120},
   {"Icon-76.png", 76},
   {"Icon-76@2x.png", 152},
   {"Icon-Small-40.png", 40},
   {"Icon-Small-40@2x.png", 80},
   {"Icon.png", 57},
   {"Icon@2x.png", 114},
   {"Icon-72.png", 72},
   {"Icon-72@2x.png", 144},
   {"Icon-Small-50.png", 50},
   {"Icon-Small-50@2x.png", 100},
   {"Icon-Small.png", 29},
   {"Icon-Small@2x.png", 58},
}


local function generateIcons( set )
   local curIcon     = 0   
   local adjustScale = 0
   local retryCount  = 0
   
   local nextIcon
   nextIcon = function( success )
      if( retryCount > 2 ) then
         print("Failed to generate icon ", set[curIcon][1] )
         return
      end

      if( success ) then
         adjustScale = 0
         retryCount = 0
         curIcon = curIcon + 1         
      else
        retryCount = retryCount + 1
        print("Retrying icon ", set[curIcon][1] )
        adjustScale = adjustScale + 0.001
      end      
    
      if( curIcon > #set ) then 
         return 
      end
      genIcon( "images/rg1024.png", set[curIcon][1], set[curIcon][2] * 1, 1, 100, nextIcon, adjustScale )
   end
   nextIcon(true)

end

display.setDefault( "minTextureFilter", "linear" )
display.setDefault( "magTextureFilter", "linear" )


generateIcons( iosIcons )
