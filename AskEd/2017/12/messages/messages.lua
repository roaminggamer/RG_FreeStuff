-- ===========================================================================
-- Copyright Chris Hodgkinson. www.aquietspace.org 2017 (All Rights Reserved)
-- ===========================================================================
-- Message Queue System 
--
-- Basic system for a message display board. Enables the user to queue 
-- messages up to be displayed in sequence for a specified period of time.
-- Now includes an 'onComplete' function
-- ===========================================================================
-- Version 0.something
-- Last Updated: 17 JULY 2017
-- ===========================================================================
-- 
-- System must be initialised with at least a display group
--
-- ===========================================================================
--   
-- Please be aware that this is still a work in progress.
-- It may one day be finished but who knows.
-- 
--
-- ===========================================================================



----------------------------------------------------------------------------
local debug = true
----------------------------------------------------------------------------

local messageQueue = {}
local centerX = display.actualContentWidth*0.5
local centerY = display.actualContentHeight*0.5
local w = display.contentWidth
local queue={}

local prefs={
	font = native.systemFont,
	fontSize = 64,
	yPos = centerY,
  xPos = centerX,
	textColour = {1,1,1,1},
	background = false,
  bgWidth = w,
  bgHeight = 120,
  bgColour = {0,0,0,.6},
  bgBorderColour = {1,1,1},
  bgBorderWidth = 4,
  bgCornerRadius = 60,
  messageGroup = "",
  time = 3000,
  fadeIn = true,
  fadeOut = true,
	}
	
	messageQueue.queue = queue

local userPrefs = false
local working = false
local messageFont = native.systemFont
local msgInit=false

local isShowingMessage = false
local backgroundIsShowing = false
local fadeBG = false
local background
local messageDisplay
local onMessageComplete
local showBG = prefs.background

----------------------------------------------------------------------------

function messageQueue:init(params)
  if not params.messageGroup then
    if debug then print("// Display Group must be specified //"); end
    return false
  end
  local p={}
  p.font = params.font or prefs.font
  p.fontSize = params.fontSize or prefs.fontSize
  p.yPos = params.yPos or prefs.yPos
  p.xPos = params.xPos or prefs.xPos
  p.textColour = params.textColour or prefs.textColour
  p.background = params.background or prefs.background
  p.bgWidth = params.bgWidth or prefs.bgWidth
  p.bgHeight = params.bgHeight or prefs.bgHeight
  p.bgColour = params.bgColour or prefs.bgColour
  p.bgBorderColour = params.bgBorderColour or prefs.bgBorderColour
  p.bgBorderWidth = params.bgBorderWidth or prefs.bgBorderWidth
  p.bgCornerRadius = params.bgCornerRadius or prefs.bgCornerRadius
  p.time = params.time or prefs.time
  p.fadeIn = params.fadeIn or prefs.fadeIn
  p.fadeOut = params.fadeOut or prefs.fadeOut
  p.messageGroup = params.messageGroup or prefs.messageGroup
  prefs=p

  background = display.newRoundedRect(prefs.messageGroup, prefs.xPos, prefs.yPos, prefs.bgWidth, prefs.bgHeight, prefs.bgCornerRadius)
  background.strokeWidth = prefs.bgBorderWidth
  background:setFillColor ( unpack( prefs.bgColour) )
  background:setStrokeColor (unpack( prefs.bgBorderColour ) )
  background.alpha= 0

  messageDisplay = display.newText (prefs.messageGroup, " ", prefs.xPos, prefs.yPos, prefs.font, prefs.fontSize )
  messageDisplay:setFillColor(unpack(prefs.textColour))
  messageDisplay.alpha=0
  messageDisplay:toFront()
  msgInit=true
  if debug then print("// MESSAGEQUEUE SUCCESSFULLY INITIALISED //"); end
end

----------------------------------------------------------------------------

function messageQueue:setPrefs(params)
	if not params then return false end
	local p={}
	p.font = params.font or prefs.font
  p.fontSize = params.fontSize or prefs.fontSize
  p.yPos = params.yPos or prefs.yPos
  p.xPos = params.xPos or prefs.xPos
  p.textColour = params.textColour or prefs.textColour
  p.background = params.background or prefs.background
  p.bgWidth = params.bgWidth or prefs.bgWidth
  p.bgHeight = params.bgHeight or prefs.bgHeight
  p.bgColour = params.bgColour or prefs.bgColour
  p.bgBorderColour = params.bgBorderColour or prefs.bgBorderColour
  p.bgBorderWidth = params.bgBorderWidth or prefs.bgBorderWidth
  p.bgCornerRadius = params.bgCornerRadius or prefs.bgCornerRadius
  p.time = params.time or prefs.time
  p.fadeIn = params.fadeIn or prefs.fadeIn
  p.fadeOut = params.fadeOut or prefs.fadeOut
  p.messageGroup = params.messageGroup or prefs.messageGroup
	prefs=p
	
  display.remove(background)
  background = display.newRoundedRect(prefs.messageGroup, prefs.xPos, prefs.yPos, prefs.bgWidth, prefs.bgHeight, prefs.bgCornerRadius)
  background.strokeWidth = prefs.bgBorderWidth
  background:setFillColor ( unpack( prefs.bgColour) )
  background:setStrokeColor (unpack( prefs.bgBorderColour ) )
  background.alpha= 0
  
  display.remove(messageDisplay)
  messageDisplay = display.newText (prefs.messageGroup, " ", prefs.xPos, prefs.yPos, prefs.font, prefs.fontSize )
  messageDisplay:setFillColor(unpack(prefs.textColour))
  messageDisplay.alpha=0
  messageDisplay:toFront()
	
  return true
end

----------------------------------------------------------------------------

function messageQueue.nextMessage()
  if queue[1].comp then
    onMessageComplete=queue[1].comp
    onMessageComplete()
  end
  table.remove ( queue, 1 )
  isShowingMessage = false
  messageQueue.processQueue()
end

----------------------------------------------------------------------------

function messageQueue.hideMessage()
  local m=queue[1]
  local fadeOut = transition.to(messageDisplay, {alpha=0, time=500, onComplete=function() messageQueue.nextMessage() end} )
  if not queue[2] then
    local bgFade= transition.to(background, {alpha=0, time=500})
  end
  return true
end

----------------------------------------------------------------------------

function messageQueue.showMessage()
  if not isShowingMessage then
    local m=queue[1]
    messageDisplay.text = m.message
    if prefs.background and not backgroundIsShowing then
        local fadeIn = transition.to(background, {alpha=1, time=500})
      backgroundIsShowing = true
      clearBG = true
    end
    local fadeIn = transition.to(messageDisplay, {alpha=1, time=500})
    isShowingMessage = true
    timer.performWithDelay(m.displayTime, function() messageQueue.hideMessage() end)
  else return false end
end

----------------------------------------------------------------------------

function messageQueue.processQueue()
	if #queue < 1 then 
    isWorking = false
    backgroundIsShowing = false
    if debug then print ("No messages to process"); end
    return false 
  else
    messageQueue.showMessage()
    return true
  end
end

----------------------------------------------------------------------------

function messageQueue:addMessage(msg, params)
  local p = params
  if not msgInit then
    if debug then print("// MESSAGE QUEUE HAS NOT YET BEEN INITIALISED //"); end
    return false
  end
  local newMessage={}
  newMessage.message 		  = msg
  newMessage.displayTime  = p.time or prefs.time
  newMessage.fadeIn 		  = p.fadeIn or prefs.fadeIn
  newMessage.fadeOut 	    = p.fadeOut or prefs.fadeOut
  newMessage.comp         = p.onComplete or nil
  newMessage.background   = p.bg or prefs.background
  table.insert( queue, newMessage )
  if not working then
  	isWorking = true
    self.processQueue()
  end
  return
end

----------------------------------------------------------------------------

return messageQueue




