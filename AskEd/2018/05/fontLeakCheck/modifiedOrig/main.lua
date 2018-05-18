-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local g = display.newGroup()
local spawnGroup = display.newGroup()
g:insert(spawnGroup)

local font = native.systemFont

local spawnCount = 0
local spawnText = false
local removeSpawnOnComplete = false
local t = 0

local debugText = display.newText({
    parent = g,
    text = "debug",
    fontSize = 12,
    font = native.systemFont,
    x = display.safeScreenOriginX + 10,
    y = display.safeScreenOriginY + 10
  })

debugText.anchorX = 0
debugText.anchorY = 0
debugText:setFillColor(0.2,1,0.2)

local timeText = display.newText({
    parent = g,
    text = "0:00",
    fontSize = 40,
    font = native.systemFont,
    x = display.safeActualContentWidth - 10,
    y = display.safeScreenOriginY + 10
  })

timeText.anchorX = 1
timeText.anchorY = 0
timeText:setFillColor(1,0.4)

local fontSwitchBtn = display.newText({
    parent = g,
    text = "font: native.systemDefault",
--    fontSize = 20,
    font = native.systemFont,
    x = (display.safeActualContentWidth / 6) * 3,
    y = display.safeActualContentHeight - 120
  })

local optBtn = display.newText({
    parent = g,
    text = "remove text object onComplete: "..tostring(removeSpawnOnComplete),
--    fontSize = 20,
    font = native.systemFont,
    x = (display.safeActualContentWidth / 6) * 3,
    y = display.safeActualContentHeight - 90
  })

local startBtn = display.newText({
    parent = g,
    text = "start",
    fontSize = 20,
    font = native.systemFont,
    x = (display.safeActualContentWidth / 6) * 1,
    y = display.safeActualContentHeight - 60
  })

local stopBtn = display.newText({
    parent = g,
    text = "stop",
    fontSize = 20,
    font = native.systemFont,
    x = (display.safeActualContentWidth / 6) * 3,
    y = display.safeActualContentHeight - 60
  })

local clearBtn = display.newText({
    parent = g,
    text = "clear",
    fontSize = 20,
    font = native.systemFont,
    x = (display.safeActualContentWidth / 6) * 5,
    y = display.safeActualContentHeight - 60
    })

local function gameLoop()
  
  if spawnText  then
    spawnCount = spawnCount + 1
    local curText = display.newText({
      parent = spawnGroup,
      text = "Some text "..tostring(spawnCount),
      fontSize = 20,
      font = font,
      x = display.contentCenterX,
      y = display.contentCenterY + math.sin(t)*100
      }
      )
    
    
    transition.to(curText,{
        time = 1000,
        size = 40,
        transition = easing.outQuad,
        onComplete = function()
              transition.to(curText,{
                time = 2000,
                size = 20,
                alpha = 0.2,
                x = display.safeActualContentWidth,
                y = display.safeActualContentHeight,
                transition = easing.inOutQuad,
                onComplete = function()
                  if removeSpawnOnComplete then
                    print("removing spawn")
                    display.remove(curText)
                    curText = nil
                  end
                end
            },1)
        end
        },1)
    
  
end 

    local memUsage_str = string.format( "MEM = %.3f KB", collectgarbage( "count" ) )
     
   local texmem = math.floor((system.getInfo("textureMemoryUsed") / (1024 * 1024)*1000))/1000
   
   print( memUsage_str, "TEX = "..tostring( texmem).." MB" )
   
   debugText.text = memUsage_str.."\n".."TEX = "..tostring( texmem).." MB"

end -- gameLoop end

local function runCounter()
  t = t + 1
  local m, s
  m = math.floor(t/60)
  s = t%60
  if s < 10 then s = "0"..tostring(s) end
  
  timeText.text = m..":"..s
  
end
  
   local function fontSwitchBtnAction()
  print("fontSwitchBtnAction() called")
  if font == native.systemFont then
    font = "Playball.ttf"
    fontSwitchBtn.text = "font: custom"
  else
    font = native.systemFont
    fontSwitchBtn.text = "font: native.systemFont"
  end
  optBtn.text = "remove text object onComplete:"..tostring(removeSpawnOnComplete)
  
 end
  
  local function optBtnAction()
  print("optBtnAction() called")
  if removeSpawnOnComplete then
    removeSpawnOnComplete = false
  else
    removeSpawnOnComplete = true
  end
  optBtn.text = "removeSpawnOnComplete:"..tostring(removeSpawnOnComplete)
  
 end

local function startBtnAction()
  print("functionstartBtnAction() called")
  spawnText = true
end

 local function stopBtnAction()
  print("stopBtnAction() called")
  spawnText = false
end

  local function clearBtnAction()
    print("clearBtnAction() called")
    -- clear spawned text
    display.remove(spawnGroup)
    spawnGroup = nil
    spawnGroup = display.newGroup()
    g:insert(spawnGroup)
  end

  fontSwitchBtn:addEventListener("tap", fontSwitchBtnAction)
  optBtn:addEventListener("tap", optBtnAction)
  startBtn:addEventListener("tap", startBtnAction)
  stopBtn:addEventListener("tap", stopBtnAction)
  clearBtn:addEventListener("tap", clearBtnAction)
  
  timer.performWithDelay(1000, runCounter, -1)
  timer.performWithDelay(500, gameLoop, -1)
--Runtime:addEventListener("enterFrame")