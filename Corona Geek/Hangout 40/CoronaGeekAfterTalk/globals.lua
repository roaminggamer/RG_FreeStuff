-- Some useful global variables
--
_G.w = display.contentWidth
_G.h = display.contentHeight

_G.centerX = w/2
_G.centerY = h/2

_G.scaleX = 1/display.contentScaleX
_G.scaleY = 1/display.contentScaleY

_G.displayWidth        = (display.contentWidth - display.screenOriginX*2)
_G.displayHeight       = (display.contentHeight - display.screenOriginY*2)

_G.unusedWidth    = _G.displayWidth - _G.w
_G.unusedHeight   = _G.displayHeight - _G.h

_G.deviceWidth  = math.floor((displayWidth/display.contentScaleX) + 0.5)
_G.deviceHeight = math.floor((displayHeight/display.contentScaleY) + 0.5)



-- Some useful global functions
--

function _G.round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end

_G.monitorMem = function( mainMemLabel, textureMemLabel )
    
	collectgarbage()

	local mainMenuUsage = "Main Memory: " .. round(collectgarbage("count"),2)  .. " KB"
	local textMem = "Texture Memory:   " .. round(system.getInfo( "textureMemoryUsed" ) / (1024 * 1024),2) .. " MB"

    --print(mainMenuUsage)
	--print(textMem)
    
    if(mainMemLabel) then mainMemLabel.text = mainMenuUsage end
	if(textureMemLabel) then textureMemLabel.text = textMem end
end
