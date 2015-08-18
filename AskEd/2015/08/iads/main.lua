local unusedWidth     = display.actualContentWidth - display.contentWidth
local unusedHeight    = display.actualContentHeight - display.contentHeight
local left            = 0 - unusedWidth/2
local top             = 0 - unusedHeight/2
local right           = display.contentWidth + unusedWidth/2
local bottom          = display.contentHeight + unusedHeight/2

local bannerID = "ADIDGOESHERE"
local testMode = true

local ads=require("ads")

local function adListener( event )
   for k,v in pairs( event ) do
      print("adListener ", k, v ) -- so you see everything you get
   end
end

ads.init("iads", bannerID, adListener )
ads:setCurrentProvider("iads")

local function showAd( adPosition, isTestMode )
   local xPos, yPos
   local adPosition = "top" -- "top", "bottom"
   if adPosition == "top" then
      xPos, yPos = display.screenOriginX, top
   elseif adPosition == "bottom" then
      xPos, yPos = display.screenOriginX, bottom
   end
   ads:setCurrentProvider("iads")
   ads.show( "banner", { x = xPos, y = yPos, appId = bannerID, testMode = isTestMode } )
end

showAd( "top", testMode )